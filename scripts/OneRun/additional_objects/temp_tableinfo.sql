USE MASTER;
GO
USE T21;
GO

-----temp table list


DROP TABLE IF EXISTS Config.temp_tableinfo
CREATE TABLE Config.temp_tableinfo(
tablename nvarchar(1000));

INSERT INTO Config.temp_tableinfo
VALUES
('Shop.AddressCustomer'),
('Shop.AddressEmployee'),
('Shop.Addresses'),
('Shop.Categories'),
('Shop.ContactCustomer'),
('Shop.ContactEmployee'),
('Shop.Contacts'),
('Shop.Customers'),
('Shop.Employees'),
('Shop.OrderDetails'),
('Shop.OrderStatus'),
('Shop.Orders'),
('Shop.ProductPrices'),
('Shop.Products'),
('Logs.OperationStatuses'),
('Logs.VersionTypes'),
('Logs.Versions');
