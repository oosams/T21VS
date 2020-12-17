USE MASTER;
GO

USE T21;
GO

-- Check Product Quantity, return 1 if order matches quantity, return -1 if not.

-------------
CREATE OR ALTER PROCEDURE Shop.sp_CheckQuantity
	@OrderDetails Staging.type_OrderDetails READONLY

AS
BEGIN
	BEGIN TRY

		-- for logging
		--DECLARE @curentParameters NVARCHAR(MAX) =  CONCAT(
		--	CHAR(9), '@ProductID = ', @ProductID, CHAR(13), CHAR(10),
		--	CHAR(9), '@Quantity = ', @Quantity, CHAR(13), CHAR(10));
					
		-- to keep new OperationRunID 
		DECLARE @curentRunID INT;	

		-- Start Operation and get new OperationRunID
		EXEC @curentRunID = 
			logs.sp_StartOperation   @OperationID = 11	-- INT     OperationID for Shop.sp_CheckQuantity from Logs.Operations
									,@Description = NULL	-- NVARCHAR(255), NULL
									,@OperationRunParameters = '!!!Logging for Dataset parameter curently not supported'	-- NVARCHAR(MAX), NULL
		
		
		-- Start check  		
		-- Suming quanity in case products are duplicated
		;WITH OrderedQuanity AS(
			SELECT 
				ProductID,
				SUM(Quantity) AS OrderedQuanity
			 FROM @OrderDetails
			 GROUP BY ProductID)

		-- Remove rows where Quantity in Products > Quantity in Order
		,ProductExisting AS(
			SELECT 
				o.ProductID,
				o.OrderedQuanity,
				p.Quantity,
				p.ProductName
			FROM OrderedQuanity o
			JOIN Shop.Products p ON o.ProductID = p.ProductID
			WHERE o.OrderedQuanity > p.Quantity)

		SELECT * INTO #ProductExisting FROM	  ProductExisting

		-- Check if all products matches order's quanity
		IF (SELECT COUNT(*) FROM #ProductExisting) > 0
		BEGIN											 

			-- create message for logging
			DECLARE @eventMessage NVARCHAR(MAX) = CONCAT('Ordered Products don''t exist in desired quantity in our stock', CHAR(13), CHAR(10));
			DECLARE	@ProductID INT;
			DECLARE	@OrderedQuanity	INT;
			DECLARE	@Quanity INT;
			DECLARE @ProductName NVARCHAR(255);
			DECLARE CUR CURSOR FAST_FORWARD FOR
				SELECT * FROM #ProductExisting
			OPEN CUR
			FETCH NEXT FROM CUR INTO @ProductID, @OrderedQuanity, @Quanity, @ProductName
			WHILE @@FETCH_STATUS = 0
			BEGIN	   
				
				-- add Product details to the message
				SET  @eventMessage = CONCAT(@eventMessage, CHAR(9), 'The Product ''', @ProductName,''' with ID: ', @ProductID, ' is available in ', @Quanity, ' units. Ordered :',@OrderedQuanity, ' units;' , CHAR(13), CHAR(10))

				FETCH NEXT FROM CUR INTO @ProductID, @OrderedQuanity, @Quanity, @ProductName
			END
			CLOSE CUR
			DEALLOCATE CUR
			
			-- throw event
			EXEC logs.sp_SetEvent	 @runID = @curentRunID		-- INT						
									,@affectedRows = @@rowcount		-- INT, NULL
									,@procedureID = @@PROCID		-- INT, NULL
									,@parameters = '!!!Logging for Dataset parameter curently not supported'	-- NVARCHAR(MAX), NULL
									,@eventMessage = @eventMessage		-- NVARCHAR(MAX)
			
			-- Complete Operation
			EXEC logs.sp_CompleteOperation   @OperationRunID = 	@curentRunID	 -- INT       -- get from sp_StartOperation
											,@OperationRunParameters = '!!!Logging for Dataset parameter curently not supported'  -- NVARCHAR(MAX), NULL

			RETURN -1
		END	 
									  							   							   		
		-- throw event
		EXEC logs.sp_SetEvent	 @runID = @curentRunID		-- INT						
								,@affectedRows = @@rowcount		-- INT, NULL
								,@procedureID = @@PROCID		-- INT, NULL
								,@parameters = '!!!Logging for Dataset parameter curently not supported'	-- NVARCHAR(MAX), NULL
								,@eventMessage = 'Ordered Products exist in desired quantity in our stock'		-- NVARCHAR(MAX)
								  													   			 		  		  		 	   		
		-- Complete Operation
		EXEC logs.sp_CompleteOperation   @OperationRunID = 	@curentRunID	 -- INT       -- get from sp_StartOperation
										,@OperationRunParameters = '!!!Logging for Dataset parameter curently not supported'  -- NVARCHAR(MAX), NULL
		
		RETURN 1
	END TRY
	BEGIN CATCH
	
		-- throw Error
		EXEC logs.sp_SetError	 @runID = @curentRunID 		-- INT       -- get from sp_StartOperation
								,@procedureID = @@PROCID	-- INT, NULL
								,@parameters = '!!!Logging for Dataset parameter curently not supported'	-- NVARCHAR(MAX), NULL
								,@errorMessage = 'Can''t check Product Quantity'	-- NVARCHAR(MAX), NULL

		-- Fail Operation
		EXEC logs.sp_FailOperation   @OperationRunID = 	@curentRunID	 -- INT       -- get from sp_StartOperation
									,@OperationRunParameters = '!!!Logging for Dataset parameter curently not supported'  -- NVARCHAR(MAX), NULL

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
	(11,'Shop.sp_CheckQuantity','Check Product Quantity, return 1 if order matches quantity, return -1 if not');
SET IDENTITY_INSERT Logs.Operations OFF;
GO
SELECT * FROM Logs.Operations


--------DEBUG---------

DECLARE @OrderDetails Staging.type_OrderDetails
INSERT INTO @OrderDetails 
VALUES
(1,11,12,155555,14),
(2,21,1,1,24),
(1,11,12,2,14),
(1,21,2,2,24),
(3,31,32,2,34)

--SELECT * FROM @OrderDetails
-------------------------
		
EXEC Shop.sp_CheckQuantity  @OrderDetails = @OrderDetails -- Staging.type_OrderDetails 




SELECT * FROM Shop.Products

SELECT * FROM Logs.EventLogs
SELECT * FROM Logs.ErrorLogs
SELECT * FROM Logs.OperationRuns
SELECT * FROM Logs.Operations

