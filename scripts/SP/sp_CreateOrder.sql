USE MASTER;
GO

USE T21;
GO

-- Create new Order, return new OrderID

-------------
CREATE OR ALTER PROCEDURE shop.sp_CreateOrder
	@AddressID INT = NULL,
	@CustomerID INT,
	@EmployeeID	INT,	
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
			CHAR(9), '@RequiredDate = ', @RequiredDate, CHAR(13), CHAR(10)
--todo			,CHAR(9), '@OrderDetails = ', @OrderDetails, CHAR(13), CHAR(10)
			);

		
		-- to keep new OperationRunID 
		DECLARE @curentRunID INT;	

		-- Start Operation and get new OperationRunID
		EXEC @curentRunID = 
			logs.sp_StartOperation   @OperationID = 10	-- INT     OperationID for Shop.sp_CreateOrder  from Logs.Operations
									,@Description = NULL	-- NVARCHAR(255), NULL
									,@OperationRunParameters = @curentParameters	-- NVARCHAR(MAX), NULL
		
		
		-- to keep new OrderID
		DECLARE @newOrderID INT;		
		
		-- Create new Order
		INSERT INTO Shop.Orders(
			AddressID,
			CustomerID,
			EmployeeID,
			OrderStatusID,
			OrderDate,
			RequiredDate,
			ShipDate)
		VALUES(
			@AddressID,
			@CustomerID,
			@EmployeeID,
			1,				-- New, "New registered order, whait for payment" in Shop.OrderStatus			CURRENT_TIMESTAMP,
			@RequiredDate,
			NULL);
			 
		SET @newOrderID = SCOPE_IDENTITY();

		-- throw event
		DECLARE @eventMessage NVARCHAR(MAX) = CONCAT('Created new Order with ID: ', @newOrderID);
		EXEC logs.sp_SetEvent	 @runID = @curentRunID		-- INT						
								,@affectedRows = @@rowcount		-- INT, NULL
								,@procedureID = @@PROCID		-- INT, NULL
								,@parameters = @curentParameters	-- NVARCHAR(MAX), NULL
								,@eventMessage = @eventMessage		-- NVARCHAR(MAX)





		-- Complete Operation
		EXEC logs.sp_CompleteOperation   @OperationRunID = 	@curentRunID	 -- INT       -- get from sp_StartOperation
										,@OperationRunParameters = @curentParameters  -- NVARCHAR(MAX), NULL

		RETURN @newOrderID;

	END TRY
	BEGIN CATCH
	
		-- throw Error
		EXEC logs.sp_SetError	 @runID = @curentRunID 		-- INT       -- get from sp_StartOperation
								,@procedureID = @@PROCID	-- INT, NULL
								,@parameters = @curentParameters	-- NVARCHAR(MAX), NULL
								,@errorMessage = 'Can not create Order'	-- NVARCHAR(MAX), NULL

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
	(10,'Shop.sp_CreateOrder','Create new Order, return new OrderID');
SET IDENTITY_INSERT Logs.Operations OFF;
GO
SELECT * FROM Logs.Operations

--------DEBUG---------
DECLARE @OrderDetails Staging.type_OrderDetails
INSERT INTO @OrderDetails 
VALUES
(1,11,12,13,14),
(2,21,22,23,24),
(3,31,32,33,34)

EXEC shop.sp_CreateOrder @EmployeeID = 11	-- INT
						,@CustomerID = 22	-- INT
						,@AddressID = 33	-- INT, NULL
						,@RequiredDate	= NULL	-- DATETIME, NULL
						,@OrderDetails	= @OrderDetails -- Staging.type_OrderDetails 


SELECT * FROM Shop.Orders
SELECT * FROM Shop.OrderDetails

SELECT * FROM Logs.EventLogs
SELECT * FROM Logs.ErrorLogs
SELECT * FROM Logs.OperationRuns
SELECT * FROM Logs.Operations

------------------------------




