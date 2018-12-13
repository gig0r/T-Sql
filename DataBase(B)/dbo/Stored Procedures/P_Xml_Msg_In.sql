CREATE PROCEDURE [dbo].[P_Xml_Msg_In]
AS
DECLARE @h UNIQUEIDENTIFIER, @message_type_name SYSNAME, @body XML, @msg XML;
WHILE 1=1 BEGIN
     BEGIN TRANSACTION;
     WAITFOR (
	        RECEIVE TOP(1) @h = [conversation_handle],
			               @message_type_name = [message_type_name],
						   @body = CONVERT(XML, [message_body])
            FROM [dbo].[Xml_In_Queue]
	 ), TIMEOUT 1000
	 IF @@ROWCOUNT <= 0 BEGIN
	     ROLLBACK TRANSACTION;
		 BREAK;
	 END;
	 IF (@message_type_name NOT IN ('http://schemas.microsoft.com/SQL/ServiceBroker/Error', 'http://schemas.microsoft.com/SQL/ServiceBroker/EndDialog', 'http://schemas.microsoft.com/SQL/ServiceBroker/DialogTimer')
	 AND @message_type_name = 'xml_msg')
	 BEGIN

	 	INSERT INTO [Product] ([Name],[Price],[Description])
		SELECT
		@body.value('(/Warehouse/Name)[1]', 'NVARCHAR(50)'),
		@body.value('(/Warehouse/Price)[1]', 'MONEY'),
		@body.value('(/Warehouse/Description)[1]', 'NVARCHAR(MAX)')

	    SET @msg = CONVERT(XML, '<Insert><Result>Success</Result><Message>'+CONVERT(VARCHAR(MAX),@body)+'</Message></Insert>');
	    SEND ON CONVERSATION @h MESSAGE TYPE [xml_msg] (@msg);
	 END;
	 END CONVERSATION @h;
	 COMMIT TRANSACTION;
END;