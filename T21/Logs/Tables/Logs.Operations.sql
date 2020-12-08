CREATE TABLE [Logs].[Operations] (
    [OperationID]   INT                   NOT NULL,
    [OperationName] NVARCHAR (100)        NOT NULL,
    [Description]   [dbo].[nvarchar(max)] NOT NULL,
    CONSTRAINT [PK_OPERATIONS] PRIMARY KEY CLUSTERED ([OperationID] ASC)
);

