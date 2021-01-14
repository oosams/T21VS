CREATE TABLE [Shop].[Employees] (
    [EmployeeID] INT            IDENTITY (1, 1) NOT NULL,
    [ManagerID]  INT            NULL,
    [RoleTitle]  NVARCHAR (255) NOT NULL,
    [HireDate]   DATETIME       NOT NULL,
    [IsActive]   TINYINT        NOT NULL,
    CONSTRAINT [PK_EMPLOYEES] PRIMARY KEY CLUSTERED ([EmployeeID] ASC),
    CONSTRAINT [FK_EMPLOYEES_EMPLOYEES] FOREIGN KEY ([ManagerID]) REFERENCES [Shop].[Employees] ([EmployeeID])
);


GO
CREATE NONCLUSTERED INDEX [Employee_Employee_FK]
    ON [Shop].[Employees]([ManagerID] ASC);

