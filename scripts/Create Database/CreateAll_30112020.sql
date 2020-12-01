/*==============================================================*/
/* Database name:  T21                                          */
/* DBMS name:      Microsoft SQL Server 2012                    */
/* Created on:     30-Nov-20 11:24:19 PM                        */
/*==============================================================*/


drop database T21
go

/*==============================================================*/
/* Database: T21                                                */
/*==============================================================*/
create database T21
on
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
/* User: Master                                                 */
/*==============================================================*/
create schema Master
go

/*==============================================================*/
/* User: Reporting                                              */
/*==============================================================*/
create schema Reporting
go

/*==============================================================*/
/* User: Staging                                                */
/*==============================================================*/
create schema Staging
go

/*==============================================================*/
/* Domain: [nvarchar(max)]                                      */
/*==============================================================*/
create type [nvarchar(max)]
   from nvarchar(Max)
go

/*==============================================================*/
/* Table: AddressCustomer                                       */
/*==============================================================*/
create table Master.AddressCustomer (
   CustomerID           int                  not null,
   AddressID            int                  not null,
   constraint PK_ADDRESSCUSTOMER primary key nonclustered (CustomerID, AddressID)
)
go

/*==============================================================*/
/* Index: Address_Customer2_FK                                  */
/*==============================================================*/
create index Address_Customer2_FK on Master.AddressCustomer (
AddressID ASC
)
go

/*==============================================================*/
/* Index: Address_Customer_FK                                   */
/*==============================================================*/
create index Address_Customer_FK on Master.AddressCustomer (
CustomerID ASC
)
go

/*==============================================================*/
/* Table: AddressEmployee                                       */
/*==============================================================*/
create table Master.AddressEmployee (
   EmployeeID           int                  not null,
   AddressID            int                  not null,
   constraint PK_ADDRESSEMPLOYEE primary key nonclustered (EmployeeID, AddressID)
)
go

/*==============================================================*/
/* Index: Address_Employee2_FK                                  */
/*==============================================================*/
create index Address_Employee2_FK on Master.AddressEmployee (
AddressID ASC
)
go

/*==============================================================*/
/* Index: Address_Employee_FK                                   */
/*==============================================================*/
create index Address_Employee_FK on Master.AddressEmployee (
EmployeeID ASC
)
go

/*==============================================================*/
/* Table: Addresses                                             */
/*==============================================================*/
create table Master.Addresses (
   AddressID            int                  not null,
   CityID               int                  not null,
   AddressLine1         nvarchar(255)        not null,
   AddressLine2         nvarchar(255)        null,
   PostalCode           nvarchar(10)         not null,
   constraint PK_ADDRESSES primary key nonclustered (AddressID)
)
go

/*==============================================================*/
/* Index: City_Address_FK                                       */
/*==============================================================*/
create index City_Address_FK on Master.Addresses (
CityID ASC
)
go

/*==============================================================*/
/* Table: Categories                                            */
/*==============================================================*/
create table Master.Categories (
   CategoryID           int                  not null,
   CategoryName         nvarchar(50)         not null,
   Description          [nvarchar(max)]      not null,
   constraint PK_CATEGORIES primary key nonclustered (CategoryID)
)
go

/*==============================================================*/
/* Table: Cities                                                */
/*==============================================================*/
create table Master.Cities (
   CityID               int                  not null,
   CountryID            smallint             not null,
   RegionID             smallint             not null,
   CityLatitude         decimal(11,8)        null,
   CityLongitude        decimal(11,8)        null,
   CityName             nvarchar(50)         not null,
   constraint PK_CITIES primary key nonclustered (CityID)
)
go

/*==============================================================*/
/* Index: Country_City_FK                                       */
/*==============================================================*/
create index Country_City_FK on Master.Cities (
CountryID ASC
)
go

/*==============================================================*/
/* Index: Region_City_FK                                        */
/*==============================================================*/
create index Region_City_FK on Master.Cities (
RegionID ASC
)
go

/*==============================================================*/
/* Table: ContactCustomer                                       */
/*==============================================================*/
create table Master.ContactCustomer (
   CustomerID           int                  not null,
   ContactID            int                  not null,
   constraint PK_CONTACTCUSTOMER primary key nonclustered (CustomerID, ContactID)
)
go

/*==============================================================*/
/* Index: Contact_Customer2_FK                                  */
/*==============================================================*/
create index Contact_Customer2_FK on Master.ContactCustomer (
ContactID ASC
)
go

/*==============================================================*/
/* Index: Contact_Customer_FK                                   */
/*==============================================================*/
create index Contact_Customer_FK on Master.ContactCustomer (
CustomerID ASC
)
go

/*==============================================================*/
/* Table: ContactEmployee                                       */
/*==============================================================*/
create table Master.ContactEmployee (
   EmployeeID           int                  not null,
   ContactID            int                  not null,
   constraint PK_CONTACTEMPLOYEE primary key nonclustered (EmployeeID, ContactID)
)
go

/*==============================================================*/
/* Index: Contact_Employee2_FK                                  */
/*==============================================================*/
create index Contact_Employee2_FK on Master.ContactEmployee (
ContactID ASC
)
go

/*==============================================================*/
/* Index: Contact_Employee_FK                                   */
/*==============================================================*/
create index Contact_Employee_FK on Master.ContactEmployee (
EmployeeID ASC
)
go

/*==============================================================*/
/* Table: Contacts                                              */
/*==============================================================*/
create table Master.Contacts (
   ContactID            int                  not null,
   Title                nvarchar(10)         null,
   FirstName            nvarchar(100)        not null,
   MiddleName           nvarchar(100)        null,
   LastName             nvarchar(100)        not null,
   Gender               nvarchar(10)         not null,
   BirthDay             nvarchar(15)         not null,
   Email                nvarchar(50)         not null,
   Phone                nvarchar(15)         not null,
   constraint PK_CONTACTS primary key nonclustered (ContactID)
)
go

/*==============================================================*/
/* Table: Countries                                             */
/*==============================================================*/
create table Master.Countries (
   CountryID            smallint             not null,
   CountryName          nvarchar(100)        not null,
   CountryCode          nvarchar(10)         null,
   constraint PK_COUNTRIES primary key nonclustered (CountryID)
)
go

/*==============================================================*/
/* Table: Customers                                             */
/*==============================================================*/
create table Master.Customers (
   CustomerID           int                  not null,
   Discount             float                null,
   constraint PK_CUSTOMERS primary key nonclustered (CustomerID)
)
go

/*==============================================================*/
/* Table: Employees                                             */
/*==============================================================*/
create table Master.Employees (
   EmployeeID           int                  not null,
   ManagerID            int                  null,
   RoleTitle            nvarchar(20)         not null,
   HireDate             datetime             not null,
   IsActive             tinyint              not null,
   constraint PK_EMPLOYEES primary key nonclustered (EmployeeID)
)
go

/*==============================================================*/
/* Index: Employee_Employee_FK                                  */
/*==============================================================*/
create index Employee_Employee_FK on Master.Employees (
ManagerID ASC
)
go

/*==============================================================*/
/* Table: ErrorLogs                                             */
/*==============================================================*/
create table Logs.ErrorLogs (
   ErrorID              int                  not null,
   EventID              int                  not null,
   OperationRunID       int                  not null,
   ErrorNumber          nvarchar(20)         null,
   ErrorProcName        nvarchar(255)        null,
   Parameters           nvarchar(1024)       null,
   ErrorMessage         [nvarchar(max)]      null,
   ErrorDateTime        datetime             not null,
   constraint PK_ERRORLOGS primary key nonclustered (ErrorID)
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
   EventID              int                  not null,
   OperationRunID       int                  not null,
   [User]               nvarchar(20)         null,
   AffectedRows         nvarchar(255)        null,
   EventProcName        nvarchar(255)        null,
   Parameters           nvarchar(1024)       null,
   EventMessage         [nvarchar(max)]      null,
   EventDateTime        datetime             not null,
   constraint PK_EVENTLOGS primary key nonclustered (EventID)
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
   OperationRunID       int                  not null,
   StatusID             int                  not null,
   OperationID          int                  not null,
   StartTime            datetime             not null,
   EndTime              datetime             not null,
   Description          [nvarchar(max)]      not null,
   constraint PK_OPERATIONRUNS primary key nonclustered (OperationRunID)
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
   StatusID             int                  not null,
   Status               nvarchar(1)          not null,
   StatusName           nvarchar(20)         not null,
   Description          [nvarchar(max)]      not null,
   constraint PK_OPERATIONSTATUSES primary key nonclustered (StatusID)
)
go

/*==============================================================*/
/* Table: Operations                                            */
/*==============================================================*/
create table Logs.Operations (
   OperationID          int                  not null,
   OperationName        nvarchar(100)        not null,
   Description          [nvarchar(max)]      not null,
   constraint PK_OPERATIONS primary key nonclustered (OperationID)
)
go

/*==============================================================*/
/* Table: OrderDetails                                          */
/*==============================================================*/
create table Master.OrderDetails (
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
create index Order_OrderDetail_FK on Master.OrderDetails (
OrderID ASC
)
go

/*==============================================================*/
/* Index: Product_OrderDetail_FK                                */
/*==============================================================*/
create index Product_OrderDetail_FK on Master.OrderDetails (
ProductID ASC
)
go

/*==============================================================*/
/* Table: Orders                                                */
/*==============================================================*/
create table Master.Orders (
   OrderID              int                  not null,
   AddressID            int                  not null,
   PaymentID            int                  not null,
   CustomerID           int                  not null,
   EmployeeID           int                  not null,
   OrderStatus          nvarchar(30)         not null,
   OrderDate            datetime             not null,
   RequiredDate         datetime             null,
   ShipDate             datetime             null,
   Freight              money                null,
   SalesTax             decimal(5,2)         null,
   constraint PK_ORDERS primary key nonclustered (OrderID)
)
go

/*==============================================================*/
/* Index: Address_Order_FK                                      */
/*==============================================================*/
create index Address_Order_FK on Master.Orders (
AddressID ASC
)
go

/*==============================================================*/
/* Index: Payment_Order_FK                                      */
/*==============================================================*/
create index Payment_Order_FK on Master.Orders (
PaymentID ASC
)
go

/*==============================================================*/
/* Index: Customer_Order_FK                                     */
/*==============================================================*/
create index Customer_Order_FK on Master.Orders (
CustomerID ASC
)
go

/*==============================================================*/
/* Index: Employee_Order_FK                                     */
/*==============================================================*/
create index Employee_Order_FK on Master.Orders (
EmployeeID ASC
)
go

/*==============================================================*/
/* Table: Payments                                              */
/*==============================================================*/
create table Master.Payments (
   PaymentID            int                  not null,
   PaymentType          nvarchar(40)         not null,
   PaymentStatus        nvarchar(20)         not null,
   constraint PK_PAYMENTS primary key nonclustered (PaymentID)
)
go

/*==============================================================*/
/* Table: Products                                              */
/*==============================================================*/
create table Master.Products (
   ProductID            int                  not null,
   CategoryID           int                  not null,
   ProductName          nvarchar(50)         not null,
   IsActive             tinyint              not null,
   Description          [nvarchar(max)]      not null,
   constraint PK_PRODUCTS primary key nonclustered (ProductID)
)
go

/*==============================================================*/
/* Index: Category_Product_FK                                   */
/*==============================================================*/
create index Category_Product_FK on Master.Products (
CategoryID ASC
)
go

/*==============================================================*/
/* Table: Regions                                               */
/*==============================================================*/
create table Master.Regions (
   RegionID             smallint             not null,
   CountryID            smallint             not null,
   RegionName           nvarchar(255)        not null,
   RegionCode           nvarchar(10)         null,
   constraint PK_REGIONS primary key nonclustered (RegionID)
)
go

/*==============================================================*/
/* Index: Country_Region_FK                                     */
/*==============================================================*/
create index Country_Region_FK on Master.Regions (
CountryID ASC
)
go

/*==============================================================*/
/* Table: VersionTypes                                          */
/*==============================================================*/
create table Master.VersionTypes (
   VersionTypeID        int                  not null,
   VersionTypeName      nvarchar(50)         not null,
   Description          [nvarchar(max)]      not null,
   constraint PK_VERSIONTYPES primary key nonclustered (VersionTypeID)
)
go

/*==============================================================*/
/* Table: Versions                                              */
/*==============================================================*/
create table Master.Versions (
   VersionID            int                  not null,
   VersionTypeID        int                  not null,
   OperationRunID       int                  not null,
   Version              int                  not null,
   Description          [nvarchar(max)]      not null,
   StartDate            datetime             not null,
   EndDate              datetime             not null,
   constraint PK_VERSIONS primary key nonclustered (VersionID)
)
go

/*==============================================================*/
/* Index: VersionType_Version_FK                                */
/*==============================================================*/
create index VersionType_Version_FK on Master.Versions (
VersionTypeID ASC
)
go

/*==============================================================*/
/* Index: OperationRun_Version_FK                               */
/*==============================================================*/
create index OperationRun_Version_FK on Master.Versions (
OperationRunID ASC
)
go

/*==============================================================*/
/* Table: Warehouse                                             */
/*==============================================================*/
create table Master.Warehouse (
   WarehouseID          int                  not null,
   ProductID            int                  not null,
   StartVersion         int                  not null,
   EndVersion           int                  not null,
   UnitPrice            money                not null,
   Quantity             int                  not null,
   Description          [nvarchar(max)]      not null,
   constraint PK_WAREHOUSE primary key nonclustered (WarehouseID)
)
go

/*==============================================================*/
/* Index: Product_Warehouse_FK                                  */
/*==============================================================*/
create index Product_Warehouse_FK on Master.Warehouse (
ProductID ASC
)
go

/*==============================================================*/
/* Index: Version_WarehouseStart_FK                             */
/*==============================================================*/
create index Version_WarehouseStart_FK on Master.Warehouse (
StartVersion ASC
)
go

/*==============================================================*/
/* Index: Version_WarehouseEnd_FK                               */
/*==============================================================*/
create index Version_WarehouseEnd_FK on Master.Warehouse (
EndVersion ASC
)
go

alter table Master.AddressCustomer
   add constraint FK_CUSTOMERS_ADDRESSCUSTOMER foreign key (CustomerID)
      references Master.Customers (CustomerID)
go

alter table Master.AddressCustomer
   add constraint FK_ADDRESSES_ADDRESSCUSTOMER foreign key (AddressID)
      references Master.Addresses (AddressID)
go

alter table Master.AddressEmployee
   add constraint FK_EMPLOYEES_ADDRESSEMPLOYEE foreign key (EmployeeID)
      references Master.Employees (EmployeeID)
go

alter table Master.AddressEmployee
   add constraint FK_ADDRESSES_ADDRESSEMPLOYEE foreign key (AddressID)
      references Master.Addresses (AddressID)
go

alter table Master.Addresses
   add constraint FK_CITIES_ADDRESSES foreign key (CityID)
      references Master.Cities (CityID)
go

alter table Master.Cities
   add constraint FK_COUNTRIES_CITIES foreign key (CountryID)
      references Master.Countries (CountryID)
go

alter table Master.Cities
   add constraint FK_REGIONS_CITIES foreign key (RegionID)
      references Master.Regions (RegionID)
go

alter table Master.ContactCustomer
   add constraint FK_CUSTOMERS_CONTACTCUSTOMER foreign key (CustomerID)
      references Master.Customers (CustomerID)
go

alter table Master.ContactCustomer
   add constraint FK_CONTACTS_CONTACTCUSTOMER foreign key (ContactID)
      references Master.Contacts (ContactID)
go

alter table Master.ContactEmployee
   add constraint FK_EMPLOYEES_CONTACTEMPLOYEE foreign key (EmployeeID)
      references Master.Employees (EmployeeID)
go

alter table Master.ContactEmployee
   add constraint FK_CONTACTS_CONTACTEMPLOYEE foreign key (ContactID)
      references Master.Contacts (ContactID)
go

alter table Master.Employees
   add constraint FK_EMPLOYEES_EMPLOYEES foreign key (ManagerID)
      references Master.Employees (EmployeeID)
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
   add constraint FK_OPERATIONSTATUSE_OPERATIONRUNS foreign key (StatusID)
      references Logs.OperationStatuses (StatusID)
go

alter table Logs.OperationRuns
   add constraint FK_OPERATIONS_OPERATIONRUNS foreign key (OperationID)
      references Logs.Operations (OperationID)
go

alter table Master.OrderDetails
   add constraint FK_ORDERS_ORDERDETAILS foreign key (OrderID)
      references Master.Orders (OrderID)
go

alter table Master.OrderDetails
   add constraint FK_PRODUCTS_ORDERDETAILS foreign key (ProductID)
      references Master.Products (ProductID)
go

alter table Master.Orders
   add constraint FK_ADDRESSES_ORDERS foreign key (AddressID)
      references Master.Addresses (AddressID)
go

alter table Master.Orders
   add constraint FK_CUSTOMERS_ORDERS foreign key (CustomerID)
      references Master.Customers (CustomerID)
go

alter table Master.Orders
   add constraint FK_EMPLOYEES_ORDERS foreign key (EmployeeID)
      references Master.Employees (EmployeeID)
go

alter table Master.Orders
   add constraint FK_PAYMENTS_ORDERS foreign key (PaymentID)
      references Master.Payments (PaymentID)
go

alter table Master.Products
   add constraint FK_CATEGORIES_PRODUCTS foreign key (CategoryID)
      references Master.Categories (CategoryID)
go

alter table Master.Regions
   add constraint FK_COUNTRIES_REGIONS foreign key (CountryID)
      references Master.Countries (CountryID)
go

alter table Master.Versions
   add constraint FK_OPERATIONRUNS_VERSIONS foreign key (OperationRunID)
      references Logs.OperationRuns (OperationRunID)
go

alter table Master.Versions
   add constraint FK_VERSIONTYPES_VERSIONS foreign key (VersionTypeID)
      references Master.VersionTypes (VersionTypeID)
go

alter table Master.Warehouse
   add constraint FK_PRODUCTS_WAREHOUSE foreign key (ProductID)
      references Master.Products (ProductID)
go

alter table Master.Warehouse
   add constraint FK_VERSIONS_WAREHOUSE_End foreign key (EndVersion)
      references Master.Versions (VersionID)
go

alter table Master.Warehouse
   add constraint FK_VERSIONS_WAREHOUSE_Start foreign key (StartVersion)
      references Master.Versions (VersionID)
go

