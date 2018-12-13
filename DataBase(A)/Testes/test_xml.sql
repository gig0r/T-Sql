INSERT INTO [Warehouse] ([Name], [Price], [Count], [Description])
VALUES ('Product9', 185.12, 5, 'Description my product')

DECLARE @x XML = (SELECT * FROM Warehouse FOR XML AUTO, ELEMENTS);
DECLARE @conversation_handle UNIQUEIDENTIFIER;
BEGIN DIALOG CONVERSATION @conversation_handle
FROM SERVICE [A_Service_Xml_Out] TO SERVICE 'B_Service_Xml_In'
ON CONTRACT [xml_contract]
WITH ENCRYPTION = ON; 

SEND ON CONVERSATION @conversation_handle MESSAGE TYPE [xml_msg] (@x);
GO
WAITFOR DELAY '00:00:05.000'; --задержка сделана специально, потому что если сразу запросить статусы в sys.conversation_endpoints может сложиться мнимое ошущение что ошибка в чем то другом потому что диалог будет в статусе CONVERSING
EXEC [dbo].[service_broker_get];

EXEC [dbo].[service_broker_clear]

SELECT TRY_CONVERT(XML, [message_body]), * FROM [dbo].[Xml_Out_Queue] WITH(NOLOCK);

select * from sys.conversation_endpoints;