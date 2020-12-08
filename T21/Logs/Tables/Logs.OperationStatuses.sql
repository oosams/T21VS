CREATE TABLE [Logs].[OperationStatuses] (
    [StatusID]    INT                   NOT NULL,
    [Status]      NVARCHAR (1)          NOT NULL,
    [StatusName]  NVARCHAR (20)         NOT NULL,
    [Description] [dbo].[nvarchar(max)] NOT NULL,
    CONSTRAINT [PK_OPERATIONSTATUSES] PRIMARY KEY CLUSTERED ([StatusID] ASC)
);

