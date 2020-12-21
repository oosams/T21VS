select 1;
/****** Script for SelectTopNRows command from SSMS  ******/
SELECT TOP (1000) [ProductPriceID]
      ,[ProductID]
      ,[UnitPrice]
      ,[StartVersion]
      ,[EndVersion]
  FROM [T21].[Shop].[ProductPrices]
  
  select 2