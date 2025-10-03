# Changelog

Todas as mudanças importantes deste projeto serão documentadas aqui.

## 2025-07-24

### Adicionado
- envio de webhook com n8n PAGAMENTO CRIADO e PAGAMENTO APROVADO.
- Melhoramento na Logica 
- adicionado menu admin gerenciamento de admin
- melhoramento no layout do menu admin
- adicionado menu admin gerenciamento de admin
- melhoramento no layout do menu admin
- criado a tabela admins no banco de dados armazenar uma lista de admins permitido pra acessar o bot

### Corrigido
- corrigido mensagem de erro ao editar plano
- corrigido envio de mensagem no broadcast emojis fonts
- corrigido edicao de texto mensagem de inicio e mensagem de pagamento
- removido colunas nao usadas no banco de dados


## 2025-07-02

### Adicionado
- Menu para adicionar planos pelo bot
- Menu para editar planos existentes
- Menu para associar grupos a um plano existente
- Botão de exportar para Excel no menu estatísticas
- Fluxo completo de criação de planos VIP com grupos
- Pergunta automática para criar grupo VIP ao adicionar plano
- Inserção automática na tabela vip_groups e plan_groups
- Guia completo para configuração no Railway (GUIA_RAILWAY.md)
- Script de verificação de configurações (verificar_config.py)


### Alterado
- Arquivo db_config.py otimizado e simplificado
- Removidas configurações hardcoded e redundantes
- Simplificado para apenas 2 ambientes: local e Railway
- Adicionadas verificações de segurança para DB_CONFIG None
- Melhorado tratamento de erros de conexão com banco
- Removidos emojis da documentação para maior profissionalismo

### Corrigido
- Tratamento de configurações de banco quando não configuradas
- Verificações de segurança em database.py, bot.py e setup_config.py
- Redundância de código no db_config.py


## 2025-06-23

### Testes 
- Testado a correçao do Bug de Contexto de Envio de Mensagens.
- Testado o Envio de Mensagens do Broadcast Envio Quadrado Redondo e Envio Normal.
- testado geraçao de qrcode e recebimento de convite
- testado remoçao de usuario vencido

### Adicionado
- Interface de envio com botao em Broadcast.
- Logica de broadcast pra envio com ou sem botao de redirecionamento

### Alterado
- Melhoramento no envio do Broadcast.
- Layout melhorado de pergunta no Broadcast

### Corrigido
- Bug de Contexto de envio em Mensagens.
- Melhoramento na Logica
- Melhoramento na logica dos split
- corrigido a geraçao do qrcode do pix
- corrigido o  envio de convite ao usuario pos compra

---