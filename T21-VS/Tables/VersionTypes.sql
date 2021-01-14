CREATE TABLE [Logs].[VersionTypes] (
    [VersionTypeID]   INT            IDENTITY (1, 1) NOT NULL,
    [VersionTypeName] NVARCHAR (255) NOT NULL,
    [EntityID]        INT            NOT NULL,
    [Description]     NVARCHAR (MAX) NOT NULL,
    CONSTRAINT [PK_VERSIONTYPES] PRIMARY KEY CLUSTERED ([VersionTypeID] ASC)
);


GO
CREATE NONCLUSTERED INDEX [EnityID_FK]
    ON [Logs].[VersionTypes]([EntityID] ASC);

