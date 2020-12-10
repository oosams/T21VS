CREATE TABLE [dbo].[Cities] (
    [CityID]        INT             NOT NULL,
    [RegionID]      SMALLINT        NOT NULL,
    [CountryID]     SMALLINT        NOT NULL,
    [CityLatitude]  DECIMAL (10, 8) NOT NULL,
    [CityLongitude] DECIMAL (11, 8) NOT NULL,
    [CityName]      NVARCHAR (255)  NOT NULL
);

