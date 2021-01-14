CREATE TABLE [Shop].[Addresses] (
    [AddressID]    INT            IDENTITY (1, 1) NOT NULL,
    [AddressLine1] NVARCHAR (500) NOT NULL,
    [AddressLine2] NVARCHAR (500) NULL,
    [City]         NVARCHAR (255) NOT NULL,
    [Region]       NVARCHAR (255) NULL,
    [Country]      NVARCHAR (255) NOT NULL,
    [PostalCode]   NVARCHAR (100) NULL,
    CONSTRAINT [PK_ADDRESSES] PRIMARY KEY CLUSTERED ([AddressID] ASC)
);

