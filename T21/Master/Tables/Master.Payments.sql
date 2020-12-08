CREATE TABLE [Master].[Payments] (
    [PaymentID]     INT           NOT NULL,
    [PaymentType]   NVARCHAR (40) NOT NULL,
    [PaymentStatus] NVARCHAR (20) NOT NULL,
    CONSTRAINT [PK_PAYMENTS] PRIMARY KEY CLUSTERED ([PaymentID] ASC)
);

