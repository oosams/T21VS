USE T21;
GO

-- Disable all constraints for database
EXEC sp_msforeachtable "ALTER TABLE ? NOCHECK CONSTRAINT all"

--100 [Master].[Customers] 
 delete [Master].Customers;
 GO
BULK INSERT [Master].Customers
FROM 'D:\_Work\GitHub\T21VS\scripts\mockaroo\02122020\Customers.csv'
with (fieldterminator = ',',rowterminator = '0x0a',FIRSTROW = 2) 

--20+3 [Master].[Employees]
 delete [Master].Employees;
 GO
BULK INSERT [Master].Employees
FROM 'D:\_Work\GitHub\T21VS\scripts\mockaroo\02122020\Employees.csv'
with (fieldterminator = ',',rowterminator = '0x0a',FIRSTROW = 2) 



--120+10 [Master].[Contacts]   -- emaildomain - not used
delete [Master].Contacts;
 GO
BULK INSERT [Master].Contacts
FROM 'D:\_Work\GitHub\T21VS\scripts\mockaroo\02122020\Contacts.csv'
with (fieldterminator = ',',rowterminator = '0x0a',FIRSTROW = 2) 

--120+10 [Master].[Addresses] 
 delete [Master].Addresses;
 GO
BULK INSERT [Master].Addresses
FROM 'D:\_Work\GitHub\T21VS\scripts\mockaroo\02122020\Addresses.csv'
with (fieldterminator = ',',rowterminator = '0x0a',FIRSTROW = 2) 



--15 [Master].[AddressCustomer]
 delete [Master].[AddressCustomer];
 GO
BULK INSERT [Master].[AddressCustomer]
FROM 'D:\_Work\GitHub\T21VS\scripts\mockaroo\02122020\AddressCustomer.csv'
with (fieldterminator = ',',rowterminator = '0x0a',FIRSTROW = 2) 
--200 [Master].[AddressEmployee]
 delete [Master].AddressEmployee;
 GO
BULK INSERT [Master].AddressEmployee
FROM 'D:\_Work\GitHub\T21VS\scripts\mockaroo\02122020\AddressEmployee.csv'
with (fieldterminator = ',',rowterminator = '0x0a',FIRSTROW = 2) 


--15 [Master].[ContactCustomer]
 delete [Master].ContactCustomer;
 GO
BULK INSERT [Master].ContactCustomer
FROM 'D:\_Work\GitHub\T21VS\scripts\mockaroo\02122020\ContactCustomer.csv'
with (fieldterminator = ',',rowterminator = '0x0a',FIRSTROW = 2) 

--[Master].[ContactEmployee]
 delete [Master].ContactEmployee;
 GO
BULK INSERT [Master].ContactEmployee
FROM 'D:\_Work\GitHub\T21VS\scripts\mockaroo\02122020\ContactEmployee.csv'
with (fieldterminator = ',',rowterminator = '0x0a',FIRSTROW = 2) 



--20 [Master].[Categories]
 delete [Master].Categories;
 GO
BULK INSERT [Master].Categories
FROM 'D:\_Work\GitHub\T21VS\scripts\mockaroo\02122020\Categories.csv'
with (fieldterminator = ',',rowterminator = '0x0a',FIRSTROW = 2) 

--200 [Master].[Products]
 delete [Master].Products;
 GO
BULK INSERT [Master].Products
FROM 'D:\_Work\GitHub\T21VS\scripts\mockaroo\02122020\Products.csv'
with (fieldterminator = ',',rowterminator = '0x0a',FIRSTROW = 2) 
 
--200 [Master].[Warehouse]

 delete [Master].Warehouse;
 GO
BULK INSERT [Master].Warehouse
FROM 'D:\_Work\GitHub\T21VS\scripts\mockaroo\02122020\Warehouse.csv'
with (fieldterminator = ',',rowterminator = '0x0a',FIRSTROW = 2) 


--300 [Master].[Orders]
 delete [Master].Orders;
 GO
BULK INSERT [Master].Orders
FROM 'D:\_Work\GitHub\T21VS\scripts\mockaroo\02122020\Orders.csv'
with (fieldterminator = ',',rowterminator = '0x0a',FIRSTROW = 2) 

--300 [Master].[Payments]
 delete [Master].Payments;
 GO
BULK INSERT [Master].Payments
FROM 'D:\_Work\GitHub\T21VS\scripts\mockaroo\02122020\Payments.csv'
with (fieldterminator = ',',rowterminator = '0x0a',FIRSTROW = 2) 

--900 [Master].[OrderDetails]
 delete [Master].OrderDetails;
 GO
BULK INSERT [Master].OrderDetails
FROM 'D:\_Work\GitHub\T21VS\scripts\mockaroo\02122020\OrderDetails.csv'
with (fieldterminator = ',',rowterminator = '0x0a',FIRSTROW = 2) 


-- Enable all constraints for database
EXEC sp_msforeachtable "ALTER TABLE ? WITH CHECK CHECK CONSTRAINT all"


/****** Script for SelectTopNRows command from SSMS  ******/
USE master;

