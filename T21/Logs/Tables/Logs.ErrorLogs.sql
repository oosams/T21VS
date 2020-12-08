CREATE TABLE [Logs].[ErrorLogs] (
    [ErrorID]        INT                   NOT NULL,
    [EventID]        INT                   NOT NULL,
    [OperationRunID] INT                   NOT NULL,
    [ErrorNumber]    NVARCHAR (20)         NULL,
    [ErrorProcName]  NVARCHAR (255)        NULL,
    [Parameters]     NVARCHAR (1024)       NULL,
    [ErrorMessage]   [dbo].[nvarchar(max)] NULL,
    [ErrorDateTime]  DATETIME              NOT NULL,
    CONSTRAINT [PK_ERRORLOGS] PRIMARY KEY CLUSTERED ([ErrorID] ASC),
    CONSTRAINT [FK_EVENTLOGS_ERRORLOGS] FOREIGN KEY ([EventID]) REFERENCES [Logs].[EventLogs] ([EventID]),
    CONSTRAINT [FK_OPERATIONRUNS_ERRORLOGS] FOREIGN KEY ([OperationRunID]) REFERENCES [Logs].[OperationRuns] ([OperationRunID])
);


GO
CREATE NONCLUSTERED INDEX [Event_Error_FK]
    ON [Logs].[ErrorLogs]([EventID] ASC);


GO
CREATE NONCLUSTERED INDEX [OperationRun_Log_FK]
    ON [Logs].[ErrorLogs]([OperationRunID] ASC);

