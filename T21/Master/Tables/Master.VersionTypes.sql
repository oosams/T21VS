CREATE TABLE [Master].[VersionTypes] (
    [VersionTypeID]   INT                   NOT NULL,
    [VersionTypeName] NVARCHAR (50)         NOT NULL,
    [Description]     [dbo].[nvarchar(max)] NOT NULL,
    CONSTRAINT [PK_VERSIONTYPES] PRIMARY KEY CLUSTERED ([VersionTypeID] ASC)
);

