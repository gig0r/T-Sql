SELECT TRY_CONVERT(XML, [message_body]), * FROM [dbo].[Inbound] WITH(NOLOCK);
DECLARE @h UNIQUEIDENTIFIER, @message_type_name SYSNAME, @msg VARCHAR(MAX);
WHILE 1=1 BEGIN
     BEGIN TRANSACTION;
     WAITFOR (
	        RECEIVE TOP(1) @h = [conversation_handle],
			               @message_type_name = [message_type_name]
            FROM [dbo].[Inbound]
	 ), TIMEOUT 1000
	 IF @@ROWCOUNT <= 0 BEGIN
	     ROLLBACK TRANSACTION;
		 BREAK;
	 END;
	 IF @message_type_name NOT IN ('http://schemas.microsoft.com/SQL/ServiceBroker/Error', 'http://schemas.microsoft.com/SQL/ServiceBroker/EndDialog', 'http://schemas.microsoft.com/SQL/ServiceBroker/DialogTimer') BEGIN
	     SET @msg = 'answer on conversation ' + CONVERT(VARCHAR(36), @h);
	     SEND ON CONVERSATION @h MESSAGE TYPE [test_msg] (@msg);
	 END;
	 END CONVERSATION @h;
	 COMMIT TRANSACTION;
END;
GO
EXEC [dbo].[service_broker_get];
EXEC [dbo].[service_broker_clear]


SELECT TRY_CONVERT(XML, [message_body]), * FROM [dbo].[Inbound] WITH(NOLOCK);

