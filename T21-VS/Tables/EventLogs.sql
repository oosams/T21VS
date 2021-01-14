CREATE TABLE [Logs].[EventLogs] (
    [EventID]        INT             IDENTITY (1, 1) NOT NULL,
    [OperationRunID] INT             NOT NULL,
    [UserName]       NVARCHAR (100)  NULL,
    [AffectedRows]   INT             NULL,
    [EventProcName]  NVARCHAR (1024) NULL,
    [Parameters]     NVARCHAR (MAX)  NULL,
    [EventMessage]   NVARCHAR (MAX)  NOT NULL,
    [EventDateTime]  DATETIME        NOT NULL,
    CONSTRAINT [PK_EVENTLOGS] PRIMARY KEY CLUSTERED ([EventID] ASC),
    CONSTRAINT [FK_OPERATIONRUNS_EVENTLOGS] FOREIGN KEY ([OperationRunID]) REFERENCES [Logs].[OperationRuns] ([OperationRunID])
);


GO
CREATE NONCLUSTERED INDEX [OperationRun_Event_FK]
    ON [Logs].[EventLogs]([OperationRunID] ASC);

