CREATE TABLE [dbo].[person] (
    [BusinessEntityID] INT              NOT NULL,
    [PersonType]       NCHAR (2)        COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
    [NameStyle]        BIT              NOT NULL,
    [Title]            NVARCHAR (8)     COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
    [FirstName]        NVARCHAR (50)    COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
    [MiddleName]       NVARCHAR (50)    COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
    [LastName]         NVARCHAR (50)    COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
    [Suffix]           NVARCHAR (10)    COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
    [EmailPromotion]   INT              NOT NULL,
    [rowguid]          UNIQUEIDENTIFIER NOT NULL,
    [ModifiedDate]     DATETIME         NOT NULL
);

