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
CREATE OR ALTER PROCEDURE shop.sp_UpdateProduct
	@ProductID INT,
	--@CategoryID INT = NULL,
	--@CategoryName NVARCHAR(255) = NULL,
	--@CategoryDescription NVARCHAR(MAX) = NULL,
	--@ProductName NVARCHAR(255) = NULL,
	@UnitPrice MONEY  = NULL,
	@Quantity INT  = NULL--,
	--@IsActive INT = NULL,
	--@Description NVARCHAR(MAX)  = NULL

AS
BEGIN
	BEGIN TRY

		-- for logging
		DECLARE @curentParameters NVARCHAR(MAX) =  CONCAT(
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
		DECLARE @change int =  0;
								 						 
		-- to keep new OperationRunID 
		DECLARE @curentRunID INT;	

		-- Start Operation and get new OperationRunID
		EXEC @curentRunID = 
			logs.sp_StartOperation   @OperationID = 10	 -- INT     OperationID for Shop.sp_UpdateProduct from Logs.Operations
									,@Description = NULL	-- NVARCHAR(255), NULL
									,@OperationRunParameters = @curentParameters	-- NVARCHAR(MAX), NULL
		
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
		--EXEC logs.sp_SetEvent	 @runID = @curentRunID		-- INT						
		--						,@affectedRows = @@rowcount		-- INT, NULL
		--						,@procedureID = @@PROCID		-- INT, NULL
		--						,@parameters = @curentParameters	-- NVARCHAR(MAX), NULL
		--						,@eventMessage = 'Checking Name and Discription'	 -- NVARCHAR(MAX)

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
		EXEC logs.sp_SetEvent	 @runID = @curentRunID		-- INT						
								,@affectedRows = @@rowcount		-- INT, NULL
								,@procedureID = @@PROCID		-- INT, NULL
								,@parameters = @curentParameters	-- NVARCHAR(MAX), NULL
								,@eventMessage = 'Checking Price'		-- NVARCHAR(MAX)

		IF @UnitPrice != (
			SELECT UnitPrice
			FROM Shop.ProductPrices
			WHERE 1 = 1
				AND ProductID = @ProductID 
				AND EndVersion = 999999999)
			BEGIN

				-- throw event
				EXEC logs.sp_SetEvent	 @runID = @curentRunID		-- INT						
										,@affectedRows = @@rowcount		-- INT, NULL
										,@procedureID = @@PROCID		-- INT, NULL
										,@parameters = @curentParameters	-- NVARCHAR(MAX), NULL
										,@eventMessage = 'Price changed, setting new price'		-- NVARCHAR(MAX)

				SET @change = 1;

				EXEC shop.sp_UpdatePrice @ProductID = @ProductID	-- INT
										,@Price=  @UnitPrice		-- INT				
			
			END

		
		-------------------------------------------------------------
		-----			    	   Quantity		    	        -----
		-------------------------------------------------------------	

		-- throw event
		EXEC logs.sp_SetEvent	 @runID = @curentRunID		-- INT						
								,@affectedRows = @@rowcount		-- INT, NULL
								,@procedureID = @@PROCID		-- INT, NULL
								,@parameters = @curentParameters	-- NVARCHAR(MAX), NULL
								,@eventMessage = 'Checking Quantity'	 -- NVARCHAR(MAX)

		 IF @Quantity != (
			SELECT Quantity
			FROM Shop.Products
			WHERE 1 = 1
				AND ProductID = @ProductID)
			BEGIN

				-- throw event
				EXEC logs.sp_SetEvent	 @runID = @curentRunID		-- INT						
										,@affectedRows = @@rowcount		-- INT, NULL
										,@procedureID = @@PROCID		-- INT, NULL
										,@parameters = @curentParameters	-- NVARCHAR(MAX), NULL
										,@eventMessage = 'Quantity changed, setting new Quantity'		-- NVARCHAR(MAX)

				SET @change = 1;

				EXEC shop.sp_UpdateQuantity  @ProductID = @ProductID		-- INT
											,@Quantity =  @Quantity	-- INT			
			
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
								,@errorMessage = 'Can not update the Product'	-- NVARCHAR(MAX), NULL

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
	(10,'Shop.sp_UpdateProduct','Update Product, works for price and quanity for now');
SET IDENTITY_INSERT Logs.Operations OFF;
GO
SELECT * FROM Logs.Operations


--------DEBUG---------

EXEC shop.sp_UpdateProduct   @ProductID = 102		-- INT
							--not supported,@CategoryID = NULL		-- INT, NULL
							--not supported,@CategoryName =   'testCatName1'	 -- NVARCHAR(255), NULL
							--not supported,@CategoryDescription = 'Test Category for Product discription'	-- NVARCHAR(MAX), NULL
							--not supported,@ProductName =   'testProdName1' -- NVARCHAR(255), NULL
							,@UnitPrice =  49000 -- MONEY, NULL
							,@Quantity =   15 -- INT, NULL
							--not supported,@IsActive = 1   -- INT,  NULL
							--not supported,@Description =  'Test product Description' --  NVARCHAR(MAX), NULL


				
SELECT * FROM Shop.Categories
SELECT * FROM Shop.Products
SELECT * FROM Shop.ProductPrices
SELECT * FROM Logs.Versions

SELECT * FROM Logs.EventLogs
SELECT * FROM Logs.ErrorLogs
SELECT * FROM Logs.OperationRuns
SELECT * FROM Logs.Operations









