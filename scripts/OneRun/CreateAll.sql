/*==============================================================*/
/* Database name:  T21                                          */
/* DBMS name:      Microsoft SQL Server 2012                    */
/* Created on:     07-Dec-20 11:58:34 AM                        */
/*==============================================================*/
use master

drop database if exists T21
go

/*==============================================================*/
/* Database: T21                                                */
/*==============================================================*/
create database T21

go

use T21
go

/*==============================================================*/
/* User: Config                                                 */
/*==============================================================*/
create schema Config
go

/*==============================================================*/
/* User: Logs                                                   */
/*==============================================================*/
create schema Logs
go

/*==============================================================*/
/* User: Reporting                                              */
/*==============================================================*/
create schema Reporting
go

/*==============================================================*/
/* User: Shop                                                   */
/*==============================================================*/
create schema Shop
go

/*==============================================================*/
/* User: Staging                                                */
/*==============================================================*/
create schema Staging
go

/*==============================================================*/
/* Table: AddressCustomer                                       */
/*==============================================================*/
create table Shop.AddressCustomer (
   CustomerID           int                  not null,
   AddressID            int                  not null,
   constraint PK_ADDRESSCUSTOMER primary key (CustomerID, AddressID)
)
go

/*==============================================================*/
/* Index: Address_Customer2_FK                                  */
/*==============================================================*/
create index Address_Customer2_FK on Shop.AddressCustomer (
AddressID ASC
)
go

/*==============================================================*/
/* Index: Address_Customer_FK                                   */
/*==============================================================*/
create index Address_Customer_FK on Shop.AddressCustomer (
CustomerID ASC
)
go

/*==============================================================*/
/* Table: AddressEmployee                                       */
/*==============================================================*/
create table Shop.AddressEmployee (
   EmployeeID           int                  not null,
   AddressID            int                  not null,
   constraint PK_ADDRESSEMPLOYEE primary key (EmployeeID, AddressID)
)
go

/*==============================================================*/
/* Index: Address_Employee2_FK                                  */
/*==============================================================*/
create index Address_Employee2_FK on Shop.AddressEmployee (
AddressID ASC
)
go

/*==============================================================*/
/* Index: Address_Employee_FK                                   */
/*==============================================================*/
create index Address_Employee_FK on Shop.AddressEmployee (
EmployeeID ASC
)
go

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
go

/*==============================================================*/
/* Table: Categories                                            */
/*==============================================================*/
create table Shop.Categories (
   CategoryID           int                  identity,
   CategoryName         nvarchar(255)        not null,
   Description          nvarchar(Max)        not null,
   constraint PK_CATEGORIES primary key (CategoryID)
)
go

/*==============================================================*/
/* Table: ContactCustomer                                       */
/*==============================================================*/
create table Shop.ContactCustomer (
   CustomerID           int                  not null,
   ContactID            int                  not null,
   constraint PK_CONTACTCUSTOMER primary key (CustomerID, ContactID)
)
go

/*==============================================================*/
/* Index: Contact_Customer2_FK                                  */
/*==============================================================*/
create index Contact_Customer2_FK on Shop.ContactCustomer (
ContactID ASC
)
go

/*==============================================================*/
/* Index: Contact_Customer_FK                                   */
/*==============================================================*/
create index Contact_Customer_FK on Shop.ContactCustomer (
CustomerID ASC
)
go

/*==============================================================*/
/* Table: ContactEmployee                                       */
/*==============================================================*/
create table Shop.ContactEmployee (
   EmployeeID           int                  not null,
   ContactID            int                  not null,
   constraint PK_CONTACTEMPLOYEE primary key (EmployeeID, ContactID)
)
go

/*==============================================================*/
/* Index: Contact_Employee2_FK                                  */
/*==============================================================*/
create index Contact_Employee2_FK on Shop.ContactEmployee (
ContactID ASC
)
go

/*==============================================================*/
/* Index: Contact_Employee_FK                                   */
/*==============================================================*/
create index Contact_Employee_FK on Shop.ContactEmployee (
EmployeeID ASC
)
go

/*==============================================================*/
/* Table: Contacts                                              */
/*==============================================================*/
create table Shop.Contacts (
   ContactID            int                  identity,
   Title                nvarchar(50)         null,
   FirstName            nvarchar(255)        not null,
   MiddleName           nvarchar(255)        null,
   LastName             nvarchar(255)        not null,
   Gender               nvarchar(50)         not null,
   BirthDay             nvarchar(50)         not null,
   Email                nvarchar(255)        not null,
   Phone                nvarchar(50)         not null,
   constraint PK_CONTACTS primary key (ContactID)
)
go

/*==============================================================*/
/* Table: Customers                                             */
/*==============================================================*/
create table Shop.Customers (
   CustomerID           int                  identity,
   Discount             float                null,
   constraint PK_CUSTOMERS primary key (CustomerID)
)
go

/*==============================================================*/
/* Table: Employees                                             */
/*==============================================================*/
create table Shop.Employees (
   EmployeeID           int                  identity,
   ManagerID            int                  null,
   RoleTitle            nvarchar(255)        not null,
   HireDate             datetime             not null,
   IsActive             tinyint              not null,
   constraint PK_EMPLOYEES primary key (EmployeeID)
)
go

/*==============================================================*/
/* Index: Employee_Employee_FK                                  */
/*==============================================================*/
create index Employee_Employee_FK on Shop.Employees (
ManagerID ASC
)
go

/*==============================================================*/
/* Table: ErrorLogs                                             */
/*==============================================================*/
create table Logs.ErrorLogs (
   ErrorID              int                  identity,
   OperationRunID       int                  not null,
   ErrorNumber          int                  null,
   ErrorProcName        nvarchar(1024)       null,
   Parameters           nvarchar(Max)       null,
   ErrorMessage         nvarchar(Max)        not null,
   ErrorDateTime        datetime             not null,
   constraint PK_ERRORLOGS primary key (ErrorID)
)
go

/*==============================================================*/
/* Index: OperationRun_Log_FK                                   */
/*==============================================================*/
create index OperationRun_Log_FK on Logs.ErrorLogs (
OperationRunID ASC
)
go

/*==============================================================*/
/* Table: EventLogs                                             */
/*==============================================================*/
create table Logs.EventLogs (
   EventID              int                  identity,
   OperationRunID       int                  not null,
   UserName             nvarchar(100)        null,
   AffectedRows         int                  null,
   EventProcName        nvarchar(1024)       null,
   Parameters           nvarchar(Max)       null,
   EventMessage         nvarchar(Max)        not null,
   EventDateTime        datetime             not null,
   constraint PK_EVENTLOGS primary key (EventID)
)
go

/*==============================================================*/
/* Index: OperationRun_Event_FK                                 */
/*==============================================================*/
create index OperationRun_Event_FK on Logs.EventLogs (
OperationRunID ASC
)
go

/*==============================================================*/
/* Table: OperationRuns                                         */
/*==============================================================*/
create table Logs.OperationRuns (
   OperationRunID       int                  identity,
   StatusID             int                  not null,
   OperationID          int                  not null,
   StartTime            datetime             not null,
   EndTime              datetime             not null default {ts'9999-12-31 23:59:59'},

   Description          nvarchar(Max)        not null,
   constraint PK_OPERATIONRUNS primary key (OperationRunID)
)
go

/*==============================================================*/
/* Index: OperationStatus_OperationRun_FK                       */
/*==============================================================*/
create index OperationStatus_OperationRun_FK on Logs.OperationRuns (
StatusID ASC
)
go

/*==============================================================*/
/* Index: Operation_OperationRun_FK                             */
/*==============================================================*/
create index Operation_OperationRun_FK on Logs.OperationRuns (
OperationID ASC
)
go

/*==============================================================*/
/* Table: OperationStatuses                                     */
/*==============================================================*/
create table Logs.OperationStatuses (
   StatusID             int                  identity,
   Status               nvarchar(50)         not null,
   StatusName           nvarchar(100)        not null,
   Description          nvarchar(Max)        not null,
   constraint PK_OPERATIONSTATUSES primary key (StatusID)
)
go

/*==============================================================*/
/* Table: Operations                                            */
/*==============================================================*/
create table Logs.Operations (
   OperationID          int                  identity,
   OperationName        nvarchar(255)        not null,
   Description          nvarchar(Max)        not null,
   constraint PK_OPERATIONS primary key (OperationID)
)
go

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
go

/*==============================================================*/
/* Index: Order_OrderDetail_FK                                  */
/*==============================================================*/
create index Order_OrderDetail_FK on Shop.OrderDetails (
OrderID ASC
)
go

/*==============================================================*/
/* Index: Product_OrderDetail_FK                                */
/*==============================================================*/
create index Product_OrderDetail_FK on Shop.OrderDetails (
ProductID ASC
)
go

/*==============================================================*/
/* Table: OrderStatus                                           */
/*==============================================================*/
create table Shop.OrderStatus (
   OrderStatusID        int                  identity,
   OrderStatusName      nvarchar(255)        not null,
   Description          nvarchar(Max)        not null,
   constraint PK_ORDERSTATUS primary key nonclustered (OrderStatusID)
)
go

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
go

/*==============================================================*/
/* Index: Address_Order_FK                                      */
/*==============================================================*/
create index Address_Order_FK on Shop.Orders (
AddressID ASC
)
go

/*==============================================================*/
/* Index: Customer_Order_FK                                     */
/*==============================================================*/
create index Customer_Order_FK on Shop.Orders (
CustomerID ASC
)
go

/*==============================================================*/
/* Index: Employee_Order_FK                                     */
/*==============================================================*/
create index Employee_Order_FK on Shop.Orders (
EmployeeID ASC
)
go

/*==============================================================*/
/* Index: OrderStatus_Orders_FK                                 */
/*==============================================================*/
create index OrderStatus_Orders_FK on Shop.Orders (
OrderStatusID ASC
)
go

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
go

/*==============================================================*/
/* Index: Product_ProductPrice_FK                               */
/*==============================================================*/
create index Product_ProductPrice_FK on Shop.ProductPrices (
ProductID ASC
)
go

/*==============================================================*/
/* Index: ProductPrice_VersionStart_FK                          */
/*==============================================================*/
create index ProductPrice_VersionStart_FK on Shop.ProductPrices (
StartVersion ASC
)
go

/*==============================================================*/
/* Index: ProductPrice_VersionEnd_FK                            */
/*==============================================================*/
create index ProductPrice_VersionEnd_FK on Shop.ProductPrices (
EndVersion ASC
)
go

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
go

/*==============================================================*/
/* Index: Category_Product_FK                                   */
/*==============================================================*/
create index Category_Product_FK on Shop.Products (
CategoryID ASC
)
go

/*==============================================================*/
/* Table: VersionTypes                                          */
/*==============================================================*/
create table Logs.VersionTypes (
   VersionTypeID        int                  identity,
   VersionTypeName      nvarchar(255)        not null,
   EntityID             int                  not null,
   Description          nvarchar(Max)        not null,
   constraint PK_VERSIONTYPES primary key (VersionTypeID)
)
go

/*==============================================================*/
/* Index: EnityID_FK                                            */
/*==============================================================*/
create index EnityID_FK on Logs.VersionTypes (
EntityID ASC
)
go

/*==============================================================*/
/* Table: Versions                                              */
/*==============================================================*/
create table Logs.Versions (
   VersionID            int                  identity,
   VersionTypeID        int                  not null,
   OperationRunID       int                  not null,
   VersionNumber        int                  not null,
   Description          nvarchar(Max)        not null,
   CreateDate           datetime             not null,
   constraint PK_VERSIONS primary key (VersionID)
)
go

/*==============================================================*/
/* Index: VersionType_Version_FK                                */
/*==============================================================*/
create index VersionType_Version_FK on Logs.Versions (
VersionTypeID ASC
)
go

/*==============================================================*/
/* Index: OperationRun_Version_FK                               */
/*==============================================================*/
create index OperationRun_Version_FK on Logs.Versions (
OperationRunID ASC
)
go

/*==============================================================*/
/* Index: VersionNumber_FK                                      */
/*==============================================================*/
create index VersionNumber_FK on Logs.Versions (
VersionNumber ASC
)
go

