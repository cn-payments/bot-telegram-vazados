# Guia Completo: Bot Telegram no Railway

## Pré-requisitos

- Conta no [Railway](https://railway.app)
- Conta no [Telegram](https://telegram.org)
- Bot criado no [@BotFather](https://t.me/botfather)

---

## Passo a Passo Completo

### 1. Criar o Bot no Telegram

1. **Abra o Telegram** e procure por `@BotFather`
2. **Envie**: `/newbot`
3. **Digite o nome do bot**: `Meu Bot VIP`
4. **Digite o username**: `meu_bot_vip_bot` (deve terminar em `bot`)
5. **Copie o TOKEN** que aparecer (algo como: `1234567890:ABCdefGHIjklMNOpqrsTUVwxyz`)

### 2. Fazer Fork do Repositório

1. **Acesse**: https://github.com/seu-usuario/cnpay-bot
2. **Clique em "Fork"** (canto superior direito)
3. **Aguarde** o fork ser criado

### 3. Deploy no Railway

1. **Acesse**: https://railway.app
2. **Faça login** com GitHub
3. **Clique em "New Project"**
4. **Selecione "Deploy from GitHub repo"**
5. **Escolha seu repositório** (o que você fez fork)
6. **Clique em "Deploy Now"**

### 4. Configurar Variáveis de Ambiente

**IMPORTANTE**: Configure estas variáveis **ANTES** de iniciar o bot!

1. **No Railway**, clique na aba **Variables**
2. **Adicione cada variável**:

#### Variáveis Obrigatórias

| Variável | Valor | Exemplo |
|----------|-------|---------|
| `BOT_TOKEN` | Token do seu bot | `1234567890:ABCdefGHIjklMNOpqrsTUVwxyz` |
| `ADMIN_ID` | Seu ID do Telegram | `123456789` |

#### Variáveis do Banco de Dados

| Variável | Valor | Exemplo |
|----------|-------|---------|
| `DB_HOST` | Host do MySQL | `switchback.proxy.rlwy.net` |
| `DB_PORT` | Porta do MySQL | `53702` |
| `DB_USER` | Usuário do MySQL | `root` |
| `DB_PASSWORD` | Senha do MySQL | `sua_senha_aqui` |
| `DB_NAME` | Nome do banco | `bot_vip` |

### 5. Criar Banco de Dados MySQL

1. **No Railway**, clique em **"New"** → **"Database"** → **"Add MySQL"**
2. **Aguarde** o banco ser criado
3. **Clique no banco** e vá na aba **"Connect"**
4. **Copie as informações**:
   - Host
   - Port
   - User
   - Password
5. **Configure as variáveis** `DB_HOST`, `DB_PORT`, `DB_USER`, `DB_PASSWORD` com esses valores

### 6. Configurar o Bot

1. **No Railway**, vá na aba **Deployments**
2. **Clique em "Redeploy"** na última versão
3. **Aguarde** o deploy completar
4. **Vá na aba "Logs"** e verifique se apareceu:
   ```
   Banco de dados configurado corretamente
   Bot iniciado com sucesso
   ```

### 7. Testar o Bot

1. **Abra o Telegram**
2. **Procure seu bot** pelo username
3. **Envie**: `/start`
4. **Teste**: `/admin` (se você for admin)

---

## Problemas Comuns

### Bot não responde
- Verifique se o `BOT_TOKEN` está correto
- Confirme se o deploy foi bem-sucedido

### Erro de banco de dados
- Verifique se todas as variáveis `DB_*` estão configuradas
- Confirme se o MySQL está ativo no Railway

### Erro de configuração
- Verifique se o `ADMIN_ID` está correto
- Use `/admin` no bot para configurar

---

## Comandos do Bot

| Comando | Função |
|---------|--------|
| `/start` | Iniciar bot |
| `/vip` | Ver planos VIP |
| `/admin` | Painel administrativo |

---

## Configuração Inicial

Após o bot estar funcionando:

1. **Envie**: `/admin` no bot
2. **Vá em**: "Configurações"
3. **Configure**:
   - Token do MercadoPago (se usar)
   - Chave PIX
   - Nome do titular PIX
4. **Vá em**: "Planos VIP"
5. **Configure** os planos desejados

---

## Pronto!

Seu bot está funcionando! Agora você pode:

- Receber usuários
- Vender planos VIP
- Gerenciar assinaturas
- Fazer broadcasts
- Monitorar estatísticas

---

## Suporte

Se tiver problemas:

1. **Verifique os logs** no Railway
2. **Confirme** todas as variáveis estão configuradas
3. **Teste** a conexão com o banco
4. **Verifique** se o token do bot está ativo

**Telegram**: @saikathesun 