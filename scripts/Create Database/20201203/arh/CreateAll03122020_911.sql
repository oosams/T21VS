/*==============================================================*/
/* Database name:  T21                                          */
/* DBMS name:      Microsoft SQL Server 2012                    */
/* Created on:     03-Dec-20 9:11:58 PM                         */
/*==============================================================*/
use master

drop database T21
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
   EventID              int                  not null,
   OperationRunID       int                  not null,
   ErrorNumber          int                  null,
   ErrorProcName        nvarchar(1024)       null,
   Parameters           nvarchar(1024)       null,
   ErrorMessage         nvarchar(Max)        not null,
   ErrorDateTime        datetime             not null,
   constraint PK_ERRORLOGS primary key (ErrorID)
)
go

/*==============================================================*/
/* Index: Event_Error_FK                                        */
/*==============================================================*/
create index Event_Error_FK on Logs.ErrorLogs (
EventID ASC
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
   [User]               nvarchar(100)        null,
   AffectedRows         int                  null,
   EventProcName        nvarchar(1024)       null,
   Parameters           nvarchar(1024)       null,
   EventMessage         real                 not null,
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
   EndTime              datetime             not null,
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
/* Table: Products                                              */
/*==============================================================*/
create table Shop.Products (
   ProductID            int                  identity,
   CategoryID           int                  not null,
   ProductName          nvarchar(255)        not null,
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
create table Shop.VersionTypes (
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
create index EnityID_FK on Shop.VersionTypes (
EntityID ASC
)
go

/*==============================================================*/
/* Table: Versions                                              */
/*==============================================================*/
create table Shop.Versions (
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
create index VersionType_Version_FK on Shop.Versions (
VersionTypeID ASC
)
go

/*==============================================================*/
/* Index: OperationRun_Version_FK                               */
/*==============================================================*/
create index OperationRun_Version_FK on Shop.Versions (
OperationRunID ASC
)
go

/*==============================================================*/
/* Table: Warehouse                                             */
/*==============================================================*/
create table Shop.Warehouse (
   WarehouseID          int                  identity,
   ProductID            int                  not null,
   UnitPrice            money                not null,
   Quantity             int                  not null,
   Description          nvarchar(Max)        not null,
   StartVersion         int                  not null,
   EndVersion           int                  not null default 999999999,
   constraint PK_WAREHOUSE primary key (WarehouseID)
)
go

/*==============================================================*/
/* Index: Product_Warehouse_FK                                  */
/*==============================================================*/
create index Product_Warehouse_FK on Shop.Warehouse (
ProductID ASC
)
go

/*==============================================================*/
/* Index: Version_WarehouseStart_FK                             */
/*==============================================================*/
create index Version_WarehouseStart_FK on Shop.Warehouse (
StartVersion ASC
)
go

/*==============================================================*/
/* Index: Version_WarehouseEnd_FK                               */
/*==============================================================*/
create index Version_WarehouseEnd_FK on Shop.Warehouse (
EndVersion ASC
)
go

alter table Shop.AddressCustomer
   add constraint FK_CUSTOMERS_ADDRESSCUSTOMER foreign key (CustomerID)
      references Shop.Customers (CustomerID)
go

alter table Shop.AddressCustomer
   add constraint FK_ADDRESSES_ADDRESSCUSTOMER foreign key (AddressID)
      references Shop.Addresses (AddressID)
go

alter table Shop.AddressEmployee
   add constraint FK_EMPLOYEES_ADDRESSEMPLOYEE foreign key (EmployeeID)
      references Shop.Employees (EmployeeID)
go

alter table Shop.AddressEmployee
   add constraint FK_ADDRESSES_ADDRESSEMPLOYEE foreign key (AddressID)
      references Shop.Addresses (AddressID)
go

alter table Shop.ContactCustomer
   add constraint FK_CUSTOMERS_CONTACTCUSTOMER foreign key (CustomerID)
      references Shop.Customers (CustomerID)
go

alter table Shop.ContactCustomer
   add constraint FK_CONTACTS_CONTACTCUSTOMER foreign key (ContactID)
      references Shop.Contacts (ContactID)
go

alter table Shop.ContactEmployee
   add constraint FK_EMPLOYEES_CONTACTEMPLOYEE foreign key (EmployeeID)
      references Shop.Employees (EmployeeID)
go

alter table Shop.ContactEmployee
   add constraint FK_CONTACTS_CONTACTEMPLOYEE foreign key (ContactID)
      references Shop.Contacts (ContactID)
go

alter table Shop.Employees
   add constraint FK_EMPLOYEES_EMPLOYEES foreign key (ManagerID)
      references Shop.Employees (EmployeeID)
go

alter table Logs.ErrorLogs
   add constraint FK_EVENTLOGS_ERRORLOGS foreign key (EventID)
      references Logs.EventLogs (EventID)
go

alter table Logs.ErrorLogs
   add constraint FK_OPERATIONRUNS_ERRORLOGS foreign key (OperationRunID)
      references Logs.OperationRuns (OperationRunID)
go

alter table Logs.EventLogs
   add constraint FK_OPERATIONRUNS_EVENTLOGS foreign key (OperationRunID)
      references Logs.OperationRuns (OperationRunID)
go

alter table Logs.OperationRuns
   add constraint FK_OPERATIONSTATUSES_OPERATIONRUNS foreign key (StatusID)
      references Logs.OperationStatuses (StatusID)
go

alter table Logs.OperationRuns
   add constraint FK_OPERATIONS_OPERATIONRUNS foreign key (OperationID)
      references Logs.Operations (OperationID)
go

alter table Shop.OrderDetails
   add constraint FK_ORDERS_ORDERDETAILS foreign key (OrderID)
      references Shop.Orders (OrderID)
go

alter table Shop.OrderDetails
   add constraint FK_PRODUCTS_ORDERDETAILS foreign key (ProductID)
      references Shop.Products (ProductID)
go

alter table Shop.Orders
   add constraint FK_ADDRESSES_ORDERS foreign key (AddressID)
      references Shop.Addresses (AddressID)
go

alter table Shop.Orders
   add constraint FK_CUSTOMERS_ORDERS foreign key (CustomerID)
      references Shop.Customers (CustomerID)
go

alter table Shop.Orders
   add constraint FK_EMPLOYEES_ORDERS foreign key (EmployeeID)
      references Shop.Employees (EmployeeID)
go

alter table Shop.Orders
   add constraint FK_ORDERSTATUS_ORDERS foreign key (OrderStatusID)
      references Shop.OrderStatus (OrderStatusID)
go

alter table Shop.Products
   add constraint FK_CATEGORIES_PRODUCTS foreign key (CategoryID)
      references Shop.Categories (CategoryID)
go

alter table Shop.Versions
   add constraint FK_OPERATIONRUNS_VERSIONS foreign key (OperationRunID)
      references Logs.OperationRuns (OperationRunID)
go

alter table Shop.Versions
   add constraint FK_VERSIONTYPES_VERSIONS foreign key (VersionTypeID)
      references Shop.VersionTypes (VersionTypeID)
go

alter table Shop.Warehouse
   add constraint FK_PRODUCTS_WAREHOUSE foreign key (ProductID)
      references Shop.Products (ProductID)
go

