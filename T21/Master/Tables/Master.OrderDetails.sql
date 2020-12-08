CREATE TABLE [Master].[OrderDetails] (
    [OrderID]   INT        NOT NULL,
    [ProductID] INT        NOT NULL,
    [UnitPrice] MONEY      NOT NULL,
    [Quantity]  INT        NOT NULL,
    [Discount]  FLOAT (53) NULL,
    CONSTRAINT [PK_ORDERDETAILS] PRIMARY KEY NONCLUSTERED ([OrderID] ASC, [ProductID] ASC),
    CONSTRAINT [FK_ORDERS_ORDERDETAILS] FOREIGN KEY ([OrderID]) REFERENCES [Master].[Orders] ([OrderID]),
    CONSTRAINT [FK_PRODUCTS_ORDERDETAILS] FOREIGN KEY ([ProductID]) REFERENCES [Master].[Products] ([ProductID])
);


GO
CREATE NONCLUSTERED INDEX [Order_OrderDetail_FK]
    ON [Master].[OrderDetails]([OrderID] ASC);


GO
CREATE NONCLUSTERED INDEX [Product_OrderDetail_FK]
    ON [Master].[OrderDetails]([ProductID] ASC);

