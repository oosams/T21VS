/*==============================================================*/
/* Table: AddressEmployee                                       */
/*==============================================================*/
create table Shop.AddressEmployee (
   EmployeeID           int                  not null,
   AddressID            int                  not null,
   constraint PK_ADDRESSEMPLOYEE primary key (EmployeeID, AddressID)
)
GO
/*==============================================================*/
/* Index: Address_Employee2_FK                                  */
/*==============================================================*/
create index Address_Employee2_FK on Shop.AddressEmployee (
AddressID ASC
)
GO
/*==============================================================*/
/* Index: Address_Employee_FK                                   */
/*==============================================================*/
create index Address_Employee_FK on Shop.AddressEmployee (
EmployeeID ASC
)