CREATE TABLE [Shop].[Products] (
    [ProductID]   INT            IDENTITY (1, 1) NOT NULL,
    [CategoryID]  INT            NOT NULL,
    [ProductName] NVARCHAR (255) NOT NULL,
    [Quantity]    INT            NOT NULL,
    [IsActive]    TINYINT        NOT NULL,
    [Description] NVARCHAR (MAX) NOT NULL,
    CONSTRAINT [PK_PRODUCTS] PRIMARY KEY CLUSTERED ([ProductID] ASC),
    CONSTRAINT [FK_CATEGORIES_PRODUCTS] FOREIGN KEY ([CategoryID]) REFERENCES [Shop].[Categories] ([CategoryID])
);


GO
CREATE NONCLUSTERED INDEX [Category_Product_FK]
    ON [Shop].[Products]([CategoryID] ASC);

