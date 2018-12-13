CREATE TABLE [dbo].[User] (
    [Id]       INT           IDENTITY (1, 1) NOT NULL,
    [Login]    NCHAR (10)    NOT NULL,
    [Password] BIT           NOT NULL,
    [Salt]     BIT           NOT NULL,
    [Name]     NVARCHAR (50) NOT NULL,
    [LastName] NVARCHAR (50) NOT NULL,
    [SurName]  NVARCHAR (50) NOT NULL,
    [Email]    NVARCHAR (1)  NOT NULL,
    [Adress]   NVARCHAR (1)  NOT NULL,
    [Phone]    NVARCHAR (1)  NULL,
    CONSTRAINT [PK_User_Id] PRIMARY KEY CLUSTERED ([Id] ASC)
);

