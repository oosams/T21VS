CREATE TABLE [dbo].[Orders] (
    [OrderId]          INT      NOT NULL,
    [OrderCountryCode] CHAR (3) NOT NULL,
    [OrderDate]        DATETIME NULL,
    [OrderYear]        INT      NOT NULL,
    CONSTRAINT [PK_Order] PRIMARY KEY CLUSTERED ([OrderId] ASC, [OrderYear] ASC),
    CONSTRAINT [CK_Order] CHECK ([OrderYear]>=(2019))
);

