USE MASTER;
GO

USE T21;
GO

-----to keep integrity with data from InitialLoad 
SET IDENTITY_INSERT Logs.Operations ON;  

INSERT INTO Logs.Operations(
	OperationID,
	OperationName,
	Description)
VALUES
	(-1,'sp_InitialLoad','Hystorical - First Initial Load after db created');
SET IDENTITY_INSERT Logs.Operations OFF;
GO

SET IDENTITY_INSERT Logs.OperationRuns ON;  

INSERT INTO Logs.OperationRuns(
	OperationRunID,
	StatusID,
	OperationID,
	StartTime,
	EndTime,
	Description)
VALUES
	(-1,3,-1,'2020-12-04','2020-12-04','Hystorical - First Initial Load after db created.');
SET IDENTITY_INSERT Logs.OperationRuns OFF;
GO

---------------------Operations info for SP-----------

SET IDENTITY_INSERT Logs.Operations ON;
	
INSERT INTO Logs.Operations(
	 OperationID
	,OperationName 
	,Description)
VALUES
	 (1,'Config.sp_InitialLoadd','First Initial Load after db is created')
	,(2,'Shop.sp_CreateAddress','Create new Address, return new AddressID')
	,(3,'Shop.sp_CreateContact','Create new Contact, return new ContactID')
	,(4,'Shop.sp_CreateCustomer','Create new Customer, return new CustomerID')
	,(5,'Shop.sp_CreateEmployee','Create new Employee, return new EmployeeID')
	,(6,'Shop.sp_CreateCategory','Create new Category, return new CategoryID');
	,(7,'Shop.sp_CreateProduct','Create new Product, return new ProductID');
	,(8,'Shop.sp_UpdateQuantity','Update Product Quantity, return 1 if succeed')
	,(9,'Shop.sp_UpdatePrice','Update Product Price, return 1 if succeed')
	,(10,'Shop.sp_UpdateProduct','Update Product, works for price and quanity for now')
	,(11,'Shop.sp_CheckQuantity','Check Product Quantity, return 1 if order matches quantity, return -1 if not')
	,(12,'Shop.sp_CreateOrder','Create new Order, return new OrderID')
	,(13,'Shop.sp_UpdateOrder','Update Order, return 1 if succeed');


SET IDENTITY_INSERT Logs.Operations OFF;
GO

