CREATE TABLE [Master].[Employees] (
    [EmployeeID] INT           NOT NULL,
    [ManagerID]  INT           NULL,
    [RoleTitle]  NVARCHAR (20) NOT NULL,
    [HireDate]   DATETIME      NOT NULL,
    [IsActive]   TINYINT       NOT NULL,
    CONSTRAINT [PK_EMPLOYEES] PRIMARY KEY NONCLUSTERED ([EmployeeID] ASC),
    CONSTRAINT [FK_EMPLOYEES_EMPLOYEES] FOREIGN KEY ([ManagerID]) REFERENCES [Master].[Employees] ([EmployeeID])
);


GO
CREATE NONCLUSTERED INDEX [Employee_Employee_FK]
    ON [Master].[Employees]([ManagerID] ASC);

