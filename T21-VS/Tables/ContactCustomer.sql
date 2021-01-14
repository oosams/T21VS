CREATE TABLE [Shop].[ContactCustomer] (
    [CustomerID] INT NOT NULL,
    [ContactID]  INT NOT NULL,
    CONSTRAINT [PK_CONTACTCUSTOMER] PRIMARY KEY CLUSTERED ([CustomerID] ASC, [ContactID] ASC),
    CONSTRAINT [FK_CONTACTS_CONTACTCUSTOMER] FOREIGN KEY ([ContactID]) REFERENCES [Shop].[Contacts] ([ContactID]),
    CONSTRAINT [FK_CUSTOMERS_CONTACTCUSTOMER] FOREIGN KEY ([CustomerID]) REFERENCES [Shop].[Customers] ([CustomerID])
);


GO
CREATE NONCLUSTERED INDEX [Contact_Customer2_FK]
    ON [Shop].[ContactCustomer]([ContactID] ASC);


GO
CREATE NONCLUSTERED INDEX [Contact_Customer_FK]
    ON [Shop].[ContactCustomer]([CustomerID] ASC);

