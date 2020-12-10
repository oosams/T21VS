/*==============================================================*/
/* Table: Customers                                             */
/*==============================================================*/
create table Shop.Customers (
   CustomerID           int                  identity,
   Discount             float                null,
   constraint PK_CUSTOMERS primary key (CustomerID)
)