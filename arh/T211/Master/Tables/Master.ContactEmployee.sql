CREATE TABLE [Master].[ContactEmployee] (
    [EmployeeID] INT NOT NULL,
    [ContactID]  INT NOT NULL,
    CONSTRAINT [PK_CONTACTEMPLOYEE] PRIMARY KEY NONCLUSTERED ([EmployeeID] ASC, [ContactID] ASC),
    CONSTRAINT [FK_CONTACTS_CONTACTEMPLOYEE] FOREIGN KEY ([ContactID]) REFERENCES [Master].[Contacts] ([ContactID]),
    CONSTRAINT [FK_EMPLOYEES_CONTACTEMPLOYEE] FOREIGN KEY ([EmployeeID]) REFERENCES [Master].[Employees] ([EmployeeID])
);


GO
CREATE NONCLUSTERED INDEX [Contact_Employee2_FK]
    ON [Master].[ContactEmployee]([ContactID] ASC);


GO
CREATE NONCLUSTERED INDEX [Contact_Employee_FK]
    ON [Master].[ContactEmployee]([EmployeeID] ASC);

