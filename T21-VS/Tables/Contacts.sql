CREATE TABLE [Shop].[Contacts] (
    [ContactID]  INT            IDENTITY (1, 1) NOT NULL,
    [Title]      NVARCHAR (50)  NULL,
    [FirstName]  NVARCHAR (255) NOT NULL,
    [MiddleName] NVARCHAR (255) NULL,
    [LastName]   NVARCHAR (255) NOT NULL,
    [Gender]     NVARCHAR (50)  NOT NULL,
    [BirthDay]   NVARCHAR (50)  NOT NULL,
    [Email]      NVARCHAR (255) NOT NULL,
    [Phone]      NVARCHAR (50)  NOT NULL,
    CONSTRAINT [PK_CONTACTS] PRIMARY KEY CLUSTERED ([ContactID] ASC)
);

