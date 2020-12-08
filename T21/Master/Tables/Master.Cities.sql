CREATE TABLE [Master].[Cities] (
    [CityID]        INT             NOT NULL,
    [CountryID]     SMALLINT        NOT NULL,
    [RegionID]      SMALLINT        NOT NULL,
    [CityLatitude]  DECIMAL (11, 8) NULL,
    [CityLongitude] DECIMAL (11, 8) NULL,
    [CityName]      NVARCHAR (50)   NOT NULL,
    CONSTRAINT [PK_CITIES] PRIMARY KEY CLUSTERED ([CityID] ASC),
    CONSTRAINT [FK_COUNTRIES_CITIES] FOREIGN KEY ([CountryID]) REFERENCES [Master].[Countries] ([CountryID]),
    CONSTRAINT [FK_REGIONS_CITIES] FOREIGN KEY ([RegionID]) REFERENCES [Master].[Regions] ([RegionID])
);


GO
CREATE NONCLUSTERED INDEX [Country_City_FK]
    ON [Master].[Cities]([CountryID] ASC);


GO
CREATE NONCLUSTERED INDEX [Region_City_FK]
    ON [Master].[Cities]([RegionID] ASC);

