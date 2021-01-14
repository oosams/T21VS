CREATE TABLE [Logs].[Operations] (
    [OperationID]   INT            IDENTITY (1, 1) NOT NULL,
    [OperationName] NVARCHAR (255) NOT NULL,
    [Description]   NVARCHAR (MAX) NOT NULL,
    CONSTRAINT [PK_OPERATIONS] PRIMARY KEY CLUSTERED ([OperationID] ASC)
);

