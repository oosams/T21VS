USE MASTER;
GO

USE T21;
GO
  
-- Update Order, return 1 if secceed

-------------
CREATE OR ALTER PROCEDURE Shop.sp_UpdateOrder
	 @OrderID INT
	,@ManagerID INT = NULL 	 
	,@OrderStatusID INT 	 --   2 for Paid, 3 for Shipped, 4 for Cancelled
	,@RequiredDate DATETIME = NULL    
	--@OrderDetails Staging.type_OrderDetails READONLY	-- could be added. change list of ordered products in existing order
     
		
AS
BEGIN
	BEGIN TRY

		-- for logging
		DECLARE @CurrentParameters NVARCHAR(MAX) =  CONCAT(
			CHAR(9), '@OrderID = ', @OrderID, CHAR(13), CHAR(10),
			--CHAR(9), '@EmployeeID = ', @EmployeeID, CHAR(13), CHAR(10),
			CHAR(9), '@OrderStatusID = ', @OrderStatusID, CHAR(13), CHAR(10)--,
			--CHAR(9), '@RequiredDate = ', @RequiredDate, CHAR(13), CHAR(10)
--todo		,CHAR(9), '@OrderDetails = ', @OrderDetails, CHAR(13), CHAR(10)
			);

		-- change flag 
		DECLARE @Change int =  0;

		-- to keep new OperationRunID 
		DECLARE @CurrentRunID INT;	

		-- Start Operation and get new OperationRunID
		EXEC @CurrentRunID = 
			Logs.sp_StartOperation   @OperationID = 13	-- INT     OperationID for Shop.sp_UpdateOrder  from Logs.Operations
									,@Description = NULL	-- NVARCHAR(255), NULL
									,@OperationRunParameters = @CurrentParameters	-- NVARCHAR(MAX), NULL
		

		-------------------------------------------------------------
		-----			    	  OrderStatus	    	        -----
		-------------------------------------------------------------	
		-----     2 for Paid, 3 for Shipped, 4 for Cancelled    -----

		-- throw event
		EXEC Logs.sp_SetEvent	 @RunID = @CurrentRunID		-- INT						
								,@AffectedRows = @@rowcount		-- INT, NULL
								,@ProcedureID = @@PROCID		-- INT, NULL
								,@Parameters = @CurrentParameters	-- NVARCHAR(MAX), NULL
								,@EventMessage = 'Checking OrderStatus'		-- NVARCHAR(MAX)

		IF @OrderStatusID != (
			SELECT OrderStatusID
			FROM Shop.Orders
			WHERE 1 = 1
				AND OrderID = @OrderID)
			BEGIN

				-- throw event
				EXEC Logs.sp_SetEvent	 @RunID = @CurrentRunID		-- INT						
										,@AffectedRows = @@rowcount		-- INT, NULL
										,@ProcedureID = @@PROCID		-- INT, NULL
										,@Parameters = @CurrentParameters	-- NVARCHAR(MAX), NULL
										,@EventMessage = 'OrderStatus changed, setting new OrderStatus'		-- NVARCHAR(MAX)

				SET @Change = 1;

				-- Update status
				UPDATE Shop.Orders
				SET OrderStatusID = @OrderStatusID	-- 2 for Paid, 3 for Shipped, 4 for Cancelled
				WHERE OrderID = @OrderID
								
				-- Update shipped date
				IF @OrderStatusID = 3 					 
					UPDATE Shop.Orders	 
					SET ShipDate = CURRENT_TIMESTAMP	-- 2 for Paid, 3 for Shipped, 4 for Cancelled
					WHERE OrderID = @OrderID

				-- get OrderStatus details for logging
				DECLARE @OrderStatusName NVARCHAR(255);
				DECLARE @Description NVARCHAR(MAX);
				SELECT 
					@OrderStatusName = OrderStatusName
					,@Description  =  Description  
				FROM Shop.OrderStatus
				WHERE OrderStatusID = @OrderStatusID
						   
				-- throw event
				DECLARE @EventMessage1 NVARCHAR(MAX) = CONCAT('Setted new OrderStatus ''', @OrderStatusName, ''' with id: ', @OrderStatusID, ' - ', @Description );
				EXEC Logs.sp_SetEvent	 @RunID = @CurrentRunID		-- INT						
										,@AffectedRows = @@rowcount		-- INT, NULL
										,@ProcedureID = @@PROCID		-- INT, NULL
										,@Parameters = @CurrentParameters	-- NVARCHAR(MAX), NULL
										,@EventMessage = @EventMessage1		-- NVARCHAR(MAX)			
						   
			END

		-------------------------------------------------------------
		-----			    	  Employee	    	            -----
		-------------------------------------------------------------	

		-- throw event
		EXEC Logs.sp_SetEvent	 @RunID = @CurrentRunID		-- INT						
								,@AffectedRows = @@rowcount		-- INT, NULL
								,@ProcedureID = @@PROCID		-- INT, NULL
								,@Parameters = @CurrentParameters	-- NVARCHAR(MAX), NULL
								,@EventMessage = 'Checking Manager'		-- NVARCHAR(MAX)

		IF @ManagerID != (
			SELECT EmployeeID
			FROM Shop.Orders
			WHERE 1 = 1
				AND OrderID = @OrderID)
		AND @ManagerID IS NOT NULL
			BEGIN

				-- throw event
				EXEC Logs.sp_SetEvent	 @RunID = @CurrentRunID		-- INT						
										,@AffectedRows = @@rowcount		-- INT, NULL
										,@ProcedureID = @@PROCID		-- INT, NULL
										,@Parameters = @CurrentParameters	-- NVARCHAR(MAX), NULL
										,@EventMessage = 'Manager changed, setting new Manager for order'		-- NVARCHAR(MAX)

				SET @Change = 1;

				-- Update Employee
				UPDATE Shop.Orders
				SET EmployeeID = @ManagerID	
				WHERE OrderID = @OrderID


				-- get Employee details for logging
				DECLARE @Name NVARCHAR(1000);
				SELECT 
					@Name =
						CASE
							WHEN c.Title IS NULL THEN 	CONCAT(c.FirstName, ' ', c.MiddleName, ' ', c.LastName)
							ELSE   CONCAT(c.Title, '. ', c.FirstName, ' ', c.MiddleName, ' ', c.LastName)
						END
				FROM Shop.Employees e
				JOIN Shop.ContactEmployee ce ON e.EmployeeID = ce.EmployeeID
				JOIN Shop.Contacts c ON ce.ContactID = c.ContactID 
				WHERE e.EmployeeID = @ManagerID


				-- throw event
				DECLARE @EventMessage2 NVARCHAR(MAX) = CONCAT('Setted new Manager ''', @Name, ''' with id: ', @ManagerID);
				EXEC Logs.sp_SetEvent	 @RunID = @CurrentRunID		-- INT						
										,@AffectedRows = @@rowcount		-- INT, NULL
										,@ProcedureID = @@PROCID		-- INT, NULL
										,@Parameters = @CurrentParameters	-- NVARCHAR(MAX), NULL
										,@EventMessage = @EventMessage2		-- NVARCHAR(MAX)			
						   
			END
						 
		-------------------------------------------------------------
		-----			    	  Required Date	    	            -----
		-------------------------------------------------------------	

		-- throw event
		EXEC Logs.sp_SetEvent	 @RunID = @CurrentRunID		-- INT						
								,@AffectedRows = @@rowcount		-- INT, NULL
								,@ProcedureID = @@PROCID		-- INT, NULL
								,@Parameters = @CurrentParameters	-- NVARCHAR(MAX), NULL
								,@EventMessage = 'Checking Required Date'		-- NVARCHAR(MAX)

		IF @RequiredDate != (
			SELECT RequiredDate
			FROM Shop.Orders		 
			WHERE 1 = 1
				AND OrderID = @OrderID)
		AND @RequiredDate IS NOT NULL
			BEGIN

				-- throw event
				EXEC Logs.sp_SetEvent	 @RunID = @CurrentRunID		-- INT						
										,@AffectedRows = @@rowcount		-- INT, NULL
										,@ProcedureID = @@PROCID		-- INT, NULL
										,@Parameters = @CurrentParameters	-- NVARCHAR(MAX), NULL
										,@EventMessage = 'Required Date changed, setting new one'	-- NVARCHAR(MAX)

				SET @Change = 1;

				-- Update Required Date
				UPDATE Shop.Orders
				SET RequiredDate = @RequiredDate	
				WHERE OrderID = @OrderID
				 
				-- throw event
				DECLARE @EventMessage3 NVARCHAR(MAX) = CONCAT('Setted new Required Date: ', @RequiredDate );
				EXEC Logs.sp_SetEvent	 @RunID = @CurrentRunID		-- INT						
										,@AffectedRows = @@rowcount		-- INT, NULL
										,@ProcedureID = @@PROCID		-- INT, NULL
										,@Parameters = @CurrentParameters	-- NVARCHAR(MAX), NULL
										,@EventMessage = @EventMessage3		-- NVARCHAR(MAX)			
						   
			END

		IF @Change = 0
			-- throw event
			EXEC Logs.sp_SetEvent	 @RunID = @CurrentRunID		-- INT						
									,@AffectedRows = @@rowcount		-- INT, NULL
									,@ProcedureID = @@PROCID		-- INT, NULL
									,@Parameters = @CurrentParameters	-- NVARCHAR(MAX), NULL
									,@EventMessage = 'Nothing to update'		  
								
								  
		-- Complete Operation
		EXEC Logs.sp_CompleteOperation   @OperationRunID = 	@CurrentRunID	 -- INT       -- get from sp_StartOperation
										,@OperationRunParameters = @CurrentParameters  -- NVARCHAR(MAX), NULL

		RETURN 1;

	END TRY
	BEGIN CATCH
	
		-- throw Error
		EXEC Logs.sp_SetError	 @RunID = @CurrentRunID 		-- INT       -- get from sp_StartOperation
								,@ProcedureID = @@PROCID	-- INT, NULL
								,@Parameters = @CurrentParameters	-- NVARCHAR(MAX), NULL
								,@ErrorMessage = 'Can not Update Order'	-- NVARCHAR(MAX), NULL

		-- Fail Operation
		EXEC Logs.sp_FailOperation   @OperationRunID = 	@CurrentRunID	 -- INT       -- get from sp_StartOperation
									,@OperationRunParameters = @CurrentParameters  -- NVARCHAR(MAX), NULL

		RETURN -1

	END CATCH
END
GO

----Add info in Logs.Operations------


SET IDENTITY_INSERT Logs.Operations ON;  

INSERT INTO Logs.Operations(
	 OperationID
	,OperationName
	,Description)
VALUES
	(13,'Shop.sp_UpdateOrder','Update Order, return 1 if succeed');
SET IDENTITY_INSERT Logs.Operations OFF;
GO
--SELECT * FROM Logs.Operations
