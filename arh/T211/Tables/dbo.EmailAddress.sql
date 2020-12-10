CREATE TABLE [dbo].[EmailAddress] (
    [BusinessEntityID] INT              NOT NULL,
    [EmailAddressID]   INT              IDENTITY (1, 1) NOT NULL,
    [EmailAddress]     NVARCHAR (50)    COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
    [rowguid]          UNIQUEIDENTIFIER NOT NULL,
    [ModifiedDate]     DATETIME         NOT NULL
);

