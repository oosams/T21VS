CREATE TABLE [Master].[AddressEmployee] (
    [EmployeeID] INT NOT NULL,
    [AddressID]  INT NOT NULL,
    CONSTRAINT [PK_ADDRESSEMPLOYEE] PRIMARY KEY CLUSTERED ([EmployeeID] ASC, [AddressID] ASC),
    CONSTRAINT [FK_ADDRESSES_ADDRESSEMPLOYEE] FOREIGN KEY ([AddressID]) REFERENCES [Master].[Addresses] ([AddressID]),
    CONSTRAINT [FK_EMPLOYEES_ADDRESSEMPLOYEE] FOREIGN KEY ([EmployeeID]) REFERENCES [Master].[Employees] ([EmployeeID])
);


GO
CREATE NONCLUSTERED INDEX [Address_Employee2_FK]
    ON [Master].[AddressEmployee]([AddressID] ASC);


GO
CREATE NONCLUSTERED INDEX [Address_Employee_FK]
    ON [Master].[AddressEmployee]([EmployeeID] ASC);

