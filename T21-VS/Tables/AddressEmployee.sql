CREATE TABLE [Shop].[AddressEmployee] (
    [EmployeeID] INT NOT NULL,
    [AddressID]  INT NOT NULL,
    CONSTRAINT [PK_ADDRESSEMPLOYEE] PRIMARY KEY CLUSTERED ([EmployeeID] ASC, [AddressID] ASC),
    CONSTRAINT [FK_ADDRESSES_ADDRESSEMPLOYEE] FOREIGN KEY ([AddressID]) REFERENCES [Shop].[Addresses] ([AddressID]),
    CONSTRAINT [FK_EMPLOYEES_ADDRESSEMPLOYEE] FOREIGN KEY ([EmployeeID]) REFERENCES [Shop].[Employees] ([EmployeeID])
);


GO
CREATE NONCLUSTERED INDEX [Address_Employee2_FK]
    ON [Shop].[AddressEmployee]([AddressID] ASC);


GO
CREATE NONCLUSTERED INDEX [Address_Employee_FK]
    ON [Shop].[AddressEmployee]([EmployeeID] ASC);

