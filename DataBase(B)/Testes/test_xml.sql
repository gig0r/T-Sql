
EXEC [dbo].[service_broker_get];

EXEC [dbo].[service_broker_clear]

SELECT TRY_CONVERT(XML, [message_body]), * FROM [dbo].[Xml_Out_Queue] WITH(NOLOCK);
