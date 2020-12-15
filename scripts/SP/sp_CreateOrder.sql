USE MASTER;
GO

USE T21;
GO

-- Create new Order, return new OrderID

-------------
CREATE OR ALTER PROCEDURE shop.sp_CreateOrder
	@EmployeeID	INT,
	@CustomerID INT,
	@AddressID INT = NULL,
	@RequiredDate DATETIME = NULL,
	@OrderDetails Staging.type_OrderDetails READONLY
    

	   ,AddressID - opt input
      ,CustomerID - input
      ,EmployeeID - input
      ,OrderStatusID new 1, update when paid and shipped
      ,OrderDate current_timestamp
      ,RequiredDate - opt input
      ,ShipDate update when shipped

	   OrderID
      ,ProductID
      ,UnitPrice
      ,Quantity
      ,Discount

AS
BEGIN
	BEGIN TRY

		-- for logging
		DECLARE @curentParameters NVARCHAR(MAX) =  CONCAT(
			CHAR(9), '@EmployeeID = ', @EmployeeID, CHAR(13), CHAR(10),
			CHAR(9), '@CustomerID = ', @CustomerID, CHAR(13), CHAR(10),
			CHAR(9), '@AddressID = ', @AddressID, CHAR(13), CHAR(10),
			CHAR(9), '@RequiredDate = ', @RequiredDate, CHAR(13), CHAR(10),
			CHAR(9), '@OrderDetails = ', @OrderDetails, CHAR(13), CHAR(10));

		
		-- to keep new OperationRunID 
		DECLARE @curentRunID INT;	

		-- Start Operation and get new OperationRunID
		EXEC @curentRunID = 
			logs.sp_StartOperation   @OperationID = 6	-- INT     OperationID for Shop.sp_CreateCategory  from Logs.Operations
									,@Description = NULL	-- NVARCHAR(255), NULL
									,@OperationRunParameters = @curentParameters	-- NVARCHAR(MAX), NULL
		

		-- to keep new OrderID
		DECLARE @newCategoryID INT;		

		-- Create new Category
		INSERT INTO Shop.Categories(
			CategoryName,
			Description)
		VALUES(
			@CategoryName,
			@Description);
			 
		SET @newCategoryID = SCOPE_IDENTITY();

		-- throw event
		DECLARE @eventMessage NVARCHAR(MAX) = CONCAT('Created new Category with ID: ', @newCategoryID);
		EXEC logs.sp_SetEvent	 @runID = @curentRunID		-- INT						
								,@affectedRows = @@rowcount		-- INT, NULL
								,@procedureID = @@PROCID		-- INT, NULL
								,@parameters = @curentParameters	-- NVARCHAR(MAX), NULL
								,@eventMessage = @eventMessage		-- NVARCHAR(MAX)


		-- Complete Operation
		EXEC logs.sp_CompleteOperation   @OperationRunID = 	@curentRunID	 -- INT       -- get from sp_StartOperation
										,@OperationRunParameters = @curentParameters  -- NVARCHAR(MAX), NULL

		RETURN @newCategoryID;

	END TRY
	BEGIN CATCH
	
		-- throw Error
		EXEC logs.sp_SetError	 @runID = @curentRunID 		-- INT       -- get from sp_StartOperation
								,@procedureID = @@PROCID	-- INT, NULL
								,@parameters = @curentParameters	-- NVARCHAR(MAX), NULL
								,@errorMessage = 'Can not create Category'	-- NVARCHAR(MAX), NULL

		-- Fail Operation
		EXEC logs.sp_FailOperation   @OperationRunID = 	@curentRunID	 -- INT       -- get from sp_StartOperation
									,@OperationRunParameters = @curentParameters  -- NVARCHAR(MAX), NULL

		RETURN -1

	END CATCH
END
GO

----Add info in Logs.Operations------


SET IDENTITY_INSERT Logs.Operations ON;  

INSERT INTO Logs.Operations(
	OperationID,
	OperationName,
	Description)
VALUES
	(6,'Shop.sp_CreateCategory','Create new Category, return new CategoryID');
SET IDENTITY_INSERT Logs.Operations OFF;
GO
SELECT * FROM Logs.Operations

--------DEBUG---------
 
EXEC @iddd = shop.sp_CreateCategory  @CategoryName = 'TestCatName'	 -- NVARCHAR(255)
									,@Description = 'Test Category discription'  -- NVARCHAR(MAX)
 
 

SELECT * FROM Shop.Orders
SELECT * FROM Shop.OrderDetails

SELECT * FROM Logs.EventLogs
SELECT * FROM Logs.ErrorLogs
SELECT * FROM Logs.OperationRuns
SELECT * FROM Logs.Operations

------------------------------
------------------------------

-------------
CREATE OR ALTER PROCEDURE shop.sp_CreateOrder
	@EmployeeID	INT,
	@CustomerID INT,
	@AddressID INT = NULL,
	@RequiredDate DATETIME = NULL,
	@OrderDetails Staging.type_OrderDetails READONLY

AS
	DECLARE @curentParameters NVARCHAR(MAX) =  CONCAT(
			CHAR(9), '@EmployeeID = ', @EmployeeID, CHAR(13), CHAR(10),
			CHAR(9), '@CustomerID = ', @CustomerID, CHAR(13), CHAR(10),
			CHAR(9), '@AddressID = ', @AddressID, CHAR(13), CHAR(10),
			CHAR(9), '@RequiredDate = ', @RequiredDate, CHAR(13), CHAR(10),
			CHAR(9), '@OrderDetails = ', @OrderDetails, CHAR(13), CHAR(10));

	SELECT @curentParameters
GO



DECLARE @OrderDetails Staging.type_OrderDetails

INSERT INTO @OrderDetails 
VALUES
(1,11,12,13,14),
(2,21,22,23,24),
(3,31,32,33,34)

EXEC shop.sp_CreateOrder



select 'tab-->' + char(9) + '<--tab'