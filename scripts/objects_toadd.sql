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


	---- staging Vendor Delivery ----

DROP TABLE IF EXISTS Staging.VendorDelivery
CREATE TABLE Staging.VendorDelivery(
	 Make_Name				NVARCHAR(MAX)
	,Make_Desc				NVARCHAR(MAX)
	,Make_Guid				NVARCHAR(MAX)			
	,Product_Model_Name		NVARCHAR(MAX)			
	,Model_Desc				NVARCHAR(MAX)
	,Model_Guid				NVARCHAR(MAX)
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


 





