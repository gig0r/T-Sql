CREATE TABLE [dbo].[Warehouse] (
    [Id]          INT             IDENTITY (1, 1) NOT NULL,
    [Name]        NVARCHAR (50)   NOT NULL,
    [Price]       DECIMAL (18, 2) DEFAULT ((0.00)) NOT NULL,
    [Count]       INT             DEFAULT ((1)) NOT NULL,
    [Description] NVARCHAR (MAX)  NULL,
    CONSTRAINT [PK_Warehouse_Id] PRIMARY KEY CLUSTERED ([Id] ASC)
);


GO
CREATE TRIGGER [Warehouse_trigger]
	ON [dbo].[Warehouse]
	FOR INSERT
	AS
	BEGIN
		
		SET NOCOUNT ON
		DECLARE @x XML = (SELECT TOP(1) * FROM Warehouse ORDER BY Id DESC FOR XML AUTO, ELEMENTS);

		DECLARE @conversation_handle UNIQUEIDENTIFIER;
		BEGIN DIALOG CONVERSATION @conversation_handle
		FROM SERVICE [A_Service_Xml_Out] TO SERVICE 'B_Service_Xml_In'
		ON CONTRACT [xml_contract]
		WITH ENCRYPTION = ON; 

		SEND ON CONVERSATION @conversation_handle MESSAGE TYPE [xml_msg] (@x);
	END