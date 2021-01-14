CREATE TABLE [Logs].[OperationRuns] (
    [OperationRunID] INT            IDENTITY (1, 1) NOT NULL,
    [StatusID]       INT            NOT NULL,
    [OperationID]    INT            NOT NULL,
    [StartTime]      DATETIME       NOT NULL,
    [EndTime]        DATETIME       DEFAULT ('9999-12-31 23:59:59.000') NOT NULL,
    [Description]    NVARCHAR (MAX) NOT NULL,
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

