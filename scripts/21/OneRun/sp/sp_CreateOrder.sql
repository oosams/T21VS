USE MASTER;
GO

USE T21;
GO

-- Create new Order, return new OrderID
-- Use top 1 Customer's Address if it not provided

-------------
CREATE OR ALTER PROCEDURE Shop.sp_CreateOrder
	 @AddressID INT = NULL
	,@CustomerID INT
	,@EmployeeID INT	
	,@RequiredDate DATETIME = NULL
	,@OrderDetails Staging.type_OrderDetails READONLY

AS
BEGIN
	BEGIN TRY

		-- for logging
		DECLARE @CurrentParameters NVARCHAR(MAX) =  CONCAT(
			CHAR(9), '@EmployeeID = ', @EmployeeID, CHAR(13), CHAR(10),
			CHAR(9), '@CustomerID = ', @CustomerID, CHAR(13), CHAR(10),
			CHAR(9), '@AddressID = ', @AddressID, CHAR(13), CHAR(10),
			CHAR(9), '@RequiredDate = ', @RequiredDate, CHAR(13), CHAR(10)
--TODO			,CHAR(9), '@OrderDetails = ', @OrderDetails, CHAR(13), CHAR(10)	   -- how to keep dataset for parameters logging?
			);

		DECLARE @RowCount INT;

		-- to keep new OperationRunID 
		DECLARE @CurrentRunID INT;	

		-- Start Operation and get new OperationRunID
		EXEC @CurrentRunID = 
			Logs.sp_StartOperation   @OperationID = 12	-- INT     OperationID for Shop.sp_CreateOrder  from Logs.Operations
									,@Description = NULL	-- NVARCHAR(255), NULL
									,@OperationRunParameters = @CurrentParameters	-- NVARCHAR(MAX), NULL

		-- throw event
		EXEC Logs.sp_SetEvent	 @RunID = @CurrentRunID		-- INT						
								--,@AffectedRows = @@rowcount		-- INT, NULL
								,@ProcedureID = @@PROCID		-- INT, NULL
								,@Parameters = @CurrentParameters	-- NVARCHAR(MAX), NULL
								,@EventMessage = 'Starting Product quanity check'		-- NVARCHAR(MAX)
								  		
		-- Check product quanity
		DECLARE @i INT;
		EXEC @i = Shop.sp_CheckQuantity  @OrderDetails = @OrderDetails 
		IF 	@i != 1
			BEGIN

				-- throw Error
				EXEC Logs.sp_SetError	 @RunID = @CurrentRunID 		-- INT       -- get from sp_StartOperation
										,@ProcedureID = @@PROCID	-- INT, NULL
										,@Parameters = @CurrentParameters	-- NVARCHAR(MAX), NULL
										,@ErrorMessage = 'There are not enough products to create Order'	-- NVARCHAR(MAX), NULL

				-- Fail Operation
				EXEC Logs.sp_FailOperation   @OperationRunID = 	@CurrentRunID	 -- INT       -- get from sp_StartOperation
											,@OperationRunParameters = @CurrentParameters  -- NVARCHAR(MAX), NULL

				RETURN -1

			END

		-- throw event
		EXEC Logs.sp_SetEvent	 @RunID = @CurrentRunID		-- INT						
								--,@AffectedRows = @@rowcount		-- INT, NULL
								,@ProcedureID = @@PROCID		-- INT, NULL
								,@Parameters = @CurrentParameters	-- NVARCHAR(MAX), NULL
								,@EventMessage = 'Checking Address'		-- NVARCHAR(MAX)

		-- Check if Address was provided and use top 1 Customer's Address if not
		IF @AddressID is NULL
			BEGIN

				SELECT TOP 1 @AddressID = AddressID 
				FROM Shop.AddressCustomer
				WHERE CustomerID = @CustomerID

				-- throw event
				DECLARE @EventMessage1 NVARCHAR(MAX) = CONCAT('Address was not provided. Using first Customer''s Address with ID: ', @AddressID);
				EXEC Logs.sp_SetEvent	 @RunID = @CurrentRunID		-- INT						
										--,@AffectedRows = @@rowcount		-- INT, NULL
										,@ProcedureID = @@PROCID		-- INT, NULL
										,@Parameters = @CurrentParameters	-- NVARCHAR(MAX), NULL
										,@EventMessage = @EventMessage1		-- NVARCHAR(MAX)

			END
		
		-------------------------------------------------------------
		-----			           Order    		    	    -----
		-------------------------------------------------------------

		-- to keep new OrderID
		DECLARE @NewOrderID INT;		
		
		-- Create new Order
		INSERT INTO Shop.Orders(
			 AddressID
			,CustomerID
			,EmployeeID
			,OrderStatusID
			,OrderDate
			,RequiredDate
			,ShipDate)
		VALUES(
			 @AddressID
			,@CustomerID
			,@EmployeeID
			,1				-- New, "New registered order, whait for payment" in Shop.OrderStatus
			,CURRENT_TIMESTAMP
			,@RequiredDate
			,NULL);
	
		SET @RowCount = @@rowcount;
		SET @NewOrderID = SCOPE_IDENTITY();

		-- throw event
		DECLARE @EventMessage2 NVARCHAR(MAX) = CONCAT('Created new Order with ID: ', @NewOrderID);
		EXEC Logs.sp_SetEvent	 @RunID = @CurrentRunID		-- INT						
								,@AffectedRows = @RowCount		-- INT, NULL
								,@ProcedureID = @@PROCID		-- INT, NULL
								,@Parameters = @CurrentParameters	-- NVARCHAR(MAX), NULL
								,@EventMessage = @EventMessage2		-- NVARCHAR(MAX)

		-------------------------------------------------------------
		-----			       Order Details   		    	    -----
		-------------------------------------------------------------

		-- Populate OrderDetails
		INSERT INTO Shop.OrderDetails
		SELECT
			 @NewOrderID 
			,od.ProductID
			,od.UnitPrice
			,od.Quantity
			,od.Discount
		FROM @OrderDetails od 

		SET @RowCount = @@rowcount;

		-- throw event
		DECLARE @EventMessage NVARCHAR(MAX) = CONCAT('OrderDetails populated for Order ID: ', @NewOrderID);
		EXEC Logs.sp_SetEvent	 @RunID = @CurrentRunID		-- INT						
								,@AffectedRows = @RowCount		-- INT, NULL
								,@ProcedureID = @@PROCID		-- INT, NULL
								,@Parameters = @CurrentParameters	-- NVARCHAR(MAX), NULL
								,@EventMessage = @EventMessage		-- NVARCHAR(MAX)
								


		-- Complete Operation
		EXEC Logs.sp_CompleteOperation   @OperationRunID = 	@CurrentRunID	 -- INT       -- get from sp_StartOperation
										,@OperationRunParameters = @CurrentParameters  -- NVARCHAR(MAX), NULL

		RETURN @NewOrderID;

	END TRY
	BEGIN CATCH
	
		-- throw Error
		EXEC Logs.sp_SetError	 @RunID = @CurrentRunID 		-- INT       -- get from sp_StartOperation
								,@ProcedureID = @@PROCID	-- INT, NULL
								,@Parameters = @CurrentParameters	-- NVARCHAR(MAX), NULL
								,@ErrorMessage = 'Can not create Order'	-- NVARCHAR(MAX), NULL

		-- Fail Operation
		EXEC Logs.sp_FailOperation   @OperationRunID = 	@CurrentRunID	 -- INT       -- get from sp_StartOperation
									,@OperationRunParameters = @CurrentParameters  -- NVARCHAR(MAX), NULL

		RETURN -1

	END CATCH
END
GO

 


