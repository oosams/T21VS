/*==============================================================*/
/* Table: AddressCustomer                                       */
/*==============================================================*/
create table Shop.AddressCustomer (
   CustomerID           int                  not null,
   AddressID            int                  not null,
   constraint PK_ADDRESSCUSTOMER primary key (CustomerID, AddressID)
)
GO
/*==============================================================*/
/* Index: Address_Customer2_FK                                  */
/*==============================================================*/
create index Address_Customer2_FK on Shop.AddressCustomer (
AddressID ASC
)
GO
/*==============================================================*/
/* Index: Address_Customer_FK                                   */
/*==============================================================*/
create index Address_Customer_FK on Shop.AddressCustomer (
CustomerID ASC
)