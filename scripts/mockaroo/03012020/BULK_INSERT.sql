USE T21;
GO




-- Disable all constraints for database
EXEC sp_msforeachtable "ALTER TABLE ? NOCHECK CONSTRAINT all"

--100 [Shop].[Customers] 
 delete [Shop].Customers;

BULK INSERT [Shop].Customers
FROM 'D:\_Work\GitHub\T21VS\scripts\mockaroo\02122020\Customers.csv'
with (fieldterminator = ',',rowterminator = '0x0a',FIRSTROW = 2) 

--20+3 [Shop].[Employees]
 delete [Shop].Employees;
 GO
BULK INSERT [Shop].Employees
FROM 'D:\_Work\GitHub\T21VS\scripts\mockaroo\02122020\Employees.csv'
with (fieldterminator = ',',rowterminator = '0x0a',FIRSTROW = 2) 



--120+10 [Shop].[Contacts]   -- emaildomain - not used
delete [Shop].Contacts;
 GO
BULK INSERT [Shop].Contacts
FROM 'D:\_Work\GitHub\T21VS\scripts\mockaroo\02122020\Contacts.csv'
with (fieldterminator = ',',rowterminator = '0x0a',FIRSTROW = 2) 

--120+10 [Shop].[Addresses] 
 delete [Shop].Addresses;
 GO
BULK INSERT [Shop].Addresses
FROM 'D:\_Work\GitHub\T21VS\scripts\mockaroo\02122020\Addresses.csv'
with (fieldterminator = ',',rowterminator = '0x0a',FIRSTROW = 2) 



--100 + 5 [Shop].[AddressCustomer]
 delete [Shop].[AddressCustomer];
 GO
BULK INSERT [Shop].[AddressCustomer]
FROM 'D:\_Work\GitHub\T21VS\scripts\mockaroo\02122020\AddressCustomer.csv'
with (fieldterminator = ',',rowterminator = '0x0a',FIRSTROW = 2) 
--20 + 5 [Shop].[AddressEmployee]
 delete [Shop].AddressEmployee;
 GO
BULK INSERT [Shop].AddressEmployee
FROM 'D:\_Work\GitHub\T21VS\scripts\mockaroo\02122020\AddressEmployee.csv'
with (fieldterminator = ',',rowterminator = '0x0a',FIRSTROW = 2) 


--100 + 5  [Shop].[ContactCustomer]
 delete [Shop].ContactCustomer;
 GO
BULK INSERT [Shop].ContactCustomer
FROM 'D:\_Work\GitHub\T21VS\scripts\mockaroo\02122020\ContactCustomer.csv'
with (fieldterminator = ',',rowterminator = '0x0a',FIRSTROW = 2) 

--20 + 5 [Shop].[ContactEmployee]
 delete [Shop].ContactEmployee;
 GO
BULK INSERT [Shop].ContactEmployee
FROM 'D:\_Work\GitHub\T21VS\scripts\mockaroo\02122020\ContactEmployee.csv'
with (fieldterminator = ',',rowterminator = '0x0a',FIRSTROW = 2) 



--10 [Shop].[Categories]
 delete [Shop].Categories;
 GO
BULK INSERT [Shop].Categories
FROM 'D:\_Work\GitHub\T21VS\scripts\mockaroo\02122020\Categories.csv'
with (fieldterminator = ',',rowterminator = '0x0a',FIRSTROW = 2) 

--100 [Shop].[Products]
 delete [Shop].Products;
 GO
BULK INSERT [Shop].Products
FROM 'D:\_Work\GitHub\T21VS\scripts\mockaroo\02122020\Products.csv'
with (fieldterminator = ',',rowterminator = '0x0a',FIRSTROW = 2) 
 
--100 [Shop].[Warehouse]

 delete [Shop].Warehouse;
 GO
BULK INSERT [Shop].Warehouse
FROM 'D:\_Work\GitHub\T21VS\scripts\mockaroo\02122020\Warehouse.csv'
with (fieldterminator = ',',rowterminator = '0x0a',FIRSTROW = 2) 


---100    [Shop].[VersionTypes]    --in case of products -> version type for each product... for other enity -> for each enityID.
 delete [Shop].[VersionTypes]
 GO
BULK INSERT [Shop].[VersionTypes]
FROM 'D:\_Work\GitHub\T21VS\scripts\mockaroo\02122020\Warehouse.csv'
with (fieldterminator = ',',rowterminator = '0x0a',FIRSTROW = 2) 





--300 [Shop].[Orders]
 delete [Shop].Orders;
 GO
BULK INSERT [Shop].Orders
FROM 'D:\_Work\GitHub\T21VS\scripts\mockaroo\02122020\Orders.csv'
with (fieldterminator = ',',rowterminator = '0x0a',FIRSTROW = 2) 



--900 [Shop].[OrderDetails]
 delete [Shop].OrderDetails;
 GO
BULK INSERT [Shop].OrderDetails
FROM 'D:\_Work\GitHub\T21VS\scripts\mockaroo\02122020\OrderDetails.csv'
with (fieldterminator = ',',rowterminator = '0x0a',FIRSTROW = 2) 


-- Enable all constraints for database
EXEC sp_msforeachtable "ALTER TABLE ? WITH CHECK CHECK CONSTRAINT all"


/****** Script for SelectTopNRows command from SSMS  ******/
USE master;




SELECT
*
FROM
  	INFORMATION_SCHEMA.TABLES


-------WHILE

DECLARE @Counter INT 
SET @Counter = (SELECT count(*) from INFORMATION_SCHEMA.TABLES)

WHILE @Counter > 0


DECLARE @sqlCommand varchar(1000);		
DECLARE @table varchar (75);
DECLARE @FileExt VARCHAR(10);
DECLARE @Path VARCHAR(100);

set @table = @SchemaName + '.' + @TableName
set @FileExt = '.csv'
set @Path = 'D:\_Work\GitHub\T21VS\scripts\mockaroo\03012020\'
DECLARE @TableName VARCHAR(100)

DECLARE CUR CURSOR FAST_FORWARD FOR
    SELECT table_schema + '.' + table_name as tablename
    FROM   INFORMATION_SCHEMA.TABLES
     
OPEN CUR
FETCH NEXT FROM CUR INTO @SchemaName, @TableName
 
WHILE @@FETCH_STATUS = 0
BEGIN
	

	SET @sqlCommand = 'delete ' + @table +
		'; BULK INSERT ' + @table +
		' FROM '''+ @Path + @table +@FileExt+''' '+
		' with (fieldterminator = '','',rowterminator = ''0x0a'',FIRSTROW = 2, KEEPIDENTITY)'
	--select @sqlCommand
	EXECUTE(@sqlCommand)

   FETCH NEXT FROM CUR_TEST INTO @CursorTestID
END
CLOSE CUR
DEALLOCATE CUR
GO



------------dynamic sql

DECLARE @sqlCommand varchar(1000);		
DECLARE @table varchar (75);
DECLARE @FileExt VARCHAR(10);
DECLARE @Path VARCHAR(100);

set @table = 'Shop.Customers'
set @FileExt = '.csv'
set @Path = 'D:\_Work\GitHub\T21VS\scripts\mockaroo\03012020\'

SET @sqlCommand = 'delete ' + @table +
	'; BULK INSERT ' + @table +
	' FROM '''+ @Path + @table +@FileExt+''' '+
	' with (fieldterminator = '','',rowterminator = ''0x0a'',FIRSTROW = 2, KEEPIDENTITY)'
--select @sqlCommand
EXECUTE(@sqlCommand)



SELECT * FROM Shop.Customers;

--100 [Shop].[Customers] 
 delete [Shop].Customers;

BULK INSERT [Shop].Customers
FROM 'D:\_Work\GitHub\T21VS\scripts\mockaroo\02122020\Customers.csv'
with (fieldterminator = ',',rowterminator = '0x0a',FIRSTROW = 2, KEEPIDENTITY) 




