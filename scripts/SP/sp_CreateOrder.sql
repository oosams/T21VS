USE MASTER;
GO

USE T21;
GO

-- Create new Order, return new OrderID
-- Use top 1 Customer's Address if it not provided

-------------
CREATE OR ALTER PROCEDURE shop.sp_CreateOrder
	@AddressID INT = NULL,
	@CustomerID INT,
	@EmployeeID	INT,	
	@RequiredDate DATETIME = NULL,
	@OrderDetails Staging.type_OrderDetails READONLY

AS
BEGIN
	BEGIN TRY

		-- for logging
		DECLARE @curentParameters NVARCHAR(MAX) =  CONCAT(
			CHAR(9), '@EmployeeID = ', @EmployeeID, CHAR(13), CHAR(10),
			CHAR(9), '@CustomerID = ', @CustomerID, CHAR(13), CHAR(10),
			CHAR(9), '@AddressID = ', @AddressID, CHAR(13), CHAR(10),
			CHAR(9), '@RequiredDate = ', @RequiredDate, CHAR(13), CHAR(10)
--TODO			,CHAR(9), '@OrderDetails = ', @OrderDetails, CHAR(13), CHAR(10)	   -- how to keep dataset for parameters logging?
			);

		
		-- to keep new OperationRunID 
		DECLARE @curentRunID INT;	

		-- Start Operation and get new OperationRunID
		EXEC @curentRunID = 
			logs.sp_StartOperation   @OperationID = 12	-- INT     OperationID for Shop.sp_CreateOrder  from Logs.Operations
									,@Description = NULL	-- NVARCHAR(255), NULL
									,@OperationRunParameters = @curentParameters	-- NVARCHAR(MAX), NULL

		-- throw event
		EXEC logs.sp_SetEvent	 @runID = @curentRunID		-- INT						
								,@affectedRows = @@rowcount		-- INT, NULL
								,@procedureID = @@PROCID		-- INT, NULL
								,@parameters = @curentParameters	-- NVARCHAR(MAX), NULL
								,@eventMessage = 'Starting Product quanity check'		-- NVARCHAR(MAX)
								  		
		-- Check product quanity
		DECLARE @i INT;
		EXEC @i = Shop.sp_CheckQuantity  @OrderDetails = @OrderDetails 
		IF 	@i != 1
			BEGIN

				-- throw Error
				EXEC logs.sp_SetError	 @runID = @curentRunID 		-- INT       -- get from sp_StartOperation
										,@procedureID = @@PROCID	-- INT, NULL
										,@parameters = @curentParameters	-- NVARCHAR(MAX), NULL
										,@errorMessage = 'There are not enough products to create Order'	-- NVARCHAR(MAX), NULL

				-- Fail Operation
				EXEC logs.sp_FailOperation   @OperationRunID = 	@curentRunID	 -- INT       -- get from sp_StartOperation
											,@OperationRunParameters = @curentParameters  -- NVARCHAR(MAX), NULL

				RETURN -1

			END

		-- throw event
		EXEC logs.sp_SetEvent	 @runID = @curentRunID		-- INT						
								,@affectedRows = @@rowcount		-- INT, NULL
								,@procedureID = @@PROCID		-- INT, NULL
								,@parameters = @curentParameters	-- NVARCHAR(MAX), NULL
								,@eventMessage = 'Checking Address'		-- NVARCHAR(MAX)

		-- Check if Address was provided and use top 1 Customer's Address if not
		IF @AddressID is NULL
			BEGIN

				SELECT TOP 1 @AddressID = AddressID 
				FROM Shop.AddressCustomer
				WHERE CustomerID = @CustomerID

				-- throw event
				DECLARE @eventMessage1 NVARCHAR(MAX) = CONCAT('Address was not provided. Using first Customer''s Address with ID: ', @AddressID);
				EXEC logs.sp_SetEvent	 @runID = @curentRunID		-- INT						
										,@affectedRows = @@rowcount		-- INT, NULL
										,@procedureID = @@PROCID		-- INT, NULL
										,@parameters = @curentParameters	-- NVARCHAR(MAX), NULL
										,@eventMessage = @eventMessage1		-- NVARCHAR(MAX)

			END
		
		-------------------------------------------------------------
		-----			           Order    		    	    -----
		-------------------------------------------------------------

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
			1,				-- New, "New registered order, whait for payment" in Shop.OrderStatus
			CURRENT_TIMESTAMP,
			@RequiredDate,
			NULL);
			 
		SET @newOrderID = SCOPE_IDENTITY();

		-- throw event
		DECLARE @eventMessage2 NVARCHAR(MAX) = CONCAT('Created new Order with ID: ', @newOrderID);
		EXEC logs.sp_SetEvent	 @runID = @curentRunID		-- INT						
								,@affectedRows = @@rowcount		-- INT, NULL
								,@procedureID = @@PROCID		-- INT, NULL
								,@parameters = @curentParameters	-- NVARCHAR(MAX), NULL
								,@eventMessage = @eventMessage2		-- NVARCHAR(MAX)

		-------------------------------------------------------------
		-----			       Order Details   		    	    -----
		-------------------------------------------------------------

		-- Populate OrderDetails
		INSERT INTO Shop.OrderDetails
		SELECT
			@newOrderID, 
			od.ProductID,
			od.UnitPrice,
			od.Quantity,
			od.Discount
		FROM @OrderDetails od 

		-- throw event
		DECLARE @eventMessage NVARCHAR(MAX) = CONCAT('OrderDetails populated for Order ID: ', @newOrderID);
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
	(12,'Shop.sp_CreateOrder','Create new Order, return new OrderID');
SET IDENTITY_INSERT Logs.Operations OFF;
GO
SELECT * FROM Logs.Operations


--------DEBUG---------
DECLARE @OrderDetails Staging.type_OrderDetails
INSERT INTO @OrderDetails 
VALUES
(1,11,12,1,14),
(2,21,22,1,24),
(3,31,32,1,34)

EXEC shop.sp_CreateOrder @EmployeeID = 9	-- INT
						,@CustomerID = 4	-- INT
					--	,@AddressID = 5	-- INT, NULL
					--	,@RequiredDate	= '2021-01-16'	-- DATETIME, NULL
						,@OrderDetails	= @OrderDetails -- Staging.type_OrderDetails 

SELECT * FROM Shop.Orders
SELECT * FROM Shop.OrderDetails

SELECT * FROM Logs.EventLogs
SELECT * FROM Logs.ErrorLogs
SELECT * FROM Logs.OperationRuns
SELECT * FROM Logs.Operations

------------------------------








