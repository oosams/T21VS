CREATE TABLE [Master].[Versions] (
    [VersionID]      INT                   NOT NULL,
    [VersionTypeID]  INT                   NOT NULL,
    [OperationRunID] INT                   NOT NULL,
    [VersionNumber]  INT                   NOT NULL,
    [Description]    [dbo].[nvarchar(max)] NOT NULL,
    [StartDate]      DATETIME              NOT NULL,
    [EndDate]        DATETIME              DEFAULT ('9999-31-12') NOT NULL,
    CONSTRAINT [PK_VERSIONS] PRIMARY KEY CLUSTERED ([VersionID] ASC),
    CONSTRAINT [FK_OPERATIONRUNS_VERSIONS] FOREIGN KEY ([OperationRunID]) REFERENCES [Logs].[OperationRuns] ([OperationRunID]),
    CONSTRAINT [FK_VERSIONTYPES_VERSIONS] FOREIGN KEY ([VersionTypeID]) REFERENCES [Master].[VersionTypes] ([VersionTypeID])
);


GO
CREATE NONCLUSTERED INDEX [VersionType_Version_FK]
    ON [Master].[Versions]([VersionTypeID] ASC);


GO
CREATE NONCLUSTERED INDEX [OperationRun_Version_FK]
    ON [Master].[Versions]([OperationRunID] ASC);

