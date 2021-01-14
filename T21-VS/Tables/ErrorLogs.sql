CREATE TABLE [Logs].[ErrorLogs] (
    [ErrorID]        INT             IDENTITY (1, 1) NOT NULL,
    [OperationRunID] INT             NOT NULL,
    [ErrorNumber]    INT             NULL,
    [ErrorProcName]  NVARCHAR (1024) NULL,
    [Parameters]     NVARCHAR (MAX)  NULL,
    [ErrorMessage]   NVARCHAR (MAX)  NOT NULL,
    [ErrorDateTime]  DATETIME        NOT NULL,
    CONSTRAINT [PK_ERRORLOGS] PRIMARY KEY CLUSTERED ([ErrorID] ASC),
    CONSTRAINT [FK_OPERATIONRUNS_ERRORLOGS] FOREIGN KEY ([OperationRunID]) REFERENCES [Logs].[OperationRuns] ([OperationRunID])
);


GO
CREATE NONCLUSTERED INDEX [OperationRun_Log_FK]
    ON [Logs].[ErrorLogs]([OperationRunID] ASC);

