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