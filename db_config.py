import os
from typing import Dict, Any

# Configuração local padrão
LOCAL_CONFIG = {
    'host': 'localhost',
    'port': 3306,
    'user': 'root',
    'password': '',  # Sem senha para desenvolvimento local
    'database': 'bot_vip',
    'charset': 'utf8mb4',
    'autocommit': True
}

def get_database_config() -> Dict[str, Any]:
    """
    Configuração simplificada do banco de dados
    Suporta apenas: Local e Railway
    """
    
    # Verificar se estamos no Railway (detecta automaticamente)
    if os.getenv('RAILWAY_ENVIRONMENT'):
        print("🚂 Detectado ambiente Railway")
        
        # Verificar se há variáveis específicas configuradas
        db_host = os.getenv('DB_HOST')
        db_port = os.getenv('DB_PORT')
        db_user = os.getenv('DB_USER')
        db_password = os.getenv('DB_PASSWORD')
        db_name = os.getenv('DB_NAME')
        
        # Se as variáveis estão configuradas, usar elas
        if db_host and db_port and db_user and db_password:
            print("🔧 Usando variáveis de ambiente do Railway")
            return {
                'host': db_host,
                'port': int(db_port),
                'user': db_user,
                'password': db_password,
                'database': db_name or 'bot_vip',
                'charset': 'utf8mb4',
                'autocommit': True
            }
        else:
            print("⚠️ Variáveis de ambiente do Railway não configuradas")
            print("📋 Configure as seguintes variáveis no Railway:")
            print("   - DB_HOST")
            print("   - DB_PORT") 
            print("   - DB_USER")
            print("   - DB_PASSWORD")
            print("   - DB_NAME (opcional, padrão: bot_vip)")
            return None
    
    # Desenvolvimento local (padrão)
    else:
        print("🏠 Modo desenvolvimento local")
        return LOCAL_CONFIG.copy()

# Configuração principal
DB_CONFIG = get_database_config()

# Função para mostrar a configuração atual
def show_database_config():
    """Mostra a configuração atual do banco de dados"""
    if DB_CONFIG is None:
        print("\n❌ CONFIGURAÇÃO DO BANCO DE DADOS NÃO ENCONTRADA")
        print("=" * 50)
        print("Configure as variáveis de ambiente necessárias")
        print("=" * 50)
        return
        
    print("\n🗄️ CONFIGURAÇÃO ATUAL DO BANCO DE DADOS")
    print("=" * 50)
    print(f"🏠 Host: {DB_CONFIG['host']}")
    print(f"🚪 Porta: {DB_CONFIG['port']}")
    print(f"👤 Usuário: {DB_CONFIG['user']}")
    print(f"🔑 Senha: {'*' * len(DB_CONFIG['password']) if DB_CONFIG['password'] else 'Nenhuma'}")
    print(f"📊 Banco: {DB_CONFIG['database']}")
    print(f"🔤 Charset: {DB_CONFIG['charset']}")
    print("=" * 50)

def set_environment(env_type: str):
    """
    Define manualmente o ambiente
    Opções: 'local', 'railway', 'auto'
    """
    global DB_CONFIG
    
    if env_type == 'local':
        DB_CONFIG = LOCAL_CONFIG.copy()
        print("🏠 Configuração definida para LOCAL")
    elif env_type == 'railway':
        # Força detecção do Railway
        os.environ['RAILWAY_ENVIRONMENT'] = 'true'
        DB_CONFIG = get_database_config()
        print("🚂 Configuração definida para RAILWAY")
    elif env_type == 'auto':
        DB_CONFIG = get_database_config()
        print("🤖 Configuração automática aplicada")
    else:
        print(f"❌ Ambiente '{env_type}' não reconhecido")
        print("📋 Opções disponíveis: 'local', 'railway', 'auto'")
        return False
    
    show_database_config()
    return True

# Mostrar configuração ao importar o módulo
if __name__ == "__main__":
    show_database_config()
    print("\n📋 Para alterar o ambiente, use:")
    print("   set_environment('local')")
    print("   set_environment('railway')")
    print("   set_environment('auto')")
