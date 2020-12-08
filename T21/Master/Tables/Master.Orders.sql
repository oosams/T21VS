CREATE TABLE [Master].[Orders] (
    [OrderID]      INT            NOT NULL,
    [AddressID]    INT            NOT NULL,
    [PaymentID]    INT            NOT NULL,
    [CustomerID]   INT            NOT NULL,
    [EmployeeID]   INT            NOT NULL,
    [OrderStatus]  NVARCHAR (30)  NOT NULL,
    [OrderDate]    DATETIME       NOT NULL,
    [RequiredDate] DATETIME       NULL,
    [ShipDate]     DATETIME       NULL,
    [Freight]      MONEY          NULL,
    [SalesTax]     DECIMAL (5, 2) NULL,
    CONSTRAINT [PK_ORDERS] PRIMARY KEY CLUSTERED ([OrderID] ASC),
    CONSTRAINT [FK_ADDRESSES_ORDERS] FOREIGN KEY ([AddressID]) REFERENCES [Master].[Addresses] ([AddressID]),
    CONSTRAINT [FK_CUSTOMERS_ORDERS] FOREIGN KEY ([CustomerID]) REFERENCES [Master].[Customers] ([CustomerID]),
    CONSTRAINT [FK_EMPLOYEES_ORDERS] FOREIGN KEY ([EmployeeID]) REFERENCES [Master].[Employees] ([EmployeeID]),
    CONSTRAINT [FK_PAYMENTS_ORDERS] FOREIGN KEY ([PaymentID]) REFERENCES [Master].[Payments] ([PaymentID])
);


GO
CREATE NONCLUSTERED INDEX [Address_Order_FK]
    ON [Master].[Orders]([AddressID] ASC);


GO
CREATE NONCLUSTERED INDEX [Payment_Order_FK]
    ON [Master].[Orders]([PaymentID] ASC);


GO
CREATE NONCLUSTERED INDEX [Customer_Order_FK]
    ON [Master].[Orders]([CustomerID] ASC);


GO
CREATE NONCLUSTERED INDEX [Employee_Order_FK]
    ON [Master].[Orders]([EmployeeID] ASC);

