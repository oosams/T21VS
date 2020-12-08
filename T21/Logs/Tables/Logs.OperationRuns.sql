CREATE TABLE [Logs].[OperationRuns] (
    [OperationRunID] INT                   NOT NULL,
    [StatusID]       INT                   NOT NULL,
    [OperationID]    INT                   NOT NULL,
    [StartTime]      DATETIME              NOT NULL,
    [EndTime]        DATETIME              NOT NULL,
    [Description]    [dbo].[nvarchar(max)] NOT NULL,
    CONSTRAINT [PK_OPERATIONRUNS] PRIMARY KEY CLUSTERED ([OperationRunID] ASC),
    CONSTRAINT [FK_OPERATIONS_OPERATIONRUNS] FOREIGN KEY ([OperationID]) REFERENCES [Logs].[Operations] ([OperationID]),
    CONSTRAINT [FK_OPERATIONSTATUSES_OPERATIONRUNS] FOREIGN KEY ([StatusID]) REFERENCES [Logs].[OperationStatuses] ([StatusID])
);


GO
CREATE NONCLUSTERED INDEX [OperationStatus_OperationRun_FK]
    ON [Logs].[OperationRuns]([StatusID] ASC);


GO
CREATE NONCLUSTERED INDEX [Operation_OperationRun_FK]
    ON [Logs].[OperationRuns]([OperationID] ASC);

