CREATE TABLE [Master].[Contacts] (
    [ContactID]  INT            NOT NULL,
    [Title]      NVARCHAR (10)  NULL,
    [FirstName]  NVARCHAR (100) NOT NULL,
    [MiddleName] NVARCHAR (100) NULL,
    [LastName]   NVARCHAR (100) NOT NULL,
    [Gender]     NVARCHAR (10)  NOT NULL,
    [BirthDay]   NVARCHAR (15)  NOT NULL,
    [Email]      NVARCHAR (50)  NOT NULL,
    [Phone]      NVARCHAR (15)  NOT NULL,
    CONSTRAINT [PK_CONTACTS] PRIMARY KEY NONCLUSTERED ([ContactID] ASC)
);

