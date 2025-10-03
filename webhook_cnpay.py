from flask import Flask, request, jsonify
from database import Database
import logging
import json
from datetime import datetime, timedelta
import os
import threading
import requests

# Configurar logging
logging.basicConfig(
    format='%(asctime)s - %(name)s - %(levelname)s - %(message)s',
    level=logging.INFO
)
logger = logging.getLogger(__name__)

app = Flask(__name__)

# Cache para evitar processamento duplicado por evento
processed_events = {}  # {transaction_id: set(event_types)}
transaction_lock = threading.Lock()

@app.route('/webhook/cnpay', methods=['POST'])
def cnpay_webhook():
    """Webhook para receber callbacks do CNPay"""
    try:
        data = request.get_json(silent=True)

        if not data:
            logger.error("❌ Payload JSON inválido ou vazio")
            return jsonify({'error': 'JSON inválido'}), 400

        logger.info("🔔 Callback CNPay recebido")
        logger.info(f"📨 Payload recebido bruto:\n{json.dumps(data, indent=2, ensure_ascii=False)}")

        # Validar token do webhook (se necessário)
        webhook_token = data.get('token')
        if not webhook_token:
            logger.warning("⚠️ Token do webhook não encontrado")

        # Extrair dados da estrutura correta do CNPay
        event_type = data.get('event')  # ex: "TRANSACTION_CREATED"
        transaction_data = data.get('transaction', {}) or {}
        transaction_id = transaction_data.get('id')
        transaction_status = transaction_data.get('status')  # ex: "PENDING", "PAID"
        subscription_data = data.get('subscription', {}) or {}
        client_data = data.get('client', {}) or {}
        order_items = data.get('orderItems', []) or []

        # Validação básica
        if not transaction_id:
            logger.error("❌ ID da transação não encontrado")
            return jsonify({'error': 'transaction.id obrigatório'}), 400

        if not event_type or event_type == 'UNKNOWN':
            logger.warning("⚠️ Tipo de evento não encontrado ou desconhecido")
            logger.info(f"📦 Tentando processar como TRANSACTION_PAID baseado nos dados")
            event_type = 'TRANSACTION_PAID'
            transaction_status = 'PAID'

        # Controle de duplicatas por evento
        with transaction_lock:
            if transaction_id in processed_events and event_type in processed_events[transaction_id]:
                logger.warning(f"⚠️ Evento {event_type} para transação {transaction_id} já foi processado. Ignorando...")
                return jsonify({
                    'ok': True,
                    'transaction_id': transaction_id,
                    'event_type': event_type,
                    'status': 'already_processed',
                    'processed_at': datetime.now().isoformat()
                })

            if transaction_id not in processed_events:
                processed_events[transaction_id] = set()
            processed_events[transaction_id].add(event_type)

            if len(processed_events) > 500:
                processed_events.clear()

        # Log estruturado (mais simples)
        logger.info("📦 Dados do webhook estruturados:")
        logger.info(json.dumps({
            'event_type': event_type,
            'transaction_id': transaction_id,
            'transaction_status': transaction_status,
            'subscription_id': subscription_data.get('id'),
            'subscription_identifier': subscription_data.get('identifier'),
            'client_id': client_data.get('id'),
            'client_name': client_data.get('name'),
            'amount': transaction_data.get('amount'),
            'payment_method': transaction_data.get('paymentMethod'),
            'timestamp': datetime.now().isoformat()
        }, indent=2, ensure_ascii=False))

        # Chama a função principal para processar o evento
        result = process_cnpay_event(
            transaction_id=transaction_id,
            event_type=event_type,
            transaction_status=transaction_status,
            data=data
        )

        if result.get('success'):
            return jsonify({
                'ok': True,
                'transaction_id': transaction_id,
                'event_type': event_type,
                'status': transaction_status,
                'processed_at': datetime.now().isoformat()
            })
        else:
            with transaction_lock:
                if transaction_id in processed_events:
                    processed_events[transaction_id].discard(event_type)
                    if not processed_events[transaction_id]:
                        del processed_events[transaction_id]
            return jsonify({'error': result.get('error', 'Erro desconhecido')}), 400

    except Exception as e:
        logger.error(f"❌ Erro no webhook: {str(e)}", exc_info=True)
        return jsonify({'error': 'Erro interno'}), 500
def process_cnpay_event(transaction_id, event_type, transaction_status, data):
    """Processa eventos do CNPay"""
    logger.info(f"🔄 Processando {event_type} (status: {transaction_status}) para {transaction_id}")
    
    db = None
    try:
        db = Database()
        db.connect()
        if not db.connection:
            logger.error("❌ Erro ao conectar ao banco de dados")
            return {'success': False, 'error': 'Erro de conexão com banco'}
            
        # Buscar pagamento no banco
        payment = None
        try:
            payment = db.execute_fetch_one(
                "SELECT * FROM payments WHERE payment_id = %s",
                (transaction_id,)
            )
        except Exception as e:
            logger.error(f"❌ Erro ao buscar pagamento: {e}")
            # Continuar mesmo com erro na busca
        
        if not payment:
            # Para subscription, o identifier pode ser diferente do transaction_id
            subscription_data = data.get('subscription', {})
            subscription_identifier = subscription_data.get('identifier')
            
            if subscription_identifier:
                try:
                    # Tentar buscar pelo external_reference
                    payment = db.execute_fetch_one(
                        "SELECT * FROM payments WHERE external_reference = %s",
                        (subscription_identifier,)
                    )
                except Exception as e:
                    logger.error(f"❌ Erro ao buscar por external_reference: {e}")
            
            if not payment:
                # Se for TRANSACTION_CREATED, criar o registro
                if event_type == 'TRANSACTION_CREATED':
                    logger.info(f"📝 Criando registro para nova transação: {transaction_id}")
                    try:
                        payment = create_payment_record(transaction_id, data, db)
                        if not payment:
                            logger.error(f"❌ Falha ao criar registro para {transaction_id}")
                            return {'success': False, 'error': 'Falha ao criar registro'}
                    except Exception as e:
                        logger.error(f"❌ Erro ao criar registro: {e}")
                        return {'success': False, 'error': f'Erro ao criar registro: {str(e)}'}
                else:
                    logger.error(f"❌ Pagamento {transaction_id} não encontrado no banco")
                    logger.error(f"❌ Tentou buscar também por identifier: {subscription_identifier}")
                    return {'success': False, 'error': 'Pagamento não encontrado'}
        
        # Roteamento de eventos baseado no event_type
        try:
            if event_type == 'TRANSACTION_CREATED':
                return handle_transaction_created(transaction_id, transaction_status, data, db, payment)
            elif event_type == 'TRANSACTION_PAID':
                return handle_transaction_paid(transaction_id, transaction_status, data, db, payment)
            elif event_type == 'TRANSACTION_CANCELED':
                return handle_transaction_canceled(transaction_id, transaction_status, data, db, payment)
            elif event_type == 'TRANSACTION_REFUNDED':
                return handle_transaction_refunded(transaction_id, transaction_status, data, db, payment)
            else:
                # Para outros eventos, apenas logar
                logger.info(f"📝 Evento {event_type} recebido mas não processado")
                return {'success': True, 'message': f'Evento {event_type} registrado'}
        except Exception as e:
            logger.error(f"❌ Erro ao processar evento {event_type}: {e}")
            return {'success': False, 'error': str(e)}
        
    except Exception as e:
        logger.error(f"❌ Falha ao processar {transaction_id}: {str(e)}")
        return {'success': False, 'error': str(e)}
    finally:
        if db:
            try:
                db.close()
            except Exception as e:
                logger.error(f"❌ Erro ao fechar conexão: {str(e)}")

def create_payment_record(transaction_id, data, db):
    """Cria registro na tabela payments para nova transação CNPay"""
    try:
        # Extrair dados da transação
        transaction_data = data.get('transaction', {})
        subscription_data = data.get('subscription', {})
        order_items = data.get('orderItems', [])
        client_data = data.get('client', {})
        
        # Extrair user_id e plan_id do identifier
        subscription_identifier = subscription_data.get('identifier', '')
        user_id = None
        plan_id = 1  # Padrão
        
        # Tentar extrair do identifier da transação primeiro
        transaction_identifier = transaction_data.get('identifier', '')
        if transaction_identifier and '_' in transaction_identifier:
            try:
                # Procurar por padrão user_id_plan_id no identifier
                parts = transaction_identifier.split('-')
                for part in parts:
                    if '_' in part and part.replace('_', '').isdigit():
                        sub_parts = part.split('_')
                        if len(sub_parts) >= 2:
                            user_id = int(sub_parts[0])
                            plan_id = int(sub_parts[1])
                            break
            except (ValueError, IndexError):
                logger.warning(f"⚠️ Não foi possível extrair user_id e plan_id de {transaction_identifier}")
        
        # Se não conseguiu extrair, tentar buscar pelo email do cliente
        if not user_id and client_data.get('email'):
            email = client_data['email']
            if '@telegram.com' in email:
                username = email.replace('@telegram.com', '')
                user_info = db.execute_fetch_one(
                    "SELECT id FROM users WHERE username = %s",
                    (username,)
                )
                if user_info:
                    user_id = user_info['id']
                    logger.info(f"✅ User ID encontrado pelo email: {user_id}")
        
        # Se ainda não tem user_id, criar usuário temporário
        if not user_id:
            logger.warning(f"⚠️ User ID não encontrado, criando usuário temporário")
            try:
                db.execute_query(
                    """INSERT INTO users (id, username, first_name, last_name, joined_date) 
                    VALUES (%s, %s, %s, %s, NOW())""",
                    (999999, f"temp_{transaction_id}", "Usuário", "Temporário"),
                    commit=True
                )
                user_id = 999999
                logger.info(f"✅ Usuário temporário criado: {user_id}")
            except Exception as e:
                logger.error(f"❌ Erro ao criar usuário temporário: {e}")
                # Tentar usar um ID diferente se 999999 já existe
                user_id = 999998
        
        # Extrair valor da transação
        amount = transaction_data.get('amount', 0.01)
        
        # Extrair código PIX se disponível
        qr_code_data = ""
        pix_data = data.get('pix', {})
        if pix_data:
            qr_code_data = pix_data.get('code', '')
        
        # Usar o identifier da transação como external_reference
        external_reference = transaction_identifier or subscription_identifier
        
        logger.info(f"📝 Criando registro:")
        logger.info(f"   🆔 Transaction ID: {transaction_id}")
        logger.info(f"   👤 User ID: {user_id}")
        logger.info(f"   💎 Plan ID: {plan_id}")
        logger.info(f"   💰 Amount: {amount}")
        logger.info(f"   🔗 External Ref: {external_reference}")
        
        # Inserir registro na tabela payments
        db.execute_query(
            """INSERT INTO payments (
                payment_id, user_id, plan_id, amount, currency, 
                payment_method, status, external_reference, 
                qr_code_data, pix_key, pix_key_type, pix_key_owner
            ) VALUES (
                %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s
            )""",
            (
                transaction_id,
                user_id,
                plan_id,
                amount,
                'BRL',
                'pix_automatico',
                'pending',
                external_reference,
                qr_code_data,
                None,  # pix_key
                None,  # pix_key_type
                None   # pix_key_owner
            ),
            commit=True
        )
        
        logger.info(f"✅ Registro criado para transação {transaction_id}")
        
        # Retornar o registro criado (sem usar execute_fetch_one para evitar "Unread result found")
        return {
            'payment_id': transaction_id,
            'user_id': user_id,
            'plan_id': plan_id,
            'amount': amount,
            'currency': 'BRL',
            'payment_method': 'pix_automatico',
            'status': 'pending',
            'external_reference': external_reference,
            'qr_code_data': qr_code_data
        }
        
    except Exception as e:
        logger.error(f"❌ Erro ao criar registro para {transaction_id}: {str(e)}")
        return None

def handle_transaction_created(transaction_id, transaction_status, data, db, payment):
    """Transação criada/pendente"""
    try:
        # Se o registro foi criado agora, não precisa atualizar status
        if payment and payment.get('status') == 'pending':
            logger.info(f"✅ Transação {transaction_id} já está com status pending")
        else:
            # Atualizar status para pending
            db.execute_query(
                """UPDATE payments 
                SET status = 'pending', updated_at = NOW() 
                WHERE payment_id = %s""",
                (transaction_id,),
                commit=True
            )
            logger.info(f"✅ Status atualizado para pending: {transaction_id}")
        
        # Notificar admin sobre pagamento criado
        try:
            notify_admin_payment_created(transaction_id, data, db, payment)
        except Exception as e:
            logger.error(f"⚠️ Erro ao notificar admin sobre pagamento criado: {str(e)}")
    
    except Exception as e:
        logger.error(f"❌ Erro ao processar TRANSACTION_CREATED: {str(e)}")
        return {'success': False, 'error': str(e)}


async def register_cnpay_subscription(user_id, plan_id, payment_id, db, plan_info):
    """Registra assinatura CNPay usando a mesma lógica do MercadoPago"""
    try:
        # Calcular data de expiração
        if plan_info['duration_days'] == -1:
            end_date = datetime(2099, 12, 31)
            is_permanent = True
        else:
            end_date = datetime.now() + timedelta(days=plan_info['duration_days'])
            is_permanent = False
        
        # Inserir assinatura
        db.execute_query(
            """INSERT INTO subscriptions 
            (user_id, plan_id, payment_id, payment_method, payment_status, 
             start_date, end_date, is_permanent, is_active) 
            VALUES (%s, %s, %s, 'pix_automatico', 'approved', NOW(), %s, %s, TRUE)""",
            (user_id, plan_id, payment_id, end_date, is_permanent),
            commit=True
        )
        
        # Atualizar status VIP do usuário
        db.execute_query(
            "UPDATE users SET is_vip = TRUE WHERE id = %s",
            (user_id,),
            commit=True
        )
        
        logger.info(f"✅ Assinatura CNPay registrada: usuário {user_id}, plano {plan_id}")
        return True
        
    except Exception as e:
        logger.error(f"❌ Erro ao registrar assinatura CNPay: {e}")
        return False

async def gerar_salvar_link_e_webhook(bot, db, user_id, username, group_id, plan_info, email, phone):
    from datetime import datetime, timedelta
    config = load_config()
    n8n_url = config.get('n8n_webhook_url')
    expire_date = datetime.now() + timedelta(days=30)
    invite_link_obj = await bot.create_chat_invite_link(
        chat_id=group_id,
        name=f"VIP {user_id} - {plan_info['name']}",
        expire_date=expire_date,
        member_limit=1,
        creates_join_request=False
    )
    invite_link = invite_link_obj.invite_link
    db.execute_query(
        """INSERT INTO vip_invites (user_id, username, invite_link, created_at, expires_at)
           VALUES (%s, %s, %s, NOW(), %s)""",
        (user_id, username, invite_link, expire_date),
        commit=True
    )
    payload = {
        "user_id": user_id,
        "username": username,
        "invite_link": invite_link,
        "expires_at": expire_date.isoformat(),
        "email": email,
        "phone": phone,
        "plan": plan_info['name'],
        "created_at": datetime.now().isoformat()
    }
    try:
        if n8n_url:
            response = requests.post(n8n_url, json=payload, timeout=10)
            response.raise_for_status()
        else:
            logger.error("n8n_webhook_url não configurado no bot_config!")
    except Exception as e:
        logger.error(f"Erro ao enviar webhook para n8n: {e}")
    return invite_link, expire_date

def handle_transaction_paid(transaction_id, transaction_status, data, db, payment):
    """Transação paga"""
    try:
        # Atualizar pagamento
        db.execute_query(
            """UPDATE payments 
                SET status = 'approved', updated_at = NOW() 
            WHERE payment_id = %s""",
            (transaction_id,),
            commit=True
        )
        
        # Extrair dados do produto
        order_items = data.get('orderItems', [])
        plan_id = 1  # Padrão
        if order_items:
            product_data = order_items[0].get('product', {})
            product_external_id = product_data.get('externalId')
            if product_external_id:
                # Buscar plano apenas pelo id
                if str(product_external_id).startswith('plan_'):
                    try:
                        plan_id = int(product_external_id.replace('plan_', ''))
                    except ValueError:
                        plan_id = 1
                else:
                    try:
                        plan_id = int(product_external_id)
                    except ValueError:
                        plan_id = 1
        
        user_id = payment['user_id']
        
        # Buscar informações do plano
        plan_info = db.execute_fetch_one(
            "SELECT * FROM vip_plans WHERE id = %s",
            (plan_id,)
        )
        
        if not plan_info:
            logger.error(f"Plano {plan_id} não encontrado")
            return {'success': False, 'error': 'Plano não encontrado'}
        
        # Verificar se já existe assinatura ativa
        existing_subscription = db.execute_fetch_one(
            """SELECT * FROM subscriptions 
            WHERE user_id = %s 
            AND is_active = TRUE
            AND (is_permanent = TRUE OR end_date > NOW())
            ORDER BY end_date DESC
            LIMIT 1""",
            (user_id,)
        )
        
        if existing_subscription:
            # RENOVAÇÃO - Calcular nova data de expiração
            if plan_info['duration_days'] == -1:
                # Plano permanente
                end_date = datetime(2099, 12, 31)
                is_permanent = True
            else:
                # Renovação - soma os dias à data atual de expiração
                current_end_date = existing_subscription['end_date']
                if isinstance(current_end_date, str):
                    current_end_date = datetime.strptime(current_end_date, "%Y-%m-%d %H:%M:%S")
                end_date = current_end_date + timedelta(days=plan_info['duration_days'])
                is_permanent = False
                
                days_left = (current_end_date - datetime.now()).days
                logger.info(f"Renovação detectada. Dias restantes: {days_left}, Novos dias: {plan_info['duration_days']}, Total: {days_left + plan_info['duration_days']}")
            
            # Desativar assinatura atual
            db.execute_query(
                "UPDATE subscriptions SET is_active = FALSE WHERE id = %s",
                (existing_subscription['id'],),
                commit=True
            )
            
            # Inserir nova assinatura (renovação)
            db.execute_query(
                """INSERT INTO subscriptions 
                (user_id, plan_id, payment_id, payment_method, payment_status, 
                 start_date, end_date, is_permanent, is_active,
                 notified_1, notified_2, notified_3, renewal_notified) 
                VALUES (%s, %s, %s, 'pix_automatico', 'approved', NOW(), %s, %s, TRUE, FALSE, FALSE, FALSE, FALSE)""",
                (user_id, plan_id, transaction_id, end_date, is_permanent),
                commit=True
            )
            
            logger.info(f"✅ Renovação de assinatura VIP para usuário {user_id}")
            logger.info(f"✅ Nova data de expiração: {end_date}")
            
        else:
            # NOVA ASSINATURA
            if plan_info['duration_days'] == -1:
                end_date = datetime(2099, 12, 31)
                is_permanent = True
            else:
                end_date = datetime.now() + timedelta(days=plan_info['duration_days'])
                is_permanent = False
            
            db.execute_query(
                """INSERT INTO subscriptions (
                    user_id, plan_id, payment_id, payment_method, payment_status,
                    start_date, end_date, is_permanent, is_active
                ) VALUES (
                    %s, %s, %s, 'pix_automatico', 'approved',
                    NOW(), %s, %s, TRUE
                )""",
                (user_id, plan_id, transaction_id, end_date, is_permanent),
                commit=True
            )
            logger.info(f"✅ Nova assinatura VIP criada para usuário {user_id}")
        
        # Atualizar status VIP do usuário
        db.execute_query(
            "UPDATE users SET is_vip = TRUE WHERE id = %s",
            (user_id,),
            commit=True
        )
        logger.info(f"✅ Acesso VIP ativado para usuário {user_id}")
        
        # Entregar acesso VIP diretamente (em vez de usar fila)
        try:
            logger.info(f"🎯 Iniciando entrega de acesso VIP para usuário {user_id} (plano {plan_id})")
            
            # Buscar grupos associados ao plano
            groups = db.execute_fetch_all(
                """SELECT vg.group_id, vg.group_name
                FROM vip_groups vg
                JOIN plan_groups pg ON vg.id = pg.group_id
                WHERE pg.plan_id = %s AND vg.is_active = TRUE""",
                (plan_id,)
            )
            
            if groups:
                # Tentar usar contexto compartilhado primeiro
                from bot import get_shared_context
                shared_context = get_shared_context()
                
                if shared_context and shared_context.is_available():
                    logger.info("🔄 Usando contexto compartilhado para entrega de acesso...")
                    import asyncio
                    
                    try:
                        loop = asyncio.get_event_loop()
                    except RuntimeError:
                        loop = asyncio.new_event_loop()
                        asyncio.set_event_loop(loop)
                    
                    # Entregar acesso usando contexto compartilhado
                    loop.run_until_complete(deliver_vip_access(shared_context.get_bot(), user_id, plan_id, groups, plan_info))
                    logger.info(f"✅ Entrega de acesso VIP concluída via contexto compartilhado para usuário {user_id}")
                else:
                    # Fallback: tentar instância global
                    from bot import get_bot_instance
                    bot = get_bot_instance()
                    
                    if bot:
                        logger.info("🔄 Usando instância global do bot para entrega de acesso...")
                        import asyncio
                        try:
                            loop = asyncio.get_event_loop()
                        except RuntimeError:
                            loop = asyncio.new_event_loop()
                            asyncio.set_event_loop(loop)
                        
                        loop.run_until_complete(deliver_vip_access(bot, user_id, plan_id, groups, plan_info))
                        logger.info(f"✅ Entrega de acesso VIP concluída via instância global para usuário {user_id}")
                    else:
                        # Fallback final: criar nova instância
                        logger.info("🔄 Criando nova instância do bot para entrega de acesso...")
                        config = load_config()
                        if config and 'bot_token' in config:
                            from telegram import Bot
                            bot = Bot(token=config['bot_token'])
                            
                            import asyncio
                            try:
                                loop = asyncio.get_event_loop()
                            except RuntimeError:
                                loop = asyncio.new_event_loop()
                                asyncio.set_event_loop(loop)
                            
                            loop.run_until_complete(deliver_vip_access(bot, user_id, plan_id, groups, plan_info))
                            logger.info(f"✅ Entrega de acesso VIP concluída via nova instância para usuário {user_id}")
                        else:
                            logger.error("❌ Token do bot não encontrado para entrega de acesso")
            else:
                logger.info(f"Nenhum grupo encontrado para o plano {plan_id}")
                
        except Exception as e:
            logger.error(f"❌ Erro ao entregar acesso VIP para usuário {user_id}: {e}")
            import traceback
            logger.error(f"Traceback: {traceback.format_exc()}")
        
        # Notificar admin
        try:
            notify_admin_payment_approved(transaction_id, data, db, payment, plan_id)
        except Exception as e:
            logger.error(f"⚠️ Erro ao notificar admin: {str(e)}")
        
        return {'success': True}
    except Exception as e:
        logger.error(f"❌ Erro ao processar TRANSACTION_PAID: {str(e)}")
        return {'success': False, 'error': str(e)}
    
def handle_transaction_canceled(transaction_id, transaction_status, data, db, payment):
    """Transação cancelada"""
    try:
        db.execute_query(
            """UPDATE payments 
            SET status = 'canceled', updated_at = NOW() 
            WHERE payment_id = %s""",
            (transaction_id,),
            commit=True
        )
        
        logger.info(f"✅ Status atualizado para canceled: {transaction_id}")
    
        # Notificar admin sobre cancelamento
        try:
            notify_admin_payment_canceled(transaction_id, data, db, payment)
        except Exception as e:
            logger.error(f"⚠️ Erro ao notificar admin sobre cancelamento: {str(e)}")
    
        return {'success': True}
    except Exception as e:
        logger.error(f"❌ Erro ao processar TRANSACTION_CANCELED: {str(e)}")
        return {'success': False, 'error': str(e)}

def handle_transaction_refunded(transaction_id, transaction_status, data, db, payment):
    """Transação estornada"""
    try:
        db.execute_query(
            """UPDATE payments 
            SET status = 'refunded', updated_at = NOW() 
            WHERE payment_id = %s""",
            (transaction_id,),
            commit=True
        )
        
        # Desativar assinatura
        db.execute_query(
            """UPDATE subscriptions 
                SET is_active = FALSE, updated_at = NOW() 
            WHERE payment_id = %s""",
            (transaction_id,),
            commit=True
        )
        
        # Desativar acesso VIP
        user_id = payment['user_id']
        db.execute_query(
            "UPDATE users SET is_vip = FALSE WHERE id = %s",
            (user_id,),
            commit=True
        )
        
        logger.info(f"✅ Acesso VIP desativado para usuário {user_id}")
        
        # Notificar admin sobre estorno
        try:
            notify_admin_payment_refunded(transaction_id, data, db, payment)
        except Exception as e:
            logger.error(f"⚠️ Erro ao notificar admin sobre estorno: {str(e)}")
        
        return {'success': True}
    except Exception as e:
        logger.error(f"❌ Erro ao processar TRANSACTION_REFUNDED: {str(e)}")
        return {'success': False, 'error': str(e)}

def notify_admin_payment_created(transaction_id, data, db, payment):
    """Notifica todos os admins sobre pagamento criado"""
    try:
        admin_ids = get_all_admin_ids()
        user_id = payment['user_id']
        amount = payment['amount']
        user_info = db.execute_fetch_one(
            "SELECT username, first_name, last_name FROM users WHERE id = %s",
            (user_id,)
        )
        user_display = format_user_display(user_info, user_id)
        order_items = data.get('orderItems', [])
        product_name = "Produto VIP"
        if order_items:
            product_name = order_items[0].get('product', {}).get('name', 'Produto VIP')
        notification_message = (
            f"🆕 **Novo Pagamento CNPay Criado!**\n\n"
            f"👤 **Usuário:** {user_display}\n"
            f"💎 **Produto:** {product_name}\n"
            f"💰 **Valor:** R${float(amount):.2f}\n"
            f"🆔 **Transação:** {transaction_id}\n"
            f"📅 **Data:** {datetime.now().strftime('%d/%m/%Y %H:%M')}\n\n"
            f"⏳ **Status:** Aguardando pagamento\n"
            f"🔔 O usuário receberá acesso VIP automaticamente quando o pagamento for confirmado."
        )
        for admin_id in admin_ids:
            send_admin_notification(admin_id, notification_message)
        # Enviar webhook para n8n
        try:
            config = load_config()
            n8n_url = config.get('n8n_webhook_url') if config else None
            payload = {
                "event": "PAYMENT_CREATED",
                "transaction_id": transaction_id,
                "user_id": user_id,
                "amount": float(amount),
                "product_name": product_name,
                "created_at": datetime.now().isoformat(),
                "status": "pending"
            }
            if n8n_url:
                response = requests.post(n8n_url, json=payload, timeout=10)
                response.raise_for_status()
            else:
                logger.error("n8n_webhook_url não configurado no bot_config!")
        except Exception as e:
            logger.error(f"Erro ao enviar webhook para n8n: {e}")
    except Exception as e:
        logger.error(f"❌ Erro ao notificar admins sobre pagamento criado: {str(e)}")

def notify_admin_payment_approved(transaction_id, data, db, payment, plan_id):
    try:
        admin_ids = get_all_admin_ids()
        user_id = payment['user_id']
        amount = payment['amount']
        user_info = db.execute_fetch_one(
            "SELECT username, first_name, last_name FROM users WHERE id = %s",
            (user_id,)
        )
        user_display = format_user_display(user_info, user_id)
        order_items = data.get('orderItems', [])
        product_name = "Produto VIP"
        if order_items:
            product_name = order_items[0].get('product', {}).get('name', 'Produto VIP')
        notification_message = (
            f"🎉 **Pagamento CNPay Aprovado!**\n\n"
            f"👤 **Usuário:** {user_display}\n"
            f"💎 **Produto:** {product_name}\n"
            f"💰 **Valor:** R${float(amount):.2f}\n"
            f"🆔 **Transação:** {transaction_id}\n"
            f"📅 **Data:** {datetime.now().strftime('%d/%m/%Y %H:%M')}\n\n"
            f"✅ **Status:** Aprovado\n"
            f"🎯 Acesso VIP ativado automaticamente!"
        )
        for admin_id in admin_ids:
            send_admin_notification(admin_id, notification_message)
        # Enviar webhook para n8n
        try:
            config = load_config()
            n8n_url = config.get('n8n_webhook_url') if config else None
            # Buscar grupos associados ao plano
            group_links = []
            groups = db.execute_fetch_all(
                """SELECT vg.group_id, vg.group_name FROM vip_groups vg JOIN plan_groups pg ON vg.id = pg.group_id WHERE pg.plan_id = %s AND vg.is_active = TRUE""",
                (plan_id,)
            )
            if groups:
                # Tentar usar contexto compartilhado primeiro
                try:
                    from bot import get_shared_context
                    shared_context = get_shared_context()
                except Exception as e:
                    shared_context = None
                bot = None
                if shared_context and shared_context.is_available():
                    bot = shared_context.get_bot()
                else:
                    from telegram import Bot
                    if config and 'bot_token' in config:
                        bot = Bot(token=config['bot_token'])
                import asyncio
                try:
                    loop = asyncio.get_event_loop()
                except RuntimeError:
                    loop = asyncio.new_event_loop()
                    asyncio.set_event_loop(loop)
                for group in groups:
                    group_id = group['group_id']
                    group_name = group['group_name']
                    invite_link = None
                    if bot:
                        try:
                            invite_link_obj = loop.run_until_complete(bot.create_chat_invite_link(
                                chat_id=group_id,
                                name=f"VIP {user_id} - {product_name}",
                                expire_date=datetime.now() + timedelta(days=30),
                                member_limit=1,
                                creates_join_request=False
                            ))
                            invite_link = invite_link_obj.invite_link
                        except Exception as e:
                            logger.error(f"Erro ao criar link de convite para grupo {group_id}: {e}")
                    group_links.append({
                        'group_id': group_id,
                        'group_name': group_name,
                        'invite_link': invite_link
                    })
            payload = {
                "event": "PAYMENT_APPROVED",
                "transaction_id": transaction_id,
                "user_id": user_id,
                "amount": float(amount),
                "product_name": product_name,
                "plan_id": plan_id,
                "approved_at": datetime.now().isoformat(),
                "status": "approved",
                "groups": group_links
            }
            if n8n_url:
                response = requests.post(n8n_url, json=payload, timeout=10)
                response.raise_for_status()
            else:
                logger.error("n8n_webhook_url não configurado no bot_config!")
        except Exception as e:
            logger.error(f"Erro ao enviar webhook para n8n: {e}")
    except Exception as e:
        logger.error(f"❌ Erro ao notificar admins sobre pagamento aprovado: {str(e)}")

def notify_admin_payment_canceled(transaction_id, data, db, payment):
    try:
        admin_ids = get_all_admin_ids()
        user_id = payment['user_id']
        amount = payment['amount']
        user_info = db.execute_fetch_one(
            "SELECT username, first_name, last_name FROM users WHERE id = %s",
            (user_id,)
        )
        user_display = format_user_display(user_info, user_id)
        notification_message = (
            f"❌ **Pagamento CNPay Cancelado!**\n\n"
            f"👤 **Usuário:** {user_display}\n"
            f"💰 **Valor:** R${float(amount):.2f}\n"
            f"🆔 **Transação:** {transaction_id}\n"
            f"📅 **Data:** {datetime.now().strftime('%d/%m/%Y %H:%M')}\n\n"
            f"🚫 **Status:** Cancelado\n"
            f"ℹ️ O usuário não receberá acesso VIP."
        )
        for admin_id in admin_ids:
            send_admin_notification(admin_id, notification_message)
    except Exception as e:
        logger.error(f"❌ Erro ao notificar admins sobre pagamento cancelado: {str(e)}")

def notify_admin_payment_refunded(transaction_id, data, db, payment):
    try:
        admin_ids = get_all_admin_ids()
        user_id = payment['user_id']
        amount = payment['amount']
        user_info = db.execute_fetch_one(
            "SELECT username, first_name, last_name FROM users WHERE id = %s",
            (user_id,)
        )
        user_display = format_user_display(user_info, user_id)
        notification_message = (
            f"🔄 **Pagamento CNPay Estornado!**\n\n"
            f"👤 **Usuário:** {user_display}\n"
            f"💰 **Valor:** R${float(amount):.2f}\n"
            f"🆔 **Transação:** {transaction_id}\n"
            f"📅 **Data:** {datetime.now().strftime('%d/%m/%Y %H:%M')}\n\n"
            f"🔄 **Status:** Estornado\n"
            f"🚫 Acesso VIP foi removido automaticamente."
        )
        for admin_id in admin_ids:
            send_admin_notification(admin_id, notification_message)
    except Exception as e:
        logger.error(f"❌ Erro ao notificar admins sobre pagamento estornado: {str(e)}")

def format_user_display(user_info, user_id):
    """Formata exibição do usuário"""
    if not user_info:
        return f"ID: {user_id}"
    
    if user_info['username']:
        return f"@{user_info['username']}"
    elif user_info['first_name']:
        return f"{user_info['first_name']} {user_info['last_name'] or ''}".strip()
    else:
        return f"ID: {user_id}"

def send_admin_notification(admin_id, message):
    """Envia notificação para o admin usando contexto compartilhado ou criando nova instância"""
    try:
        # Tentar usar contexto compartilhado primeiro
        from bot import get_shared_context
        shared_context = get_shared_context()
        
        if shared_context and shared_context.is_available():
            logger.info("🔄 Usando contexto compartilhado para notificação...")
            import asyncio
            
            # Criar um novo loop de eventos se necessário
            try:
                loop = asyncio.get_event_loop()
            except RuntimeError:
                loop = asyncio.new_event_loop()
                asyncio.set_event_loop(loop)
            
            # Executar a função assíncrona usando contexto compartilhado
            loop.run_until_complete(shared_context.send_message(
                chat_id=admin_id,
                text=message,
                parse_mode='Markdown'
            ))
            logger.info(f"✅ Admin notificado via contexto compartilhado: {admin_id}")
            return
        
        # Fallback: tentar instância global
        from bot import get_bot_instance
        bot = get_bot_instance()
        
        if bot:
            logger.info("🔄 Usando instância global do bot...")
            import asyncio
            try:
                loop = asyncio.get_event_loop()
            except RuntimeError:
                loop = asyncio.new_event_loop()
                asyncio.set_event_loop(loop)
            
            loop.run_until_complete(bot.send_message(
                chat_id=admin_id,
                text=message,
                parse_mode='Markdown'
            ))
            logger.info(f"✅ Admin notificado via instância global: {admin_id}")
            return
        
        # Fallback final: criar nova instância
        logger.info("🔄 Criando nova instância do bot para notificação...")
        config = load_config()
        if not config or 'bot_token' not in config:
            logger.error("❌ Token do bot não encontrado na configuração")
            return
        
        from telegram import Bot
        bot = Bot(token=config['bot_token'])
        
        import asyncio
        try:
            loop = asyncio.get_event_loop()
        except RuntimeError:
            loop = asyncio.new_event_loop()
            asyncio.set_event_loop(loop)
        
        loop.run_until_complete(bot.send_message(
            chat_id=admin_id,
            text=message,
            parse_mode='Markdown'
        ))
        logger.info(f"✅ Admin notificado via nova instância: {admin_id}")
        
    except Exception as e:
        logger.error(f"❌ Erro ao enviar notificação para admin: {str(e)}")

def send_async_message(chat_id, message, parse_mode='Markdown'):
    """Função auxiliar para enviar mensagens usando contexto compartilhado"""
    try:
        # Tentar usar contexto compartilhado primeiro
        from bot import get_shared_context
        shared_context = get_shared_context()
        
        if shared_context and shared_context.is_available():
            logger.info("🔄 Usando contexto compartilhado para envio de mensagem...")
            import asyncio
            
            try:
                loop = asyncio.get_event_loop()
            except RuntimeError:
                loop = asyncio.new_event_loop()
                asyncio.set_event_loop(loop)
            
            loop.run_until_complete(shared_context.send_message(
                chat_id=chat_id,
                text=message,
                parse_mode=parse_mode
            ))
            return True
        
        # Fallback: tentar instância global
        from bot import get_bot_instance
        bot = get_bot_instance()
        
        if bot:
            logger.info("🔄 Usando instância global do bot...")
            import asyncio
            try:
                loop = asyncio.get_event_loop()
            except RuntimeError:
                loop = asyncio.new_event_loop()
                asyncio.set_event_loop(loop)
            
            loop.run_until_complete(bot.send_message(
                chat_id=chat_id,
                text=message,
                parse_mode=parse_mode
            ))
            return True
        
        # Fallback final: criar nova instância
        logger.info("🔄 Criando nova instância do bot...")
        config = load_config()
        if not config or 'bot_token' not in config:
            logger.error("❌ Token do bot não encontrado na configuração")
            return False
        
        from telegram import Bot
        bot = Bot(token=config['bot_token'])
        
        import asyncio
        try:
            loop = asyncio.get_event_loop()
        except RuntimeError:
            loop = asyncio.new_event_loop()
            asyncio.set_event_loop(loop)
        
        loop.run_until_complete(bot.send_message(
            chat_id=chat_id,
            text=message,
            parse_mode=parse_mode
        ))
        return True
        
    except Exception as e:
        logger.error(f"❌ Erro ao enviar mensagem: {str(e)}")
        return False

async def deliver_vip_access(bot, user_id, plan_id, groups, plan_info):
    """Entrega acesso VIP diretamente para o usuário"""
    try:
        config = load_config()
        
        # Calcular duração do link baseada no plano
        if plan_info['duration_days'] == -1:
            # Plano permanente - link de 30 dias (renovável)
            link_duration = 30
            link_message = "O link expira em 30 dias e pode ser renovado."
        else:
            # Plano temporário - link com duração igual ao plano
            link_duration = plan_info['duration_days']
            link_message = f"O link expira em {link_duration} dias (duração do seu plano)."
        
        # Adicionar usuário aos grupos
        for group in groups:
            group_id = group['group_id']
            group_name = group['group_name']
            
            try:
                # Verificar se o grupo é um supergrupo
                chat = await bot.get_chat(group_id)
                if chat.type in ['group', 'supergroup', 'channel']:
                    try:
                        # Criar link de convite com duração baseada no plano
                        invite_link = await bot.create_chat_invite_link(
                            chat_id=group_id,
                            name=f"VIP {user_id} - {plan_info['name']}",
                            expire_date=datetime.now() + timedelta(days=link_duration),
                            member_limit=1,
                            creates_join_request=False
                        )
                        
                        # Enviar link para o usuário
                        await bot.send_message(
                            chat_id=user_id,
                            text=f"⬇ ESTOU PELADINHA TE ESPERANDO 🙈\n\n"
                                 f"😈 Clique em \" VER CANAL \" pra gente começar a brincar 🔥\n\n"
                                 f"💎 VIP DA EDUARDA 🍑🔥\n\n"
                                 f"📝 O link expira em {plan_info['duration_days']} dias (duração do seu plano).\n\n"
                                 f"⚠ Este link é único e só pode ser usado uma vez.\n\n"
                                 f"**Link:** {invite_link.invite_link}"
                        )
                        logger.info(f"Link de convite enviado para usuário {user_id} - grupo {group_id} (duração: {link_duration} dias)")
                        
                    except Exception as e:
                        logger.error(f"Erro ao criar link de convite para grupo {group_id}: {e}")
                        # Se falhar, tenta obter link existente
                        try:
                            invite_link = await bot.export_chat_invite_link(chat_id=group_id)
                            await bot.send_message(
                                chat_id=user_id,
                                text=f"⬇ ESTOU PELADINHA TE ESPERANDO 🙈\n\n"
                                     f"😈 Clique em \" VER CANAL \" pra gente começar a brincar 🔥\n\n"
                                     f"💎 VIP DA EDUARDA 🍑🔥\n\n"
                                     f"📝 O link expira em {plan_info['duration_days']} dias (duração do seu plano).\n\n"
                                     f"⚠ Este link é único e só pode ser usado uma vez.\n\n"
                                     f"**Link:** {invite_link}"
                            )
                            logger.info(f"Link existente enviado para usuário {user_id} - grupo {group_id}")
                        except Exception as e2:
                            logger.error(f"Erro ao obter link existente: {e2}")
                            # Se tudo falhar, notifica o admin
                            if config and 'admin_id' in config:
                                admin_id = config['admin_id']
                                await bot.send_message(
                                    chat_id=admin_id,
                                    text=f"⚠️ Erro ao gerar link para usuário {user_id} no grupo {group_id}.\n"
                                         f"Erro: {e}\nErro do link: {e2}\n\n"
                                         f"Verifique se o bot tem permissões de administrador no grupo."
                                )
                else:
                    logger.error(f"Grupo {group_id} não é um grupo ou supergrupo válido")
                    # Notifica o admin
                    if config and 'admin_id' in config:
                        admin_id = config['admin_id']
                        await bot.send_message(
                            chat_id=admin_id,
                            text=f"⚠️ Grupo {group_id} não é um grupo ou supergrupo válido.\nTipo: {chat.type}"
                        )
                        
            except Exception as e:
                logger.error(f"Erro ao processar grupo {group_id} para usuário {user_id}: {e}")
                # Notifica o admin
                if config and 'admin_id' in config:
                    admin_id = config['admin_id']
                    await bot.send_message(
                        chat_id=admin_id,
                        text=f"⚠️ Erro ao processar grupo {group_id} para usuário {user_id}.\nErro: {e}"
                    )
        
        return True
        
    except Exception as e:
        logger.error(f"Erro ao entregar acesso VIP: {e}")
        return False

def load_config():
    """Carrega configuração do bot do banco de dados"""
    db = Database()
    try:
        db.connect()
        if not db.connection:
            logger.error("Não foi possível conectar ao banco de dados")
            return None
            
        # Usar o novo método que fecha o cursor automaticamente
        rows = db.execute_fetch_all("SELECT config_key, config_value, config_type FROM bot_config")
        
        config = {}
        for row in rows:
            key = row['config_key']
            value = row['config_value']
            config_type = row['config_type']
            # Conversão de tipo
            if config_type == 'boolean':
                config[key] = value.lower() == 'true'
            elif config_type == 'integer':
                config[key] = int(value)
            elif config_type == 'json':
                config[key] = json.loads(value)
            else:
                config[key] = value
        return config
    except Exception as e:
        logger.error(f"Erro ao carregar configuração: {e}")
        return None
    finally:
        db.close()

def get_all_admin_ids():
    db = Database()
    db.connect()
    admins = db.execute_fetch_all("SELECT admin_id FROM admins")
    db.close()
    return [a['admin_id'] for a in admins if a['admin_id']]

# Endpoints auxiliares
@app.route('/webhook/cnpay/health', methods=['GET'])
def health_check():
    """Verifica se o webhook está funcionando"""
    try:
        # Testar conexão com banco
        db = Database()
        db.connect()
        if db.connection and db.connection.is_connected():
            db.close()
            return jsonify({
                'status': 'healthy',
                'timestamp': datetime.now().isoformat(),
                'processed_transactions': len(processed_events) # Changed from processed_transactions to processed_events
            })
        else:
            return jsonify({
                'status': 'unhealthy',
                'error': 'Database connection failed',
                'timestamp': datetime.now().isoformat()
            }), 500
    except Exception as e:
        return jsonify({
            'status': 'unhealthy',
            'error': str(e),
            'timestamp': datetime.now().isoformat()
        }), 500

@app.route('/webhook/cnpay/clear-cache', methods=['POST'])
def clear_cache():
    """Limpa o cache de transações processadas"""
    try:
        with transaction_lock:
            count = len(processed_events) # Changed from processed_transactions to processed_events
            processed_events.clear()
            logger.info(f"🧹 Cache limpo: {count} transações removidas")
            return jsonify({
                'success': True,
                'cleared_transactions': count,
                'timestamp': datetime.now().isoformat()
            })
    except Exception as e:
        logger.error(f"❌ Erro ao limpar cache: {str(e)}")
        return jsonify({'error': str(e)}), 500

@app.route('/webhook/cnpay/status', methods=['GET'])
def webhook_status():
    """Mostra status detalhado do webhook"""
    return jsonify({
        'status': 'running',
        'processed_transactions_count': len(processed_events), # Changed from processed_transactions to processed_events
        'processed_transactions': list(processed_events)[-10:],  # Últimas 10
        'timestamp': datetime.now().isoformat()
    })

@app.route('/webhook/cnpay/test', methods=['POST'])
def test_webhook():
    """Endpoint para testar webhook com dados simulados"""
    test_data = {
        "event": "TRANSACTION_PAID",
        "token": "test_token",
        "client": {
            "id": "test_client_id",
            "name": "Test User",
            "email": "test@example.com"
        },
        "transaction": {
            "id": "test_transaction_id",
            "status": "PAID",
            "paymentMethod": "PIX",
            "amount": 10.00
        },
        "subscription": {
            "id": "test_subscription_id",
            "identifier": "123_1"
        },
        "orderItems": [
            {
                "product": {
                    "externalId": "plan_1",
                    "name": "Plano VIP Test"
                },
                "price": 10.00
            }
        ]
    }
    
    # Simular requisição usando o payload de teste
    try:
        # Temporariamente substituir request.json
        original_json = request.json
        request.json = test_data
        
        # Chamar o webhook
        result = cnpay_webhook()
        
        # Restaurar request.json original
        request.json = original_json
        
        return result
    except Exception as e:
        logger.error(f"❌ Erro no teste do webhook: {str(e)}")
        return jsonify({'error': 'Erro no teste'}), 500

if __name__ == '__main__':
    logger.info("🚀 Iniciando Webhook CNPay na porta 8082")
    app.run(host='0.0.0.0', port=8082, debug=True)