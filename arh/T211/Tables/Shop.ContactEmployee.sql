/*==============================================================*/
/* Table: ContactEmployee                                       */
/*==============================================================*/
create table Shop.ContactEmployee (
   EmployeeID           int                  not null,
   ContactID            int                  not null,
   constraint PK_CONTACTEMPLOYEE primary key (EmployeeID, ContactID)
)
GO
/*==============================================================*/
/* Index: Contact_Employee2_FK                                  */
/*==============================================================*/
create index Contact_Employee2_FK on Shop.ContactEmployee (
ContactID ASC
)
GO
/*==============================================================*/
/* Index: Contact_Employee_FK                                   */
/*==============================================================*/
create index Contact_Employee_FK on Shop.ContactEmployee (
EmployeeID ASC
)