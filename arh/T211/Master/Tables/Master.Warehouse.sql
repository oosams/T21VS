CREATE TABLE [Master].[Warehouse] (
    [WarehouseID]  INT                   NOT NULL,
    [ProductID]    INT                   NOT NULL,
    [StartVersion] INT                   NOT NULL,
    [EndVersion]   INT                   NOT NULL,
    [UnitPrice]    MONEY                 NOT NULL,
    [Quantity]     INT                   NOT NULL,
    [Description]  [dbo].[nvarchar(max)] NOT NULL,
    CONSTRAINT [PK_WAREHOUSE] PRIMARY KEY NONCLUSTERED ([WarehouseID] ASC),
    CONSTRAINT [FK_PRODUCTS_WAREHOUSE] FOREIGN KEY ([ProductID]) REFERENCES [Master].[Products] ([ProductID]),
    CONSTRAINT [FK_VERSIONS_WAREHOUSE_End] FOREIGN KEY ([EndVersion]) REFERENCES [Master].[Versions] ([VersionID]),
    CONSTRAINT [FK_VERSIONS_WAREHOUSE_Start] FOREIGN KEY ([StartVersion]) REFERENCES [Master].[Versions] ([VersionID])
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

