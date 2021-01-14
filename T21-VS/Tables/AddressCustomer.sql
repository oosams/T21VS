CREATE TABLE [Shop].[AddressCustomer] (
    [CustomerID] INT NOT NULL,
    [AddressID]  INT NOT NULL,
    CONSTRAINT [PK_ADDRESSCUSTOMER] PRIMARY KEY CLUSTERED ([CustomerID] ASC, [AddressID] ASC),
    CONSTRAINT [FK_ADDRESSES_ADDRESSCUSTOMER] FOREIGN KEY ([AddressID]) REFERENCES [Shop].[Addresses] ([AddressID]),
    CONSTRAINT [FK_CUSTOMERS_ADDRESSCUSTOMER] FOREIGN KEY ([CustomerID]) REFERENCES [Shop].[Customers] ([CustomerID])
);


GO
CREATE NONCLUSTERED INDEX [Address_Customer2_FK]
    ON [Shop].[AddressCustomer]([AddressID] ASC);


GO
CREATE NONCLUSTERED INDEX [Address_Customer_FK]
    ON [Shop].[AddressCustomer]([CustomerID] ASC);

