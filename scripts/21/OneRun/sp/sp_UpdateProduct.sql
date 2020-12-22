USE MASTER;
GO

USE T21;
GO

--TODO
-- Update Product, return ...
-- update price - add new price, mark old as not active
-- update quanity -

-- name and discr - create new product, mark old as not active
-- category

-------------
CREATE OR ALTER PROCEDURE Shop.sp_UpdateProduct
	 @ProductID INT
	--,@CategoryID INT = NULL 
	--,@CategoryName NVARCHAR(255) = NULL 
	--,@CategoryDescription NVARCHAR(MAX) = NULL 
	--,@ProductName NVARCHAR(255) = NULL 
	,@UnitPrice MONEY  = NULL 
	,@Quantity INT  = NULL 
	--,@IsActive INT = NULL 
	--,@Description NVARCHAR(MAX)  = NULL

AS
BEGIN
	BEGIN TRY

		-- for logging
		DECLARE @CurrentParameters NVARCHAR(MAX) =  CONCAT(
			CHAR(9), '@ProductID = ', @ProductID, CHAR(13), CHAR(10),
			--CHAR(9), '@CategoryID = ', @CategoryID, CHAR(13), CHAR(10),
			--CHAR(9), '@CategoryName = ', @CategoryName, CHAR(13), CHAR(10),
			--CHAR(9), '@CategoryDescription = ', @CategoryDescription, CHAR(13), CHAR(10),
			--CHAR(9), '@ProductName = ', @ProductName, CHAR(13), CHAR(10),
			CHAR(9), '@UnitPrice = ', @UnitPrice, CHAR(13), CHAR(10),
			CHAR(9), '@Quantity = ', @Quantity, CHAR(13), CHAR(10)--,
			--CHAR(9), '@IsActive = ', @IsActive, CHAR(13), CHAR(10),
			--CHAR(9), '@Description = ', @Description, CHAR(13), CHAR(10)
																			);
		
		-- change flag 
		DECLARE @Change int =  0;
								 						 
		-- to keep new OperationRunID 
		DECLARE @CurrentRunID INT;	

		-- Start Operation and get new OperationRunID
		EXEC @CurrentRunID = 
			Logs.sp_StartOperation   @OperationID = 10	 -- INT     OperationID for Shop.sp_UpdateProduct from Logs.Operations
									,@Description = NULL	-- NVARCHAR(255), NULL
									,@OperationRunParameters = @CurrentParameters	-- NVARCHAR(MAX), NULL
		
	---
	---
	----
		-------------------------------------------------------------
		-----	todo		    	   Category			    	    -----
		-------------------------------------------------------------
					--Will be added after adding versioning on Product  and  Category	 dimension



		---- Check if Category esists, if not - create new one
		--IF @CategoryID is NULL
		--	BEGIN


		--	END
				
				
		-------------------------------------------------------------
		-----  todo         Product Name and Description	        -----
		-------------------------------------------------------------				
								--Will be added after adding versioning on Product dimension


		---- throw event
		--EXEC Logs.sp_SetEvent	 @RunID = @CurrentRunID		-- INT						
		--						,@AffectedRows = @@rowcount		-- INT, NULL
		--						,@ProcedureID = @@PROCID		-- INT, NULL
		--						,@Parameters = @CurrentParameters	-- NVARCHAR(MAX), NULL
		--						,@EventMessage = 'Checking Name and Discription'	 -- NVARCHAR(MAX)

		--IF @ProductName != (
		--	SELECT ProductName
		--	FROM Shop.Products
		--	WHERE 1 = 1
		--		OR ProductID = @ProductID)
		--AND @Description != (
		--	SELECT Description
		--	FROM Shop.Products
		--	WHERE 1 = 1
		--		AND ProductID = @ProductID)	

		--BEGIN

		--	SELECT * FROM Shop.Products			
			   	  
		--END
		

		-------------------------------------------------------------
		-----			    	   Price		    	        -----
		-------------------------------------------------------------	

		-- throw event
		EXEC Logs.sp_SetEvent	 @RunID = @CurrentRunID		-- INT						
								,@AffectedRows = @@rowcount		-- INT, NULL
								,@ProcedureID = @@PROCID		-- INT, NULL
								,@Parameters = @CurrentParameters	-- NVARCHAR(MAX), NULL
								,@EventMessage = 'Checking Price'		-- NVARCHAR(MAX)

		IF @UnitPrice != (
			SELECT UnitPrice
			FROM Shop.ProductPrices
			WHERE 1 = 1
				AND ProductID = @ProductID 
				AND EndVersion = 999999999)
			BEGIN

				-- throw event
				EXEC Logs.sp_SetEvent	 @RunID = @CurrentRunID		-- INT						
										,@AffectedRows = @@rowcount		-- INT, NULL
										,@ProcedureID = @@PROCID		-- INT, NULL
										,@Parameters = @CurrentParameters	-- NVARCHAR(MAX), NULL
										,@EventMessage = 'Price changed, setting new price'		-- NVARCHAR(MAX)

				SET @Change = 1;

				EXEC Shop.sp_UpdatePrice @ProductID = @ProductID	-- INT
										,@Price=  @UnitPrice		-- INT				
			
			END

		
		-------------------------------------------------------------
		-----			    	   Quantity		    	        -----
		-------------------------------------------------------------	

		-- throw event
		EXEC Logs.sp_SetEvent	 @RunID = @CurrentRunID		-- INT						
								,@AffectedRows = @@rowcount		-- INT, NULL
								,@ProcedureID = @@PROCID		-- INT, NULL
								,@Parameters = @CurrentParameters	-- NVARCHAR(MAX), NULL
								,@EventMessage = 'Checking Quantity'	 -- NVARCHAR(MAX)

		 IF @Quantity != (
			SELECT Quantity
			FROM Shop.Products
			WHERE 1 = 1
				AND ProductID = @ProductID)
			BEGIN

				-- throw event
				EXEC Logs.sp_SetEvent	 @RunID = @CurrentRunID		-- INT						
										,@AffectedRows = @@rowcount		-- INT, NULL
										,@ProcedureID = @@PROCID		-- INT, NULL
										,@Parameters = @CurrentParameters	-- NVARCHAR(MAX), NULL
										,@EventMessage = 'Quantity changed, setting new Quantity'		-- NVARCHAR(MAX)

				SET @Change = 1;

				EXEC Shop.sp_UpdateQuantity  @ProductID = @ProductID		-- INT
											,@Quantity =  @Quantity	-- INT			
			
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
								,@ErrorMessage = 'Can not update the Product'	-- NVARCHAR(MAX), NULL

		-- Fail Operation
		EXEC Logs.sp_FailOperation   @OperationRunID = 	@CurrentRunID	 -- INT       -- get from sp_StartOperation
									,@OperationRunParameters = @CurrentParameters  -- NVARCHAR(MAX), NULL

		RETURN -1
	END CATCH
END
GO

 

