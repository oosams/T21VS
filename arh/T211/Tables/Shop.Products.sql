/*==============================================================*/
/* Table: Products                                              */
/*==============================================================*/
create table Shop.Products (
   ProductID            int                  identity,
   CategoryID           int                  not null,
   ProductName          nvarchar(255)        not null,
   Quantity             int                  not null,
   IsActive             tinyint              not null,
   Description          nvarchar(Max)        not null,
   constraint PK_PRODUCTS primary key (ProductID)
)
GO
/*==============================================================*/
/* Index: Category_Product_FK                                   */
/*==============================================================*/
create index Category_Product_FK on Shop.Products (
CategoryID ASC
)