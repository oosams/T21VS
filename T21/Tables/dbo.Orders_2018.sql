CREATE TABLE [dbo].[Orders_2018] (
    [OrderId]          INT      NOT NULL,
    [OrderCountryCode] CHAR (3) NOT NULL,
    [OrderDate]        DATETIME NULL,
    [OrderYear]        INT      NOT NULL,
    CONSTRAINT [PK_Order_2018] PRIMARY KEY CLUSTERED ([OrderId] ASC, [OrderYear] ASC),
    CONSTRAINT [CK_Order_2018] CHECK ([OrderYear]=(2018))
);

