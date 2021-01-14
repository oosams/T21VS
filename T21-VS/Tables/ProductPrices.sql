CREATE TABLE [Shop].[ProductPrices] (
    [ProductPriceID] INT   IDENTITY (1, 1) NOT NULL,
    [ProductID]      INT   NOT NULL,
    [UnitPrice]      MONEY NOT NULL,
    [StartVersion]   INT   NOT NULL,
    [EndVersion]     INT   DEFAULT ((999999999)) NOT NULL,
    CONSTRAINT [PK_PRODUCTPRICES] PRIMARY KEY CLUSTERED ([ProductPriceID] ASC),
    CONSTRAINT [FK_PRODUCTS_PRODUCTPRICES] FOREIGN KEY ([ProductID]) REFERENCES [Shop].[Products] ([ProductID])
);


GO
CREATE NONCLUSTERED INDEX [Product_ProductPrice_FK]
    ON [Shop].[ProductPrices]([ProductID] ASC);


GO
CREATE NONCLUSTERED INDEX [ProductPrice_VersionStart_FK]
    ON [Shop].[ProductPrices]([StartVersion] ASC);


GO
CREATE NONCLUSTERED INDEX [ProductPrice_VersionEnd_FK]
    ON [Shop].[ProductPrices]([EndVersion] ASC);

