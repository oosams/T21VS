USE MASTER;
GO

USE T21;
GO
  
-- Update Order, return 1 if secceed

-------------
CREATE OR ALTER PROCEDURE Shop.sp_UpdateOrder
	@OrderID INT,
	@ManagerID INT = NULL,	 
	@OrderStatusID INT,	 --   2 for Paid, 3 for Shipped, 4 for Cancelled
	@RequiredDate DATETIME = NULL--,   
	--@OrderDetails Staging.type_OrderDetails READONLY	-- could be added. change list of ordered products in existing order
     
		
AS
BEGIN
	BEGIN TRY

		-- for logging
		DECLARE @curentParameters NVARCHAR(MAX) =  CONCAT(
			CHAR(9), '@OrderID = ', @OrderID, CHAR(13), CHAR(10),
			--CHAR(9), '@EmployeeID = ', @EmployeeID, CHAR(13), CHAR(10),
			CHAR(9), '@OrderStatusID = ', @OrderStatusID, CHAR(13), CHAR(10)--,
			--CHAR(9), '@RequiredDate = ', @RequiredDate, CHAR(13), CHAR(10)
--todo		,CHAR(9), '@OrderDetails = ', @OrderDetails, CHAR(13), CHAR(10)
			);

		-- change flag 
		DECLARE @change int =  0;

		-- to keep new OperationRunID 
		DECLARE @curentRunID INT;	

		-- Start Operation and get new OperationRunID
		EXEC @curentRunID = 
			logs.sp_StartOperation   @OperationID = 13	-- INT     OperationID for Shop.sp_UpdateOrder  from Logs.Operations
									,@Description = NULL	-- NVARCHAR(255), NULL
									,@OperationRunParameters = @curentParameters	-- NVARCHAR(MAX), NULL
		

		-------------------------------------------------------------
		-----			    	  OrderStatus	    	        -----
		-------------------------------------------------------------	
		-----     2 for Paid, 3 for Shipped, 4 for Cancelled    -----

		-- throw event
		EXEC logs.sp_SetEvent	 @runID = @curentRunID		-- INT						
								,@affectedRows = @@rowcount		-- INT, NULL
								,@procedureID = @@PROCID		-- INT, NULL
								,@parameters = @curentParameters	-- NVARCHAR(MAX), NULL
								,@eventMessage = 'Checking OrderStatus'		-- NVARCHAR(MAX)

		IF @OrderStatusID != (
			SELECT OrderStatusID
			FROM Shop.Orders
			WHERE 1 = 1
				AND OrderID = @OrderID)
			BEGIN

				-- throw event
				EXEC logs.sp_SetEvent	 @runID = @curentRunID		-- INT						
										,@affectedRows = @@rowcount		-- INT, NULL
										,@procedureID = @@PROCID		-- INT, NULL
										,@parameters = @curentParameters	-- NVARCHAR(MAX), NULL
										,@eventMessage = 'OrderStatus changed, setting new OrderStatus'		-- NVARCHAR(MAX)

				SET @change = 1;

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
				DECLARE @eventMessage1 NVARCHAR(MAX) = CONCAT('Setted new OrderStatus ''', @OrderStatusName, ''' with id: ', @OrderStatusID, ' - ', @Description );
				EXEC logs.sp_SetEvent	 @runID = @curentRunID		-- INT						
										,@affectedRows = @@rowcount		-- INT, NULL
										,@procedureID = @@PROCID		-- INT, NULL
										,@parameters = @curentParameters	-- NVARCHAR(MAX), NULL
										,@eventMessage = @eventMessage1		-- NVARCHAR(MAX)			
						   
			END

		-------------------------------------------------------------
		-----			    	  Employee	    	            -----
		-------------------------------------------------------------	

		-- throw event
		EXEC logs.sp_SetEvent	 @runID = @curentRunID		-- INT						
								,@affectedRows = @@rowcount		-- INT, NULL
								,@procedureID = @@PROCID		-- INT, NULL
								,@parameters = @curentParameters	-- NVARCHAR(MAX), NULL
								,@eventMessage = 'Checking Manager'		-- NVARCHAR(MAX)

		IF @ManagerID != (
			SELECT EmployeeID
			FROM Shop.Orders
			WHERE 1 = 1
				AND OrderID = @OrderID)
		AND @ManagerID IS NOT NULL
			BEGIN

				-- throw event
				EXEC logs.sp_SetEvent	 @runID = @curentRunID		-- INT						
										,@affectedRows = @@rowcount		-- INT, NULL
										,@procedureID = @@PROCID		-- INT, NULL
										,@parameters = @curentParameters	-- NVARCHAR(MAX), NULL
										,@eventMessage = 'Manager changed, setting new Manager for order'		-- NVARCHAR(MAX)

				SET @change = 1;

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
				DECLARE @eventMessage2 NVARCHAR(MAX) = CONCAT('Setted new Manager ''', @Name, ''' with id: ', @ManagerID);
				EXEC logs.sp_SetEvent	 @runID = @curentRunID		-- INT						
										,@affectedRows = @@rowcount		-- INT, NULL
										,@procedureID = @@PROCID		-- INT, NULL
										,@parameters = @curentParameters	-- NVARCHAR(MAX), NULL
										,@eventMessage = @eventMessage2		-- NVARCHAR(MAX)			
						   
			END
						 
		-------------------------------------------------------------
		-----			    	  Required Date	    	            -----
		-------------------------------------------------------------	

		-- throw event
		EXEC logs.sp_SetEvent	 @runID = @curentRunID		-- INT						
								,@affectedRows = @@rowcount		-- INT, NULL
								,@procedureID = @@PROCID		-- INT, NULL
								,@parameters = @curentParameters	-- NVARCHAR(MAX), NULL
								,@eventMessage = 'Checking Required Date'		-- NVARCHAR(MAX)

		IF @RequiredDate != (
			SELECT RequiredDate
			FROM Shop.Orders		 
			WHERE 1 = 1
				AND OrderID = @OrderID)
		AND @RequiredDate IS NOT NULL
			BEGIN

				-- throw event
				EXEC logs.sp_SetEvent	 @runID = @curentRunID		-- INT						
										,@affectedRows = @@rowcount		-- INT, NULL
										,@procedureID = @@PROCID		-- INT, NULL
										,@parameters = @curentParameters	-- NVARCHAR(MAX), NULL
										,@eventMessage = 'Required Date changed, setting new one'	-- NVARCHAR(MAX)

				SET @change = 1;

				-- Update Required Date
				UPDATE Shop.Orders
				SET RequiredDate = @RequiredDate	
				WHERE OrderID = @OrderID
				 
				-- throw event
				DECLARE @eventMessage3 NVARCHAR(MAX) = CONCAT('Setted new Required Date: ', @RequiredDate );
				EXEC logs.sp_SetEvent	 @runID = @curentRunID		-- INT						
										,@affectedRows = @@rowcount		-- INT, NULL
										,@procedureID = @@PROCID		-- INT, NULL
										,@parameters = @curentParameters	-- NVARCHAR(MAX), NULL
										,@eventMessage = @eventMessage3		-- NVARCHAR(MAX)			
						   
			END

		IF @change = 0
			-- throw event
			EXEC logs.sp_SetEvent	 @runID = @curentRunID		-- INT						
									,@affectedRows = @@rowcount		-- INT, NULL
									,@procedureID = @@PROCID		-- INT, NULL
									,@parameters = @curentParameters	-- NVARCHAR(MAX), NULL
									,@eventMessage = 'Nothing to update'		  
								
								  
		-- Complete Operation
		EXEC logs.sp_CompleteOperation   @OperationRunID = 	@curentRunID	 -- INT       -- get from sp_StartOperation
										,@OperationRunParameters = @curentParameters  -- NVARCHAR(MAX), NULL

		RETURN 1;

	END TRY
	BEGIN CATCH
	
		-- throw Error
		EXEC logs.sp_SetError	 @runID = @curentRunID 		-- INT       -- get from sp_StartOperation
								,@procedureID = @@PROCID	-- INT, NULL
								,@parameters = @curentParameters	-- NVARCHAR(MAX), NULL
								,@errorMessage = 'Can not Update Order'	-- NVARCHAR(MAX), NULL

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
	(13,'Shop.sp_UpdateOrder','Update Order, return 1 if succeed');
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

--  paid and set req date
EXEC shop.sp_UpdateOrder @OrderID = 1001	-- INT
						,@ManagerID = NULL	-- INT, NULL
						,@OrderStatusID = 2	-- INT, NULL  --   2 for Paid, 3 for Shipped, 4 for Cancelled
						,@RequiredDate	= '2021-01-16'	-- DATETIME, NULL
						--,@OrderDetails	= @OrderDetails -- Staging.type_OrderDetails  -- could be added. change list of ordered products in existing order

-- paid and set new manager
EXEC shop.sp_UpdateOrder @OrderID = 1002	-- INT
						,@ManagerID = 19	-- INT, NULL
						,@OrderStatusID = 2	-- INT, NULL  --   2 for Paid, 3 for Shipped, 4 for Cancelled
						,@RequiredDate	= NULL	-- DATETIME, NULL
						--,@OrderDetails	= @OrderDetails -- Staging.type_OrderDetails  -- could be added. change list of ordered products in existing order

-- shipped 
EXEC shop.sp_UpdateOrder @OrderID = 1003	-- INT
						,@ManagerID = NULL	-- INT, NULL
						,@OrderStatusID = 3	-- INT, NULL  --   2 for Paid, 3 for Shipped, 4 for Cancelled
						,@RequiredDate	= NULL	-- DATETIME, NULL
						--,@OrderDetails	= @OrderDetails -- Staging.type_OrderDetails  -- could be added. change list of ordered products in existing order
 
-- canceled
EXEC shop.sp_UpdateOrder @OrderID = 1004	-- INT
						--,@ManagerID = 1	-- INT, NULL
						,@OrderStatusID = 4	-- INT, NULL  --   2 for Paid, 3 for Shipped, 4 for Cancelled
						,@RequiredDate	= NULL	-- DATETIME, NULL
						--,@OrderDetails	= @OrderDetails -- Staging.type_OrderDetails  -- could be added. change list of ordered products in existing order

-- no change
EXEC shop.sp_UpdateOrder @OrderID = 1005	-- INT
						,@ManagerID = 9	-- INT, NULL
						,@OrderStatusID = 1	-- INT, NULL  --   2 for Paid, 3 for Shipped, 4 for Cancelled
						,@RequiredDate	= NULL	-- DATETIME, NULL
						--,@OrderDetails	= @OrderDetails -- Staging.type_OrderDetails  -- could be added. change list of ordered products in existing order


SELECT * FROM Shop.Orders
SELECT * FROM Shop.OrderDetails
SELECT * FROM Shop.OrderStatus

SELECT * FROM Logs.EventLogs
SELECT * FROM Logs.ErrorLogs
SELECT * FROM Logs.OperationRuns
SELECT * FROM Logs.Operations

------------------------------

