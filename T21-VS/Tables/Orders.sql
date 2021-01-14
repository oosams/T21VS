CREATE TABLE [Shop].[Orders] (
    [OrderID]       INT      IDENTITY (1, 1) NOT NULL,
    [AddressID]     INT      NOT NULL,
    [CustomerID]    INT      NOT NULL,
    [EmployeeID]    INT      NOT NULL,
    [OrderStatusID] INT      NOT NULL,
    [OrderDate]     DATETIME NOT NULL,
    [RequiredDate]  DATETIME NULL,
    [ShipDate]      DATETIME NULL,
    CONSTRAINT [PK_ORDERS] PRIMARY KEY CLUSTERED ([OrderID] ASC),
    CONSTRAINT [FK_ADDRESSES_ORDERS] FOREIGN KEY ([AddressID]) REFERENCES [Shop].[Addresses] ([AddressID]),
    CONSTRAINT [FK_CUSTOMERS_ORDERS] FOREIGN KEY ([CustomerID]) REFERENCES [Shop].[Customers] ([CustomerID]),
    CONSTRAINT [FK_EMPLOYEES_ORDERS] FOREIGN KEY ([EmployeeID]) REFERENCES [Shop].[Employees] ([EmployeeID]),
    CONSTRAINT [FK_ORDERSTATUS_ORDERS] FOREIGN KEY ([OrderStatusID]) REFERENCES [Shop].[OrderStatus] ([OrderStatusID])
);


GO
CREATE NONCLUSTERED INDEX [Address_Order_FK]
    ON [Shop].[Orders]([AddressID] ASC);


GO
CREATE NONCLUSTERED INDEX [Customer_Order_FK]
    ON [Shop].[Orders]([CustomerID] ASC);


GO
CREATE NONCLUSTERED INDEX [Employee_Order_FK]
    ON [Shop].[Orders]([EmployeeID] ASC);


GO
CREATE NONCLUSTERED INDEX [OrderStatus_Orders_FK]
    ON [Shop].[Orders]([OrderStatusID] ASC);

