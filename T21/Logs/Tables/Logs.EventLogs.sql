CREATE TABLE [Logs].[EventLogs] (
    [EventID]        INT                   NOT NULL,
    [OperationRunID] INT                   NOT NULL,
    [User]           NVARCHAR (20)         NULL,
    [AffectedRows]   NVARCHAR (255)        NULL,
    [EventProcName]  NVARCHAR (255)        NULL,
    [Parameters]     NVARCHAR (1024)       NULL,
    [EventMessage]   [dbo].[nvarchar(max)] NULL,
    [EventDateTime]  DATETIME              NOT NULL,
    CONSTRAINT [PK_EVENTLOGS] PRIMARY KEY CLUSTERED ([EventID] ASC),
    CONSTRAINT [FK_OPERATIONRUNS_EVENTLOGS] FOREIGN KEY ([OperationRunID]) REFERENCES [Logs].[OperationRuns] ([OperationRunID])
);


GO
CREATE NONCLUSTERED INDEX [OperationRun_Event_FK]
    ON [Logs].[EventLogs]([OperationRunID] ASC);

