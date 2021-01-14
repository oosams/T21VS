CREATE TABLE [Shop].[OrderStatus] (
    [OrderStatusID]   INT            IDENTITY (1, 1) NOT NULL,
    [OrderStatusName] NVARCHAR (255) NOT NULL,
    [Description]     NVARCHAR (MAX) NOT NULL,
    CONSTRAINT [PK_ORDERSTATUS] PRIMARY KEY NONCLUSTERED ([OrderStatusID] ASC)
);

