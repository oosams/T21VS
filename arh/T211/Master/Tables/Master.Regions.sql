CREATE TABLE [Master].[Regions] (
    [RegionID]   SMALLINT       NOT NULL,
    [CountryID]  SMALLINT       NOT NULL,
    [RegionName] NVARCHAR (255) NOT NULL,
    [RegionCode] NVARCHAR (10)  NULL,
    CONSTRAINT [PK_REGIONS] PRIMARY KEY NONCLUSTERED ([RegionID] ASC),
    CONSTRAINT [FK_COUNTRIES_REGIONS] FOREIGN KEY ([CountryID]) REFERENCES [Master].[Countries] ([CountryID])
);


GO
CREATE NONCLUSTERED INDEX [Country_Region_FK]
    ON [Master].[Regions]([CountryID] ASC);

