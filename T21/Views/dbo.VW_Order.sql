CREATE VIEW VW_Order  
AS  
SELECT OrderId,OrderCountryCode,OrderDate,OrderYear  FROM Orders  
UNION ALL  
SELECT OrderId,OrderCountryCode,OrderDate,OrderYear  FROM Orders_2018  
UNION ALL  
SELECT OrderId,OrderCountryCode,OrderDate,OrderYear  FROM Orders_2017  
