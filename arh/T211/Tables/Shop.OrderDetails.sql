/*==============================================================*/
/* Table: OrderDetails                                          */
/*==============================================================*/
create table Shop.OrderDetails (
   OrderID              int                  not null,
   ProductID            int                  not null,
   UnitPrice            money                not null,
   Quantity             int                  not null,
   Discount             float                null,
   constraint PK_ORDERDETAILS primary key nonclustered (OrderID, ProductID)
)
GO
/*==============================================================*/
/* Index: Order_OrderDetail_FK                                  */
/*==============================================================*/
create index Order_OrderDetail_FK on Shop.OrderDetails (
OrderID ASC
)
GO
/*==============================================================*/
/* Index: Product_OrderDetail_FK                                */
/*==============================================================*/
create index Product_OrderDetail_FK on Shop.OrderDetails (
ProductID ASC
)