CREATE TABLE [dbo].[Orders_2017] (
    [OrderId]          INT      NOT NULL,
    [OrderCountryCode] CHAR (3) NOT NULL,
    [OrderDate]        DATETIME NULL,
    [OrderYear]        INT      NOT NULL,
    CONSTRAINT [PK_Order_2017] PRIMARY KEY CLUSTERED ([OrderId] ASC, [OrderYear] ASC),
    CONSTRAINT [CK_Order_2017] CHECK ([OrderYear]=(2017))
);

