USE MASTER;
GO

USE T21;
GO

-- Create new Product, return new ProductID

-------------
CREATE OR ALTER PROCEDURE shop.sp_CreateProduct
	@CategoryID INT = NULL,
	@CategoryName NVARCHAR(255) = NULL,
	@CategoryDescription NVARCHAR(MAX) = NULL,
	@ProductName NVARCHAR(255),
	@UnitPrice MONEY,
	@Quantity INT,
	@IsActive INT = 1,
	@Description NVARCHAR(MAX)

AS
BEGIN
	BEGIN TRY

		-- for logging
		DECLARE @curentParameters NVARCHAR(MAX) =  CONCAT(
			CHAR(9), '@CategoryID = ', @CategoryID, CHAR(13), CHAR(10),
			CHAR(9), '@CategoryName = ', @CategoryName, CHAR(13), CHAR(10),
			CHAR(9), '@CategoryDescription = ', @CategoryDescription, CHAR(13), CHAR(10),
			CHAR(9), '@ProductName = ', @ProductName, CHAR(13), CHAR(10),
			CHAR(9), '@UnitPrice = ', @UnitPrice, CHAR(13), CHAR(10),
			CHAR(9), '@Quantity = ', @Quantity, CHAR(13), CHAR(10),
			CHAR(9), '@IsActive = ', @IsActive, CHAR(13), CHAR(10),
			CHAR(9), '@Description = ', @Description, CHAR(13), CHAR(10));
					
		-- to keep new OperationRunID 
		DECLARE @curentRunID INT;	

		-- Start Operation and get new OperationRunID
		EXEC @curentRunID = 
			logs.sp_StartOperation   @OperationID = 7	-- INT     OperationID for Shop.sp_CreateProduct from Logs.Operations
									,@Description = NULL	-- NVARCHAR(255), NULL
									,@OperationRunParameters = @curentParameters	-- NVARCHAR(MAX), NULL
		

		-------------------------------------------------------------
		-----			    	   Category			    	    -----
		-------------------------------------------------------------

		-- Check if Category esists, if not - create new one
		IF @CategoryID is NULL
			BEGIN

				-- throw event
				EXEC logs.sp_SetEvent	 @runID = @curentRunID		-- INT						
										,@affectedRows = @@rowcount		-- INT, NULL
										,@procedureID = @@PROCID		-- INT, NULL
										,@parameters = @curentParameters	-- NVARCHAR(MAX), NULL
										,@eventMessage = 'Category were not provided. Creating new one ...'	-- NVARCHAR(MAX)

				-- Check if details for new category were provided otherwise throw error
				IF @CategoryName is NUll OR @CategoryDescription is NUll
					BEGIN

						-- throw Error
						EXEC logs.sp_SetError	 @runID = @curentRunID		-- INT       -- get from sp_StartOperation
												,@procedureID = @@PROCID	-- INT, NULL
												,@parameters = @curentParameters	-- NVARCHAR(MAX), NULL
												,@errorMessage = 'CategoryID along with Category details were not provided. Please provide @CategoryID or @CategoryName with @CategoryDescription to create new Category'	-- NVARCHAR(MAX), NULL

						-- Fail Operation
						EXEC logs.sp_FailOperation   @OperationRunID = 	@curentRunID	 -- INT       -- get from sp_StartOperation
													,@OperationRunParameters = @curentParameters  -- NVARCHAR(MAX), NULL

						RETURN -1	
					END

				-- Create new Category for Product
				EXEC @CategoryID = 
					shop.sp_CreateCategory   @CategoryName = @CategoryName	 -- NVARCHAR(255)
											,@Description = @CategoryDescription  -- NVARCHAR(MAX)

				-- throw event
				DECLARE @eventMessageCategory NVARCHAR(MAX) = CONCAT('Created new Category: ', @CategoryID,' for Product with Name: ', @ProductName);
				EXEC logs.sp_SetEvent	 @runID = @curentRunID		-- INT						
								,@affectedRows = @@rowcount		-- INT, NULL
								,@procedureID = @@PROCID		-- INT, NULL
								,@parameters = @curentParameters	-- NVARCHAR(MAX), NULL
								,@eventMessage = @eventMessageCategory		-- NVARCHAR(MAX)

			END
				
				
		-------------------------------------------------------------
		-----			    	   Product		    	        -----
		-------------------------------------------------------------				

		-- to keep new ProductID
		DECLARE @newProductID INT;		

		-- Create new Product
		INSERT INTO Shop.Products(
			CategoryID,
			ProductName,
			Quantity,
			IsActive,
			Description)
		VALUES(
			@CategoryID,
			@ProductName,
			@Quantity,
			@IsActive,
			@Description);
			 
		SET @newProductID = SCOPE_IDENTITY();

		-- throw event
		DECLARE @eventMessage NVARCHAR(MAX) = CONCAT('Created new Product with ID: ', @newProductID, 'with CategoryID: ',@CategoryID );
		EXEC logs.sp_SetEvent	 @runID = @curentRunID		-- INT						
								,@affectedRows = @@rowcount		-- INT, NULL
								,@procedureID = @@PROCID		-- INT, NULL
								,@parameters = @curentParameters	-- NVARCHAR(MAX), NULL
								,@eventMessage = @eventMessage		-- NVARCHAR(MAX)

		-------------------------------------------------------------
		-----			    	   Price		    	        -----
		-------------------------------------------------------------	

		-- Insert new Price for new Product
		INSERT INTO Shop.ProductPrices(
			ProductID,
			UnitPrice,
			StartVersion)
		VALUES(
			@newProductID,
			@UnitPrice,
			10000);

		-- throw event
		EXEC logs.sp_SetEvent	 @runID = @curentRunID		-- INT						
								,@affectedRows = @@rowcount		-- INT, NULL
								,@procedureID = @@PROCID		-- INT, NULL
								,@parameters = @curentParameters	-- NVARCHAR(MAX), NULL
								,@eventMessage = 'Added price for new Product'		-- NVARCHAR(MAX)


		-- to keep new VersionTypeID
		DECLARE @newVersionTypeID INT;	

		-- Insert new VersionType for new Version
		INSERT INTO Logs.VersionTypes(
			VersionTypeName,
			EntityID,
			Description)
		VALUES(
			'Product price version',
			@newProductID,
			CONCAT('Version of product price. EntityID refers to ProductID. Created on OperationRun: ',@curentRunID));

		SET @newVersionTypeID = SCOPE_IDENTITY();

		-- throw event
		EXEC logs.sp_SetEvent	 @runID = @curentRunID		-- INT						
								,@affectedRows = @@rowcount		-- INT, NULL
								,@procedureID = @@PROCID		-- INT, NULL
								,@parameters = @curentParameters	-- NVARCHAR(MAX), NULL
								,@eventMessage = 'Added VersionType for new Version'		-- NVARCHAR(MAX)
		

		-- Insert new Version for new Price
		INSERT INTO Logs.Versions(
			VersionTypeID,
			OperationRunID,
			VersionNumber,
			Description,
			CreateDate)
		VALUES(
			@newVersionTypeID,
			@curentRunID,
			10000,
			CONCAT('Initial Price for new Product ''', @ProductName ,''' with ID: ', @newProductID),
			CURRENT_TIMESTAMP);

		-- throw event
		EXEC logs.sp_SetEvent	 @runID = @curentRunID		-- INT						
								,@affectedRows = @@rowcount		-- INT, NULL
								,@procedureID = @@PROCID		-- INT, NULL
								,@parameters = @curentParameters	-- NVARCHAR(MAX), NULL
								,@eventMessage = 'Added Version for new Price'		-- NVARCHAR(MAX)

													   			 		  		  		 	   		
		-- Complete Operation
		EXEC logs.sp_CompleteOperation   @OperationRunID = 	@curentRunID	 -- INT       -- get from sp_StartOperation
										,@OperationRunParameters = @curentParameters  -- NVARCHAR(MAX), NULL

		RETURN @newProductID;

	END TRY
	BEGIN CATCH
	
		-- throw Error
		EXEC logs.sp_SetError	 @runID = @curentRunID 		-- INT       -- get from sp_StartOperation
								,@procedureID = @@PROCID	-- INT, NULL
								,@parameters = @curentParameters	-- NVARCHAR(MAX), NULL
								,@errorMessage = 'Can not create Product'	-- NVARCHAR(MAX), NULL

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
	(7,'Shop.sp_CreateProduct','Create new Product, return new ProductID');
SET IDENTITY_INSERT Logs.Operations OFF;
GO
SELECT * FROM Logs.Operations


--------DEBUG---------
DROP TABLE IF EXISTS #testID 
CREATE TABLE #testID 
(
	id INT
);
declare @iddd int
EXEC @iddd = shop.sp_CreateProduct  @CategoryID = NULL	-- INT, NULL
									,@CategoryName =   'TestCatNameForProduct'	 -- NVARCHAR(255), NULL
									,@CategoryDescription =   'Test Category for Product discription'	 -- NVARCHAR(MAX), NULL
									,@ProductName = 'testName1'   -- NVARCHAR(255)
									,@UnitPrice =   232323 -- MONEY
									,@Quantity =   10 -- INT
									--,@IsActive = 1   -- INT, 1
									,@Description =  'Test product Description' -- NVARCHAR(255)

							
INSERT INTO #testID (id)
SELECT @iddd
SELECT Top 1 id FROM #testID

DELETE Shop.Products
WHERE ProductID =  (SELECT Top 1 id FROM #testID) 

DBCC CHECKIDENT ('Shop.Products')
DBCC CHECKIDENT ('Shop.Products', RESEED, 10)  
  
SELECT SCOPE_IDENTITY()

SELECT * FROM Shop.Categories
SELECT * FROM Shop.Products

SELECT * FROM Logs.EventLogs
SELECT * FROM Logs.ErrorLogs
SELECT * FROM Logs.OperationRuns
SELECT * FROM Logs.Operations

