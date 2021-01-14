CREATE TYPE [Staging].[type_OrderDetails] AS TABLE (
    [OrderID]   INT        NULL,
    [ProductID] INT        NULL,
    [UnitPrice] MONEY      NULL,
    [Quantity]  INT        NULL,
    [Discount]  FLOAT (53) NULL);

