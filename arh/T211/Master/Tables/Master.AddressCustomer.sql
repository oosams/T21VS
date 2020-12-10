CREATE TABLE [Master].[AddressCustomer] (
    [CustomerID] INT NOT NULL,
    [AddressID]  INT NOT NULL,
    CONSTRAINT [PK_ADDRESSCUSTOMER] PRIMARY KEY NONCLUSTERED ([CustomerID] ASC, [AddressID] ASC),
    CONSTRAINT [FK_ADDRESSES_ADDRESSCUSTOMER] FOREIGN KEY ([AddressID]) REFERENCES [Master].[Addresses] ([AddressID]),
    CONSTRAINT [FK_CUSTOMERS_ADDRESSCUSTOMER] FOREIGN KEY ([CustomerID]) REFERENCES [Master].[Customers] ([CustomerID])
);


GO
CREATE NONCLUSTERED INDEX [Address_Customer2_FK]
    ON [Master].[AddressCustomer]([AddressID] ASC);


GO
CREATE NONCLUSTERED INDEX [Address_Customer_FK]
    ON [Master].[AddressCustomer]([CustomerID] ASC);

