CREATE TABLE [Shop].[Customers] (
    [CustomerID] INT        IDENTITY (1, 1) NOT NULL,
    [Discount]   FLOAT (53) NULL,
    CONSTRAINT [PK_CUSTOMERS] PRIMARY KEY CLUSTERED ([CustomerID] ASC)
);

