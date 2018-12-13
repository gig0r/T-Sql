/*Service master key*/
SELECT * FROM sys.symmetric_keys
SELECT [name], [is_master_key_encrypted_by_server] FROM sys.databases

USE [master]
IF NOT EXISTS (SELECT 1 FROM sys.symmetric_keys WHERE [name] = '##MS_DataBaseMasterKey##')
CREATE MASTER KEY ENCRYPTION BY PASSWORD = 'P@ssw0rd';

IF NOT EXISTS (SELECT 1 FROM sys.databases WHERE [is_master_key_encrypted_by_server] = 1)
ALTER MASTER KEY ADD ENCRYPTION BY SERVICE MASTER KEY;

/*Certificates*/
SELECT * FROM sys.certificates

USE [master]

IF NOT EXISTS (SELECT 1 FROM sys.certificates WHERE [name] = 'a_cert')
CREATE CERTIFICATE [a_cert]
	WITH SUBJECT = 'certificate_database_A'

/*backup certificate database A*/
USE [master]
GO
BACKUP CERTIFICATE [a_cert]
TO FILE = 'C:\cert\a_cert.cer';

/*endpoint enabled*/
SELECT * FROM sys.service_broker_endpoints;

USE [master]

CREATE ENDPOINT [a_endpoint]
STATE=STARTED
	AS TCP
	(
		LISTENER_PORT = 4022
	)
	FOR SERVICE_BROKER
	(
		AUTHENTICATION = CERTIFICATE [a_cert],
		ENCRYPTION = REQUIRED ALGORITHM AES
	)

/*enable service broker*/
IF NOT EXISTS (SELECT 1 FROM sys.databases
WHERE [name] = 'DataBase(B)'
AND [is_broker_enabled] = 1)
BEGIN
	PRINT N'Enable broker Database...';
END
GO
ALTER DATABASE [DataBase(B)] SET ENABLE_BROKER;
GO

/* create user to grant endpoint*/
CREATE LOGIN [b_user] WITH PASSWORD = 'P@ssw0rd';
CREATE USER [b_user];
CREATE CERTIFICATE [b_cert] AUTHORIZATION [b_user] FROM FILE = 'C:\cert\b_cert.cer';

/*grant endpoint to user*/
USE [master]
GO
GRANT CONNECT ON ENDPOINT::a_endpoint TO [b_user];

/* пользователя и его сертификат для дальнейшей настройки безопасности диалога*/
CREATE USER [a_service_owner] WITHOUT LOGIN;

ALTER AUTHORIZATION ON SERVICE::[a_service_outbound] TO [a_service_owner];
ALTER AUTHORIZATION ON SERVICE::[a_service_inbound] TO [a_service_owner];


IF NOT EXISTS (SELECT 1 FROM sys.certificates WHERe [name] = 'a_service_owner_cert')
CREATE CERTIFICATE [a_service_owner_cert] AUTHORIZATION [a_service_owner] WITH SUBJECT = 'Certificate for A service owner dialog security'

BACKUP CERTIFICATE [a_service_owner_cert] TO FILE = 'C:\cert\a_service_owner_cert.cer';

/*пользователя для аутентификации службы*/
IF NOT EXISTS (SELECT 1 FROM sys.database_principals WHERE [name] = 'b_service_owner') CREATE USER [b_service_owner] WITHOUT LOGIN;
IF NOT EXISTS (SELECT 1 FROM sys.certificates WHERE [name] = 'b_service_owner_cert') CREATE CERTIFICATE [b_service_owner_cert] AUTHORIZATION [b_service_owner] FROM FILE = 'C:\cert\b_service_owner_cert.cer';
GRANT SEND ON SERVICE::[a_service_outbound] TO [b_service_owner];
GRANT SEND ON SERVICE::[a_service_inbound] TO [b_service_owner];


/*привязку удаленной службы*/
CREATE REMOTE SERVICE BINDING [To_B]
AUTHORIZATION [dbo]
TO SERVICE 'b_service_inbound'
WITH USER = [b_service_owner]; --ANONYMOUS = ON