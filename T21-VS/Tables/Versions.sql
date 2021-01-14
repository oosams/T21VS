CREATE TABLE [Logs].[Versions] (
    [VersionID]      INT            IDENTITY (1, 1) NOT NULL,
    [VersionTypeID]  INT            NOT NULL,
    [OperationRunID] INT            NOT NULL,
    [VersionNumber]  INT            NOT NULL,
    [Description]    NVARCHAR (MAX) NOT NULL,
    [CreateDate]     DATETIME       NOT NULL,
    CONSTRAINT [PK_VERSIONS] PRIMARY KEY CLUSTERED ([VersionID] ASC),
    CONSTRAINT [FK_OPERATIONRUNS_VERSIONS] FOREIGN KEY ([OperationRunID]) REFERENCES [Logs].[OperationRuns] ([OperationRunID]),
    CONSTRAINT [FK_VERSIONTYPES_VERSIONS] FOREIGN KEY ([VersionTypeID]) REFERENCES [Logs].[VersionTypes] ([VersionTypeID])
);


GO
CREATE NONCLUSTERED INDEX [VersionType_Version_FK]
    ON [Logs].[Versions]([VersionTypeID] ASC);


GO
CREATE NONCLUSTERED INDEX [OperationRun_Version_FK]
    ON [Logs].[Versions]([OperationRunID] ASC);


GO
CREATE NONCLUSTERED INDEX [VersionNumber_FK]
    ON [Logs].[Versions]([VersionNumber] ASC);

