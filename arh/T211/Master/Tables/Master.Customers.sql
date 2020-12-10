CREATE TABLE [Master].[Customers] (
    [CustomerID] INT        NOT NULL,
    [Discount]   FLOAT (53) NULL,
    CONSTRAINT [PK_CUSTOMERS] PRIMARY KEY NONCLUSTERED ([CustomerID] ASC)
);

