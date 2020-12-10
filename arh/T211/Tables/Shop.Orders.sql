/*==============================================================*/
/* Table: Orders                                                */
/*==============================================================*/
create table Shop.Orders (
   OrderID              int                  identity,
   AddressID            int                  not null,
   CustomerID           int                  not null,
   EmployeeID           int                  not null,
   OrderStatusID        int                  not null,
   OrderDate            datetime             not null,
   RequiredDate         datetime             null,
   ShipDate             datetime             null,
   constraint PK_ORDERS primary key (OrderID)
)
GO
/*==============================================================*/
/* Index: Address_Order_FK                                      */
/*==============================================================*/
create index Address_Order_FK on Shop.Orders (
AddressID ASC
)
GO
/*==============================================================*/
/* Index: Customer_Order_FK                                     */
/*==============================================================*/
create index Customer_Order_FK on Shop.Orders (
CustomerID ASC
)
GO
/*==============================================================*/
/* Index: Employee_Order_FK                                     */
/*==============================================================*/
create index Employee_Order_FK on Shop.Orders (
EmployeeID ASC
)
GO
/*==============================================================*/
/* Index: OrderStatus_Orders_FK                                 */
/*==============================================================*/
create index OrderStatus_Orders_FK on Shop.Orders (
OrderStatusID ASC
)