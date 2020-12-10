/*==============================================================*/
/* Table: ContactCustomer                                       */
/*==============================================================*/
create table Shop.ContactCustomer (
   CustomerID           int                  not null,
   ContactID            int                  not null,
   constraint PK_CONTACTCUSTOMER primary key (CustomerID, ContactID)
)
GO
/*==============================================================*/
/* Index: Contact_Customer2_FK                                  */
/*==============================================================*/
create index Contact_Customer2_FK on Shop.ContactCustomer (
ContactID ASC
)
GO
/*==============================================================*/
/* Index: Contact_Customer_FK                                   */
/*==============================================================*/
create index Contact_Customer_FK on Shop.ContactCustomer (
CustomerID ASC
)