USE MASTER
GO

USE T21
GO

DROP TYPE IF EXISTS Staging.type_OrderDetails;
CREATE TYPE Staging.type_OrderDetails AS TABLE
(
	OrderID INT,
	ProductID INT,
	UnitPrice MONEY,
	Quantity INT,
	Discount FLOAT
)
GO