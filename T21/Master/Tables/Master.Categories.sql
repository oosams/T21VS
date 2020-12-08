CREATE TABLE [Master].[Categories] (
    [CategoryID]   INT                   NOT NULL,
    [CategoryName] NVARCHAR (50)         NOT NULL,
    [Description]  [dbo].[nvarchar(max)] NOT NULL,
    CONSTRAINT [PK_CATEGORIES] PRIMARY KEY CLUSTERED ([CategoryID] ASC)
);

