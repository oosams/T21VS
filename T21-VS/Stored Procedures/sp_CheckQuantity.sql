
-- Check Product Quantity, return 1 if order matches quantity, return -1 if not.

-------------
CREATE   PROCEDURE Shop.sp_CheckQuantity
	@OrderDetails Staging.type_OrderDetails READONLY

AS
BEGIN
	BEGIN TRY

		-- for logging
		--DECLARE @currentParameters NVARCHAR(MAX) =  CONCAT(
		--	CHAR(9), '@ProductID = ', @ProductID, CHAR(13), CHAR(10),
		--	CHAR(9), '@Quantity = ', @Quantity, CHAR(13), CHAR(10));
					
		-- to keep new OperationRunID 
		DECLARE @CurrentRunID INT;	

		-- Start Operation and get new OperationRunID
		EXEC @CurrentRunID = 
			Logs.sp_StartOperation   @OperationID = 11	-- INT     OperationID for Shop.sp_CheckQuantity from Logs.Operations
									,@Description = NULL	-- NVARCHAR(255), NULL
									,@OperationRunParameters = '!!!Logging for Dataset parameter currently not supported'	-- NVARCHAR(MAX), NULL
		
		
		-- Start check  		
		-- Suming quanity in case products are duplicated
		;WITH OrderedQuanity AS(
			SELECT 
				 ProductID
				,SUM(Quantity) AS OrderedQuanity
			 FROM @OrderDetails
			 GROUP BY ProductID)

		-- Remove rows where Quantity in Products > Quantity in Order
		,ProductExisting AS(
			SELECT 
				 o.ProductID
				,o.OrderedQuanity
				,p.Quantity
				,p.ProductName
			FROM OrderedQuanity o
			JOIN Shop.Products p ON o.ProductID = p.ProductID
			WHERE o.OrderedQuanity > p.Quantity)

		SELECT * INTO #ProductExisting FROM	  ProductExisting
																		  
		-- Check if all products matches order's quanity
		IF (SELECT COUNT(*) FROM #ProductExisting) > 0
		BEGIN											 

			-- create message for logging
			DECLARE @EventMessage NVARCHAR(MAX) = CONCAT('Ordered Products don''t exist in desired quantity in our stock', CHAR(13), CHAR(10));
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
				SET  @EventMessage = CONCAT(@EventMessage, CHAR(9), 'The Product ''', @ProductName,''' with ID: ', @ProductID, ' is available in ', @Quanity, ' units. Ordered :',@OrderedQuanity, ' units;' , CHAR(13), CHAR(10))

				FETCH NEXT FROM CUR INTO @ProductID, @OrderedQuanity, @Quanity, @ProductName
			END
			CLOSE CUR
			DEALLOCATE CUR
			
			-- throw event
			EXEC Logs.sp_SetEvent	 @RunID = @CurrentRunID		-- INT						
									,@AffectedRows = @@rowcount		-- INT, NULL
									,@ProcedureID = @@PROCID		-- INT, NULL
									,@Parameters = '!!!Logging for Dataset parameter currently not supported'	-- NVARCHAR(MAX), NULL
									,@EventMessage = @EventMessage		-- NVARCHAR(MAX)
			
			-- Complete Operation
			EXEC Logs.sp_CompleteOperation   @OperationRunID = 	@CurrentRunID	 -- INT       -- get from sp_StartOperation
											,@OperationRunParameters = '!!!Logging for Dataset parameter currently not supported'  -- NVARCHAR(MAX), NULL

			RETURN -1
		END	 
									  							   							   		
		-- throw event
		EXEC Logs.sp_SetEvent	 @RunID = @CurrentRunID		-- INT						
								,@AffectedRows = @@rowcount		-- INT, NULL
								,@ProcedureID = @@PROCID		-- INT, NULL
								,@Parameters = '!!!Logging for Dataset parameter currently not supported'	-- NVARCHAR(MAX), NULL
								,@EventMessage = 'Ordered Products exist in desired quantity in our stock'		-- NVARCHAR(MAX)
								  													   			 		  		  		 	   		
		-- Complete Operation
		EXEC Logs.sp_CompleteOperation   @OperationRunID = 	@CurrentRunID	 -- INT       -- get from sp_StartOperation
										,@OperationRunParameters = '!!!Logging for Dataset parameter currently not supported'  -- NVARCHAR(MAX), NULL
		
		RETURN 1
	END TRY
	BEGIN CATCH
	
		-- throw Error
		EXEC Logs.sp_SetError	 @RunID = @CurrentRunID 		-- INT       -- get from sp_StartOperation
								,@ProcedureID = @@PROCID	-- INT, NULL
								,@Parameters = '!!!Logging for Dataset parameter currently not supported'	-- NVARCHAR(MAX), NULL
								,@ErrorMessage = 'Can''t check Product Quantity'	-- NVARCHAR(MAX), NULL

		-- Fail Operation
		EXEC Logs.sp_FailOperation   @OperationRunID = 	@CurrentRunID	 -- INT       -- get from sp_StartOperation
									,@OperationRunParameters = '!!!Logging for Dataset parameter currently not supported'  -- NVARCHAR(MAX), NULL

		RETURN -1
	END CATCH
END
