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

-----For Excel Dynamic Input all columns
DROP TABLE IF EXISTS Staging.ExcelTest
CREATE TABLE Staging.ExcelTest(
	 Col1				NVARCHAR(MAX)
	,Col2				NVARCHAR(MAX)	 
	,Col3				NVARCHAR(MAX)
	,Col4				NVARCHAR(MAX)
	,Col5				NVARCHAR(MAX)
	,Col6				NVARCHAR(MAX)
	,Col7				NVARCHAR(MAX)
	,Col8				NVARCHAR(MAX)
	,Col9				NVARCHAR(MAX)
	,Col10				NVARCHAR(MAX)
	,Col11				NVARCHAR(MAX)
	,Col12				NVARCHAR(MAX)	 
	,Col13				NVARCHAR(MAX)
	,Col14				NVARCHAR(MAX)
	,Col15				NVARCHAR(MAX)
	,Col16				NVARCHAR(MAX)
	,Col17				NVARCHAR(MAX)
	,Col18				NVARCHAR(MAX)
	,Col19				NVARCHAR(MAX)
	,Col20				NVARCHAR(MAX)
	,Col21				NVARCHAR(MAX)
	,Col22				NVARCHAR(MAX)	 
	,Col23				NVARCHAR(MAX)
	,Col24				NVARCHAR(MAX)
	,Col25				NVARCHAR(MAX)
	,Col26				NVARCHAR(MAX)
	,Col27				NVARCHAR(MAX)
	,Col28				NVARCHAR(MAX)
	,Col29				NVARCHAR(MAX)
	,Col30				NVARCHAR(MAX)
)
GO

 -----For Excel Dynamic Input
DROP TABLE IF EXISTS Staging.ExcelColumns
CREATE TABLE Staging.ExcelColumns(
	 Make_name					NVARCHAR(MAX)
	,Make_guid					uniqueidentifier
	,Product_Model_Name			NVARCHAR(MAX)
	,Model_guid					uniqueidentifier
	,Model_Specifications_1		NVARCHAR(MAX)		
	,Model_Specifications_2		NVARCHAR(MAX)	
	,Quantity					INT		
	,Unit_Price					INT	
)
GO

 


				 