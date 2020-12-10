/*==============================================================*/
/* Table: ProductPrices                                         */
/*==============================================================*/
create table Shop.ProductPrices (
   ProductPriceID       int                  identity,
   ProductID            int                  not null,
   UnitPrice            money                not null,
   StartVersion         int                  not null,
   EndVersion           int                  not null default 999999999,
   constraint PK_PRODUCTPRICES primary key (ProductPriceID)
)
GO
/*==============================================================*/
/* Index: Product_ProductPrice_FK                               */
/*==============================================================*/
create index Product_ProductPrice_FK on Shop.ProductPrices (
ProductID ASC
)
GO
/*==============================================================*/
/* Index: ProductPrice_VersionStart_FK                          */
/*==============================================================*/
create index ProductPrice_VersionStart_FK on Shop.ProductPrices (
StartVersion ASC
)
GO
/*==============================================================*/
/* Index: ProductPrice_VersionEnd_FK                            */
/*==============================================================*/
create index ProductPrice_VersionEnd_FK on Shop.ProductPrices (
EndVersion ASC
)