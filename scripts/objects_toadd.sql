USE MASTER
GO
USE T21
GO

		--vw_ProductCategoryPrice
 SELECT
	   p.ProductID
      ,p.ProductName
	  ,c.CategoryID
	  ,c.CategoryName
	  ,c.Description
      ,p.Quantity
	  ,pp.UnitPrice
      ,p.IsActive
      ,p.Description
  FROM Shop.Products p
  JOIN Shop.Categories c ON p.CategoryID = c.CategoryID
  JOIN Shop.ProductPrices pp ON p.ProductID = pp.ProductID	
  WHERE 1=1
	AND pp.EndVersion = 999999999

	------------------------------------------------




SELECT * FROM  Staging.VendorDeliveryNewMapping 
 

SELECT * FROM  Staging.VendorDeliveryMapped 
WHERE Product_Model_id IS NULL
 
SELECT * FROM  Staging.VendorDelivery 
order by file_name, make_name

SELECT * FROM Logs.EventLogs
SELECT * FROM Logs.ErrorLogs
SELECT * FROM Logs.OperationRuns
SELECT * FROM [Shop].[Products]


TRUNCATE TABLE Staging.VendorDelivery;
GO
DBCC CHECKIDENT ('Staging.VendorDelivery', RESEED, 1);
GO
TRUNCATE TABLE Staging.VendorDeliveryMapped
GO
DBCC CHECKIDENT ('Staging.VendorDeliveryMapped', RESEED, 1);
GO
TRUNCATE TABLE Staging.VendorDeliveryNewMapping
GO

 
 
 
 
	---- staging Vendor Delivery ----

DROP TABLE IF EXISTS Staging.VendorDelivery
CREATE TABLE Staging.VendorDelivery(
	 rowID					INT IDENTITY(1,1)
	,File_Name				NVARCHAR(MAX)
	,Load_Date				NVARCHAR(MAX)
	,Make_Name				NVARCHAR(MAX)
	,Make_Desc				NVARCHAR(MAX)
	,Make_Guid				uniqueidentifier			
	,Product_Model_Name		NVARCHAR(MAX)			
	,Model_Desc				NVARCHAR(MAX)
	,Model_Guid				uniqueidentifier
	,Model_Specifications_1	NVARCHAR(MAX)
	,Model_Specifications_2	NVARCHAR(MAX)
	,Quantity				INT
	,Unit_Price				INT
	,Add_Field_1			NVARCHAR(MAX)
	,Add_Field_2			NVARCHAR(MAX)
	,Add_Field_3			NVARCHAR(MAX)
	,Add_Field_4			NVARCHAR(MAX)
	,Add_Field_5			NVARCHAR(MAX)
	,Add_Field_6			NVARCHAR(MAX)
	,Add_Field_7			NVARCHAR(MAX)
	,Add_Field_8			NVARCHAR(MAX)
	,Add_Field_9			NVARCHAR(MAX)
	,Add_Field_10			NVARCHAR(MAX)
)
GO
-----mapped
DROP TABLE IF EXISTS Staging.VendorDeliveryMapped
CREATE TABLE Staging.VendorDeliveryMapped(
	 rowID					INT IDENTITY(1,1)
	,Make_id				INT
	,Product_Model_id		INT
	,File_Name				NVARCHAR(MAX)
	,Load_Date				NVARCHAR(MAX)
	,Make_Name				NVARCHAR(MAX)
	,Make_Desc				NVARCHAR(MAX)
	,Make_Guid				uniqueidentifier			
	,Product_Model_Name		NVARCHAR(MAX)			
	,Model_Desc				NVARCHAR(MAX)
	,Model_Guid				uniqueidentifier
	,Model_Specifications_1	NVARCHAR(MAX)
	,Model_Specifications_2	NVARCHAR(MAX)
	,Quantity				INT
	,Unit_Price				INT
	,Add_Field_1			NVARCHAR(MAX)
	,Add_Field_2			NVARCHAR(MAX)
	,Add_Field_3			NVARCHAR(MAX)
	,Add_Field_4			NVARCHAR(MAX)
	,Add_Field_5			NVARCHAR(MAX)
	,Add_Field_6			NVARCHAR(MAX)
	,Add_Field_7			NVARCHAR(MAX)
	,Add_Field_8			NVARCHAR(MAX)
	,Add_Field_9			NVARCHAR(MAX)
	,Add_Field_10			NVARCHAR(MAX)
)
GO

-----to keep new mapping
DROP TABLE IF EXISTS Staging.VendorDeliveryNewMapping
CREATE TABLE Staging.VendorDeliveryNewMapping(
	 Make_id				INT
	,Make_Name				NVARCHAR(MAX)	 
	--,Make_Desc				NVARCHAR(MAX)
	,Make_Guid				uniqueidentifier
	,Product_Model_id		INT			
	,Product_Model_Name		NVARCHAR(MAX)			
	--,Model_Desc				NVARCHAR(MAX)
	,Model_Guid				uniqueidentifier 
)
GO









				 