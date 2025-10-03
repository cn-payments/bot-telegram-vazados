import mysql.connector
from mysql.connector import Error
from db_config import DB_CONFIG

class Database:
    def __init__(self):
        self.connection = None
    
    def connect(self):
        try:
            if DB_CONFIG is None:
                print("❌ Configuração do banco de dados não encontrada")
                print("📋 Configure as variáveis de ambiente necessárias no Railway:")
                print("   - DB_HOST")
                print("   - DB_PORT") 
                print("   - DB_USER")
                print("   - DB_PASSWORD")
                print("   - DB_NAME (opcional, padrão: bot_vip)")
                return None
                
            self.connection = mysql.connector.connect(**DB_CONFIG)
            return self.connection
        except Error as e:
            print(f"Erro ao conectar ao MySQL: {e}")
            return None
    
    def close(self):
        if self.connection and self.connection.is_connected():
            try:
                self.connection.close()
            except Exception as e:
                print(f"Erro ao fechar conexão: {e}")
    
    def execute_query(self, query, params=None, commit=False):
        cursor = None
        try:
            cursor = self.connection.cursor(dictionary=True)
            cursor.execute(query, params or ())
            if commit:
                self.connection.commit()
            return True
        except Error as e:
            print(f"Erro ao executar query: {e}")
            if commit:
                try:
                    self.connection.rollback()
                except Exception as rollback_error:
                    print(f"Erro ao fazer rollback: {rollback_error}")
            return False
        finally:
            if cursor:
                try:
                    cursor.close()
                except Exception as close_error:
                    print(f"Erro ao fechar cursor: {close_error}")
    
    def execute_fetch_all(self, query, params=None):
        """Executa uma query e retorna todos os resultados, fechando o cursor automaticamente"""
        cursor = None
        try:
            cursor = self.connection.cursor(dictionary=True)
            cursor.execute(query, params or ())
            results = cursor.fetchall()
            return results
        except Error as e:
            print(f"Erro ao executar query: {e}")
            return []
        finally:
            if cursor:
                try:
                    cursor.close()
                except Exception as close_error:
                    print(f"Erro ao fechar cursor: {close_error}")
    
    def execute_fetch_one(self, query, params=None):
        """Executa uma query e retorna um resultado, fechando o cursor automaticamente"""
        cursor = None
        try:
            cursor = self.connection.cursor(dictionary=True)
            cursor.execute(query, params or ())
            result = cursor.fetchone()
            return result
        except Error as e:
            print(f"Erro ao executar query: {e}")
            return None
        finally:
            if cursor:
                try:
                    cursor.close()
                except Exception as close_error:
                    print(f"Erro ao fechar cursor: {close_error}")