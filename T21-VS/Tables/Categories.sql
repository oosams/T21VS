CREATE TABLE [Shop].[Categories] (
    [CategoryID]   INT            IDENTITY (1, 1) NOT NULL,
    [CategoryName] NVARCHAR (255) NOT NULL,
    [Description]  NVARCHAR (MAX) NOT NULL,
    CONSTRAINT [PK_CATEGORIES] PRIMARY KEY CLUSTERED ([CategoryID] ASC)
);

