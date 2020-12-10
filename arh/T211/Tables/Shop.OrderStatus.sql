/*==============================================================*/
/* Table: OrderStatus                                           */
/*==============================================================*/
create table Shop.OrderStatus (
   OrderStatusID        int                  identity,
   OrderStatusName      nvarchar(255)        not null,
   Description          nvarchar(Max)        not null,
   constraint PK_ORDERSTATUS primary key nonclustered (OrderStatusID)
)