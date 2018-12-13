IF (DB_ID(N'DataBase(A)') IS NULL)
BEGIN
	PRINT N'Creating Database...';
END
GO
IF (DB_ID(N'DataBase(A)') IS NULL)
BEGIN
	CREATE DATABASE [DataBase(A)];
END

/* Параметры быз дынных*/
SELECT @@VERSION;
SELECT
[name],
[database_id],
[is_broker_enabled],
[service_broker_guid],
[is_master_key_encrypted_by_server],
[is_honor_broker_priority_on],
[is_trustworthy_on],
[is_db_chaining_on],
[compatibility_level],
[user_access_desc],
[state_desc]
from sys.databases

/*Service master key*/
SELECT * FROM sys.symmetric_keys
CREATE MASTER KEY ENCRYPTION BY PASSWORD = 'P@ssw0rd';
ALTER MASTER KEY ADD ENCRYPTION BY SERVICE MASTER KEY;

/*Certificates*/
USE [master]
GO
SELECT * FROM sys.certificates
--DROP CERTIFICATE [cert_a]
CREATE CERTIFICATE [a_service_owner_cert]
	AUTHORIZATION [a_service_owner]
	WITH SUBJECT = 'Certificate for A service owner dialog security'

/*backup certificate database A*/
USE [master]
GO
BACKUP CERTIFICATE [cert_a]
TO FILE = 'C:\cert\cert_a.cer';

USE[DataBase(A)]
GO
BACKUP CERTIFICATE [a_service_owner_cert]
TO FILE = 'C:\cert\a_service_owner_cert.cer'

/*endpoint enabled*/
SELECT * FROM sys.service_broker_endpoints;

/*enable service broker*/
IF NOT EXISTS (SELECT 1 FROM sys.databases
WHERE [name] = 'DataBase(A)'
AND [is_broker_enabled] = 1)
BEGIN
	PRINT N'Enable broker Database...';
END
GO
ALTER DATABASE [DataBase(A)] SET ENABLE_BROKER;
GO

/*test service broker*/
EXEC [dbo].[service_broker_get]
EXEC [dbo].[service_broker_clear]

/*Guid Service Briker*/
SELECT [service_broker_guid] FROM sys.databases WHERE database_id = DB_ID();


/*grant endpoint to user*/
USE [master]
GO
GRANT CONNECT ON ENDPOINT::Endpoint_A TO [b_user];

/*reconfig security server (xp_cmdshell enable)*/
USE [DataBase(A)];
GO
DECLARE @config TABLE ([name] sysname, [mininum] int, [maximum] int, [config_value] int, run_value int);
INSERT INTO @config
EXEC sp_configure;
IF NOT EXISTS (SELECT 1 FROM @config WHERE [name] = 'xp_cmdshell' AND [run_value] = 1)
EXEC (N'sp_configure "xp_cmdshell", 1; RECONFIGURE;');

/*service authorization to user owner*/
ALTER AUTHORIZATION ON SERVICE::[a_service_inbound] TO [a_service_owner];
ALTER AUTHORIZATION ON SERVICE::[a_service_outbound] TO [a_service_owner];

IF NOT EXISTS (SELECT 1 FROM sys.database_principals
WHERE [name] = 'a_service_owner')
CREATE USER [a_service_owner]
WITHOUT LOGIN;
IF NOT EXISTS (SELECT 1 FROM sys.certificates
WHERE [name] = 'a_service_owner_cert')
CREATE CERTIFICATE [a_service_owner_cert]
AUTHORIZATION [a_service_owner]
FROM FILE = 'C:\cert\a_service_owner_cert.cer';
GRANT SEND ON SERVICE::[a_service_outbound] TO [b_service_owner];

CREATE REMOTE SERVICE BINDING [To_B]
AUTHORIZATION [dbo]
TO SERVICE 'b_service_inbound'
WITH USER = [b_service_owner]; --ANONYMOUS = ON

/**/
DECLARE @conversation_handle UNIQUEIDENTIFIER;
BEGIN DIALOG CONVERSATION @conversation_handle
FROM SERVICE [a_service_outbound] TO SERVICE 'b_service_inbound'
ON CONTRACT [test_contract]
WITH ENCRYPTION = ON; 

SEND ON CONVERSATION @conversation_handle MESSAGE TYPE [test_msg] ('test message without message security');
GO
WAITFOR DELAY '00:00:05.000'; --задержка сделана специально, потому что если сразу запросить статусы в sys.conversation_endpoints может сложиться мнимое ошущение что ошибка в чем то другом потому что диалог будет в статусе CONVERSING
EXEC [dbo].[service_broker_get];

SELECT TRY_CONVERT(XML, [message_body]), * FROM [dbo].[Outbound] WITH(NOLOCK);

/**/
SELECT * FROM sys.database_principals;
SELECT * FROM sys.server_permissions;

/**/
SELECT [state_desc], [far_broker_instance] FROM sys.conversation_endpoints;
SELECT * FROM sys.dm_broker_connections;
SELECT [transmission_status] FROM sys.transmission_queue;
SELECT * FROM sys.service_queues;
SELECT * FROM sys.services;
SELECT * FROM sys.routes;

