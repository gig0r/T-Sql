CREATE PROCEDURE [dbo].[service_broker_clear]
AS
DECLARE @sql NVARCHAR(MAX) = N''
SELECT @sql = @sql + REPLACE('END CONVERSATION "' + CONVERT(NVARCHAR(36), [conversation_handle]) + '" WITH CLEANUP', NCHAR(34), NCHAR(39)) + NCHAR(59) + NCHAR(13) + NCHAR(10) FROM sys.conversation_endpoints WHERE [state] <> 'CD';
PRINT @sql;
EXEC (@sql);