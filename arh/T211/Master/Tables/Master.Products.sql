CREATE TABLE [Master].[Products] (
    [ProductID]   INT                   NOT NULL,
    [CategoryID]  INT                   NOT NULL,
    [ProductName] NVARCHAR (50)         NOT NULL,
    [IsActive]    TINYINT               NOT NULL,
    [Description] [dbo].[nvarchar(max)] NOT NULL,
    CONSTRAINT [PK_PRODUCTS] PRIMARY KEY NONCLUSTERED ([ProductID] ASC),
    CONSTRAINT [FK_CATEGORIES_PRODUCTS] FOREIGN KEY ([CategoryID]) REFERENCES [Master].[Categories] ([CategoryID])
);


GO
CREATE NONCLUSTERED INDEX [Category_Product_FK]
    ON [Master].[Products]([CategoryID] ASC);

