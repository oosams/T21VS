CREATE TABLE [dbo].[PersonPhone] (
    [BusinessEntityID]  INT           NOT NULL,
    [PhoneNumber]       NVARCHAR (25) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
    [PhoneNumberTypeID] INT           NOT NULL,
    [ModifiedDate]      DATETIME      NOT NULL
);

