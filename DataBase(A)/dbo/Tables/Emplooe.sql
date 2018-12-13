CREATE TABLE [dbo].[Emplooe] (
    [Id]       INT           IDENTITY (1, 1) NOT NULL,
    [Login]    NCHAR (10)    NOT NULL,
    [Password] BIT           NOT NULL,
    [Name]     NVARCHAR (50) NOT NULL,
    CONSTRAINT [PK_Emplooe_Id] PRIMARY KEY CLUSTERED ([Id] ASC)
);

