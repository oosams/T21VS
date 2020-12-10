CREATE TABLE [Master].[Countries] (
    [CountryID]   SMALLINT       NOT NULL,
    [CountryName] NVARCHAR (100) NOT NULL,
    [CountryCode] NVARCHAR (10)  NULL,
    CONSTRAINT [PK_COUNTRIES] PRIMARY KEY NONCLUSTERED ([CountryID] ASC)
);

