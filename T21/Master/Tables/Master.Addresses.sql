CREATE TABLE [Master].[Addresses] (
    [AddressID]    INT            NOT NULL,
    [CityID]       INT            NOT NULL,
    [AddressLine1] NVARCHAR (255) NOT NULL,
    [AddressLine2] NVARCHAR (255) NULL,
    [PostalCode]   NVARCHAR (10)  NOT NULL,
    CONSTRAINT [PK_ADDRESSES] PRIMARY KEY CLUSTERED ([AddressID] ASC),
    CONSTRAINT [FK_CITIES_ADDRESSES] FOREIGN KEY ([CityID]) REFERENCES [Master].[Cities] ([CityID])
);


GO
CREATE NONCLUSTERED INDEX [City_Address_FK]
    ON [Master].[Addresses]([CityID] ASC);

