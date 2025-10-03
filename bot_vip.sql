-- MySQL dump 10.13  Distrib 8.0.36, for Win64 (x86_64)
--
-- Host: interchange.proxy.rlwy.net    Database: bot_vip
-- ------------------------------------------------------
-- Server version	9.4.0

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Temporary view structure for view `active_vip_users`
--

DROP TABLE IF EXISTS `active_vip_users`;
/*!50001 DROP VIEW IF EXISTS `active_vip_users`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `active_vip_users` AS SELECT 
 1 AS `id`,
 1 AS `username`,
 1 AS `first_name`,
 1 AS `last_name`,
 1 AS `joined_date`,
 1 AS `plan_id`,
 1 AS `plan_name`,
 1 AS `end_date`,
 1 AS `is_permanent`*/;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `activity_logs`
--

DROP TABLE IF EXISTS `activity_logs`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `activity_logs` (
  `id` int NOT NULL AUTO_INCREMENT COMMENT 'ID interno',
  `user_id` bigint DEFAULT NULL COMMENT 'ID do usuário relacionado',
  `action` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'Ação realizada',
  `description` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci COMMENT 'Descrição detalhada',
  `ip_address` varchar(45) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'IP de origem',
  `user_agent` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci COMMENT 'User agent do cliente',
  `success` tinyint(1) DEFAULT '1' COMMENT 'Se a ação foi bem-sucedida',
  `error_message` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci COMMENT 'Mensagem de erro (se houver)',
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP COMMENT 'Data de criação',
  PRIMARY KEY (`id`),
  KEY `idx_user_id` (`user_id`),
  KEY `idx_action` (`action`),
  KEY `idx_success` (`success`),
  KEY `idx_created_at` (`created_at`),
  KEY `idx_activity_logs_user_action` (`user_id`,`action`),
  CONSTRAINT `activity_logs_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Logs de atividades do sistema';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `activity_logs`
--

LOCK TABLES `activity_logs` WRITE;
/*!40000 ALTER TABLE `activity_logs` DISABLE KEYS */;
/*!40000 ALTER TABLE `activity_logs` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `admins`
--

DROP TABLE IF EXISTS `admins`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `admins` (
  `id` int NOT NULL AUTO_INCREMENT,
  `user` varchar(255) NOT NULL,
  `added_at` datetime DEFAULT CURRENT_TIMESTAMP,
  `admin_id` bigint NOT NULL,
  `is_vip` tinyint(1) NOT NULL DEFAULT 0 COMMENT 'Indica se o admin é VIP (1) ou não (0) para liberar funções extras',
  PRIMARY KEY (`id`),
  UNIQUE KEY `user_id` (`user`),
  UNIQUE KEY `admin_id` (`admin_id`),
  UNIQUE KEY `user` (`user`),
  KEY `idx_is_vip` (`is_vip`)
) ENGINE=InnoDB AUTO_INCREMENT=13 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `admins`
--

LOCK TABLES `admins` WRITE;
/*!40000 ALTER TABLE `admins` DISABLE KEYS */;
INSERT INTO `admins` VALUES (8,'cnpaygateway','2025-07-24 17:36:42',7258291634,0),(12,'lssbusiness','2025-09-03 14:52:36',1868519352,0);
/*!40000 ALTER TABLE `admins` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `bot_config`
--

DROP TABLE IF EXISTS `bot_config`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `bot_config` (
  `id` int NOT NULL AUTO_INCREMENT COMMENT 'ID interno',
  `config_key` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'Chave de configuração',
  `config_value` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci COMMENT 'Valor da configuração',
  `config_type` enum('string','boolean','integer','json') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT 'string' COMMENT 'Tipo do valor',
  `description` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci COMMENT 'Descrição da configuração',
  `is_sensitive` tinyint(1) DEFAULT '0' COMMENT 'Se é informação sensível',
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP COMMENT 'Data de criação',
  `updated_at` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT 'Data de atualização',
  PRIMARY KEY (`id`),
  UNIQUE KEY `unique_config_key` (`config_key`),
  KEY `idx_config_key` (`config_key`)
) ENGINE=InnoDB AUTO_INCREMENT=5198 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Configurações do bot';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `bot_config`
--

LOCK TABLES `bot_config` WRITE;
/*!40000 ALTER TABLE `bot_config` DISABLE KEYS */;
INSERT INTO `bot_config` VALUES (1,'bot_token','8228880639:AAHuWPGfu6H3hSf7WYv9wCmAeJRDS3hSywY','string','Token do bot no BotFather',1,'2025-06-16 22:24:27','2025-09-03 03:44:50'),(4,'mercadopago_access_token','token','string','Token de acesso do MercadoPago',1,'2025-06-16 22:24:27','2025-07-26 14:19:26'),(5,'pix_automatico_enabled','True','string','Habilitar PIX automático',0,'2025-06-16 22:24:27','2025-06-16 23:37:06'),(6,'pix_manual_enabled','True','string','Habilitar PIX manual',0,'2025-06-16 22:24:27','2025-06-16 23:37:06'),(7,'pix_manual_chave','','string','Chave PIX para pagamento manual',0,'2025-06-16 22:24:27','2025-06-16 22:24:27'),(8,'pix_manual_nome_titular','','string','Nome do titular da chave PIX',0,'2025-06-16 22:24:27','2025-06-16 22:24:27'),(9,'maintenance_mode','False','string','Modo de manutenção do bot',0,'2025-06-16 22:24:27','2025-07-24 00:55:20'),(10,'welcome_message','Olá! Bem-vindo ao Bot VIP. Use /start para ver os planos disponíveis.','string','Mensagem de boas-vindas',0,'2025-06-16 22:24:27','2025-06-16 22:24:27'),(11,'payment_methods','{\"pix_automatico\": {\"enabled\": true}, \"pix_manual\": {\"enabled\": false, \"chave_pix\": \"SUA_CHAVE_PIX_AQUI\", \"nome_titular\": \"SEU_NOME_AQUI\"}}','json','Métodos de pagamento disponíveis',0,'2025-06-16 23:07:36','2025-06-18 21:05:06'),(18,'mercadopago','{\"access_token\": \"SEU_TOKEN_MERCADOPAGO_AQUI\"}','json','Configuração: mercadopago',0,'2025-06-16 23:11:00','2025-06-16 23:11:00'),(19,'admin_settings','{\"maintenance_mode\": false, \"welcome_message\": \"Ol\\u00e1! Bem-vindo ao Bot VIP. Use /start para ver os planos dispon\\u00edveis.\"}','json','Configuração: admin_settings',0,'2025-06-16 23:11:00','2025-07-24 00:55:18'),(25,'welcome_file','{\"enabled\": true, \"file_id\": \"AgACAgEAAxkBAAN5aIT9KhqvjXaZRX3PxqyXzG5VaM0AAgGvMRs3GChECkmQZtCKmkcBAAMCAAN4AAM2BA\", \"file_type\": \"photo\"}','json','Configuração: welcome_file',0,'2025-06-16 23:24:09','2025-07-26 16:07:07'),(1063,'cnpay_enabled','true','boolean','Habilitar CNPay como provedor PIX',0,'2025-06-17 16:35:09','2025-09-03 23:02:00'),(1064,'cnpay_api_key','gestaotriangulada_cjkm52g8i5jgioob','string','Chave da API do CNPay PUBLICA',1,'2025-06-17 16:35:09','2025-09-03 03:44:50'),(1065,'cnpay_api_secret','fsrm8kawfdusqbnd5zojw0ungxkh0xucoa8tgnh0zb7xyo6u7t8bkf4h17bj26tt','string','Secret da API do CNPay',1,'2025-06-17 16:35:09','2025-09-03 03:44:50'),(1066,'cnpay_webhook_url','https://rare-connection-production.up.railway.app/webhook/cnpay','string','URL do webhook do CNPay',0,'2025-06-17 16:35:09','2025-09-03 03:44:51'),(1067,'cnpay_environment','production','string','Ambiente do CNPay (sandbox/production)',0,'2025-06-17 16:35:09','2025-06-17 17:07:36'),(1068,'pix_provider','cnpay','string','Provedor PIX padrão (mercadopago/cnpay)',0,'2025-06-17 16:35:09','2025-06-18 00:54:28'),(1069,'mercadopago_enabled','false','boolean','Habilitar MercadoPago como provedor PIX',0,'2025-06-17 16:35:09','2025-06-18 00:54:28'),(1070,'mercadopago_environment','production','string','Ambiente do MercadoPago (sandbox/production)',0,'2025-06-17 16:35:09','2025-06-17 16:35:09'),(3020,'n8n_webhook_url','https://webhook.site/1e5d89ba-c5c0-4697-b402-d8c17070dec7','string','n8n endpoint',0,'2025-07-22 20:41:27','2025-07-22 20:41:27'),(3628,'first_start_enabled','true','boolean','Ativar mensagem especial no primeiro /start',0,'2025-06-18 19:09:19','2025-06-18 19:09:19'),(3631,'support_admin','https://wa.me/5511999696429?text=Oi!%20Vim%20pelo%20bot%20do%20Telegram%2C%20entrei%20pelo%20%2Fadmin%20e%20t%C3%B4%20com%20uma%20d%C3%BAvida.%20Pode%20me%20ajudar%3F','string','Link de Suporte Admin',0,'2025-06-18 19:09:19','2025-07-26 14:19:26');
/*!40000 ALTER TABLE `bot_config` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `bot_messages`
--

DROP TABLE IF EXISTS `bot_messages`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `bot_messages` (
  `id` int NOT NULL AUTO_INCREMENT COMMENT 'ID interno',
  `message_key` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'Chave da mensagem',
  `message_value` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'Texto da mensagem',
  `language` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT 'pt-BR' COMMENT 'Idioma da mensagem',
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP COMMENT 'Data de criação',
  `updated_at` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT 'Data de atualização',
  PRIMARY KEY (`id`),
  UNIQUE KEY `unique_message_key_lang` (`message_key`,`language`),
  KEY `idx_message_key` (`message_key`),
  KEY `idx_language` (`language`)
) ENGINE=InnoDB AUTO_INCREMENT=39 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Mensagens padrão do bot';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `bot_messages`
--

LOCK TABLES `bot_messages` WRITE;
/*!40000 ALTER TABLE `bot_messages` DISABLE KEYS */;
INSERT INTO `bot_messages` VALUES (1,'welcome_message','Fala irmão, vi que você clicou interessado no Grupo VIP!\nAqui dentro é onde a grana gira de verdade — quem tá no grupo recebe as entradas quentes, direto da fonte.\n\nE ó, se você tá vendo essa mensagem, é porque a porta ainda tá aberta… mas não por muito tempo.','pt-BR','2025-06-16 22:24:27','2025-07-26 15:57:59'),(2,'start_message','Welcome Message\n\nWelcome to the group of DoutorChips for Arbitrage Bets ?\n\nHere, you’ll learn how to be profitable in a simple, clear, and effective way — without mistakes, without losses.\nOur goal is to give you the right entries so you can grow with confidence and consistency. \n\nStay tuned, because every step here is designed to maximize your results!','pt-BR','2025-06-16 22:24:27','2025-09-03 20:48:46'),(3,'payment_instructions','Para pagar, escolha o método de pagamento!','pt-BR','2025-06-16 22:24:27','2025-07-26 14:30:16'),(4,'pix_automatico_instructions','Para pagar, escolha o método de pagamento','pt-BR','2025-06-16 22:24:27','2025-07-24 15:43:24'),(5,'pix_manual_instructions','Faça o pagamento para a chave PIX: {chave_pix}','pt-BR','2025-06-16 22:24:27','2025-06-16 22:24:27'),(6,'payment_success','✅ Editar Mensagem de Sucesso\n\nMensagem atual:\n✅ Pagamento aprovado com sucesso.\n\nE agora começa uma nova fase na sua caminhada.\n\nVocê não está mais sozinho(a). A partir de agora, faz parte de um grupo que joga pra vencer todos os dias.\n\nAqui está seu acesso ao GRUPO VIP: \n\nEnvie a nova mensagem de sucesso:','pt-BR','2025-06-16 22:24:27','2025-09-03 20:49:40'),(7,'payment_pending','Aguardando confirmação do pagamento...','pt-BR','2025-06-16 22:24:27','2025-06-16 22:24:27'),(8,'payment_error','Ocorreu um erro no pagamento. Tente novamente','pt-BR','2025-06-16 22:24:27','2025-07-24 15:43:34'),(9,'admin_welcome','Bem-vindo ao painel administrativo.','pt-BR','2025-06-16 22:24:27','2025-06-16 22:24:27'),(10,'maintenance_message','O bot está em manutenção. Tente novamente mais tarde.','pt-BR','2025-06-16 22:24:27','2025-06-16 22:24:27');
/*!40000 ALTER TABLE `bot_messages` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Temporary view structure for view `expiring_subscriptions`
--

DROP TABLE IF EXISTS `expiring_subscriptions`;
/*!50001 DROP VIEW IF EXISTS `expiring_subscriptions`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `expiring_subscriptions` AS SELECT 
 1 AS `user_id`,
 1 AS `username`,
 1 AS `first_name`,
 1 AS `last_name`,
 1 AS `plan_id`,
 1 AS `plan_name`,
 1 AS `end_date`,
 1 AS `days_until_expiry`*/;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `maintenance_logs`
--

DROP TABLE IF EXISTS `maintenance_logs`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `maintenance_logs` (
  `id` int NOT NULL AUTO_INCREMENT COMMENT 'ID interno',
  `admin_id` bigint NOT NULL COMMENT 'ID do admin responsável',
  `action` enum('start_maintenance','end_maintenance','config_update','system_update') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'Ação realizada',
  `description` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci COMMENT 'Descrição detalhada',
  `maintenance_start` datetime DEFAULT NULL COMMENT 'Início da manutenção',
  `maintenance_end` datetime DEFAULT NULL COMMENT 'Término da manutenção',
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP COMMENT 'Data de criação',
  PRIMARY KEY (`id`),
  KEY `idx_admin_id` (`admin_id`),
  KEY `idx_action` (`action`),
  KEY `idx_created_at` (`created_at`),
  CONSTRAINT `maintenance_logs_ibfk_1` FOREIGN KEY (`admin_id`) REFERENCES `users` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Registro de atividades de manutenção';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `maintenance_logs`
--

LOCK TABLES `maintenance_logs` WRITE;
/*!40000 ALTER TABLE `maintenance_logs` DISABLE KEYS */;
/*!40000 ALTER TABLE `maintenance_logs` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `notifications`
--

DROP TABLE IF EXISTS `notifications`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `notifications` (
  `id` int NOT NULL AUTO_INCREMENT COMMENT 'ID interno',
  `user_id` bigint NOT NULL COMMENT 'ID do usuário destinatário',
  `type` enum('payment_success','payment_pending','subscription_expiring','subscription_expired','admin_message','system_alert') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'Tipo de notificação',
  `title` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'Título da notificação',
  `message` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'Conteúdo da notificação',
  `is_read` tinyint(1) DEFAULT '0' COMMENT 'Se foi lida',
  `sent_at` datetime DEFAULT CURRENT_TIMESTAMP COMMENT 'Data de envio',
  `read_at` datetime DEFAULT NULL COMMENT 'Data de leitura',
  PRIMARY KEY (`id`),
  KEY `idx_user_id` (`user_id`),
  KEY `idx_type` (`type`),
  KEY `idx_is_read` (`is_read`),
  KEY `idx_sent_at` (`sent_at`),
  KEY `idx_notifications_user_read` (`user_id`,`is_read`),
  CONSTRAINT `notifications_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Notificações enviadas aos usuários';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `notifications`
--

LOCK TABLES `notifications` WRITE;
/*!40000 ALTER TABLE `notifications` DISABLE KEYS */;
/*!40000 ALTER TABLE `notifications` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `payments`
--

DROP TABLE IF EXISTS `payments`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `payments` (
  `id` int NOT NULL AUTO_INCREMENT COMMENT 'ID interno',
  `payment_id` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'ID do pagamento',
  `user_id` bigint NOT NULL COMMENT 'ID do usuário',
  `plan_id` int NOT NULL COMMENT 'ID do plano',
  `amount` decimal(10,2) NOT NULL COMMENT 'Valor pago',
  `currency` varchar(3) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT 'BRL' COMMENT 'Moeda (BRL)',
  `payment_method` enum('mercadopago','pix_automatico','pix_manual') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'Método de pagamento',
  `status` enum('pending','approved','rejected','cancelled','refunded') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'pending' COMMENT 'Status do pagamento',
  `external_reference` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'Referência externa',
  `qr_code_data` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci COMMENT 'Dados do QR Code (PIX)',
  `pix_key` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'Chave PIX',
  `pix_key_type` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'Tipo de chave PIX',
  `pix_key_owner` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'Titular da chave PIX',
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP COMMENT 'Data de criação',
  `updated_at` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT 'Data de atualização',
  `processed_at` datetime DEFAULT NULL COMMENT 'Data de processamento',
  PRIMARY KEY (`id`),
  UNIQUE KEY `unique_payment_id` (`payment_id`),
  KEY `idx_user_id` (`user_id`),
  KEY `idx_plan_id` (`plan_id`),
  KEY `idx_status` (`status`),
  KEY `idx_created_at` (`created_at`),
  KEY `idx_payments_user_status` (`user_id`,`status`),
  KEY `idx_payments_created_status` (`created_at`,`status`),
  CONSTRAINT `payments_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE,
  CONSTRAINT `payments_ibfk_2` FOREIGN KEY (`plan_id`) REFERENCES `vip_plans` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=280 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Registro de pagamentos';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `payments`
--

LOCK TABLES `payments` WRITE;
/*!40000 ALTER TABLE `payments` DISABLE KEYS */;
INSERT INTO `payments` VALUES (255,'cmdza7sm10ax0khanntyw5v43',6237528772,1,47.97,'BRL','pix_automatico','pending','6237528772_1','00020101021226810014br.gov.bcb.pix2559qr.woovi.com/qr/v2/cob/731f03ac-ab4c-4cd0-8721-acd2ac3e4366520400005303986540548.465802BR5906CN_PAY6009Sao_Paulo622905251393b619d8cb41c09e68ad1b96304081D',NULL,NULL,NULL,'2025-08-06 01:20:57','2025-08-06 01:20:57',NULL),(256,'cmdzazuoo0bszkhan3w2bs0p0',6184655187,1,47.97,'BRL','pix_automatico','approved','6184655187_1','00020101021226810014br.gov.bcb.pix2559qr.woovi.com/qr/v2/cob/c05d3ff5-a30e-4085-a348-b0d415c7d112520400005303986540548.465802BR5906CN_PAY6009Sao_Paulo62290525f8dd7a3106d14bf4bc261a6036304FCD4',NULL,NULL,NULL,'2025-08-06 01:42:46','2025-08-06 01:50:18',NULL),(257,'cmdzb7awl0chd3v87jjsxk24o',6423539592,1,47.97,'BRL','pix_automatico','pending','6423539592_1','00020101021226810014br.gov.bcb.pix2559qr.woovi.com/qr/v2/cob/422d8797-7387-4d67-a6ff-e3bc6b506dc9520400005303986540548.465802BR5906CN_PAY6009Sao_Paulo622905256265165fe380424b809a0eaa763047CA8',NULL,NULL,NULL,'2025-08-06 01:48:34','2025-08-06 01:48:34',NULL),(258,'cmdzbgjqb0cvix224rhkw1bm9',7752367560,1,47.97,'BRL','pix_automatico','approved','7752367560_1','00020101021226810014br.gov.bcb.pix2559qr.woovi.com/qr/v2/cob/1bc95878-2fbf-4264-8485-7ec08cd80706520400005303986540548.465802BR5906CN_PAY6009Sao_Paulo6229052597ec877c29974d059de5c0383630443F6',NULL,NULL,NULL,'2025-08-06 01:55:45','2025-08-06 01:56:24',NULL),(259,'cmdzbgrpg0bjxginam4azvej7',1410750629,1,47.97,'BRL','pix_automatico','approved','1410750629_1','00020101021226810014br.gov.bcb.pix2559qr.woovi.com/qr/v2/cob/0b3db510-2348-49c4-a493-55556628cc99520400005303986540548.465802BR5906CN_PAY6009Sao_Paulo6229052538f782b271ad4434a21d8e31b6304B901',NULL,NULL,NULL,'2025-08-06 01:55:55','2025-08-06 01:57:11',NULL),(260,'cmdzbgtb30cwkx224nygjcp0j',5343078464,1,47.97,'BRL','pix_automatico','approved','5343078464_1','00020101021226810014br.gov.bcb.pix2559qr.woovi.com/qr/v2/cob/aeb1cbc0-1ae0-4811-962c-359303e2ca30520400005303986540548.465802BR5906CN_PAY6009Sao_Paulo62290525d7d3307d9b47439ca4f38fe7763048165',NULL,NULL,NULL,'2025-08-06 01:55:57','2025-08-06 01:58:40',NULL),(261,'cmdzbi3f30ccakhanfmd9apdv',5743300144,1,47.97,'BRL','pix_automatico','approved','5743300144_1','00020101021226810014br.gov.bcb.pix2559qr.woovi.com/qr/v2/cob/3f783f86-7e0f-4767-8ff2-e0d1625d57b6520400005303986540548.465802BR5906CN_PAY6009Sao_Paulo62290525daa37b574cfb4081be41a08926304826E',NULL,NULL,NULL,'2025-08-06 01:56:57','2025-08-06 01:59:55',NULL),(262,'cmdzbijbt0bd78tsafaykg2tr',6015265562,1,47.97,'BRL','pix_automatico','pending','6015265562_1','00020101021226810014br.gov.bcb.pix2559qr.woovi.com/qr/v2/cob/c85d9e21-beb6-42cf-bcac-63c5222421eb520400005303986540548.465802BR5906CN_PAY6009Sao_Paulo622905258748080aa1304b51afc72173b6304053D',NULL,NULL,NULL,'2025-08-06 01:57:17','2025-08-06 01:57:17',NULL),(263,'cmdzbikqx0cyhx224hu0rbt1x',6015265562,1,47.97,'BRL','pix_automatico','approved','6015265562_1','00020101021226810014br.gov.bcb.pix2559qr.woovi.com/qr/v2/cob/d6b126e8-2dd4-4b60-b03d-b56e0c44d7d5520400005303986540548.465802BR5906CN_PAY6009Sao_Paulo62290525f0e9bf629dd943ab8d47e30286304167B',NULL,NULL,NULL,'2025-08-06 01:57:19','2025-08-06 02:00:35',NULL),(264,'cmdzbimdv0ce6khank8h9anp9',6015265562,1,47.97,'BRL','pix_automatico','pending','6015265562_1','00020101021226810014br.gov.bcb.pix2559qr.woovi.com/qr/v2/cob/760f14f6-6fbc-4d72-a2cf-7bc12505c401520400005303986540548.465802BR5906CN_PAY6009Sao_Paulo62290525952c00370b6e419a89ff9bdda6304959A',NULL,NULL,NULL,'2025-08-06 01:57:21','2025-08-06 01:57:21',NULL),(265,'cmdzbo2fj0bo7369cypsmeyl4',6423539592,1,47.97,'BRL','pix_automatico','pending','6423539592_1','00020101021226810014br.gov.bcb.pix2559qr.woovi.com/qr/v2/cob/71d1e068-8727-4c6f-bc5e-17d25dd6535b520400005303986540548.465802BR5906CN_PAY6009Sao_Paulo622905252aaa20d340df4ec18274b321d6304AE27',NULL,NULL,NULL,'2025-08-06 02:01:36','2025-08-06 02:01:36',NULL),(266,'cmdzbrsq80cvntb0jcdrol9lw',1410750629,1,47.97,'BRL','pix_automatico','pending','1410750629_1','00020101021226810014br.gov.bcb.pix2559qr.woovi.com/qr/v2/cob/1b27156e-c52b-44cf-b298-5e75758a8772520400005303986540548.465802BR5906CN_PAY6009Sao_Paulo622905250c4b9b24d5cd45c8b6c4679a06304AA96',NULL,NULL,NULL,'2025-08-06 02:04:30','2025-08-06 02:04:30',NULL),(267,'cmdzbt2dw0ckgkhangzldcefo',7336789033,1,47.97,'BRL','pix_automatico','approved','7336789033_1','00020101021226810014br.gov.bcb.pix2559qr.woovi.com/qr/v2/cob/b56e64d2-da84-4b87-a22a-701509259c7b520400005303986540548.465802BR5906CN_PAY6009Sao_Paulo62290525dbd16e3e60bf43ba91463cb246304B935',NULL,NULL,NULL,'2025-08-06 02:05:29','2025-08-06 02:06:36',NULL),(268,'cmdzc0meg0bkz70esuaxln17a',6423539592,1,47.97,'BRL','pix_automatico','pending','6423539592_1','00020101021226810014br.gov.bcb.pix2559qr.woovi.com/qr/v2/cob/2f3440a4-e996-49e8-84ec-02ef89fa65d0520400005303986540548.465802BR5906CN_PAY6009Sao_Paulo62290525cb17a8a4ac7f4477a9645ff1263044C22',NULL,NULL,NULL,'2025-08-06 02:11:21','2025-08-06 02:11:21',NULL),(269,'cmdzc3hws0d9i3v87wvukvald',6617472428,1,47.97,'BRL','pix_automatico','approved','6617472428_1','00020101021226810014br.gov.bcb.pix2559qr.woovi.com/qr/v2/cob/2889808e-7614-4917-8bad-8a2149438c89520400005303986540548.465802BR5906CN_PAY6009Sao_Paulo62290525c136cdeb7a5b4e8f9b4b492376304DE2B',NULL,NULL,NULL,'2025-08-06 02:13:36','2025-08-06 02:15:50',NULL),(270,'cmdzc3jm50d6rtb0jmf3ri8he',6423539592,1,47.97,'BRL','pix_automatico','pending','6423539592_1','00020101021226810014br.gov.bcb.pix2559qr.woovi.com/qr/v2/cob/d96fd30c-060f-4abf-aa61-4f87ef60c3fb520400005303986540548.465802BR5906CN_PAY6009Sao_Paulo62290525cf11550f224e4d6aa8b74931863047CC4',NULL,NULL,NULL,'2025-08-06 02:13:38','2025-08-06 02:13:38',NULL),(271,'cmdzc3wut0db03v87rowez5mi',6423539592,3,369.97,'BRL','pix_automatico','pending','6423539592_3','00020101021226810014br.gov.bcb.pix2559qr.woovi.com/qr/v2/cob/b8ab42fe-218f-4860-8883-5ccc15b804a05204000053039865406370.465802BR5906CN_PAY6009Sao_Paulo62290525547a327a5cbb4f32ad5179a3b630454DE',NULL,NULL,NULL,'2025-08-06 02:13:55','2025-08-06 02:13:55',NULL),(272,'cmdzcikdo0cigginajkso8rrc',7336789033,1,47.97,'BRL','pix_automatico','pending','7336789033_1','00020101021226810014br.gov.bcb.pix2559qr.woovi.com/qr/v2/cob/bc948a65-6f22-48a2-934a-f00f8640b326520400005303986540548.465802BR5906CN_PAY6009Sao_Paulo622905251cf64fc874b149a0b35d1abbf630413A7',NULL,NULL,NULL,'2025-08-06 02:25:19','2025-08-06 02:25:19',NULL),(273,'cmdzcn4520duox224uxrnvxi1',7335520690,1,47.97,'BRL','pix_automatico','approved','7335520690_1','00020101021226810014br.gov.bcb.pix2559qr.woovi.com/qr/v2/cob/47fa515d-253e-4efb-b48e-e59e6be4b398520400005303986540548.465802BR5906CN_PAY6009Sao_Paulo62290525087ee65acd424c0abf57c204e63046168',NULL,NULL,NULL,'2025-08-06 02:28:51','2025-08-06 02:31:47',NULL),(274,'cmdzcocd80dvnx224895t0vyw',7140566731,1,47.97,'BRL','pix_automatico','pending','7140566731_1','00020101021226810014br.gov.bcb.pix2559qr.woovi.com/qr/v2/cob/f9c5c19e-b39b-4803-bfdd-f653f03fe54e520400005303986540548.465802BR5906CN_PAY6009Sao_Paulo62290525ef3679b9059c429dabd48b2516304991C',NULL,NULL,NULL,'2025-08-06 02:29:48','2025-08-06 02:29:48',NULL),(275,'cmf4byg5h05oryg79s97l31cn',1868519352,1,299.00,'BRL','pix_automatico','pending','1868519352_1','00020101021226810014br.gov.bcb.pix2559qr.woovi.com/qr/v2/cob/bbd50db8-3873-4908-953f-78d7714306505204000053039865406299.005802BR5906CN_PAY6009Sao_Paulo622905255b8955c29c054455bcb1d849e6304E2C7',NULL,NULL,NULL,'2025-09-03 18:48:13','2025-09-03 18:48:13',NULL),(276,'cmf4maa5y01luximil8xd7jvg',1985884040,1,299.00,'BRL','pix_automatico','pending','1985884040_1','00020101021226810014br.gov.bcb.pix2559qr.woovi.com/qr/v2/cob/25708b61-02d9-484a-a544-ed19d155fed95204000053039865406299.005802BR5906CN_PAY6009Sao_Paulo62290525a36c69446c514bc59cde958466304917E',NULL,NULL,NULL,'2025-09-03 23:37:21','2025-09-03 23:37:21',NULL),(277,'cmf4pat2z032fv8uxetguh6m7',1868519352,1,1.00,'BRL','pix_automatico','approved','1868519352_1','00020101021226810014br.gov.bcb.pix2559qr.woovi.com/qr/v2/cob/c03de5d5-930c-4fe8-aade-0fda3bf56dbf52040000530398654041.005802BR5906CN_PAY6009Sao_Paulo622905256cb7af51d010437ab05a6ede8630418CE',NULL,NULL,NULL,'2025-09-04 01:01:45','2025-09-04 01:02:39',NULL),(278,'cmf4r98r2041bma1tuglijl39',5318655974,2,999.00,'BRL','pix_automatico','pending','5318655974_2','00020101021226810014br.gov.bcb.pix2559qr.woovi.com/qr/v2/cob/75886a19-5fe4-45ac-b96b-f8fa427ea25d5204000053039865406999.005802BR5906CN_PAY6009Sao_Paulo622905254f339de86fb44a01a8bee2bec6304420E',NULL,NULL,NULL,'2025-09-04 01:56:31','2025-09-04 01:56:31',NULL),(279,'cmf4r9xd70427ma1tjjbrwzlh',5318655974,1,1.00,'BRL','pix_automatico','approved','5318655974_1','00020101021226810014br.gov.bcb.pix2559qr.woovi.com/qr/v2/cob/a155b868-52be-4c57-91e8-029b162e02bf52040000530398654041.005802BR5906CN_PAY6009Sao_Paulo62290525960a1dde9620421680cfbd70563040957',NULL,NULL,NULL,'2025-09-04 01:57:03','2025-09-04 01:59:19',NULL);
/*!40000 ALTER TABLE `payments` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `plan_groups`
--

DROP TABLE IF EXISTS `plan_groups`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `plan_groups` (
  `id` int NOT NULL AUTO_INCREMENT COMMENT 'ID interno',
  `plan_id` int NOT NULL COMMENT 'ID do plano',
  `group_id` int NOT NULL COMMENT 'ID do grupo',
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP COMMENT 'Data de criação',
  PRIMARY KEY (`id`),
  UNIQUE KEY `unique_plan_group` (`plan_id`,`group_id`),
  KEY `idx_plan_id` (`plan_id`),
  KEY `idx_group_id` (`group_id`),
  CONSTRAINT `plan_groups_ibfk_1` FOREIGN KEY (`plan_id`) REFERENCES `vip_plans` (`id`) ON DELETE CASCADE,
  CONSTRAINT `plan_groups_ibfk_2` FOREIGN KEY (`group_id`) REFERENCES `vip_groups` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Relacionamento entre planos e grupos';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `plan_groups`
--

LOCK TABLES `plan_groups` WRITE;
/*!40000 ALTER TABLE `plan_groups` DISABLE KEYS */;
INSERT INTO `plan_groups` VALUES (1,1,1,'2025-08-06 01:07:11'),(2,2,1,'2025-08-06 01:07:11'),(3,3,1,'2025-08-06 01:07:11');
/*!40000 ALTER TABLE `plan_groups` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Temporary view structure for view `sales_report`
--

DROP TABLE IF EXISTS `sales_report`;
/*!50001 DROP VIEW IF EXISTS `sales_report`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `sales_report` AS SELECT 
 1 AS `sale_date`,
 1 AS `total_sales`,
 1 AS `successful_sales`,
 1 AS `total_revenue`,
 1 AS `plan_name`,
 1 AS `payment_method`*/;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `statistics`
--

DROP TABLE IF EXISTS `statistics`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `statistics` (
  `id` int NOT NULL AUTO_INCREMENT COMMENT 'ID interno',
  `stat_date` date NOT NULL COMMENT 'Data da estatística',
  `total_users` int DEFAULT '0' COMMENT 'Total de usuários',
  `new_users` int DEFAULT '0' COMMENT 'Novos usuários no dia',
  `active_subscriptions` int DEFAULT '0' COMMENT 'Assinaturas ativas',
  `expired_subscriptions` int DEFAULT '0' COMMENT 'Assinaturas expiradas',
  `total_payments` int DEFAULT '0' COMMENT 'Total de pagamentos',
  `successful_payments` int DEFAULT '0' COMMENT 'Pagamentos aprovados',
  `total_revenue` decimal(10,2) DEFAULT '0.00' COMMENT 'Receita total',
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP COMMENT 'Data de criação',
  `updated_at` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT 'Data de atualização',
  PRIMARY KEY (`id`),
  UNIQUE KEY `unique_stat_date` (`stat_date`),
  KEY `idx_stat_date` (`stat_date`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Estatísticas diárias do bot';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `statistics`
--

LOCK TABLES `statistics` WRITE;
/*!40000 ALTER TABLE `statistics` DISABLE KEYS */;
INSERT INTO `statistics` VALUES (1,'2025-06-16',1,1,0,0,0,0,0.00,'2025-06-16 23:05:28','2025-06-16 23:05:28'),(2,'2025-06-17',1,1,0,4,0,0,0.00,'2025-06-17 16:02:50','2025-06-17 16:19:15');
/*!40000 ALTER TABLE `statistics` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `subscriptions`
--

DROP TABLE IF EXISTS `subscriptions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `subscriptions` (
  `id` int NOT NULL AUTO_INCREMENT COMMENT 'ID interno',
  `user_id` bigint NOT NULL COMMENT 'ID do usuário',
  `plan_id` int NOT NULL COMMENT 'ID do plano',
  `payment_id` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'ID do pagamento',
  `payment_method` enum('mercadopago','pix_automatico','pix_manual') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'Método de pagamento',
  `payment_status` enum('pending','approved','rejected','cancelled') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'pending' COMMENT 'Status do pagamento',
  `start_date` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT 'Data de início',
  `end_date` datetime NOT NULL COMMENT 'Data de término',
  `is_permanent` tinyint(1) DEFAULT '0' COMMENT 'Se é assinatura permanente',
  `is_active` tinyint(1) DEFAULT '1' COMMENT 'Se a assinatura está ativa',
  `notified_1` tinyint(1) DEFAULT '0' COMMENT 'Notificação 1 dia antes',
  `notified_2` tinyint(1) DEFAULT '0' COMMENT 'Notificação 2 dias antes',
  `notified_3` tinyint(1) DEFAULT '0' COMMENT 'Notificação 3 dias antes',
  `renewal_notified` tinyint(1) DEFAULT '0' COMMENT 'Notificação de renovação',
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP COMMENT 'Data de criação',
  `updated_at` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT 'Data de atualização',
  PRIMARY KEY (`id`),
  UNIQUE KEY `unique_payment_id` (`payment_id`),
  KEY `idx_user_id` (`user_id`),
  KEY `idx_plan_id` (`plan_id`),
  KEY `idx_payment_status` (`payment_status`),
  KEY `idx_end_date` (`end_date`),
  KEY `idx_is_active` (`is_active`),
  KEY `idx_subscriptions_user_active` (`user_id`,`is_active`),
  KEY `idx_subscriptions_end_date_active` (`end_date`,`is_active`),
  CONSTRAINT `subscriptions_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE,
  CONSTRAINT `subscriptions_ibfk_2` FOREIGN KEY (`plan_id`) REFERENCES `vip_plans` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=99 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Assinaturas VIP dos usuários';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `subscriptions`
--

LOCK TABLES `subscriptions` WRITE;
/*!40000 ALTER TABLE `subscriptions` DISABLE KEYS */;
INSERT INTO `subscriptions` VALUES (88,6184655187,1,'cmdzazuoo0bszkhan3w2bs0p0','pix_automatico','approved','2025-08-06 01:50:18','2025-09-05 01:50:18',0,0,1,0,0,0,'2025-08-06 01:50:18','2025-09-05 01:53:12'),(89,7752367560,1,'cmdzbgjqb0cvix224rhkw1bm9','pix_automatico','approved','2025-08-06 01:56:24','2025-09-05 01:56:25',0,0,1,0,0,0,'2025-08-06 01:56:24','2025-09-05 01:59:12'),(90,1410750629,1,'cmdzbgrpg0bjxginam4azvej7','pix_automatico','approved','2025-08-06 01:57:11','2025-09-05 01:57:11',0,0,1,0,0,0,'2025-08-06 01:57:11','2025-09-05 01:59:13'),(91,5343078464,1,'cmdzbgtb30cwkx224nygjcp0j','pix_automatico','approved','2025-08-06 01:58:40','2025-09-05 01:58:40',0,0,0,0,0,0,'2025-08-06 01:58:40','2025-09-05 01:59:14'),(92,5743300144,1,'cmdzbi3f30ccakhanfmd9apdv','pix_automatico','approved','2025-08-06 01:59:55','2025-09-05 01:59:56',0,0,1,0,0,0,'2025-08-06 01:59:55','2025-09-05 02:02:12'),(93,6015265562,1,'cmdzbikqx0cyhx224hu0rbt1x','pix_automatico','approved','2025-08-06 02:00:35','2025-09-05 02:00:36',0,0,1,0,0,0,'2025-08-06 02:00:35','2025-09-05 02:02:13'),(94,7336789033,1,'cmdzbt2dw0ckgkhangzldcefo','pix_automatico','approved','2025-08-06 02:06:36','2025-09-05 02:06:37',0,0,1,0,0,0,'2025-08-06 02:06:36','2025-09-05 02:08:12'),(95,6617472428,1,'cmdzc3hws0d9i3v87wvukvald','pix_automatico','approved','2025-08-06 02:15:50','2025-09-05 02:15:50',0,0,1,0,0,0,'2025-08-06 02:15:50','2025-09-05 02:17:12'),(96,7335520690,1,'cmdzcn4520duox224uxrnvxi1','pix_automatico','approved','2025-08-06 02:31:47','2025-09-05 02:31:48',0,0,1,0,0,0,'2025-08-06 02:31:47','2025-09-05 02:32:12'),(97,1868519352,1,'cmf4pat2z032fv8uxetguh6m7','pix_automatico','approved','2025-09-04 01:02:39','2025-10-04 01:02:39',0,1,0,0,0,0,'2025-09-04 01:02:39','2025-09-04 01:02:39'),(98,5318655974,1,'cmf4r9xd70427ma1tjjbrwzlh','pix_automatico','approved','2025-09-04 01:59:19','2025-10-04 01:59:20',0,1,0,0,0,0,'2025-09-04 01:59:19','2025-09-04 01:59:19');
/*!40000 ALTER TABLE `subscriptions` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `users`
--

DROP TABLE IF EXISTS `users`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `users` (
  `id` bigint NOT NULL COMMENT 'ID do usuário no Telegram',
  `username` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'Username do Telegram',
  `first_name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'Primeiro nome',
  `last_name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'Sobrenome',
  `joined_date` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT 'Data de cadastro',
  `is_vip` tinyint(1) DEFAULT '0' COMMENT 'Se é usuário VIP',
  `is_admin` tinyint(1) DEFAULT '0' COMMENT 'Se é administrador',
  `is_blocked` tinyint(1) DEFAULT '0' COMMENT 'Se está bloqueado',
  `last_activity` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT 'Última interação',
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP COMMENT 'Data de criação',
  `updated_at` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT 'Data de atualização',
  `first_start_done` tinyint(1) DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `idx_username` (`username`),
  KEY `idx_is_vip` (`is_vip`),
  KEY `idx_joined_date` (`joined_date`),
  KEY `idx_users_joined_vip` (`joined_date`,`is_vip`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Armazena informações dos usuários do bot';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `users`
--

LOCK TABLES `users` WRITE;
/*!40000 ALTER TABLE `users` DISABLE KEYS */;
INSERT INTO `users` VALUES (809789480,NULL,'Vandson',NULL,'2025-08-04 01:30:04',0,0,0,'2025-08-04 01:30:04','2025-08-04 01:30:04','2025-08-04 01:30:04',0),(853032052,NULL,'Guilherme','Pletsch','2025-08-03 22:53:09',0,0,0,'2025-08-03 22:53:09','2025-08-03 22:53:09','2025-08-03 22:53:09',0),(858541641,'cleiton1706','Cleiton','Marcos','2025-07-27 00:47:56',1,0,0,'2025-08-01 18:47:02','2025-07-27 00:47:56','2025-08-01 18:47:02',0),(886872941,'Renan_0','Renan',NULL,'2025-07-26 21:03:25',0,0,0,'2025-07-26 21:03:25','2025-07-26 21:03:25','2025-07-26 21:03:25',0),(896528698,'esquemaindianofc','?| Esquema Indiano | ??',NULL,'2025-07-29 03:23:53',0,0,0,'2025-07-29 03:23:53','2025-07-29 03:23:53','2025-07-29 03:23:53',0),(903373065,'bigbosstra','Big Boss',NULL,'2025-07-26 21:44:57',0,0,0,'2025-07-26 21:44:57','2025-07-26 21:44:57','2025-07-26 21:44:57',0),(927089926,NULL,'Carlos','Medeiros','2025-07-28 20:12:47',0,0,0,'2025-07-28 20:12:47','2025-07-28 20:12:47','2025-07-28 20:12:47',0),(927825130,NULL,'Carlos','Fernando','2025-07-26 21:56:41',0,0,0,'2025-07-26 21:56:41','2025-07-26 21:56:41','2025-07-26 21:56:41',0),(931694864,NULL,'TH',NULL,'2025-07-26 22:21:08',0,0,0,'2025-07-26 22:21:08','2025-07-26 22:21:08','2025-07-26 22:21:08',0),(949129120,NULL,'Breno','Ferreira','2025-08-04 02:05:55',0,0,0,'2025-08-04 02:05:55','2025-08-04 02:05:55','2025-08-04 02:05:55',0),(953528967,'Sidney2k23','SdN_Q',NULL,'2025-08-06 01:38:39',0,0,0,'2025-08-06 01:38:39','2025-08-06 01:38:39','2025-08-06 01:38:39',0),(960597727,NULL,'Rocha',NULL,'2025-07-26 22:07:18',0,0,0,'2025-07-26 22:07:18','2025-07-26 22:07:18','2025-07-26 22:07:18',0),(1015325212,'Pedrold466','Pedro','Sperandio Júnior 466','2025-08-06 01:54:17',0,0,0,'2025-08-06 01:54:17','2025-08-06 01:54:17','2025-08-06 01:54:17',0),(1027903694,NULL,'Leandro','Dias','2025-07-29 20:21:09',0,0,0,'2025-07-29 20:21:09','2025-07-29 20:21:09','2025-07-29 20:21:09',0),(1051789292,NULL,'Matheus','Beto Santos','2025-07-27 00:15:22',0,0,0,'2025-07-27 00:15:22','2025-07-27 00:15:22','2025-07-27 00:15:22',0),(1138399379,NULL,'Lucas','Lima','2025-07-26 21:03:56',0,0,0,'2025-07-26 21:03:56','2025-07-26 21:03:56','2025-07-26 21:03:56',0),(1139994055,'juliano_kauann','Juliano kauan',NULL,'2025-07-26 22:15:43',0,0,0,'2025-07-26 22:15:43','2025-07-26 22:15:43','2025-07-26 22:15:43',0),(1146786623,NULL,'Miguel','Araújo','2025-07-27 01:19:47',0,0,0,'2025-07-27 01:19:47','2025-07-27 01:19:47','2025-07-27 01:19:47',0),(1161184342,NULL,'Caio','Duarte','2025-07-29 02:02:43',0,0,0,'2025-07-29 02:02:43','2025-07-29 02:02:43','2025-07-29 02:02:43',0),(1169109135,NULL,'H2001abc',NULL,'2025-07-26 21:49:58',0,0,0,'2025-07-26 21:49:58','2025-07-26 21:49:58','2025-07-26 21:49:58',0),(1177025753,NULL,'..',NULL,'2025-07-29 05:15:01',0,0,0,'2025-07-29 05:15:01','2025-07-29 05:15:01','2025-07-29 05:15:01',0),(1181064229,NULL,'?',NULL,'2025-08-04 02:23:39',1,0,0,'2025-08-04 17:28:36','2025-08-04 02:23:39','2025-08-04 17:28:36',0),(1184858207,NULL,'Nego','Net','2025-07-26 21:19:10',0,0,0,'2025-07-26 21:19:10','2025-07-26 21:19:10','2025-07-26 21:19:10',0),(1198569837,'leo_oss','Léo ?',NULL,'2025-07-27 04:45:54',0,0,0,'2025-07-27 04:45:54','2025-07-27 04:45:54','2025-07-27 04:45:54',0),(1217527718,'RAELZINHOMILGRAU','Israel Silva',NULL,'2025-07-26 21:26:40',1,0,0,'2025-08-03 03:40:20','2025-07-26 21:26:40','2025-08-03 03:40:20',0),(1220957168,'mic10_m','Michael','Carneiro','2025-07-26 22:03:53',0,0,0,'2025-07-26 22:03:53','2025-07-26 22:03:53','2025-07-26 22:03:53',0),(1268933804,NULL,'Heitor',NULL,'2025-08-05 01:31:23',0,0,0,'2025-08-05 01:31:23','2025-08-05 01:31:23','2025-08-05 01:31:23',0),(1277276491,'Cell0351','Marcello',NULL,'2025-08-06 01:49:30',0,0,0,'2025-08-06 01:49:30','2025-08-06 01:49:30','2025-08-06 01:49:30',0),(1301841212,NULL,'Souza',NULL,'2025-07-27 02:14:09',0,0,0,'2025-07-27 02:14:09','2025-07-27 02:14:09','2025-07-27 02:14:09',0),(1328894699,NULL,'Igor',NULL,'2025-07-27 12:29:41',0,0,0,'2025-07-27 12:29:41','2025-07-27 12:29:41','2025-07-27 12:29:41',0),(1340758346,NULL,'Mioto','Martins','2025-07-27 17:44:09',0,0,0,'2025-07-27 17:44:09','2025-07-27 17:44:09','2025-07-27 17:44:09',0),(1381273149,NULL,'Victor','@victor10zz','2025-07-26 23:07:18',1,0,0,'2025-08-02 02:23:10','2025-07-26 23:07:18','2025-08-02 02:23:10',0),(1386887165,NULL,'Jonatham','Gabriel','2025-07-29 00:05:50',0,0,0,'2025-07-29 00:05:50','2025-07-29 00:05:50','2025-07-29 00:05:50',0),(1391942687,NULL,'Gabriel','Miranda','2025-07-30 01:04:20',0,0,0,'2025-07-30 01:04:20','2025-07-30 01:04:20','2025-07-30 01:04:20',0),(1400597934,NULL,'Lucas',NULL,'2025-07-27 02:23:52',0,0,0,'2025-07-27 02:23:52','2025-07-27 02:23:52','2025-07-27 02:23:52',0),(1410750629,NULL,'Eduardo','Caetano','2025-08-06 01:55:43',0,0,0,'2025-09-05 01:59:13','2025-08-06 01:55:43','2025-09-05 01:59:13',0),(1430052064,'Lucaslc77','I’-‘','Costa','2025-07-27 01:15:43',1,0,0,'2025-07-30 02:59:52','2025-07-27 01:15:43','2025-07-30 02:59:52',0),(1454914246,NULL,'Matheus','Henrique','2025-07-26 21:03:08',0,0,0,'2025-07-26 21:03:08','2025-07-26 21:03:08','2025-07-26 21:03:08',0),(1462111258,'Raf2a_07','Rafael','Oliveira','2025-07-28 23:04:53',0,0,0,'2025-07-28 23:04:53','2025-07-28 23:04:53','2025-07-28 23:04:53',0),(1465963752,'Pedromanzini','Pedro',NULL,'2025-08-06 01:54:56',0,0,0,'2025-08-06 01:54:56','2025-08-06 01:54:56','2025-08-06 01:54:56',0),(1485773677,NULL,'Renann','Souza','2025-07-30 13:43:43',0,0,0,'2025-07-30 13:43:43','2025-07-30 13:43:43','2025-07-30 13:43:43',0),(1540138848,'lusca_silva','Lucas','Silva','2025-08-02 14:20:11',0,0,0,'2025-08-02 14:20:11','2025-08-02 14:20:11','2025-08-02 14:20:11',0),(1567537513,'jp0076','JP',NULL,'2025-07-27 09:58:27',0,0,0,'2025-07-27 09:58:27','2025-07-27 09:58:27','2025-07-27 09:58:27',0),(1577515286,NULL,'Gabriel',NULL,'2025-07-29 01:26:13',1,0,0,'2025-07-29 01:30:52','2025-07-29 01:26:13','2025-07-29 01:30:52',0),(1603561688,NULL,'igor','Teixeira','2025-08-06 01:53:55',0,0,0,'2025-08-06 01:53:55','2025-08-06 01:53:55','2025-08-06 01:53:55',0),(1616872335,NULL,'Giovanne','Guimarães','2025-07-26 22:00:10',0,0,0,'2025-07-26 22:00:10','2025-07-26 22:00:10','2025-07-26 22:00:10',0),(1619896715,NULL,'Luiz','Guilherme','2025-08-06 01:50:59',0,0,0,'2025-08-06 01:50:59','2025-08-06 01:50:59','2025-08-06 01:50:59',0),(1621664343,'Lvt54','L',NULL,'2025-07-27 02:44:27',0,0,0,'2025-07-27 02:44:27','2025-07-27 02:44:27','2025-07-27 02:44:27',0),(1628656377,'Marillu_01','Marillu',NULL,'2025-08-06 01:21:30',0,0,0,'2025-08-06 01:21:30','2025-08-06 01:21:30','2025-08-06 01:21:30',0),(1642316897,NULL,'Davi','Rodrigues','2025-07-29 06:00:25',0,0,0,'2025-07-29 06:00:25','2025-07-29 06:00:25','2025-07-29 06:00:25',0),(1643196763,NULL,'Elvis','Edson','2025-07-27 11:20:30',0,0,0,'2025-07-27 11:20:30','2025-07-27 11:20:30','2025-07-27 11:20:30',0),(1664145364,NULL,'Kevin Jefferson',NULL,'2025-07-29 01:07:02',0,0,0,'2025-07-29 01:07:02','2025-07-29 01:07:02','2025-07-29 01:07:02',0),(1667703951,NULL,'Will',NULL,'2025-07-26 22:00:50',0,0,0,'2025-07-26 22:00:50','2025-07-26 22:00:50','2025-07-26 22:00:50',0),(1676467652,NULL,'Clecio','Medeiros','2025-07-29 16:51:34',0,0,0,'2025-07-29 16:51:34','2025-07-29 16:51:34','2025-07-29 16:51:34',0),(1681550186,NULL,'2A',NULL,'2025-07-27 15:38:20',0,0,0,'2025-07-27 15:38:20','2025-07-27 15:38:20','2025-07-27 15:38:20',0),(1684879645,NULL,'paulo silva',NULL,'2025-08-06 01:54:12',0,0,0,'2025-08-06 01:54:12','2025-08-06 01:54:12','2025-08-06 01:54:12',0),(1704754541,NULL,'Luis',NULL,'2025-07-29 01:08:17',0,0,0,'2025-07-29 01:08:17','2025-07-29 01:08:17','2025-07-29 01:08:17',0),(1705037537,NULL,'Jamal',NULL,'2025-07-26 22:28:52',0,0,0,'2025-07-26 22:28:52','2025-07-26 22:28:52','2025-07-26 22:28:52',0),(1715625089,'queirozz777','Queiroz',NULL,'2025-07-26 21:20:23',0,0,0,'2025-07-26 21:20:23','2025-07-26 21:20:23','2025-07-26 21:20:23',0),(1715896331,NULL,'Suporte - ArbRay',NULL,'2025-08-01 11:33:44',0,0,0,'2025-08-01 11:33:44','2025-08-01 11:33:44','2025-08-01 11:33:44',0),(1733451063,NULL,'Mateus','...','2025-08-03 00:02:43',0,0,0,'2025-08-03 00:02:43','2025-08-03 00:02:43','2025-08-03 00:02:43',0),(1737466794,'Meninonike','Menino Nike',NULL,'2025-08-03 03:39:13',0,0,0,'2025-08-03 03:39:13','2025-08-03 03:39:13','2025-08-03 03:39:13',0),(1749934069,'Thiagoooooooou','Bloemer',NULL,'2025-07-28 20:44:54',0,0,0,'2025-07-28 20:44:54','2025-07-28 20:44:54','2025-07-28 20:44:54',0),(1771794215,'j_mtmm','J',NULL,'2025-08-05 14:00:07',0,0,0,'2025-08-05 14:00:07','2025-08-05 14:00:07','2025-08-05 14:00:07',0),(1774077180,NULL,'Wyllian',NULL,'2025-08-06 01:03:25',0,0,0,'2025-08-06 01:03:25','2025-08-06 01:03:25','2025-08-06 01:03:25',0),(1775494817,'lima172','Samuel','Lima','2025-07-26 22:22:57',1,0,0,'2025-07-28 20:11:45','2025-07-26 22:22:57','2025-07-28 20:11:45',0),(1779160682,'donovanlechner','donovan','lechner','2025-08-06 01:56:06',0,0,0,'2025-08-06 01:56:06','2025-08-06 01:56:06','2025-08-06 01:56:06',0),(1818318930,NULL,'Rayan',NULL,'2025-08-05 02:25:44',0,0,0,'2025-08-05 02:25:44','2025-08-05 02:25:44','2025-08-05 02:25:44',0),(1821422739,'loboslot777','Lobo','Slot777','2025-07-26 21:25:38',0,0,0,'2025-07-26 21:25:38','2025-07-26 21:25:38','2025-07-26 21:25:38',0),(1834045086,NULL,'MC','Drakizin','2025-08-04 14:20:33',1,0,0,'2025-08-04 16:45:29','2025-08-04 14:20:33','2025-08-04 16:45:29',0),(1847290283,NULL,'00 da Zs',NULL,'2025-08-04 15:47:00',0,0,0,'2025-08-04 15:47:00','2025-08-04 15:47:00','2025-08-04 15:47:00',0),(1860250576,'Wallace4p','Ramos','.','2025-08-03 00:10:27',1,0,0,'2025-08-03 03:35:36','2025-08-03 00:10:27','2025-08-03 03:35:36',0),(1868105831,NULL,'JacDash',NULL,'2025-07-27 00:30:52',1,0,0,'2025-07-29 20:45:45','2025-07-27 00:30:52','2025-07-29 20:45:45',0),(1868519352,'lssbusiness','Lssbusiness',NULL,'2025-09-03 13:47:49',1,0,0,'2025-09-04 01:02:39','2025-09-03 13:47:49','2025-09-04 01:02:39',0),(1873760177,NULL,'deryck',NULL,'2025-08-06 01:02:42',0,0,0,'2025-08-06 01:02:42','2025-08-06 01:02:42','2025-08-06 01:02:42',0),(1882158246,NULL,'Pablo','Stvsz','2025-08-05 01:37:50',0,0,0,'2025-08-05 01:37:50','2025-08-05 01:37:50','2025-08-05 01:37:50',0),(1888153577,NULL,'Thalisson','Silva','2025-07-27 03:24:53',0,0,0,'2025-07-27 03:24:53','2025-07-27 03:24:53','2025-07-27 03:24:53',0),(1897141459,'MikaelUzumaqui','Mikael','uzumaqui','2025-07-26 21:20:08',0,0,0,'2025-07-26 21:20:08','2025-07-26 21:20:08','2025-07-26 21:20:08',0),(1908059593,NULL,'.','.','2025-07-26 21:19:36',0,0,0,'2025-07-26 21:19:36','2025-07-26 21:19:36','2025-07-26 21:19:36',0),(1920464047,'Tiago_Rezende09','Tiago','Rezende','2025-07-26 21:20:54',0,0,0,'2025-07-26 21:20:54','2025-07-26 21:20:54','2025-07-26 21:20:54',0),(1927232070,'thierry046','thierry','santos','2025-08-06 01:27:19',0,0,0,'2025-08-06 01:27:19','2025-08-06 01:27:19','2025-08-06 01:27:19',0),(1931697058,NULL,'brayan',NULL,'2025-08-02 16:24:54',1,0,0,'2025-08-04 15:03:14','2025-08-02 16:24:54','2025-08-04 15:03:14',0),(1940852926,NULL,'Caua','Reis','2025-08-06 01:02:09',0,0,0,'2025-08-06 01:02:09','2025-08-06 01:02:09','2025-08-06 01:02:09',0),(1943393298,NULL,'Souza',NULL,'2025-07-29 03:01:32',0,0,0,'2025-07-29 03:01:32','2025-07-29 03:01:32','2025-07-29 03:01:32',0),(1943493310,NULL,'Bassani',NULL,'2025-08-03 20:06:23',1,0,0,'2025-08-04 02:12:14','2025-08-03 20:06:23','2025-08-04 02:12:14',0),(1947007734,NULL,'K M ??',NULL,'2025-08-04 01:20:58',0,0,0,'2025-08-04 01:20:58','2025-08-04 01:20:58','2025-08-04 01:20:58',0),(1950164087,NULL,'Juan','Rossi','2025-08-02 22:20:17',0,0,0,'2025-08-02 22:20:17','2025-08-02 22:20:17','2025-08-02 22:20:17',0),(1959271768,'brunninho_9','brunninho_9',NULL,'2025-07-27 01:22:31',1,0,0,'2025-07-27 01:26:56','2025-07-27 01:22:31','2025-07-27 01:26:56',0),(1967414127,NULL,'…',NULL,'2025-07-26 22:32:39',0,0,0,'2025-07-26 22:32:39','2025-07-26 22:32:39','2025-07-26 22:32:39',0),(1969550446,NULL,'Pedro','Otávio','2025-08-03 14:35:39',0,0,0,'2025-08-03 14:35:39','2025-08-03 14:35:39','2025-08-03 14:35:39',0),(1985884040,'mad0ki','Raphael','Rossi','2025-09-03 23:36:05',0,0,0,'2025-09-03 23:36:05','2025-09-03 23:36:05','2025-09-03 23:36:05',0),(1990617914,'CristianMiguelDias','Cristian','Miguel','2025-07-30 01:04:10',0,0,0,'2025-07-30 01:04:10','2025-07-30 01:04:10','2025-07-30 01:04:10',0),(2020960278,'Jams_zs','Gaspar','Plz','2025-07-29 02:20:39',0,0,0,'2025-07-29 02:20:39','2025-07-29 02:20:39','2025-07-29 02:20:39',0),(2026341444,'felipinhooo55','Gustavo feitosa',NULL,'2025-08-03 03:57:03',1,0,0,'2025-08-05 03:00:51','2025-08-03 03:57:03','2025-08-05 03:00:51',0),(2031833791,'FernandohZK','Fernando','Martins','2025-07-26 22:34:27',0,0,0,'2025-07-26 22:34:27','2025-07-26 22:34:27','2025-07-26 22:34:27',0),(2060491487,NULL,'Letícia','Menezes','2025-08-05 01:31:13',0,0,0,'2025-08-05 01:31:13','2025-08-05 01:31:13','2025-08-05 01:31:13',0),(2080675696,NULL,'Vinicius',NULL,'2025-08-02 02:21:18',0,0,0,'2025-08-02 02:21:18','2025-08-02 02:21:18','2025-08-02 02:21:18',0),(2080845300,NULL,'Pablo','Sanchez','2025-07-26 21:36:11',0,0,0,'2025-07-26 21:36:11','2025-07-26 21:36:11','2025-07-26 21:36:11',0),(2092800090,NULL,'Cesar','Moreira','2025-07-26 21:26:30',0,0,0,'2025-07-26 21:26:30','2025-07-26 21:26:30','2025-07-26 21:26:30',0),(2132764022,NULL,'Rugall','157','2025-08-02 02:21:06',0,0,0,'2025-08-02 02:21:06','2025-08-02 02:21:06','2025-08-02 02:21:06',0),(2140605313,NULL,'Mengão',NULL,'2025-07-26 21:19:56',0,0,0,'2025-07-26 21:19:56','2025-07-26 21:19:56','2025-07-26 21:19:56',0),(5000295848,NULL,'H.Prado',NULL,'2025-07-31 21:54:38',0,0,0,'2025-07-31 21:54:38','2025-07-31 21:54:38','2025-07-31 21:54:38',0),(5020449997,NULL,'João Ramos',NULL,'2025-07-30 01:40:53',0,0,0,'2025-07-30 01:40:53','2025-07-30 01:40:53','2025-07-30 01:40:53',0),(5033818810,NULL,'Sebastião',NULL,'2025-08-02 02:02:24',0,0,0,'2025-08-02 02:02:24','2025-08-02 02:02:24','2025-08-02 02:02:24',0),(5037496577,NULL,'Andre','Felipe','2025-08-05 03:10:29',0,0,0,'2025-08-05 03:10:29','2025-08-05 03:10:29','2025-08-05 03:10:29',0),(5040410754,NULL,'Aguilar',NULL,'2025-07-28 01:02:43',0,0,0,'2025-07-28 01:02:43','2025-07-28 01:02:43','2025-07-28 01:02:43',0),(5043537678,NULL,'Gabriel','Nasc! ?','2025-07-29 02:37:24',0,0,0,'2025-07-29 02:37:24','2025-07-29 02:37:24','2025-07-29 02:37:24',0),(5044061708,NULL,'?',NULL,'2025-07-26 23:42:38',0,0,0,'2025-07-26 23:42:38','2025-07-26 23:42:38','2025-07-26 23:42:38',0),(5045892313,'SOUZADADOSS','Souza',NULL,'2025-07-30 01:00:53',0,0,0,'2025-07-30 01:00:53','2025-07-30 01:00:53','2025-07-30 01:00:53',0),(5059175602,'mrl134','Murilo',NULL,'2025-08-06 01:50:34',0,0,0,'2025-08-06 01:50:34','2025-08-06 01:50:34','2025-08-06 01:50:34',0),(5065063166,'gui_bonfim','Guilherme',NULL,'2025-07-28 22:32:51',0,0,0,'2025-07-28 22:32:51','2025-07-28 22:32:51','2025-07-28 22:32:51',0),(5082108380,'Jhoon_22','Jhon',NULL,'2025-08-04 03:24:20',0,0,0,'2025-08-04 03:24:20','2025-08-04 03:24:20','2025-08-04 03:24:20',0),(5082386972,'guh7_7','Gustavo',NULL,'2025-07-26 21:03:32',1,0,0,'2025-07-29 00:17:12','2025-07-26 21:03:32','2025-07-29 00:17:12',0),(5087885152,NULL,'Sandro yrllem',NULL,'2025-07-27 00:29:32',0,0,0,'2025-07-27 00:29:32','2025-07-27 00:29:32','2025-07-27 00:29:32',0),(5125955936,'legendluiz','Luiz','Gonçalves','2025-08-03 03:27:09',0,0,0,'2025-08-03 03:27:09','2025-08-03 03:27:09','2025-08-03 03:27:09',0),(5127656984,NULL,'Kaua','Pereira','2025-07-27 13:10:38',0,0,0,'2025-07-27 13:10:38','2025-07-27 13:10:38','2025-07-27 13:10:38',0),(5134759926,NULL,'Jaoo','Pedro','2025-07-26 22:12:53',0,0,0,'2025-07-26 22:12:53','2025-07-26 22:12:53','2025-07-26 22:12:53',0),(5196680577,NULL,'Raphael','Oliveira','2025-07-30 17:45:42',0,0,0,'2025-07-30 17:45:42','2025-07-30 17:45:42','2025-07-30 17:45:42',0),(5212099137,NULL,'almeida ?',NULL,'2025-08-04 14:41:40',1,0,0,'2025-08-04 14:43:05','2025-08-04 14:41:40','2025-08-04 14:43:05',0),(5219459655,'LeozinhoAM','Leonardo?',NULL,'2025-07-26 22:52:58',0,0,0,'2025-07-26 22:52:58','2025-07-26 22:52:58','2025-07-26 22:52:58',0),(5223114581,NULL,'Gusttavo',NULL,'2025-07-26 22:26:57',0,0,0,'2025-07-26 22:26:57','2025-07-26 22:26:57','2025-07-26 22:26:57',0),(5249708715,'Joaopedrodiasgiesteira','João Pedro','Dias Giesteira','2025-08-02 23:05:31',0,0,0,'2025-08-02 23:05:31','2025-08-02 23:05:31','2025-08-02 23:05:31',0),(5249891064,NULL,'Lucas','Alves','2025-07-26 21:46:53',0,0,0,'2025-07-26 21:46:53','2025-07-26 21:46:53','2025-07-26 21:46:53',0),(5252296262,'victorzl017','victor',NULL,'2025-07-26 21:03:24',0,0,0,'2025-07-26 21:03:24','2025-07-26 21:03:24','2025-07-26 21:03:24',0),(5264980214,'vinicius_Oli','Vinícius','Oliveira Dos Santos','2025-07-27 15:16:32',0,0,0,'2025-07-27 15:16:32','2025-07-27 15:16:32','2025-07-27 15:16:32',0),(5269066928,NULL,'Matheus','Froes','2025-07-26 22:40:37',0,0,0,'2025-07-26 22:40:37','2025-07-26 22:40:37','2025-07-26 22:40:37',0),(5300560110,NULL,'Junior','Silva','2025-08-05 23:39:36',0,0,0,'2025-08-05 23:39:36','2025-08-05 23:39:36','2025-08-05 23:39:36',0),(5304336923,'Sombra551','Dog','Da Sensi','2025-08-06 01:07:09',0,0,0,'2025-08-06 01:07:09','2025-08-06 01:07:09','2025-08-06 01:07:09',0),(5312347049,NULL,'Narcizo','Henrique','2025-07-27 05:31:29',0,0,0,'2025-07-27 05:31:29','2025-07-27 05:31:29','2025-07-27 05:31:29',0),(5314472042,NULL,'Gabriela',NULL,'2025-07-26 21:18:56',0,0,0,'2025-07-26 21:18:56','2025-07-26 21:18:56','2025-07-26 21:18:56',0),(5315661063,NULL,'Diego Araújo','...','2025-07-28 02:30:29',0,0,0,'2025-07-28 02:30:29','2025-07-28 02:30:29','2025-07-28 02:30:29',0),(5318655974,NULL,'Mat',NULL,'2025-09-04 01:55:55',1,0,0,'2025-09-04 01:59:19','2025-09-04 01:55:55','2025-09-04 01:59:19',0),(5329943229,NULL,'Michel','Alves','2025-07-26 21:29:37',0,0,0,'2025-07-26 21:29:37','2025-07-26 21:29:37','2025-07-26 21:29:37',0),(5340461582,'Darik_mtquerido','Darik',NULL,'2025-08-02 03:30:59',0,0,0,'2025-08-02 03:30:59','2025-08-02 03:30:59','2025-08-02 03:30:59',0),(5342192596,NULL,'Vitor','Manoel','2025-07-26 23:15:01',0,0,0,'2025-07-26 23:15:01','2025-07-26 23:15:01','2025-07-26 23:15:01',0),(5343078464,'Tomaz3108','Zamot',NULL,'2025-08-04 01:22:30',0,0,0,'2025-09-05 01:59:14','2025-08-04 01:22:30','2025-09-05 01:59:14',0),(5345893006,NULL,'Pedro','Pereira','2025-08-05 01:38:20',0,0,0,'2025-08-05 01:38:20','2025-08-05 01:38:20','2025-08-05 01:38:20',0),(5347339730,'menolzz4M','menolzz',NULL,'2025-07-29 01:22:03',0,0,0,'2025-07-29 01:22:03','2025-07-29 01:22:03','2025-07-29 01:22:03',0),(5353089037,NULL,'Alexandre','Neto','2025-07-27 14:46:26',0,0,0,'2025-07-27 14:46:26','2025-07-27 14:46:26','2025-07-27 14:46:26',0),(5353181386,NULL,'Jeovanna','Araújo','2025-07-27 07:14:05',1,0,0,'2025-08-05 23:25:36','2025-07-27 07:14:05','2025-08-05 23:25:36',0),(5353780263,'R44PH4','Raphael','Baptista','2025-07-27 00:30:44',0,0,0,'2025-07-27 00:30:44','2025-07-27 00:30:44','2025-07-27 00:30:44',0),(5356340391,NULL,'thiago',NULL,'2025-08-06 01:51:32',0,0,0,'2025-08-06 01:51:32','2025-08-06 01:51:32','2025-08-06 01:51:32',0),(5370890687,NULL,'Win Or Win','??','2025-07-26 21:03:32',0,0,0,'2025-07-26 21:03:32','2025-07-26 21:03:32','2025-07-26 21:03:32',0),(5374431850,NULL,'Matheus Santos',NULL,'2025-07-30 02:06:04',0,0,0,'2025-07-30 02:06:04','2025-07-30 02:06:04','2025-07-30 02:06:04',0),(5378518618,NULL,'Carlos',NULL,'2025-08-02 06:27:42',0,0,0,'2025-08-02 06:27:42','2025-08-02 06:27:42','2025-08-02 06:27:42',0),(5395807796,NULL,'Y','Oliva','2025-07-29 03:05:48',0,0,0,'2025-07-29 03:05:48','2025-07-29 03:05:48','2025-07-29 03:05:48',0),(5407179005,'newleovitor06','Eu',NULL,'2025-07-28 20:47:19',0,0,0,'2025-07-28 20:47:19','2025-07-28 20:47:19','2025-07-28 20:47:19',0),(5441398855,NULL,'J',NULL,'2025-07-29 00:07:34',0,0,0,'2025-07-29 00:07:34','2025-07-29 00:07:34','2025-07-29 00:07:34',0),(5445889613,NULL,'Gustavo Ferreir',NULL,'2025-07-26 21:23:03',0,0,0,'2025-07-26 21:23:03','2025-07-26 21:23:03','2025-07-26 21:23:03',0),(5480699554,NULL,'23024',NULL,'2025-07-29 13:13:03',0,0,0,'2025-07-29 13:13:03','2025-07-29 13:13:03','2025-07-29 13:13:03',0),(5482518608,NULL,'Victor','Gabriell','2025-07-26 21:04:00',0,0,0,'2025-07-26 21:04:00','2025-07-26 21:04:00','2025-07-26 21:04:00',0),(5495676792,NULL,'Lucas','BDS','2025-07-29 02:23:58',1,0,0,'2025-08-03 03:44:33','2025-07-29 02:23:58','2025-08-03 03:44:33',0),(5500121547,'joaotr1','João',NULL,'2025-07-26 23:44:38',0,0,0,'2025-07-26 23:44:38','2025-07-26 23:44:38','2025-07-26 23:44:38',0),(5512256079,NULL,'De','Oliveira','2025-08-03 00:50:34',0,0,0,'2025-08-03 00:50:34','2025-08-03 00:50:34','2025-08-03 00:50:34',0),(5515187878,'Gabriel_marcha','Gabriel',NULL,'2025-07-27 03:16:45',0,0,0,'2025-07-27 03:16:45','2025-07-27 03:16:45','2025-07-27 03:16:45',0),(5528510973,NULL,'Anderson',NULL,'2025-08-03 19:43:28',0,0,0,'2025-08-03 19:43:28','2025-08-03 19:43:28','2025-08-03 19:43:28',0),(5534319366,'Sla610','Thebest⁷',NULL,'2025-07-28 20:29:15',1,0,0,'2025-07-28 20:45:41','2025-07-28 20:29:15','2025-07-28 20:45:41',0),(5535808597,NULL,'Ygor','Gabriel','2025-08-04 22:18:16',0,0,0,'2025-08-04 22:18:16','2025-08-04 22:18:16','2025-08-04 22:18:16',0),(5540777063,'madrzinn','Vini',NULL,'2025-08-03 03:43:47',0,0,0,'2025-08-03 03:43:47','2025-08-03 03:43:47','2025-08-03 03:43:47',0),(5546208738,NULL,'Ikaro','Arruda','2025-08-05 04:41:24',1,0,0,'2025-08-05 04:50:38','2025-08-05 04:41:24','2025-08-05 04:50:38',0),(5576752071,NULL,'Rick','Sp','2025-07-27 01:11:29',0,0,0,'2025-07-27 01:11:29','2025-07-27 01:11:29','2025-07-27 01:11:29',0),(5576968217,NULL,'Junio','Andrade','2025-08-04 19:22:33',0,0,0,'2025-08-04 19:22:33','2025-08-04 19:22:33','2025-08-04 19:22:33',0),(5588817821,'Danilo3330','Danilo',NULL,'2025-07-26 22:29:43',0,0,0,'2025-07-26 22:29:43','2025-07-26 22:29:43','2025-07-26 22:29:43',0),(5590266139,NULL,'Thiago','Magnani','2025-07-26 21:03:14',0,0,0,'2025-07-26 21:03:14','2025-07-26 21:03:14','2025-07-26 21:03:14',0),(5595105344,'Fr4ga','Fraga',NULL,'2025-07-29 03:08:30',0,0,0,'2025-07-29 03:08:30','2025-07-29 03:08:30','2025-07-29 03:08:30',0),(5595356123,NULL,'Eduardo','Henrique','2025-08-03 16:48:32',0,0,0,'2025-08-03 16:48:32','2025-08-03 16:48:32','2025-08-03 16:48:32',0),(5597323807,NULL,'Daniel',NULL,'2025-07-26 22:14:09',0,0,0,'2025-07-26 22:14:09','2025-07-26 22:14:09','2025-07-26 22:14:09',0),(5610735848,NULL,'João Guilherme',NULL,'2025-08-06 01:56:01',0,0,0,'2025-08-06 01:56:01','2025-08-06 01:56:01','2025-08-06 01:56:01',0),(5619996360,NULL,'Renan',NULL,'2025-08-04 01:19:24',0,0,0,'2025-08-04 01:19:24','2025-08-04 01:19:24','2025-08-04 01:19:24',0),(5631816196,NULL,'Robson','Santos','2025-08-04 02:54:11',0,0,0,'2025-08-04 02:54:11','2025-08-04 02:54:11','2025-08-04 02:54:11',0),(5632792429,NULL,'Pedro','Gabriel','2025-07-28 15:06:35',0,0,0,'2025-07-28 15:06:35','2025-07-28 15:06:35','2025-07-28 15:06:35',0),(5634930443,NULL,'Caique','cachorro loco','2025-08-04 01:10:58',0,0,0,'2025-08-04 01:10:58','2025-08-04 01:10:58','2025-08-04 01:10:58',0),(5640173044,NULL,'M','R','2025-07-26 22:25:04',1,0,0,'2025-08-03 19:50:56','2025-07-26 22:25:04','2025-08-03 19:50:56',0),(5642191516,'dudinha_alves18','Duda','Alves','2025-07-28 20:13:49',1,0,0,'2025-08-04 19:15:22','2025-07-28 20:13:49','2025-08-04 19:15:22',0),(5655887603,NULL,'Eduardo','Machado','2025-07-30 03:06:40',0,0,0,'2025-07-30 03:06:40','2025-07-30 03:06:40','2025-07-30 03:06:40',0),(5671186652,NULL,'Rian','Sousa','2025-07-26 21:27:48',0,0,0,'2025-07-26 21:27:48','2025-07-26 21:27:48','2025-07-26 21:27:48',0),(5680561795,NULL,'Mateus','Andrade','2025-08-02 04:16:09',1,0,0,'2025-08-04 18:07:28','2025-08-02 04:16:09','2025-08-04 18:07:28',0),(5685519892,'Joaobrgslk','Nicolas',NULL,'2025-08-03 21:51:23',0,0,0,'2025-08-03 21:51:23','2025-08-03 21:51:23','2025-08-03 21:51:23',0),(5685599364,NULL,'Juan','Da Silva','2025-08-04 04:50:19',0,0,0,'2025-08-04 04:50:19','2025-08-04 04:50:19','2025-08-04 04:50:19',0),(5704626517,NULL,'Joao Pedro','Pedro','2025-07-26 23:05:10',0,0,0,'2025-07-26 23:05:10','2025-07-26 23:05:10','2025-07-26 23:05:10',0),(5705487113,'saaallees','Kauanne','Sales','2025-08-06 01:49:43',0,0,0,'2025-08-06 01:49:43','2025-08-06 01:49:43','2025-08-06 01:49:43',0),(5708662760,NULL,'Paulo','Henrique','2025-07-28 20:56:25',0,0,0,'2025-07-28 20:56:25','2025-07-28 20:56:25','2025-07-28 20:56:25',0),(5712011546,NULL,'Hugo silas',NULL,'2025-08-06 01:50:06',0,0,0,'2025-08-06 01:50:06','2025-08-06 01:50:06','2025-08-06 01:50:06',0),(5735814098,NULL,'Luís','Costa','2025-08-03 04:04:21',0,0,0,'2025-08-03 04:04:21','2025-08-03 04:04:21','2025-08-03 04:04:21',0),(5738010584,NULL,'Jonathan','Duran','2025-08-06 01:04:40',0,0,0,'2025-08-06 01:04:40','2025-08-06 01:04:40','2025-08-06 01:04:40',0),(5742879634,NULL,'Sthevan','Emanuel','2025-07-26 21:34:01',0,0,0,'2025-07-26 21:34:01','2025-07-26 21:34:01','2025-07-26 21:34:01',0),(5743300144,'uHHIgfutAw','Kauã','Santos','2025-08-06 01:50:19',0,0,0,'2025-09-05 02:02:12','2025-08-06 01:50:19','2025-09-05 02:02:12',0),(5752356989,NULL,'Yunior','Lopez','2025-07-26 21:19:16',0,0,0,'2025-07-26 21:19:16','2025-07-26 21:19:16','2025-07-26 21:19:16',0),(5756470561,NULL,'JJ',NULL,'2025-08-04 01:36:00',1,0,0,'2025-08-04 01:36:24','2025-08-04 01:36:00','2025-08-04 01:36:24',0),(5771216868,NULL,'13392','Dada','2025-07-26 22:38:08',0,0,0,'2025-07-26 22:38:08','2025-07-26 22:38:08','2025-07-26 22:38:08',0),(5778916195,'alemao_trader_015','João',NULL,'2025-08-05 04:56:11',0,0,0,'2025-08-05 04:56:11','2025-08-05 04:56:11','2025-08-05 04:56:11',0),(5781264718,NULL,'Cabral',NULL,'2025-08-05 18:19:44',0,0,0,'2025-08-05 18:19:44','2025-08-05 18:19:44','2025-08-05 18:19:44',0),(5787672264,NULL,'Melissa','Aparecida','2025-07-26 23:48:21',1,0,0,'2025-07-28 21:57:27','2025-07-26 23:48:21','2025-07-28 21:57:27',0),(5805561739,NULL,'Thiago','Vieira','2025-08-02 06:16:04',0,0,0,'2025-08-02 06:16:04','2025-08-02 06:16:04','2025-08-02 06:16:04',0),(5805716763,'L939i4b8rhev','jovca',NULL,'2025-08-02 01:54:26',0,0,0,'2025-08-02 01:54:26','2025-08-02 01:54:26','2025-08-02 01:54:26',0),(5821036979,NULL,'Douglas','Ferreira','2025-07-26 23:32:46',0,0,0,'2025-07-26 23:32:46','2025-07-26 23:32:46','2025-07-26 23:32:46',0),(5827543309,NULL,'?',NULL,'2025-07-26 21:59:19',0,0,0,'2025-07-26 21:59:19','2025-07-26 21:59:19','2025-07-26 21:59:19',0),(5831278965,NULL,'Marco.chef11',NULL,'2025-08-04 01:41:01',0,0,0,'2025-08-04 01:41:01','2025-08-04 01:41:01','2025-08-04 01:41:01',0),(5842731656,NULL,'Gomexxx',NULL,'2025-07-29 04:48:05',0,0,0,'2025-07-29 04:48:05','2025-07-29 04:48:05','2025-07-29 04:48:05',0),(5849185852,NULL,'Luizoto',NULL,'2025-07-26 22:10:41',0,0,0,'2025-07-26 22:10:41','2025-07-26 22:10:41','2025-07-26 22:10:41',0),(5861428329,NULL,'Haliffer',NULL,'2025-08-02 22:47:26',0,0,0,'2025-08-02 22:47:26','2025-08-02 22:47:26','2025-08-02 22:47:26',0),(5871473402,NULL,'Victor','Bruno','2025-07-26 21:20:44',0,0,0,'2025-07-26 21:20:44','2025-07-26 21:20:44','2025-07-26 21:20:44',0),(5872958304,'agentewess','Wesley','Trader','2025-08-02 01:54:00',0,0,0,'2025-08-02 01:54:00','2025-08-02 01:54:00','2025-08-02 01:54:00',0),(5884063223,'kankzada77','Ryan',NULL,'2025-07-27 16:07:50',1,0,0,'2025-08-05 22:43:48','2025-07-27 16:07:50','2025-08-05 22:43:48',0),(5887830472,NULL,'J. Lucas','F','2025-07-29 02:04:54',0,0,0,'2025-07-29 02:04:54','2025-07-29 02:04:54','2025-07-29 02:04:54',0),(5890349897,NULL,'Prosperidade2k23',NULL,'2025-08-06 02:19:14',0,0,0,'2025-08-06 02:19:14','2025-08-06 02:19:14','2025-08-06 02:19:14',0),(5897571975,NULL,'ㅤgusthavo',NULL,'2025-08-03 13:33:28',0,0,0,'2025-08-03 13:33:28','2025-08-03 13:33:28','2025-08-03 13:33:28',0),(5908805900,NULL,'Hugo','Corradi','2025-07-26 21:12:53',1,0,0,'2025-08-06 00:59:20','2025-07-26 21:12:53','2025-08-06 00:59:20',0),(5921940983,'thiagonazare','Thiago','Nazare','2025-08-05 05:07:48',0,0,0,'2025-08-05 05:07:48','2025-08-05 05:07:48','2025-08-05 05:07:48',0),(5936488730,NULL,'Kauã','Vitor','2025-08-04 17:52:38',0,0,0,'2025-08-04 17:52:38','2025-08-04 17:52:38','2025-08-04 17:52:38',0),(5961247551,NULL,'Artur','Vieira','2025-08-06 01:44:50',0,0,0,'2025-08-06 01:44:50','2025-08-06 01:44:50','2025-08-06 01:44:50',0),(5970146371,NULL,'Riick','Junio','2025-07-29 00:37:37',0,0,0,'2025-07-29 00:37:37','2025-07-29 00:37:37','2025-07-29 00:37:37',0),(5978225638,NULL,'Biel','Tunn3s','2025-07-29 01:08:06',0,0,0,'2025-07-29 01:08:06','2025-07-29 01:08:06','2025-07-29 01:08:06',0),(5980568171,NULL,'Jc','.importa','2025-08-05 02:56:59',0,0,0,'2025-08-05 02:56:59','2025-08-05 02:56:59','2025-08-05 02:56:59',0),(5991239749,NULL,'Daniel','Fernando','2025-08-02 01:57:56',0,0,0,'2025-08-02 01:57:56','2025-08-02 01:57:56','2025-08-02 01:57:56',0),(6009883347,NULL,'Wellington','Martins','2025-07-26 22:42:26',1,0,0,'2025-07-26 23:14:54','2025-07-26 22:42:26','2025-07-26 23:14:54',0),(6015265562,NULL,'Ezequiel','Chernhak','2025-08-06 01:38:56',0,0,0,'2025-09-05 02:02:13','2025-08-06 01:38:56','2025-09-05 02:02:13',0),(6025118270,NULL,'Yan','Gabriel','2025-07-28 20:49:18',0,0,0,'2025-07-28 20:49:18','2025-07-28 20:49:18','2025-07-28 20:49:18',0),(6026354073,NULL,'Vinicius','Miguel','2025-08-04 17:57:00',0,0,0,'2025-08-04 17:57:00','2025-08-04 17:57:00','2025-08-04 17:57:00',0),(6032335861,'Rebecarc7','Rebeca','Cristina','2025-07-26 22:47:09',0,0,0,'2025-07-26 22:47:09','2025-07-26 22:47:09','2025-07-26 22:47:09',0),(6033265481,NULL,'João','Victor','2025-08-04 15:43:59',0,0,0,'2025-08-04 15:43:59','2025-08-04 15:43:59','2025-08-04 15:43:59',0),(6045098016,NULL,'Thyago',NULL,'2025-07-29 17:45:20',0,0,0,'2025-07-29 17:45:20','2025-07-29 17:45:20','2025-07-29 17:45:20',0),(6051547740,NULL,'mtfe',NULL,'2025-07-29 00:46:33',0,0,0,'2025-07-29 00:46:33','2025-07-29 00:46:33','2025-07-29 00:46:33',0),(6071702038,NULL,'Luiz','Ricardo','2025-07-29 04:37:34',0,0,0,'2025-07-29 04:37:34','2025-07-29 04:37:34','2025-07-29 04:37:34',0),(6079986847,NULL,'Victor','M.','2025-07-26 21:03:22',0,0,0,'2025-07-26 21:03:22','2025-07-26 21:03:22','2025-07-26 21:03:22',0),(6100760448,NULL,'Jdjshs','Ssjjdsj','2025-08-02 22:59:54',0,0,0,'2025-08-02 22:59:54','2025-08-02 22:59:54','2025-08-02 22:59:54',0),(6106243450,NULL,'Kaciano','Siqueira','2025-08-04 01:49:41',1,0,0,'2025-08-04 01:50:29','2025-08-04 01:49:41','2025-08-04 01:50:29',0),(6110134425,NULL,'Jao',NULL,'2025-07-29 13:01:47',1,0,0,'2025-08-05 23:00:16','2025-07-29 13:01:47','2025-08-05 23:00:16',0),(6112970777,NULL,'Neymar',NULL,'2025-08-02 01:54:44',0,0,0,'2025-08-02 01:54:44','2025-08-02 01:54:44','2025-08-02 01:54:44',0),(6132984274,'Mnrsgz57','Abençoado????',NULL,'2025-08-05 02:03:14',0,0,0,'2025-08-05 02:03:14','2025-08-05 02:03:14','2025-08-05 02:03:14',0),(6137069381,'suporte333s','suporte','333','2025-07-30 19:11:06',0,0,0,'2025-07-30 19:11:06','2025-07-30 19:11:06','2025-07-30 19:11:06',0),(6138467649,NULL,'Soares','Silva','2025-07-26 21:25:15',0,0,0,'2025-07-26 21:25:15','2025-07-26 21:25:15','2025-07-26 21:25:15',0),(6140099634,NULL,'Victor',NULL,'2025-08-04 02:10:15',0,0,0,'2025-08-04 02:10:15','2025-08-04 02:10:15','2025-08-04 02:10:15',0),(6151082029,NULL,'Jonas','Medeiros','2025-08-05 13:15:33',0,0,0,'2025-08-05 13:15:33','2025-08-05 13:15:33','2025-08-05 13:15:33',0),(6163995530,NULL,'Marcos','Vinicius','2025-07-27 00:34:04',0,0,0,'2025-07-27 00:34:04','2025-07-27 00:34:04','2025-07-27 00:34:04',0),(6168092113,NULL,'João','Lucio','2025-07-27 07:21:44',0,0,0,'2025-07-27 07:21:44','2025-07-27 07:21:44','2025-07-27 07:21:44',0),(6184655187,NULL,'Davi','Almeida','2025-08-06 01:41:46',0,0,0,'2025-09-05 01:53:12','2025-08-06 01:41:46','2025-09-05 01:53:12',0),(6188479195,NULL,'k1',NULL,'2025-08-06 02:12:54',0,0,0,'2025-08-06 02:12:54','2025-08-06 02:12:54','2025-08-06 02:12:54',0),(6198682653,NULL,'JG BIELZIN',NULL,'2025-07-28 21:08:48',0,0,0,'2025-07-28 21:08:48','2025-07-28 21:08:48','2025-07-28 21:08:48',0),(6208651360,'oKayomc','KAYOX',NULL,'2025-07-26 22:12:57',0,0,0,'2025-07-26 22:12:57','2025-07-26 22:12:57','2025-07-26 22:12:57',0),(6237528772,NULL,'Kauan','Osorio','2025-07-26 23:40:33',0,0,0,'2025-07-26 23:40:33','2025-07-26 23:40:33','2025-07-26 23:40:33',0),(6248748539,NULL,'Couto7',NULL,'2025-08-04 02:07:57',0,0,0,'2025-08-04 02:07:57','2025-08-04 02:07:57','2025-08-04 02:07:57',0),(6255423202,NULL,'Davi','Davi','2025-07-30 01:23:27',0,0,0,'2025-07-30 01:23:27','2025-07-30 01:23:27','2025-07-30 01:23:27',0),(6270672329,NULL,'Pedro',NULL,'2025-07-27 00:41:15',0,0,0,'2025-07-27 00:41:15','2025-07-27 00:41:15','2025-07-27 00:41:15',0),(6297310145,NULL,'Valdeir','Silva','2025-07-30 16:08:38',0,0,0,'2025-07-30 16:08:38','2025-07-30 16:08:38','2025-07-30 16:08:38',0),(6304566586,'arthur_pavaneli','Arthur','Pavaneli','2025-08-03 03:43:10',1,0,0,'2025-08-03 04:25:37','2025-08-03 03:43:10','2025-08-03 04:25:37',0),(6326522229,'matheusbnc','RodadasBÔNUS - Matheus',NULL,'2025-07-27 00:50:06',0,0,0,'2025-07-27 00:50:06','2025-07-27 00:50:06','2025-07-27 00:50:06',0),(6328876016,NULL,'Fernanda','Bressane','2025-07-26 21:10:31',0,0,0,'2025-07-26 21:10:31','2025-07-26 21:10:31','2025-07-26 21:10:31',0),(6333239349,NULL,'??',NULL,'2025-07-26 21:33:32',0,0,0,'2025-07-26 21:33:32','2025-07-26 21:33:32','2025-07-26 21:33:32',0),(6335213026,NULL,'Luiz','Gustavo','2025-08-04 14:49:16',0,0,0,'2025-08-04 14:49:16','2025-08-04 14:49:16','2025-08-04 14:49:16',0),(6353891184,NULL,'Gabriel',NULL,'2025-08-05 02:55:59',0,0,0,'2025-08-05 02:55:59','2025-08-05 02:55:59','2025-08-05 02:55:59',0),(6355058116,NULL,'Martinsz',NULL,'2025-07-29 01:34:11',0,0,0,'2025-07-29 01:34:11','2025-07-29 01:34:11','2025-07-29 01:34:11',0),(6357392494,NULL,'Anderson','Costa','2025-07-26 21:33:49',0,0,0,'2025-07-26 21:33:49','2025-07-26 21:33:49','2025-07-26 21:33:49',0),(6364899775,NULL,'Felipe','Valadares','2025-07-26 21:14:33',0,0,0,'2025-07-26 21:14:33','2025-07-26 21:14:33','2025-07-26 21:14:33',0),(6374473460,'jonatham07','Jonathan Silva',NULL,'2025-08-05 08:32:19',0,0,0,'2025-08-05 08:32:19','2025-08-05 08:32:19','2025-08-05 08:32:19',0),(6408412430,NULL,'Rumo a elite ??',NULL,'2025-08-04 01:13:44',0,0,0,'2025-08-04 01:13:44','2025-08-04 01:13:44','2025-08-04 01:13:44',0),(6420187474,NULL,'Adriel Silva','Silva','2025-07-29 01:39:52',0,0,0,'2025-07-29 01:39:52','2025-07-29 01:39:52','2025-07-29 01:39:52',0),(6421176285,NULL,'Wemerson','Kauê','2025-07-27 00:39:19',1,0,0,'2025-07-27 19:22:16','2025-07-27 00:39:19','2025-07-27 19:22:16',0),(6423539592,'saikathesun','SAIKA',NULL,'2025-08-05 22:46:27',0,0,0,'2025-08-05 22:46:27','2025-08-05 22:46:27','2025-08-05 22:46:27',0),(6433416580,NULL,'Yago','Kauan','2025-08-06 01:43:29',0,0,0,'2025-08-06 01:43:29','2025-08-06 01:43:29','2025-08-06 01:43:29',0),(6450413356,NULL,'Sandy','$2','2025-07-26 21:38:29',0,0,0,'2025-07-26 21:38:29','2025-07-26 21:38:29','2025-07-26 21:38:29',0),(6462824527,NULL,'Max','Tranyd ??','2025-08-04 01:38:51',0,0,0,'2025-08-04 01:38:51','2025-08-04 01:38:51','2025-08-04 01:38:51',0),(6468581921,NULL,'Pedro','Marcosfx','2025-07-26 21:54:38',0,0,0,'2025-07-26 21:54:38','2025-07-26 21:54:38','2025-07-26 21:54:38',0),(6469959302,NULL,'miguel','nogueira','2025-08-05 08:47:15',0,0,0,'2025-08-05 08:47:15','2025-08-05 08:47:15','2025-08-05 08:47:15',0),(6484698622,NULL,'Arthur Augusto Da Silva Aguiar Carneiro','Augusto','2025-07-26 22:24:40',0,0,0,'2025-07-26 22:24:40','2025-07-26 22:24:40','2025-07-26 22:24:40',0),(6486230627,NULL,'DKS','Santos','2025-07-29 00:13:55',1,0,0,'2025-07-29 00:14:56','2025-07-29 00:13:55','2025-07-29 00:14:56',0),(6489213783,NULL,'Caio',NULL,'2025-07-29 01:09:16',0,0,0,'2025-07-29 01:09:16','2025-07-29 01:09:16','2025-07-29 01:09:16',0),(6489920842,NULL,'Jecson','Jecson','2025-07-26 22:21:02',0,0,0,'2025-07-26 22:21:02','2025-07-26 22:21:02','2025-07-26 22:21:02',0),(6498021822,NULL,'Larissa','Rodrigues','2025-07-26 21:35:17',0,0,0,'2025-07-26 21:35:17','2025-07-26 21:35:17','2025-07-26 21:35:17',0),(6502828752,NULL,'Gui',NULL,'2025-07-28 20:40:20',1,0,0,'2025-08-04 15:58:10','2025-07-28 20:40:20','2025-08-04 15:58:10',0),(6509486741,NULL,'Chris','Medeiros','2025-08-04 01:29:34',0,0,0,'2025-08-04 01:29:34','2025-08-04 01:29:34','2025-08-04 01:29:34',0),(6516249392,NULL,'Gustavo','Santos','2025-08-04 05:41:16',0,0,0,'2025-08-04 05:41:16','2025-08-04 05:41:16','2025-08-04 05:41:16',0),(6533869207,'hugo_0992','Gabriel','Silva','2025-07-26 21:20:41',1,0,0,'2025-08-05 14:19:06','2025-07-26 21:20:41','2025-08-05 14:19:06',0),(6537623887,NULL,'Biel',NULL,'2025-08-06 01:03:19',0,0,0,'2025-08-06 01:03:19','2025-08-06 01:03:19','2025-08-06 01:03:19',0),(6548420856,NULL,'Luiz','Guilherme','2025-08-05 17:27:43',0,0,0,'2025-08-05 17:27:43','2025-08-05 17:27:43','2025-08-05 17:27:43',0),(6566078476,NULL,'cleiton alburquerque',NULL,'2025-08-02 01:58:53',1,0,0,'2025-08-04 01:45:11','2025-08-02 01:58:53','2025-08-04 01:45:11',0),(6570577929,NULL,'74837',NULL,'2025-08-06 01:50:51',0,0,0,'2025-08-06 01:50:51','2025-08-06 01:50:51','2025-08-06 01:50:51',0),(6577698975,'IAWITTOR','Wittor','Costa','2025-07-26 21:29:02',0,0,0,'2025-07-26 21:29:02','2025-07-26 21:29:02','2025-07-26 21:29:02',0),(6582862127,'Gustta063','Gusttavo','Aguiar','2025-07-26 22:39:35',1,0,0,'2025-08-05 14:27:29','2025-07-26 22:39:35','2025-08-05 14:27:29',0),(6593996583,NULL,'Pedro','Oliveira','2025-07-27 00:35:06',1,0,0,'2025-07-27 12:19:22','2025-07-27 00:35:06','2025-07-27 12:19:22',0),(6597104669,NULL,'Kennedy','Kewer','2025-07-26 22:16:32',0,0,0,'2025-07-26 22:16:32','2025-07-26 22:16:32','2025-07-26 22:16:32',0),(6598566910,NULL,'Laura','Laura@&','2025-08-06 02:13:03',0,0,0,'2025-08-06 02:13:03','2025-08-06 02:13:03','2025-08-06 02:13:03',0),(6604580702,NULL,'Huggo','Ribeiro','2025-07-26 22:07:05',0,0,0,'2025-07-26 22:07:05','2025-07-26 22:07:05','2025-07-26 22:07:05',0),(6617472428,NULL,'japa','.','2025-07-29 00:57:31',0,0,0,'2025-09-05 02:17:12','2025-07-29 00:57:31','2025-09-05 02:17:12',0),(6621862923,NULL,'Giro loko',NULL,'2025-07-27 17:29:03',0,0,0,'2025-07-27 17:29:03','2025-07-27 17:29:03','2025-07-27 17:29:03',0),(6628023104,NULL,'Jhon','Baek','2025-07-27 11:25:19',0,0,0,'2025-07-27 11:25:19','2025-07-27 11:25:19','2025-07-27 11:25:19',0),(6650038077,NULL,'dantasaztro',NULL,'2025-07-29 02:33:22',0,0,0,'2025-07-29 02:33:22','2025-07-29 02:33:22','2025-07-29 02:33:22',0),(6651065365,'Hyury_Silva','Hyury','Silva','2025-07-27 02:04:41',0,0,0,'2025-07-27 02:04:41','2025-07-27 02:04:41','2025-07-27 02:04:41',0),(6654622360,NULL,'Deyvisson',NULL,'2025-07-26 21:49:49',1,0,0,'2025-07-26 23:05:46','2025-07-26 21:49:49','2025-07-26 23:05:46',0),(6663506818,NULL,'Lucas','Eduardo','2025-07-26 21:33:55',0,0,0,'2025-07-26 21:33:55','2025-07-26 21:33:55','2025-07-26 21:33:55',0),(6664352206,NULL,'E','A','2025-07-29 03:10:24',0,0,0,'2025-07-29 03:10:24','2025-07-29 03:10:24','2025-07-29 03:10:24',0),(6673534604,NULL,'Matheus',NULL,'2025-08-04 01:30:17',0,0,0,'2025-08-04 01:30:17','2025-08-04 01:30:17','2025-08-04 01:30:17',0),(6676114226,NULL,'João Vitor',NULL,'2025-07-29 01:59:35',1,0,0,'2025-08-04 21:53:09','2025-07-29 01:59:35','2025-08-04 21:53:09',0),(6688942075,NULL,'fumaça','real','2025-08-04 17:16:33',0,0,0,'2025-08-04 17:16:33','2025-08-04 17:16:33','2025-08-04 17:16:33',0),(6698521079,'Suporte_oficial_01','Berrio rico','trader','2025-08-03 03:34:58',0,0,0,'2025-08-03 03:34:58','2025-08-03 03:34:58','2025-08-03 03:34:58',0),(6702884038,NULL,'Andres','Guerra','2025-07-28 22:46:00',0,0,0,'2025-07-28 22:46:00','2025-07-28 22:46:00','2025-07-28 22:46:00',0),(6708218429,NULL,'Escuro',NULL,'2025-07-27 02:23:36',0,0,0,'2025-07-27 02:23:36','2025-07-27 02:23:36','2025-07-27 02:23:36',0),(6716305946,NULL,'Cauã','Henrique','2025-07-26 22:10:12',0,0,0,'2025-07-26 22:10:12','2025-07-26 22:10:12','2025-07-26 22:10:12',0),(6717005469,NULL,'Pablo W',NULL,'2025-07-26 21:39:01',0,0,0,'2025-07-26 21:39:01','2025-07-26 21:39:01','2025-07-26 21:39:01',0),(6723661240,NULL,'Patricia','Melo','2025-07-30 05:06:43',0,0,0,'2025-07-30 05:06:43','2025-07-30 05:06:43','2025-07-30 05:06:43',0),(6729381876,'Douglas2218','Breno',NULL,'2025-07-26 21:18:58',0,0,0,'2025-07-26 21:18:58','2025-07-26 21:18:58','2025-07-26 21:18:58',0),(6732682672,NULL,'Leozin',NULL,'2025-07-30 13:56:32',0,0,0,'2025-07-30 13:56:32','2025-07-30 13:56:32','2025-07-30 13:56:32',0),(6735756038,'aragao7','Aragão Cripto',NULL,'2025-07-26 21:47:07',1,0,0,'2025-08-03 03:28:20','2025-07-26 21:47:07','2025-08-03 03:28:20',0),(6746009572,NULL,'…..',NULL,'2025-07-26 22:03:57',0,0,0,'2025-07-26 22:03:57','2025-07-26 22:03:57','2025-07-26 22:03:57',0),(6747272877,'mthsq2','ytheuznxs7','7','2025-08-02 21:37:57',0,0,0,'2025-08-02 21:37:57','2025-08-02 21:37:57','2025-08-02 21:37:57',0),(6750584402,NULL,'VENDAS NO AUTOMÁTICO COM A KIWIFY?',NULL,'2025-08-06 01:49:52',0,0,0,'2025-08-06 01:49:52','2025-08-06 01:49:52','2025-08-06 01:49:52',0),(6767661363,NULL,'Kauan','Costa','2025-07-26 21:42:14',0,0,0,'2025-07-26 21:42:14','2025-07-26 21:42:14','2025-07-26 21:42:14',0),(6773871757,NULL,'Marcos','Mayquin','2025-08-05 02:51:13',0,0,0,'2025-08-05 02:51:13','2025-08-05 02:51:13','2025-08-05 02:51:13',0),(6781789779,NULL,'Jonatha','Barros','2025-07-26 21:33:39',1,0,0,'2025-07-29 00:59:30','2025-07-26 21:33:39','2025-07-29 00:59:30',0),(6801634386,NULL,'Luiz Davy','Gonçalves Silva','2025-08-04 01:14:53',0,0,0,'2025-08-04 01:14:53','2025-08-04 01:14:53','2025-08-04 01:14:53',0),(6811627354,NULL,'Kaique','Mc','2025-07-27 17:57:11',0,0,0,'2025-07-27 17:57:11','2025-07-27 17:57:11','2025-07-27 17:57:11',0),(6819563856,NULL,'Alice','Vitoria','2025-07-27 02:27:12',0,0,0,'2025-07-27 02:27:12','2025-07-27 02:27:12','2025-07-27 02:27:12',0),(6824412732,NULL,'Daniel William','Sousa','2025-08-05 02:16:14',0,0,0,'2025-08-05 02:16:14','2025-08-05 02:16:14','2025-08-05 02:16:14',0),(6830139793,NULL,'Bruto7',NULL,'2025-07-30 02:47:34',0,0,0,'2025-07-30 02:47:34','2025-07-30 02:47:34','2025-07-30 02:47:34',0),(6851540819,'Isack_trader','Aprendizado','Trader','2025-08-03 23:02:04',0,0,0,'2025-08-03 23:02:04','2025-08-03 23:02:04','2025-08-03 23:02:04',0),(6853375396,NULL,'Otaviano',NULL,'2025-07-26 21:24:04',0,0,0,'2025-07-26 21:24:04','2025-07-26 21:24:04','2025-07-26 21:24:04',0),(6854791760,NULL,'Gabriel','Prince','2025-07-26 21:32:48',1,0,0,'2025-08-03 12:19:20','2025-07-26 21:32:48','2025-08-03 12:19:20',0),(6879911731,NULL,'Matheus','Almeida','2025-07-26 22:10:31',1,0,0,'2025-08-05 01:34:24','2025-07-26 22:10:31','2025-08-05 01:34:24',0),(6881699114,NULL,'Lucas','RD','2025-07-27 05:33:39',0,0,0,'2025-07-27 05:33:39','2025-07-27 05:33:39','2025-07-27 05:33:39',0),(6886917741,NULL,'Lucas','Tyler','2025-07-27 21:03:09',0,0,0,'2025-07-27 21:03:09','2025-07-27 21:03:09','2025-07-27 21:03:09',0),(6890380194,NULL,'Bumblebee',NULL,'2025-08-04 01:39:00',1,0,0,'2025-08-04 03:59:23','2025-08-04 01:39:00','2025-08-04 03:59:23',0),(6892222041,'ana_juliaa1','Ana Julia','Gomes','2025-07-26 21:22:46',0,0,0,'2025-07-26 21:22:46','2025-07-26 21:22:46','2025-07-26 21:22:46',0),(6892749695,'Semsobrenomes7','Sem','Sobrenomes','2025-07-27 09:15:25',0,0,0,'2025-07-27 09:15:25','2025-07-27 09:15:25','2025-07-27 09:15:25',0),(6900633778,NULL,'?',NULL,'2025-07-29 03:32:12',0,0,0,'2025-07-29 03:32:12','2025-07-29 03:32:12','2025-07-29 03:32:12',0),(6906375670,NULL,'ENRY',NULL,'2025-08-04 02:01:17',0,0,0,'2025-08-04 02:01:17','2025-08-04 02:01:17','2025-08-04 02:01:17',0),(6912953910,'omaisbraabo','O mais brabo',NULL,'2025-08-06 01:53:24',0,0,0,'2025-08-06 01:53:24','2025-08-06 01:53:24','2025-08-06 01:53:24',0),(6915905731,NULL,'Luiz Felipe',NULL,'2025-07-30 11:39:46',0,0,0,'2025-07-30 11:39:46','2025-07-30 11:39:46','2025-07-30 11:39:46',0),(6918076061,NULL,'????‍♂️',NULL,'2025-08-05 13:24:54',0,0,0,'2025-08-05 13:24:54','2025-08-05 13:24:54','2025-08-05 13:24:54',0),(6923004982,NULL,'Victor Hugo','Morzeli','2025-08-03 03:36:06',0,0,0,'2025-08-03 03:36:06','2025-08-03 03:36:06','2025-08-03 03:36:06',0),(6956239896,NULL,'Vini','Vini','2025-07-27 13:26:30',0,0,0,'2025-07-27 13:26:30','2025-07-27 13:26:30','2025-07-27 13:26:30',0),(6972071649,NULL,'Laryssa',NULL,'2025-08-03 03:37:12',0,0,0,'2025-08-03 03:37:12','2025-08-03 03:37:12','2025-08-03 03:37:12',0),(6972453563,NULL,'Vinicius',NULL,'2025-08-02 04:05:57',0,0,0,'2025-08-02 04:05:57','2025-08-02 04:05:57','2025-08-02 04:05:57',0),(6991710766,NULL,'Jefferson',NULL,'2025-07-29 01:28:28',0,0,0,'2025-07-29 01:28:28','2025-07-29 01:28:28','2025-07-29 01:28:28',0),(6997353714,NULL,'Marcelinho',NULL,'2025-07-29 23:19:34',0,0,0,'2025-07-29 23:19:34','2025-07-29 23:19:34','2025-07-29 23:19:34',0),(7010133561,NULL,'Davi S.C',NULL,'2025-08-02 02:04:42',0,0,0,'2025-08-02 02:04:42','2025-08-02 02:04:42','2025-08-02 02:04:42',0),(7015794091,NULL,'Bart','gg','2025-07-26 23:37:14',0,0,0,'2025-07-26 23:37:14','2025-07-26 23:37:14','2025-07-26 23:37:14',0),(7016246498,NULL,'Matheus',NULL,'2025-07-26 21:52:08',0,0,0,'2025-07-26 21:52:08','2025-07-26 21:52:08','2025-07-26 21:52:08',0),(7021979295,NULL,'Luis Felipe','de Mello','2025-08-04 01:29:57',0,0,0,'2025-08-04 01:29:57','2025-08-04 01:29:57','2025-08-04 01:29:57',0),(7044744845,NULL,'Menor Menor',NULL,'2025-07-30 02:58:25',0,0,0,'2025-07-30 02:58:25','2025-07-30 02:58:25','2025-07-30 02:58:25',0),(7044888770,NULL,'Meno','Topp','2025-07-26 21:32:30',0,0,0,'2025-07-26 21:32:30','2025-07-26 21:32:30','2025-07-26 21:32:30',0),(7049693275,NULL,'rayan’s',NULL,'2025-07-26 21:46:59',0,0,0,'2025-07-26 21:46:59','2025-07-26 21:46:59','2025-07-26 21:46:59',0),(7054636226,NULL,'Caio','victor','2025-08-02 16:50:00',0,0,0,'2025-08-02 16:50:00','2025-08-02 16:50:00','2025-08-02 16:50:00',0),(7065175393,NULL,'Cleberson','Santos','2025-07-26 22:36:57',0,0,0,'2025-07-26 22:36:57','2025-07-26 22:36:57','2025-07-26 22:36:57',0),(7071384610,NULL,'Ygor','Gomes','2025-07-29 22:30:21',0,0,0,'2025-07-29 22:30:21','2025-07-29 22:30:21','2025-07-29 22:30:21',0),(7074580189,NULL,'@Wevergrau_46??',NULL,'2025-07-27 02:31:58',0,0,0,'2025-07-27 02:31:58','2025-07-27 02:31:58','2025-07-27 02:31:58',0),(7077039042,'Futuroviator','Josivany','Josivany','2025-07-27 09:49:19',0,0,0,'2025-07-27 09:49:19','2025-07-27 09:49:19','2025-07-27 09:49:19',0),(7083224200,NULL,'Daniel','Silva','2025-07-30 14:10:53',0,0,0,'2025-07-30 14:10:53','2025-07-30 14:10:53','2025-07-30 14:10:53',0),(7084289205,NULL,'Rychard','Simonete','2025-08-02 10:01:40',0,0,0,'2025-08-02 10:01:40','2025-08-02 10:01:40','2025-08-02 10:01:40',0),(7095400984,'alvesmarcelli','Marcelli',NULL,'2025-07-27 07:04:46',0,0,0,'2025-07-27 07:04:46','2025-07-27 07:04:46','2025-07-27 07:04:46',0),(7102206280,'Relikia777','Relikia',NULL,'2025-08-05 15:06:49',0,0,0,'2025-08-05 15:06:49','2025-08-05 15:06:49','2025-08-05 15:06:49',0),(7103577820,NULL,'Vinicius',NULL,'2025-08-02 23:02:08',0,0,0,'2025-08-02 23:02:08','2025-08-02 23:02:08','2025-08-02 23:02:08',0),(7114651096,NULL,'Luiz','Henrique','2025-07-29 01:29:35',0,0,0,'2025-07-29 01:29:35','2025-07-29 01:29:35','2025-07-29 01:29:35',0),(7119847985,NULL,'Menor','Zl','2025-07-26 21:19:23',0,0,0,'2025-07-26 21:19:23','2025-07-26 21:19:23','2025-07-26 21:19:23',0),(7124774796,NULL,'Luis','Felipe','2025-07-29 20:50:34',0,0,0,'2025-07-29 20:50:34','2025-07-29 20:50:34','2025-07-29 20:50:34',0),(7126297283,'kauanvsa4','Kauan',NULL,'2025-07-26 17:33:11',0,0,0,'2025-07-26 17:33:11','2025-07-26 17:33:11','2025-07-26 17:33:11',0),(7126717358,NULL,'Murilo','Constantino','2025-08-05 01:42:11',0,0,0,'2025-08-05 01:42:11','2025-08-05 01:42:11','2025-08-05 01:42:11',0),(7135811047,NULL,'Fabricio','Resende','2025-08-03 01:08:51',0,0,0,'2025-08-03 01:08:51','2025-08-03 01:08:51','2025-08-03 01:08:51',0),(7140566731,NULL,'Bd','Ol','2025-08-06 02:28:57',0,0,0,'2025-08-06 02:28:57','2025-08-06 02:28:57','2025-08-06 02:28:57',0),(7143196659,NULL,'Juan','Pablo','2025-07-26 23:25:42',0,0,0,'2025-07-26 23:25:42','2025-07-26 23:25:42','2025-07-26 23:25:42',0),(7157261444,NULL,'Apolo','Monteiro','2025-07-26 23:00:50',0,0,0,'2025-07-26 23:00:50','2025-07-26 23:00:50','2025-07-26 23:00:50',0),(7167577973,NULL,'and',NULL,'2025-07-30 16:02:50',0,0,0,'2025-07-30 16:02:50','2025-07-30 16:02:50','2025-07-30 16:02:50',0),(7172032630,NULL,'fxzn',NULL,'2025-07-26 23:35:37',0,0,0,'2025-07-26 23:35:37','2025-07-26 23:35:37','2025-07-26 23:35:37',0),(7173435350,NULL,'Michelli',NULL,'2025-07-26 22:51:38',0,0,0,'2025-07-26 22:51:38','2025-07-26 22:51:38','2025-07-26 22:51:38',0),(7176966659,'yudi_trader','ya',NULL,'2025-07-26 21:27:35',0,0,0,'2025-07-26 21:27:35','2025-07-26 21:27:35','2025-07-26 21:27:35',0),(7185440745,'Kaiootr','Kaioor','Silvr','2025-08-05 02:47:49',0,0,0,'2025-08-05 02:47:49','2025-08-05 02:47:49','2025-08-05 02:47:49',0),(7189908453,NULL,'Thiago',NULL,'2025-07-27 15:24:59',0,0,0,'2025-07-27 15:24:59','2025-07-27 15:24:59','2025-07-27 15:24:59',0),(7197367122,NULL,'…',NULL,'2025-08-05 03:04:12',0,0,0,'2025-08-05 03:04:12','2025-08-05 03:04:12','2025-08-05 03:04:12',0),(7201162454,NULL,'Vitin',NULL,'2025-07-29 16:45:40',0,0,0,'2025-07-29 16:45:40','2025-07-29 16:45:40','2025-07-29 16:45:40',0),(7216122935,NULL,'Vitinn',NULL,'2025-07-26 22:45:03',0,0,0,'2025-07-26 22:45:03','2025-07-26 22:45:03','2025-07-26 22:45:03',0),(7217405134,NULL,'Edson','Junior','2025-08-02 23:58:44',0,0,0,'2025-08-02 23:58:44','2025-08-02 23:58:44','2025-08-02 23:58:44',0),(7236926901,NULL,'Felipe Snt',NULL,'2025-07-26 22:50:10',0,0,0,'2025-07-26 22:50:10','2025-07-26 22:50:10','2025-07-26 22:50:10',0),(7238288720,NULL,'Darke_Zs',NULL,'2025-07-27 05:47:19',0,0,0,'2025-07-27 05:47:19','2025-07-27 05:47:19','2025-07-27 05:47:19',0),(7250636522,NULL,'DVzinnx.LX7',NULL,'2025-08-06 01:03:31',0,0,0,'2025-08-06 01:03:31','2025-08-06 01:03:31','2025-08-06 01:03:31',0),(7257422496,NULL,'Devid','Devid Dacosta De Oliveira','2025-07-26 21:18:57',0,0,0,'2025-07-26 21:18:57','2025-07-26 21:18:57','2025-07-26 21:18:57',0),(7257860123,NULL,'Douglas','Henrique','2025-08-04 02:08:17',0,0,0,'2025-08-04 02:08:17','2025-08-04 02:08:17','2025-08-04 02:08:17',0),(7258291634,'cnpaygateway','CN Payment Solutions',NULL,'2025-07-26 16:27:28',0,0,0,'2025-07-26 16:27:28','2025-07-26 16:27:28','2025-07-26 16:27:28',0),(7260783882,NULL,'Rulyan','Duarte','2025-07-28 23:51:24',0,0,0,'2025-07-28 23:51:24','2025-07-28 23:51:24','2025-07-28 23:51:24',0),(7261591103,NULL,'Ryan','Santos','2025-07-29 01:26:24',0,0,0,'2025-07-29 01:26:24','2025-07-29 01:26:24','2025-07-29 01:26:24',0),(7274551369,NULL,'Brenno','Rafael','2025-08-04 02:29:41',1,0,0,'2025-08-04 02:30:33','2025-08-04 02:29:41','2025-08-04 02:30:33',0),(7287478359,NULL,'Taliba','P','2025-07-26 23:01:26',0,0,0,'2025-07-26 23:01:26','2025-07-26 23:01:26','2025-07-26 23:01:26',0),(7292266140,'Dey_trade01','Marcos Vinicius',NULL,'2025-08-02 21:56:23',0,0,0,'2025-08-02 21:56:23','2025-08-02 21:56:23','2025-08-02 21:56:23',0),(7294650761,NULL,'Miguel henrique','Silva brito','2025-08-02 23:55:47',0,0,0,'2025-08-02 23:55:47','2025-08-02 23:55:47','2025-08-02 23:55:47',0),(7295592038,NULL,'Ricardo',NULL,'2025-07-26 21:05:16',0,0,0,'2025-07-26 21:05:16','2025-07-26 21:05:16','2025-07-26 21:05:16',0),(7310112579,NULL,'Lucas','Lubschinski Peres','2025-07-29 01:08:00',1,0,0,'2025-07-29 02:17:45','2025-07-29 01:08:00','2025-07-29 02:17:45',0),(7321822032,NULL,'Eduardo',NULL,'2025-07-27 00:20:07',1,0,0,'2025-07-27 00:23:51','2025-07-27 00:20:07','2025-07-27 00:23:51',0),(7335520690,NULL,'Newton','Roballo','2025-08-03 12:59:11',0,0,0,'2025-09-05 02:32:12','2025-08-03 12:59:11','2025-09-05 02:32:12',0),(7336789033,NULL,'Felipe','Cabral','2025-08-06 01:02:22',0,0,0,'2025-09-05 02:08:12','2025-08-06 01:02:22','2025-09-05 02:08:12',0),(7343761078,NULL,'Neymar Jr',NULL,'2025-08-03 03:34:33',0,0,0,'2025-08-03 03:34:33','2025-08-03 03:34:33','2025-08-03 03:34:33',0),(7363184577,NULL,'Rafael','Matos','2025-07-29 00:14:05',0,0,0,'2025-07-29 00:14:05','2025-07-29 00:14:05','2025-07-29 00:14:05',0),(7366269893,NULL,'Gabriel','henrique','2025-07-27 00:04:12',1,0,0,'2025-07-29 01:09:15','2025-07-27 00:04:12','2025-07-29 01:09:15',0),(7374670881,NULL,'Thiago','Duran','2025-08-05 02:27:15',0,0,0,'2025-08-05 02:27:15','2025-08-05 02:27:15','2025-08-05 02:27:15',0),(7385326262,NULL,'Arth7r',NULL,'2025-08-06 01:48:45',0,0,0,'2025-08-06 01:48:45','2025-08-06 01:48:45','2025-08-06 01:48:45',0),(7390252153,NULL,'Ocupado',NULL,'2025-07-26 23:04:30',0,0,0,'2025-07-26 23:04:30','2025-07-26 23:04:30','2025-07-26 23:04:30',0),(7403734038,NULL,'Rodrigomeylls','Ribeiro','2025-08-04 01:19:01',0,0,0,'2025-08-04 01:19:01','2025-08-04 01:19:01','2025-08-04 01:19:01',0),(7413931502,NULL,'joabe',NULL,'2025-07-27 00:25:11',0,0,0,'2025-07-27 00:25:11','2025-07-27 00:25:11','2025-07-27 00:25:11',0),(7422579454,NULL,'Domingos Martinho','Nsenga','2025-07-27 13:18:17',0,0,0,'2025-07-27 13:18:17','2025-07-27 13:18:17','2025-07-27 13:18:17',0),(7428425949,NULL,'Pedro',NULL,'2025-07-29 01:08:30',0,0,0,'2025-07-29 01:08:30','2025-07-29 01:08:30','2025-07-29 01:08:30',0),(7430397565,'anderrferreira','.',NULL,'2025-07-27 01:17:25',0,0,0,'2025-07-27 01:17:25','2025-07-27 01:17:25','2025-07-27 01:17:25',0),(7436033557,NULL,'Cauan','Santana','2025-08-06 01:44:01',0,0,0,'2025-08-06 01:44:01','2025-08-06 01:44:01','2025-08-06 01:44:01',0),(7448186215,NULL,'Thalyson','Thalyson','2025-07-26 21:45:13',0,0,0,'2025-07-26 21:45:13','2025-07-26 21:45:13','2025-07-26 21:45:13',0),(7449121440,NULL,'Eduardo','Fernandes','2025-07-26 22:43:16',0,0,0,'2025-07-26 22:43:16','2025-07-26 22:43:16','2025-07-26 22:43:16',0),(7465588254,NULL,'thiago','henrique','2025-07-29 00:14:04',0,0,0,'2025-07-29 00:14:04','2025-07-29 00:14:04','2025-07-29 00:14:04',0),(7469515875,NULL,'Yasmim','Dias','2025-07-28 11:49:46',0,0,0,'2025-07-28 11:49:46','2025-07-28 11:49:46','2025-07-28 11:49:46',0),(7470688672,NULL,'raí','Jose','2025-07-29 01:18:51',0,0,0,'2025-07-29 01:18:51','2025-07-29 01:18:51','2025-07-29 01:18:51',0),(7472236938,NULL,'Lucas','Silva','2025-08-03 02:53:20',1,0,0,'2025-08-03 04:08:18','2025-08-03 02:53:20','2025-08-03 04:08:18',0),(7474718430,NULL,'Fabiola','Farias','2025-07-27 00:11:23',0,0,0,'2025-07-27 00:11:23','2025-07-27 00:11:23','2025-07-27 00:11:23',0),(7479058196,NULL,'Mellanye','Lima','2025-08-06 01:51:10',0,0,0,'2025-08-06 01:51:10','2025-08-06 01:51:10','2025-08-06 01:51:10',0),(7483323480,NULL,'Daniel de almeida ferraz','Almeida ferraz','2025-08-06 02:00:00',0,0,0,'2025-08-06 02:00:00','2025-08-06 02:00:00','2025-08-06 02:00:00',0),(7494590632,NULL,'.',NULL,'2025-07-26 21:45:17',0,0,0,'2025-07-26 21:45:17','2025-07-26 21:45:17','2025-07-26 21:45:17',0),(7496940494,NULL,'Atanã','Neto','2025-08-02 04:28:30',0,0,0,'2025-08-02 04:28:30','2025-08-02 04:28:30','2025-08-02 04:28:30',0),(7503273038,NULL,'Nicolau',NULL,'2025-07-29 02:08:02',0,0,0,'2025-07-29 02:08:02','2025-07-29 02:08:02','2025-07-29 02:08:02',0),(7505660242,NULL,'Pedro','Genrique','2025-08-04 00:55:24',0,0,0,'2025-08-04 00:55:24','2025-08-04 00:55:24','2025-08-04 00:55:24',0),(7509500017,NULL,'Brenner','joel','2025-08-04 01:34:42',1,0,0,'2025-08-04 01:51:31','2025-08-04 01:34:42','2025-08-04 01:51:31',0),(7511730582,NULL,'Matheus','Henrique','2025-08-02 05:01:38',0,0,0,'2025-08-02 05:01:38','2025-08-02 05:01:38','2025-08-02 05:01:38',0),(7524070720,'Castrootrader','Castro',NULL,'2025-08-05 02:56:35',0,0,0,'2025-08-05 02:56:35','2025-08-05 02:56:35','2025-08-05 02:56:35',0),(7529488510,NULL,'Felipe','Oliveira','2025-07-27 22:26:36',0,0,0,'2025-07-27 22:26:36','2025-07-27 22:26:36','2025-07-27 22:26:36',0),(7531502586,NULL,'Kauan','Dias','2025-07-26 21:20:52',0,0,0,'2025-07-26 21:20:52','2025-07-26 21:20:52','2025-07-26 21:20:52',0),(7549979215,NULL,'Artur','Santana','2025-07-26 21:05:58',1,0,0,'2025-08-04 01:32:38','2025-07-26 21:05:58','2025-08-04 01:32:38',0),(7550917786,NULL,'Anderson','Brandão','2025-08-04 05:00:24',0,0,0,'2025-08-04 05:00:24','2025-08-04 05:00:24','2025-08-04 05:00:24',0),(7551210040,NULL,'Trindade','Brian','2025-07-29 01:45:25',1,0,0,'2025-07-29 01:46:03','2025-07-29 01:45:25','2025-07-29 01:46:03',0),(7554060102,NULL,'Douglas',NULL,'2025-08-04 18:48:00',0,0,0,'2025-08-04 18:48:00','2025-08-04 18:48:00','2025-08-04 18:48:00',0),(7558064833,'Mateuzinhooooo','Mateus','Do Nascimento Oliveira','2025-08-05 11:48:45',0,0,0,'2025-08-05 11:48:45','2025-08-05 11:48:45','2025-08-05 11:48:45',0),(7563955064,NULL,'Carlos Eduardo',NULL,'2025-07-29 17:45:42',0,0,0,'2025-07-29 17:45:42','2025-07-29 17:45:42','2025-07-29 17:45:42',0),(7567762370,NULL,'Yasmim','Lorrana','2025-07-29 02:04:06',0,0,0,'2025-07-29 02:04:06','2025-07-29 02:04:06','2025-07-29 02:04:06',0),(7569380668,NULL,'Bruna',NULL,'2025-07-29 00:03:15',0,0,0,'2025-07-29 00:03:15','2025-07-29 00:03:15','2025-07-29 00:03:15',0),(7575562007,NULL,'Leo Souza',NULL,'2025-07-26 21:19:31',0,0,0,'2025-07-26 21:19:31','2025-07-26 21:19:31','2025-07-26 21:19:31',0),(7577379281,NULL,'Edson','Silva','2025-08-05 12:39:18',0,0,0,'2025-08-05 12:39:18','2025-08-05 12:39:18','2025-08-05 12:39:18',0),(7577483396,'Venhamcomig0','ESCANNOR',NULL,'2025-07-26 21:03:49',0,0,0,'2025-07-26 21:03:49','2025-07-26 21:03:49','2025-07-26 21:03:49',0),(7579637250,NULL,'fall',NULL,'2025-08-04 16:59:18',0,0,0,'2025-08-04 16:59:18','2025-08-04 16:59:18','2025-08-04 16:59:18',0),(7581569850,NULL,'Alex','Daniel','2025-07-26 22:20:15',1,0,0,'2025-08-04 02:09:40','2025-07-26 22:20:15','2025-08-04 02:09:40',0),(7585359811,NULL,'布拉甘蒂諾',NULL,'2025-08-05 01:47:53',0,0,0,'2025-08-05 01:47:53','2025-08-05 01:47:53','2025-08-05 01:47:53',0),(7589493105,NULL,'Kauan','Bk','2025-07-28 21:37:50',0,0,0,'2025-07-28 21:37:50','2025-07-28 21:37:50','2025-07-28 21:37:50',0),(7594342495,NULL,'samucassxzn',NULL,'2025-08-04 01:11:25',0,0,0,'2025-08-04 01:11:25','2025-08-04 01:11:25','2025-08-04 01:11:25',0),(7604125410,NULL,'Nathalia','Rodrigues','2025-07-27 04:20:52',0,0,0,'2025-07-27 04:20:52','2025-07-27 04:20:52','2025-07-27 04:20:52',0),(7604652441,NULL,'Miguel zeno','Medina','2025-08-03 03:35:17',0,0,0,'2025-08-03 03:35:17','2025-08-03 03:35:17','2025-08-03 03:35:17',0),(7605193467,NULL,'Ritinha','Cruz','2025-07-27 11:21:34',0,0,0,'2025-07-27 11:21:34','2025-07-27 11:21:34','2025-07-27 11:21:34',0),(7616021480,NULL,'Ariadna','Ubatuba','2025-07-26 22:26:24',0,0,0,'2025-07-26 22:26:24','2025-07-26 22:26:24','2025-07-26 22:26:24',0),(7621784193,NULL,'Alvez','Yago','2025-08-02 16:42:15',0,0,0,'2025-08-02 16:42:15','2025-08-02 16:42:15','2025-08-02 16:42:15',0),(7631435405,NULL,'sofia','azzevedo','2025-07-29 21:42:17',0,0,0,'2025-07-29 21:42:17','2025-07-29 21:42:17','2025-07-29 21:42:17',0),(7634812034,NULL,'Rick','Tds','2025-07-28 00:03:52',0,0,0,'2025-07-28 00:03:52','2025-07-28 00:03:52','2025-07-28 00:03:52',0),(7639174832,NULL,'Kelvin',NULL,'2025-08-02 04:48:10',0,0,0,'2025-08-02 04:48:10','2025-08-02 04:48:10','2025-08-02 04:48:10',0),(7651508922,NULL,'Santos','Santos','2025-07-26 21:19:09',0,0,0,'2025-07-26 21:19:09','2025-07-26 21:19:09','2025-07-26 21:19:09',0),(7655990868,NULL,'Will',NULL,'2025-07-27 12:34:58',0,0,0,'2025-07-27 12:34:58','2025-07-27 12:34:58','2025-07-27 12:34:58',0),(7659245954,NULL,'Galdino',NULL,'2025-07-29 01:36:56',0,0,0,'2025-07-29 01:36:56','2025-07-29 01:36:56','2025-07-29 01:36:56',0),(7663088302,NULL,'Pedro','Maciel','2025-07-29 00:14:02',0,0,0,'2025-07-29 00:14:02','2025-07-29 00:14:02','2025-07-29 00:14:02',0),(7671634353,NULL,'Alisson4c','Chaves','2025-08-04 01:11:07',0,0,0,'2025-08-04 01:11:07','2025-08-04 01:11:07','2025-08-04 01:11:07',0),(7681120177,NULL,'Mayck','Nunes','2025-07-26 22:20:57',0,0,0,'2025-07-26 22:20:57','2025-07-26 22:20:57','2025-07-26 22:20:57',0),(7685603268,NULL,'Jonas','Gab','2025-07-26 23:01:28',0,0,0,'2025-07-26 23:01:28','2025-07-26 23:01:28','2025-07-26 23:01:28',0),(7685744488,NULL,'Bruno','Araujo','2025-08-03 04:01:05',0,0,0,'2025-08-03 04:01:05','2025-08-03 04:01:05','2025-08-03 04:01:05',0),(7690103682,NULL,'Ismael','Guedes','2025-07-26 21:03:23',0,0,0,'2025-07-26 21:03:23','2025-07-26 21:03:23','2025-07-26 21:03:23',0),(7695002155,NULL,'Pedro','Ivo','2025-08-03 04:10:26',0,0,0,'2025-08-03 04:10:26','2025-08-03 04:10:26','2025-08-03 04:10:26',0),(7695906583,'Guel_g21','Guel7',NULL,'2025-08-04 01:14:13',0,0,0,'2025-08-04 01:14:13','2025-08-04 01:14:13','2025-08-04 01:14:13',0),(7697155347,'GuilhermeUpBet','Guilherme','Nesk','2025-07-26 14:35:07',0,0,0,'2025-07-27 14:38:06','2025-07-26 14:35:07','2025-07-27 14:38:06',0),(7713843048,NULL,'Arthur','Souza','2025-07-27 18:34:40',0,0,0,'2025-07-27 18:34:40','2025-07-27 18:34:40','2025-07-27 18:34:40',0),(7730244561,'lfmaia','Lara','Maia','2025-08-04 02:03:09',1,0,0,'2025-08-04 02:04:28','2025-08-04 02:03:09','2025-08-04 02:04:28',0),(7733064669,NULL,'Andre','Pereira','2025-07-27 17:11:15',0,0,0,'2025-07-27 17:11:15','2025-07-27 17:11:15','2025-07-27 17:11:15',0),(7741596090,NULL,'Gabriel',NULL,'2025-08-04 18:27:39',1,0,0,'2025-08-04 18:35:48','2025-08-04 18:27:39','2025-08-04 18:35:48',0),(7743985301,NULL,'Job',NULL,'2025-07-26 21:27:01',0,0,0,'2025-07-26 21:27:01','2025-07-26 21:27:01','2025-07-26 21:27:01',0),(7745219635,NULL,'joao','vitor','2025-07-27 00:59:35',0,0,0,'2025-07-27 00:59:35','2025-07-27 00:59:35','2025-07-27 00:59:35',0),(7751411691,NULL,'Joao',NULL,'2025-08-04 01:21:44',0,0,0,'2025-08-04 01:21:44','2025-08-04 01:21:44','2025-08-04 01:21:44',0),(7752367560,NULL,'Dhdhd','Hehe','2025-07-27 01:23:12',0,0,0,'2025-09-05 01:59:12','2025-07-27 01:23:12','2025-09-05 01:59:12',0),(7754132379,NULL,'Mateus','Lucas','2025-07-27 00:15:56',0,0,0,'2025-07-27 00:15:56','2025-07-27 00:15:56','2025-07-27 00:15:56',0),(7755781068,NULL,'Henrique zin 2.0??',NULL,'2025-08-03 10:13:37',1,0,0,'2025-08-04 02:12:34','2025-08-03 10:13:37','2025-08-04 02:12:34',0),(7756662067,NULL,'Muttley',NULL,'2025-07-29 01:26:27',0,0,0,'2025-07-29 01:26:27','2025-07-29 01:26:27','2025-07-29 01:26:27',0),(7762676561,NULL,'Josivaldo ?',NULL,'2025-07-29 22:05:49',0,0,0,'2025-07-29 22:05:49','2025-07-29 22:05:49','2025-07-29 22:05:49',0),(7775559657,'conteudos202511','Conteúdo Free',NULL,'2025-08-02 01:48:17',0,0,0,'2025-08-02 01:48:17','2025-08-02 01:48:17','2025-08-02 01:48:17',0),(7775654123,'marcosfelipmusic','Marcos','Felipe','2025-08-06 01:03:42',0,0,0,'2025-08-06 01:03:42','2025-08-06 01:03:42','2025-08-06 01:03:42',0),(7779566856,'Andryw11','Andryw','Adm','2025-07-26 22:28:22',0,0,0,'2025-07-26 22:28:22','2025-07-26 22:28:22','2025-07-26 22:28:22',0),(7783120392,NULL,'A','Monick','2025-07-26 21:21:50',1,0,0,'2025-08-04 22:04:41','2025-07-26 21:21:50','2025-08-04 22:04:41',0),(7788036052,NULL,'Santss?‍??',NULL,'2025-08-05 11:01:17',0,0,0,'2025-08-05 11:01:17','2025-08-05 11:01:17','2025-08-05 11:01:17',0),(7794143780,NULL,'Bryan','Cleb','2025-08-05 02:31:50',0,0,0,'2025-08-05 02:31:50','2025-08-05 02:31:50','2025-08-05 02:31:50',0),(7797616323,NULL,'Breno',NULL,'2025-07-29 02:52:16',0,0,0,'2025-07-29 02:52:16','2025-07-29 02:52:16','2025-07-29 02:52:16',0),(7802769587,NULL,'Gustavo','Rabelo','2025-07-26 21:37:43',0,0,0,'2025-07-26 21:37:43','2025-07-26 21:37:43','2025-07-26 21:37:43',0),(7804059954,NULL,'Marques',NULL,'2025-07-26 22:44:56',0,0,0,'2025-07-26 22:44:56','2025-07-26 22:44:56','2025-07-26 22:44:56',0),(7805479584,NULL,'Jonatas','Monteiro','2025-07-27 22:29:56',0,0,0,'2025-07-27 22:29:56','2025-07-27 22:29:56','2025-07-27 22:29:56',0),(7811294127,NULL,'Lucaas.bgz',NULL,'2025-08-03 03:47:56',0,0,0,'2025-08-03 03:47:56','2025-08-03 03:47:56','2025-08-03 03:47:56',0),(7813534309,NULL,'RD',NULL,'2025-07-28 21:45:16',0,0,0,'2025-07-28 21:45:16','2025-07-28 21:45:16','2025-07-28 21:45:16',0),(7819480338,NULL,'José',NULL,'2025-07-26 22:17:15',0,0,0,'2025-07-26 22:17:15','2025-07-26 22:17:15','2025-07-26 22:17:15',0),(7822235881,NULL,'Paulo','Henrrique','2025-07-28 02:02:56',0,0,0,'2025-07-28 02:02:56','2025-07-28 02:02:56','2025-07-28 02:02:56',0),(7830509928,NULL,'leonardo','soares','2025-07-27 02:43:53',0,0,0,'2025-07-27 02:43:53','2025-07-27 02:43:53','2025-07-27 02:43:53',0),(7842230028,NULL,'Thalles','Henrique','2025-07-27 02:28:41',0,0,0,'2025-07-27 02:28:41','2025-07-27 02:28:41','2025-07-27 02:28:41',0),(7846428238,NULL,'Hentonny','Kaue','2025-07-26 21:46:56',0,0,0,'2025-07-26 21:46:56','2025-07-26 21:46:56','2025-07-26 21:46:56',0),(7846856380,NULL,'Nanin',NULL,'2025-07-29 01:40:44',1,0,0,'2025-08-03 17:11:58','2025-07-29 01:40:44','2025-08-03 17:11:58',0),(7848621860,NULL,'Boos',NULL,'2025-07-26 21:03:16',1,0,0,'2025-08-04 01:13:31','2025-07-26 21:03:16','2025-08-04 01:13:31',0),(7850725901,NULL,'Tifany',NULL,'2025-07-27 21:03:22',0,0,0,'2025-07-27 21:03:22','2025-07-27 21:03:22','2025-07-27 21:03:22',0),(7851345831,NULL,'vini7',NULL,'2025-08-05 05:59:32',0,0,0,'2025-08-05 17:30:12','2025-08-05 05:59:32','2025-08-05 17:30:12',0),(7858346397,'Pedrosa710','Pedro','Farias','2025-08-03 04:24:22',0,0,0,'2025-08-03 04:24:22','2025-08-03 04:24:22','2025-08-03 04:24:22',0),(7862694393,NULL,'Taua','Da Silva','2025-08-03 05:16:19',0,0,0,'2025-08-03 05:16:19','2025-08-03 05:16:19','2025-08-03 05:16:19',0),(7864030346,NULL,'Wl','Oliveira7e7','2025-08-04 01:48:46',0,0,0,'2025-08-04 01:48:46','2025-08-04 01:48:46','2025-08-04 01:48:46',0),(7875669137,NULL,'ray',NULL,'2025-08-05 02:55:16',1,0,0,'2025-08-05 03:00:32','2025-08-05 02:55:16','2025-08-05 03:00:32',0),(7876063072,NULL,'Moises','Cristian','2025-08-05 02:53:49',0,0,0,'2025-08-05 02:53:49','2025-08-05 02:53:49','2025-08-05 02:53:49',0),(7887784918,NULL,'runxdr','hjh','2025-07-29 01:16:52',0,0,0,'2025-07-29 01:16:52','2025-07-29 01:16:52','2025-07-29 01:16:52',0),(7890337024,NULL,'Jh','H','2025-07-27 08:04:39',0,0,0,'2025-07-27 08:04:39','2025-07-27 08:04:39','2025-07-27 08:04:39',0),(7893069529,NULL,'Weslen Douglas',NULL,'2025-07-30 01:12:14',1,0,0,'2025-08-05 01:43:31','2025-07-30 01:12:14','2025-08-05 01:43:31',0),(7905763681,NULL,'Alexsanderfaalmeida@gmail.com','Allice1910','2025-07-26 21:03:31',0,0,0,'2025-07-26 21:03:31','2025-07-26 21:03:31','2025-07-26 21:03:31',0),(7919757142,NULL,'David','Pereira','2025-08-04 01:51:59',0,0,0,'2025-08-04 01:51:59','2025-08-04 01:51:59','2025-08-04 01:51:59',0),(7920104562,NULL,'Ailton','Silva','2025-08-04 02:14:09',0,0,0,'2025-08-04 02:14:09','2025-08-04 02:14:09','2025-08-04 02:14:09',0),(7924087231,NULL,'Kaik','Dantas','2025-07-27 07:07:06',0,0,0,'2025-07-27 07:07:06','2025-07-27 07:07:06','2025-07-27 07:07:06',0),(7925631696,NULL,'Gustavo','Castro','2025-08-02 16:06:48',0,0,0,'2025-08-02 16:06:48','2025-08-02 16:06:48','2025-08-02 16:06:48',0),(7936603429,NULL,'Di','A','2025-07-28 23:15:24',0,0,0,'2025-07-28 23:15:24','2025-07-28 23:15:24','2025-07-28 23:15:24',0),(7937246915,NULL,'Bianca','Alcantara','2025-07-26 21:32:35',0,0,0,'2025-07-26 21:32:35','2025-07-26 21:32:35','2025-07-26 21:32:35',0),(7941066661,NULL,'Sophia','Silva','2025-08-03 01:16:08',0,0,0,'2025-08-03 01:16:08','2025-08-03 01:16:08','2025-08-03 01:16:08',0),(7969226024,NULL,'Victor','Hugoo','2025-08-06 01:52:06',0,0,0,'2025-08-06 01:52:06','2025-08-06 01:52:06','2025-08-06 01:52:06',0),(7981174086,NULL,'Daniel',NULL,'2025-08-06 01:02:26',0,0,0,'2025-08-06 01:02:26','2025-08-06 01:02:26','2025-08-06 01:02:26',0),(7981809332,NULL,'Lep','Santo','2025-07-30 01:23:36',0,0,0,'2025-07-30 01:23:36','2025-07-30 01:23:36','2025-07-30 01:23:36',0),(7988393804,NULL,'Amanda',NULL,'2025-07-26 21:35:21',0,0,0,'2025-07-26 21:35:21','2025-07-26 21:35:21','2025-07-26 21:35:21',0),(7993171386,NULL,'Gabriel',NULL,'2025-07-26 22:28:45',0,0,0,'2025-07-26 22:28:45','2025-07-26 22:28:45','2025-07-26 22:28:45',0),(7993684630,NULL,'Miguel','Oliveira','2025-08-02 02:16:11',0,0,0,'2025-08-02 02:16:11','2025-08-02 02:16:11','2025-08-02 02:16:11',0),(8000624411,'astrinffx_7','Astrinx.ff',NULL,'2025-07-26 22:40:56',0,0,0,'2025-07-26 22:40:56','2025-07-26 22:40:56','2025-07-26 22:40:56',0),(8004233990,NULL,'Laisa','Alves','2025-07-29 01:08:04',0,0,0,'2025-07-29 01:08:04','2025-07-29 01:08:04','2025-07-29 01:08:04',0),(8019242705,NULL,'Eduardo',NULL,'2025-07-28 22:59:31',0,0,0,'2025-07-28 22:59:31','2025-07-28 22:59:31','2025-07-28 22:59:31',0),(8021919351,NULL,'Marcos',NULL,'2025-08-06 02:32:50',0,0,0,'2025-08-06 02:32:50','2025-08-06 02:32:50','2025-08-06 02:32:50',0),(8024265496,NULL,'Oliveira',NULL,'2025-07-26 21:25:10',0,0,0,'2025-07-26 21:25:10','2025-07-26 21:25:10','2025-07-26 21:25:10',0),(8030729609,NULL,'Billl',NULL,'2025-07-26 21:23:21',0,0,0,'2025-07-26 21:23:21','2025-07-26 21:23:21','2025-07-26 21:23:21',0),(8032219871,NULL,'Maatheusps',NULL,'2025-08-02 22:57:20',0,0,0,'2025-08-02 22:57:20','2025-08-02 22:57:20','2025-08-02 22:57:20',0),(8033403566,NULL,'Pedro','Henrique','2025-07-26 22:02:24',0,0,0,'2025-07-26 22:02:24','2025-07-26 22:02:24','2025-07-26 22:02:24',0),(8036671810,NULL,'Gustavo','Eduardo','2025-08-04 02:35:54',0,0,0,'2025-08-04 02:35:54','2025-08-04 02:35:54','2025-08-04 02:35:54',0),(8038199169,NULL,'Surfista','Nk','2025-07-26 22:16:39',0,0,0,'2025-07-26 22:16:39','2025-07-26 22:16:39','2025-07-26 22:16:39',0),(8038626896,NULL,'Cleyton',NULL,'2025-07-29 14:18:45',0,0,0,'2025-07-29 14:18:45','2025-07-29 14:18:45','2025-07-29 14:18:45',0),(8048800762,NULL,'João Pedro','Barbosa de Lima','2025-08-03 03:40:26',0,0,0,'2025-08-03 03:40:26','2025-08-03 03:40:26','2025-08-03 03:40:26',0),(8052630011,'jknnbbj','Andre','Silva','2025-07-31 21:56:07',0,0,0,'2025-07-31 21:56:07','2025-07-31 21:56:07','2025-07-31 21:56:07',0),(8065445884,NULL,'GuinazuLL',NULL,'2025-07-26 22:00:04',0,0,0,'2025-07-26 22:00:04','2025-07-26 22:00:04','2025-07-26 22:00:04',0),(8069217206,'Joavictortrade','Joao','Victor','2025-08-05 20:42:23',0,0,0,'2025-08-05 20:42:23','2025-08-05 20:42:23','2025-08-05 20:42:23',0),(8074779821,NULL,'.',NULL,'2025-07-27 03:41:57',0,0,0,'2025-07-27 03:41:57','2025-07-27 03:41:57','2025-07-27 03:41:57',0),(8085983746,NULL,'Ramon','Santos','2025-07-27 00:48:23',0,0,0,'2025-07-27 00:48:23','2025-07-27 00:48:23','2025-07-27 00:48:23',0),(8087836351,NULL,'Arthur','Lima','2025-08-05 05:09:40',0,0,0,'2025-08-05 05:09:40','2025-08-05 05:09:40','2025-08-05 05:09:40',0),(8090567703,NULL,'Kauan33','+55 65 98146-6860','2025-08-02 21:59:32',0,0,0,'2025-08-02 21:59:32','2025-08-02 21:59:32','2025-08-02 21:59:32',0),(8100118170,NULL,'Lucas','Matos','2025-08-05 01:30:28',0,0,0,'2025-08-05 01:30:28','2025-08-05 01:30:28','2025-08-05 01:30:28',0),(8102298660,NULL,'Cleyto','Brito','2025-08-05 00:08:46',0,0,0,'2025-08-05 00:08:46','2025-08-05 00:08:46','2025-08-05 00:08:46',0),(8104509035,NULL,'Jameson Miguel',NULL,'2025-08-02 22:42:40',0,0,0,'2025-08-02 22:42:40','2025-08-02 22:42:40','2025-08-02 22:42:40',0),(8106080689,'Bittencourt_loh','Eloisy','Bittencourt','2025-08-02 08:29:58',0,0,0,'2025-08-02 08:29:58','2025-08-02 08:29:58','2025-08-02 08:29:58',0),(8108507298,NULL,'Nicolas','Rodrigues','2025-07-28 20:58:32',0,0,0,'2025-07-28 20:58:32','2025-07-28 20:58:32','2025-07-28 20:58:32',0),(8109201094,NULL,'Wilcken','Portelli','2025-07-26 21:30:12',0,0,0,'2025-07-26 21:30:12','2025-07-26 21:30:12','2025-07-26 21:30:12',0),(8109292487,NULL,'Tham',NULL,'2025-07-26 23:03:40',0,0,0,'2025-07-26 23:03:40','2025-07-26 23:03:40','2025-07-26 23:03:40',0),(8111613425,NULL,'G2k25',NULL,'2025-08-04 22:10:18',0,0,0,'2025-08-04 22:10:18','2025-08-04 22:10:18','2025-08-04 22:10:18',0),(8111861544,NULL,'Cleiton','Sartunino','2025-08-04 02:22:31',0,0,0,'2025-08-04 02:22:31','2025-08-04 02:22:31','2025-08-04 02:22:31',0),(8115684400,NULL,'alex','Gustavo Varela Sampaio','2025-07-26 21:31:37',0,0,0,'2025-07-26 21:31:37','2025-07-26 21:31:37','2025-07-26 21:31:37',0),(8118695995,NULL,'Yas',NULL,'2025-08-06 01:56:14',0,0,0,'2025-08-06 01:56:14','2025-08-06 01:56:14','2025-08-06 01:56:14',0),(8122354032,NULL,'R10','ferreira','2025-07-26 22:19:42',0,0,0,'2025-07-26 22:19:42','2025-07-26 22:19:42','2025-07-26 22:19:42',0),(8125936391,NULL,'Yago','Souza','2025-07-27 09:52:56',0,0,0,'2025-07-27 09:52:56','2025-07-27 09:52:56','2025-07-27 09:52:56',0),(8127087512,NULL,'Welio','Oliveira','2025-07-29 00:14:45',1,0,0,'2025-08-05 22:36:58','2025-07-29 00:14:45','2025-08-05 22:36:58',0),(8127215496,NULL,'Yago',NULL,'2025-08-04 15:28:13',0,0,0,'2025-08-04 15:28:13','2025-08-04 15:28:13','2025-08-04 15:28:13',0),(8127648240,NULL,'Welington','DS','2025-07-29 01:21:04',0,0,0,'2025-07-29 01:21:04','2025-07-29 01:21:04','2025-07-29 01:21:04',0),(8129474614,'cauas04','Caua','Santos','2025-08-04 04:13:37',0,0,0,'2025-08-04 04:13:37','2025-08-04 04:13:37','2025-08-04 04:13:37',0),(8135461424,NULL,'Drak','Souza','2025-08-05 02:48:14',0,0,0,'2025-08-05 02:48:14','2025-08-05 02:48:14','2025-08-05 02:48:14',0),(8139861886,NULL,'David','Mesquita','2025-07-26 23:17:51',0,0,0,'2025-07-26 23:17:51','2025-07-26 23:17:51','2025-07-26 23:17:51',0),(8140978941,NULL,'Victhor','_vv','2025-07-29 02:00:26',0,0,0,'2025-07-29 02:00:26','2025-07-29 02:00:26','2025-07-29 02:00:26',0),(8142437154,NULL,'Wirllon','Dias','2025-08-04 01:15:40',0,0,0,'2025-08-04 01:15:40','2025-08-04 01:15:40','2025-08-04 01:15:40',0),(8150745674,NULL,'GABRIEL SILVA',NULL,'2025-07-30 10:39:02',0,0,0,'2025-07-30 10:39:02','2025-07-30 10:39:02','2025-07-30 10:39:02',0),(8156874231,NULL,'Jhonne Mhayko Campanaro Amoril Oliveira','Campanaro','2025-07-26 21:08:20',0,0,0,'2025-07-26 21:08:20','2025-07-26 21:08:20','2025-07-26 21:08:20',0),(8157226837,NULL,'Richard',NULL,'2025-08-03 19:29:28',0,0,0,'2025-08-03 19:29:28','2025-08-03 19:29:28','2025-08-03 19:29:28',0),(8158185082,NULL,'Cristiano','Silva','2025-07-29 01:01:13',0,0,0,'2025-07-29 01:01:13','2025-07-29 01:01:13','2025-07-29 01:01:13',0),(8160630252,NULL,'Jonathan',NULL,'2025-07-26 23:02:03',0,0,0,'2025-07-26 23:02:03','2025-07-26 23:02:03','2025-07-26 23:02:03',0),(8166545161,NULL,'Gabriel',NULL,'2025-08-05 02:46:04',0,0,0,'2025-08-05 02:46:04','2025-08-05 02:46:04','2025-08-05 02:46:04',0),(8166832967,NULL,'Ryan','Bueno','2025-07-29 00:14:12',0,0,0,'2025-07-29 00:14:12','2025-07-29 00:14:12','2025-07-29 00:14:12',0),(8171343327,NULL,'Fábio','Cesar','2025-08-01 01:05:19',0,0,0,'2025-08-01 01:05:19','2025-08-01 01:05:19','2025-08-01 01:05:19',0),(8179703199,NULL,'Eliúde','Júnior','2025-08-03 10:59:20',1,0,0,'2025-08-04 01:50:55','2025-08-03 10:59:20','2025-08-04 01:50:55',0),(8179858722,NULL,'Lacaio','Kant','2025-07-29 00:15:01',0,0,0,'2025-07-29 00:15:01','2025-07-29 00:15:01','2025-07-29 00:15:01',0),(8187966712,NULL,'Silkelmy',NULL,'2025-07-27 20:45:30',0,0,0,'2025-07-27 20:45:30','2025-07-27 20:45:30','2025-07-27 20:45:30',0),(8195664018,NULL,'Taisson','Moraes Machado','2025-07-28 18:45:27',1,0,0,'2025-08-05 01:33:46','2025-07-28 18:45:27','2025-08-05 01:33:46',0),(8212612667,NULL,'Tallys','Fernandes','2025-08-04 14:14:04',0,0,0,'2025-08-04 14:14:04','2025-08-04 14:14:04','2025-08-04 14:14:04',0),(8224404216,NULL,'Guilherme','Neponucena','2025-07-29 02:31:23',0,0,0,'2025-07-29 02:31:23','2025-07-29 02:31:23','2025-07-29 02:31:23',0),(8295158131,NULL,'Vitor','Hugo','2025-07-27 01:52:33',0,0,0,'2025-07-27 01:52:33','2025-07-27 01:52:33','2025-07-27 01:52:33',0),(8299111241,NULL,'Murilo','Almeida','2025-08-03 03:39:06',0,0,0,'2025-08-03 03:39:06','2025-08-03 03:39:06','2025-08-03 03:39:06',0),(8330707042,NULL,'Papolo',NULL,'2025-08-06 01:42:29',0,0,0,'2025-08-06 01:42:29','2025-08-06 01:42:29','2025-08-06 01:42:29',0),(8339026161,NULL,'Taylan','Ferreira','2025-08-06 01:03:04',0,0,0,'2025-08-06 01:03:04','2025-08-06 01:03:04','2025-08-06 01:03:04',0),(8360078779,NULL,'Wendel',NULL,'2025-08-02 21:10:38',0,0,0,'2025-08-02 21:10:38','2025-08-02 21:10:38','2025-08-02 21:10:38',0),(8378242801,NULL,'Siilva','Stx','2025-08-05 02:13:02',1,0,0,'2025-08-05 02:15:12','2025-08-05 02:13:02','2025-08-05 02:15:12',0),(8432919771,NULL,'Vitão Suporte Aviator',NULL,'2025-08-04 01:28:06',0,0,0,'2025-08-04 01:28:06','2025-08-04 01:28:06','2025-08-04 01:28:06',0),(8456416396,NULL,'Matheus',NULL,'2025-08-04 16:44:11',0,0,0,'2025-08-04 16:44:11','2025-08-04 16:44:11','2025-08-04 16:44:11',0),(8459843162,NULL,'Luiz','Henrique','2025-08-05 18:15:47',0,0,0,'2025-08-05 18:15:47','2025-08-05 18:15:47','2025-08-05 18:15:47',0),(8465633608,NULL,'Ruan','Silva','2025-07-26 21:57:19',0,0,0,'2025-07-26 21:57:19','2025-07-26 21:57:19','2025-07-26 21:57:19',0),(8497387783,'Siilvastx','Siilvastx',NULL,'2025-08-04 14:45:00',0,0,0,'2025-08-04 14:45:00','2025-08-04 14:45:00','2025-08-04 14:45:00',0);
/*!40000 ALTER TABLE `users` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `vip_groups`
--

DROP TABLE IF EXISTS `vip_groups`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `vip_groups` (
  `id` int NOT NULL AUTO_INCREMENT COMMENT 'ID interno',
  `group_id` bigint NOT NULL COMMENT 'ID do grupo no Telegram',
  `group_name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'Nome do grupo',
  `group_link` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'Link de convite',
  `is_active` tinyint(1) DEFAULT '1' COMMENT 'Se o grupo está ativo',
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP COMMENT 'Data de criação',
  `updated_at` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT 'Data de atualização',
  PRIMARY KEY (`id`),
  KEY `idx_is_active` (`is_active`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Grupos VIP vinculados ao bot';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `vip_groups`
--

LOCK TABLES `vip_groups` WRITE;
/*!40000 ALTER TABLE `vip_groups` DISABLE KEYS */;
INSERT INTO `vip_groups` VALUES (1,-1002691949711,'Grupo VIP Trading',NULL,1,'2025-08-06 01:07:11','2025-08-06 01:07:11'),(2,-1868519352,'Pacote Promocional',NULL,1,'2025-09-03 20:44:54','2025-09-03 20:44:54');
/*!40000 ALTER TABLE `vip_groups` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `vip_invites`
--

DROP TABLE IF EXISTS `vip_invites`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `vip_invites` (
  `id` int NOT NULL AUTO_INCREMENT,
  `user_id` bigint NOT NULL,
  `username` varchar(255) DEFAULT NULL,
  `invite_link` varchar(512) NOT NULL,
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP,
  `expires_at` datetime DEFAULT NULL,
  `used` tinyint(1) DEFAULT '0',
  `joined_user_id` bigint DEFAULT NULL,
  `joined_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `vip_invites`
--

LOCK TABLES `vip_invites` WRITE;
/*!40000 ALTER TABLE `vip_invites` DISABLE KEYS */;
/*!40000 ALTER TABLE `vip_invites` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `vip_plans`
--

DROP TABLE IF EXISTS `vip_plans`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `vip_plans` (
  `id` int NOT NULL AUTO_INCREMENT COMMENT 'ID do plano',
  `name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'Nome do plano',
  `price` decimal(10,2) NOT NULL COMMENT 'Preço em BRL',
  `duration_days` int NOT NULL COMMENT 'Duração em dias (-1 para permanente)',
  `description` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci COMMENT 'Descrição do plano',
  `is_active` tinyint(1) DEFAULT '1' COMMENT 'Se o plano está ativo',
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP COMMENT 'Data de criação',
  `updated_at` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT 'Data de atualização',
  PRIMARY KEY (`id`),
  KEY `idx_is_active` (`is_active`),
  KEY `idx_price` (`price`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Planos de assinatura VIP disponíveis';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `vip_plans`
--

LOCK TABLES `vip_plans` WRITE;
/*!40000 ALTER TABLE `vip_plans` DISABLE KEYS */;
INSERT INTO `vip_plans` VALUES (1,'Mensal',1.00,30,'Acesso ao grupo VIP por 30 dias',1,'2025-08-06 01:07:11','2025-09-04 01:01:19'),(2,'Trimestral',999.00,90,'Acesso ao grupo VIP por 90 dias',1,'2025-08-06 01:07:11','2025-09-03 18:45:13'),(3,'Anual',2999.00,365,'Acesso ao grupo VIP por 365 dias',1,'2025-08-06 01:07:11','2025-09-03 18:46:12');
/*!40000 ALTER TABLE `vip_plans` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Final view structure for view `active_vip_users`
--

/*!50001 DROP VIEW IF EXISTS `active_vip_users`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_unicode_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`%` SQL SECURITY DEFINER */
/*!50001 VIEW `active_vip_users` AS select `u`.`id` AS `id`,`u`.`username` AS `username`,`u`.`first_name` AS `first_name`,`u`.`last_name` AS `last_name`,`u`.`joined_date` AS `joined_date`,`s`.`plan_id` AS `plan_id`,`vp`.`name` AS `plan_name`,`s`.`end_date` AS `end_date`,`s`.`is_permanent` AS `is_permanent` from ((`users` `u` join `subscriptions` `s` on((`u`.`id` = `s`.`user_id`))) join `vip_plans` `vp` on((`s`.`plan_id` = `vp`.`id`))) where ((`s`.`is_active` = 1) and ((`s`.`is_permanent` = 1) or (`s`.`end_date` > now()))) */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `expiring_subscriptions`
--

/*!50001 DROP VIEW IF EXISTS `expiring_subscriptions`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_unicode_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`%` SQL SECURITY DEFINER */
/*!50001 VIEW `expiring_subscriptions` AS select `u`.`id` AS `user_id`,`u`.`username` AS `username`,`u`.`first_name` AS `first_name`,`u`.`last_name` AS `last_name`,`s`.`plan_id` AS `plan_id`,`vp`.`name` AS `plan_name`,`s`.`end_date` AS `end_date`,(to_days(`s`.`end_date`) - to_days(now())) AS `days_until_expiry` from ((`users` `u` join `subscriptions` `s` on((`u`.`id` = `s`.`user_id`))) join `vip_plans` `vp` on((`s`.`plan_id` = `vp`.`id`))) where ((`s`.`is_active` = 1) and (`s`.`is_permanent` = 0) and (`s`.`end_date` > now()) and (`s`.`end_date` <= (now() + interval 7 day))) */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `sales_report`
--

/*!50001 DROP VIEW IF EXISTS `sales_report`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_unicode_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`%` SQL SECURITY DEFINER */
/*!50001 VIEW `sales_report` AS select cast(`p`.`created_at` as date) AS `sale_date`,count(0) AS `total_sales`,sum((case when (`p`.`status` = 'approved') then 1 else 0 end)) AS `successful_sales`,sum((case when (`p`.`status` = 'approved') then `p`.`amount` else 0 end)) AS `total_revenue`,`vp`.`name` AS `plan_name`,`p`.`payment_method` AS `payment_method` from (`payments` `p` join `vip_plans` `vp` on((`p`.`plan_id` = `vp`.`id`))) group by cast(`p`.`created_at` as date),`vp`.`name`,`p`.`payment_method` order by cast(`p`.`created_at` as date) desc,`vp`.`name` */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Tabela para mensagens agendadas
CREATE TABLE `scheduled_messages` (
  `id` int NOT NULL AUTO_INCREMENT,
  `message_text` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'Texto da mensagem agendada',
  `scheduled_date` datetime NOT NULL COMMENT 'Data e hora para envio da mensagem',
  `target_type` enum('all_users','vip_users','specific_users') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'all_users' COMMENT 'Tipo de destinatários',
  `target_users` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci COMMENT 'IDs dos usuários específicos (JSON)',
  `status` enum('pending','sent','cancelled','failed') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'pending' COMMENT 'Status da mensagem',
  `created_by` bigint NOT NULL COMMENT 'ID do admin que criou a mensagem',
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP COMMENT 'Data de criação',
  `sent_at` datetime DEFAULT NULL COMMENT 'Data de envio',
  `error_message` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci COMMENT 'Mensagem de erro se falhou',
  `total_recipients` int DEFAULT 0 COMMENT 'Total de destinatários',
  `successful_sends` int DEFAULT 0 COMMENT 'Envios bem-sucedidos',
  `failed_sends` int DEFAULT 0 COMMENT 'Envios falhados',
  PRIMARY KEY (`id`),
  KEY `idx_scheduled_date` (`scheduled_date`),
  KEY `idx_status` (`status`),
  KEY `idx_created_by` (`created_by`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Mensagens agendadas para envio';

-- Tabela para pagamentos VIP de administradores
CREATE TABLE `admin_vip_payments` (
  `id` int NOT NULL AUTO_INCREMENT,
  `admin_id` bigint NOT NULL COMMENT 'ID do admin no Telegram',
  `amount` decimal(10,2) NOT NULL COMMENT 'Valor do pagamento',
  `description` varchar(255) NOT NULL COMMENT 'Descrição do pagamento',
  `external_reference` varchar(255) NOT NULL COMMENT 'Referência externa do pagamento',
  `pix_code` text COMMENT 'Código PIX gerado',
  `status` enum('pending','approved','rejected','expired') NOT NULL DEFAULT 'pending' COMMENT 'Status do pagamento',
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP COMMENT 'Data de criação',
  `approved_at` datetime DEFAULT NULL COMMENT 'Data de aprovação',
  `expires_at` datetime DEFAULT NULL COMMENT 'Data de expiração',
  PRIMARY KEY (`id`),
  KEY `idx_admin_id` (`admin_id`),
  KEY `idx_status` (`status`),
  KEY `idx_external_reference` (`external_reference`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Pagamentos VIP de administradores';

-- Dump completed on 2025-09-15 20:31:23
