#!/usr/bin/env python3
import mysql.connector
from db_config import get_database_config

def create_admin_vip_table():
    """Cria a tabela admin_vip_payments se não existir"""
    config = get_database_config()
    
    try:
        # Conectar ao banco
        connection = mysql.connector.connect(**config)
        cursor = connection.cursor()
        
        # SQL para criar a tabela
        create_table_sql = """
        CREATE TABLE IF NOT EXISTS admin_vip_payments (
            id int NOT NULL AUTO_INCREMENT,
            admin_id bigint NOT NULL COMMENT 'ID do admin no Telegram',
            amount decimal(10,2) NOT NULL COMMENT 'Valor do pagamento',
            description varchar(255) NOT NULL COMMENT 'Descrição do pagamento',
            external_reference varchar(255) NOT NULL COMMENT 'Referência externa do pagamento',
            pix_code text COMMENT 'Código PIX gerado',
            status enum('pending','approved','rejected','expired') NOT NULL DEFAULT 'pending' COMMENT 'Status do pagamento',
            created_at datetime DEFAULT CURRENT_TIMESTAMP COMMENT 'Data de criação',
            approved_at datetime DEFAULT NULL COMMENT 'Data de aprovação',
            expires_at datetime DEFAULT NULL COMMENT 'Data de expiração',
            PRIMARY KEY (id),
            KEY idx_admin_id (admin_id),
            KEY idx_status (status),
            KEY idx_external_reference (external_reference)
        ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Pagamentos VIP de administradores'
        """
        
        # Executar SQL
        cursor.execute(create_table_sql)
        connection.commit()
        
        print("✅ Tabela admin_vip_payments criada com sucesso!")
        
    except Exception as e:
        print(f"❌ Erro ao criar tabela: {e}")
    finally:
        if connection.is_connected():
            cursor.close()
            connection.close()

if __name__ == "__main__":
    create_admin_vip_table()
