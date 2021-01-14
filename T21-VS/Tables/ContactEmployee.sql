CREATE TABLE [Shop].[ContactEmployee] (
    [EmployeeID] INT NOT NULL,
    [ContactID]  INT NOT NULL,
    CONSTRAINT [PK_CONTACTEMPLOYEE] PRIMARY KEY CLUSTERED ([EmployeeID] ASC, [ContactID] ASC),
    CONSTRAINT [FK_CONTACTS_CONTACTEMPLOYEE] FOREIGN KEY ([ContactID]) REFERENCES [Shop].[Contacts] ([ContactID]),
    CONSTRAINT [FK_EMPLOYEES_CONTACTEMPLOYEE] FOREIGN KEY ([EmployeeID]) REFERENCES [Shop].[Employees] ([EmployeeID])
);


GO
CREATE NONCLUSTERED INDEX [Contact_Employee2_FK]
    ON [Shop].[ContactEmployee]([ContactID] ASC);


GO
CREATE NONCLUSTERED INDEX [Contact_Employee_FK]
    ON [Shop].[ContactEmployee]([EmployeeID] ASC);

