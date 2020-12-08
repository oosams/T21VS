CREATE TABLE [Master].[Warehouse] (
    [WarehouseID]  INT                   NOT NULL,
    [ProductID]    INT                   NOT NULL,
    [UnitPrice]    MONEY                 NOT NULL,
    [Quantity]     INT                   NOT NULL,
    [Description]  [dbo].[nvarchar(max)] NOT NULL,
    [StartVersion] INT                   NOT NULL,
    [EndVersion]   INT                   DEFAULT ((999999999)) NOT NULL,
    CONSTRAINT [PK_WAREHOUSE] PRIMARY KEY CLUSTERED ([WarehouseID] ASC),
    CONSTRAINT [FK_PRODUCTS_WAREHOUSE] FOREIGN KEY ([ProductID]) REFERENCES [Master].[Products] ([ProductID])
);


GO
CREATE NONCLUSTERED INDEX [Product_Warehouse_FK]
    ON [Master].[Warehouse]([ProductID] ASC);


GO
CREATE NONCLUSTERED INDEX [Version_WarehouseStart_FK]
    ON [Master].[Warehouse]([StartVersion] ASC);


GO
CREATE NONCLUSTERED INDEX [Version_WarehouseEnd_FK]
    ON [Master].[Warehouse]([EndVersion] ASC);

