/*==============================================================*/
/* Table: Employees                                             */
/*==============================================================*/
create table Shop.Employees (
   EmployeeID           int                  identity,
   ManagerID            int                  null,
   RoleTitle            nvarchar(255)        not null,
   HireDate             datetime             not null,
   IsActive             tinyint              not null,
   constraint PK_EMPLOYEES primary key (EmployeeID)
)
GO
/*==============================================================*/
/* Index: Employee_Employee_FK                                  */
/*==============================================================*/
create index Employee_Employee_FK on Shop.Employees (
ManagerID ASC
)