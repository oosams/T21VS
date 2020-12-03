/*==============================================================*/
/* Database name:  T21                                          */
/* DBMS name:      Microsoft SQL Server 2012                    */
/* Created on:     03-Dec-20 10:25:34 PM                        */
/*==============================================================*/



use T21
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

alter table Shop.ProductPrices
   add constraint FK_PRODUCTS_PRODUCTPRICES foreign key (ProductID)
      references Shop.Products (ProductID)
go

alter table Shop.Products
   add constraint FK_CATEGORIES_PRODUCTS foreign key (CategoryID)
      references Shop.Categories (CategoryID)
go

alter table Logs.Versions
   add constraint FK_OPERATIONRUNS_VERSIONS foreign key (OperationRunID)
      references Logs.OperationRuns (OperationRunID)
go

alter table Logs.Versions
   add constraint FK_VERSIONTYPES_VERSIONS foreign key (VersionTypeID)
      references Logs.VersionTypes (VersionTypeID)
go

