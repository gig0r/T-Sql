CREATE TABLE [dbo].[Order] (
    [Id]        BIGINT     IDENTITY (1, 1) NOT NULL,
    [ProductId] INT        NOT NULL,
    [UserId]    INT        NOT NULL,
    [Status]    NCHAR (10) NOT NULL,
    [Date_Time] DATETIME   DEFAULT (CONVERT([datetime],sysdatetime(),(102))) NOT NULL,
    [Count]     INT        DEFAULT ((1)) NOT NULL,
    CONSTRAINT [PK_Order_Id] PRIMARY KEY CLUSTERED ([Id] ASC)
);

