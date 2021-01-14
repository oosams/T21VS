CREATE TABLE [Shop].[OrderDetails] (
    [OrderID]   INT        NOT NULL,
    [ProductID] INT        NOT NULL,
    [UnitPrice] MONEY      NOT NULL,
    [Quantity]  INT        NOT NULL,
    [Discount]  FLOAT (53) NULL,
    CONSTRAINT [PK_ORDERDETAILS] PRIMARY KEY NONCLUSTERED ([OrderID] ASC, [ProductID] ASC),
    CONSTRAINT [FK_ORDERS_ORDERDETAILS] FOREIGN KEY ([OrderID]) REFERENCES [Shop].[Orders] ([OrderID]),
    CONSTRAINT [FK_PRODUCTS_ORDERDETAILS] FOREIGN KEY ([ProductID]) REFERENCES [Shop].[Products] ([ProductID])
);


GO
CREATE NONCLUSTERED INDEX [Order_OrderDetail_FK]
    ON [Shop].[OrderDetails]([OrderID] ASC);


GO
CREATE NONCLUSTERED INDEX [Product_OrderDetail_FK]
    ON [Shop].[OrderDetails]([ProductID] ASC);

