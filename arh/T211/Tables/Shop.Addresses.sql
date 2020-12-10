/*==============================================================*/
/* Table: Addresses                                             */
/*==============================================================*/
create table Shop.Addresses (
   AddressID            int                  identity,
   AddressLine1         nvarchar(500)        not null,
   AddressLine2         nvarchar(500)        null,
   City                 nvarchar(255)        not null,
   Region               nvarchar(255)        null,
   Country              nvarchar(255)        not null,
   PostalCode           nvarchar(100)        null,
   constraint PK_ADDRESSES primary key (AddressID)
)