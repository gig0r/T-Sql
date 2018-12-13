CREATE TABLE [dbo].[Sale] (
    [Id]          INT           IDENTITY (1, 1) NOT NULL,
    [WarehouseId] NVARCHAR (50) NOT NULL,
    [Status]      CHAR (11)     NOT NULL,
    [Date_Time]   DATETIME      DEFAULT (CONVERT([datetime],sysdatetime(),(102))) NOT NULL,
    [EmplooeId]   INT           NOT NULL,
    CONSTRAINT [PK_Sale_Id] PRIMARY KEY CLUSTERED ([Id] ASC),
    CONSTRAINT [FK_Sale_ToEmploee] FOREIGN KEY ([EmplooeId]) REFERENCES [dbo].[Emplooe] ([Id]) ON DELETE CASCADE ON UPDATE CASCADE
);

