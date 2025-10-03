#Telegram Bot CNPay

Bot do Telegram para gerenciamento de assinaturas VIP com integração CNPay.

## 🚀 Deploy Rápido

### 🌐 Railway (Produção)
**📖 Guia Completo**: [GUIA_RAILWAY.md](GUIA_RAILWAY.md) - Passo a passo para iniciantes

**Resumo rápido**:
1. **Fork** este repositório
2. **Deploy** no Railway
3. **Configure** as variáveis de ambiente
4. **Crie** banco MySQL no Railway
5. **Teste** o bot

### 🏠 Desenvolvimento Local
1. **Configure o ambiente local**:
   ```bash
   python setup_local.py
   ```

2. **Instale o MySQL Server** e crie o banco `bot_vip`

3. **Execute o bot**:
   ```bash
   python bot.py
   ```

## 📋 Funcionalidades

- ✅ Pagamentos PIX Automático (CNPay)
- ✅ Gerenciamento de Assinaturas VIP
- ✅ Sistema de Grupos VIP
- ✅ Broadcast de Mensagens e Vídeos todos os formatos
- ✅ menu Administrativo
- ✅ Webhooks Automáticos
- ✅ Notificações de Expiração

## 🔧 Configuração

### Variáveis de Ambiente

Para instruções detalhadas de configuração, consulte [RAILWAY_SETUP.md](RAILWAY_SETUP.md).

```env
# Bot
BOT_TOKEN=seu_token_do_bot
ADMIN_ID=seu_id_do_admin

# Banco de Dados
DB_HOST=localhost
DB_PORT=3306
DB_USER=botuser
DB_PASSWORD=botpassword
DB_NAME=bot_vip

# Pagamento (opcional)
MERCADOPAGO_ACCESS_TOKEN=seu_token_mercadopago
CNPAY_API_KEY=sua_chave_cnpay
CNPAY_WEBHOOK_SECRET=seu_segredo_webhook
```

## 🛠️ Troubleshooting

### Erro JSONDecodeError no CNPay

Se você encontrar o erro `JSONDecodeError: Expecting value: line 1 column 1 (char 0)`, isso indica que a API do CNPay está retornando uma resposta vazia. Possíveis causas:

1. **Credenciais inválidas** - Verifique se a API Key e Secret estão corretos
2. **Ambiente incorreto** - Confirme se está usando 'sandbox' ou 'production'
3. **URL da API** - Verifique se a URL está acessível
4. **Payload inválido** - Verifique se os dados enviados estão corretos


**Verificações no painel admin:**
- Use `/admin` no bot
- Vá em "⚙️ Configurações" > "🔧 Provedores PIX"
- Teste as conexões com "🧪 Testar Conexões"

### Logs de Debug

O bot agora inclui logs detalhados para debug:
- Status da resposta HTTP
- Headers da requisição
- Conteúdo da resposta (primeiros 500 caracteres)
- Validação de credenciais

## 📱 Comandos do Bot

- `/start` - Iniciar bot e ver planos
- `/vip` - Acessar links VIP
- `/admin` - Painel administrativo

## 🗄️ Banco de Dados

Execute o arquivo `database.sql` para criar as tabelas necessárias.

## 🐳 Docker

```bash
docker-compose up -d
```

## 📞 Suporte

- 💬 Telegram: @saikathesun

---

**Desenvolvido por @saikathesun** 