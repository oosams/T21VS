CREATE TABLE [Logs].[OperationStatuses] (
    [StatusID]    INT            IDENTITY (1, 1) NOT NULL,
    [Status]      NVARCHAR (50)  NOT NULL,
    [StatusName]  NVARCHAR (100) NOT NULL,
    [Description] NVARCHAR (MAX) NOT NULL,
    CONSTRAINT [PK_OPERATIONSTATUSES] PRIMARY KEY CLUSTERED ([StatusID] ASC)
);

