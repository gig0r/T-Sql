CREATE TABLE [dbo].[Product] (
    [Id]          INT            IDENTITY (1, 1) NOT NULL,
    [Name]        NVARCHAR (50)  NOT NULL,
    [Price]       MONEY          DEFAULT ((0.00)) NOT NULL,
    [Description] NVARCHAR (MAX) NULL,
    [Image]       IMAGE          NULL,
    CONSTRAINT [PK_Product_Id] PRIMARY KEY CLUSTERED ([Id] ASC)
);

