USE MASTER;
GO

USE T21;
GO

-- Create new Product, return new ProductID
-- Create new Category if CategoryID is NULL. In that case @CategoryName and @CategoryDescription should be provided.

-------------
CREATE OR ALTER PROCEDURE Shop.sp_CreateProduct
	 @CategoryID INT = NULL
	,@CategoryName NVARCHAR(255) = NULL
	,@CategoryDescription NVARCHAR(MAX) = NULL
	,@ProductName NVARCHAR(255)
	,@UnitPrice MONEY
	,@Quantity INT
	,@IsActive INT = 1
	,@Description NVARCHAR(MAX)

AS
BEGIN
	BEGIN TRY

		-- for logging
		DECLARE @CurrentParameters NVARCHAR(MAX) =  CONCAT(
			CHAR(9), '@CategoryID = ', @CategoryID, CHAR(13), CHAR(10),
			CHAR(9), '@CategoryName = ', @CategoryName, CHAR(13), CHAR(10),
			CHAR(9), '@CategoryDescription = ', @CategoryDescription, CHAR(13), CHAR(10),
			CHAR(9), '@ProductName = ', @ProductName, CHAR(13), CHAR(10),
			CHAR(9), '@UnitPrice = ', @UnitPrice, CHAR(13), CHAR(10),
			CHAR(9), '@Quantity = ', @Quantity, CHAR(13), CHAR(10),
			CHAR(9), '@IsActive = ', @IsActive, CHAR(13), CHAR(10),
			CHAR(9), '@Description = ', @Description, CHAR(13), CHAR(10));
					
		-- to keep new OperationRunID 
		DECLARE @CurrentRunID INT;	

		-- Start Operation and get new OperationRunID
		EXEC @CurrentRunID = 
			Logs.sp_StartOperation   @OperationID = 7	-- INT     OperationID for Shop.sp_CreateProduct from Logs.Operations
									,@Description = NULL	-- NVARCHAR(255), NULL
									,@OperationRunParameters = @CurrentParameters	-- NVARCHAR(MAX), NULL
		

		-------------------------------------------------------------
		-----			    	   Category			    	    -----
		-------------------------------------------------------------

		-- Check if Category esists, if not - create new one
		IF @CategoryID is NULL
			BEGIN

				-- throw event
				EXEC Logs.sp_SetEvent	 @RunID = @CurrentRunID		-- INT						
										,@AffectedRows = @@rowcount		-- INT, NULL
										,@ProcedureID = @@PROCID		-- INT, NULL
										,@Parameters = @CurrentParameters	-- NVARCHAR(MAX), NULL
										,@EventMessage = 'Category were not provided. Creating new one ...'	-- NVARCHAR(MAX)

				-- Check if details for new category were provided otherwise throw error
				IF @CategoryName is NUll OR @CategoryDescription is NUll
					BEGIN

						-- throw Error
						EXEC Logs.sp_SetError	 @RunID = @CurrentRunID		-- INT       -- get from sp_StartOperation
												,@ProcedureID = @@PROCID	-- INT, NULL
												,@Parameters = @CurrentParameters	-- NVARCHAR(MAX), NULL
												,@ErrorMessage = 'CategoryID along with Category details were not provided. Please provide @CategoryID or @CategoryName with @CategoryDescription to create new Category'	-- NVARCHAR(MAX), NULL

						-- Fail Operation
						EXEC Logs.sp_FailOperation   @OperationRunID = 	@CurrentRunID	 -- INT       -- get from sp_StartOperation
													,@OperationRunParameters = @CurrentParameters  -- NVARCHAR(MAX), NULL

						RETURN -1	
					END

				-- Create new Category for Product
				EXEC @CategoryID = 
					Shop.sp_CreateCategory   @CategoryName = @CategoryName	 -- NVARCHAR(255)
											,@Description = @CategoryDescription  -- NVARCHAR(MAX)

				-- throw event
				DECLARE @EventMessageCategory NVARCHAR(MAX) = CONCAT('Created new Category: ', @CategoryID,' for Product with Name: ', @ProductName);
				EXEC Logs.sp_SetEvent	 @RunID = @CurrentRunID		-- INT						
										,@AffectedRows = @@rowcount		-- INT, NULL
										,@ProcedureID = @@PROCID		-- INT, NULL
										,@Parameters = @CurrentParameters	-- NVARCHAR(MAX), NULL
										,@EventMessage = @EventMessageCategory		-- NVARCHAR(MAX)

			END
				
				
		-------------------------------------------------------------
		-----			    	   Product		    	        -----
		-------------------------------------------------------------				

		-- to keep new ProductID
		DECLARE @NewProductID INT;		

		-- Create new Product
		INSERT INTO Shop.Products(
			 CategoryID
			,ProductName
			,Quantity
			,IsActive
			,Description)
		VALUES(
			 @CategoryID
			,@ProductName
			,@Quantity
			,@IsActive
			,@Description);
			 
		SET @NewProductID = SCOPE_IDENTITY();

		-- throw event
		DECLARE @EventMessage NVARCHAR(MAX) = CONCAT('Created new Product with ID: ', @NewProductID, ', with CategoryID: ',@CategoryID );
		EXEC Logs.sp_SetEvent	 @RunID = @CurrentRunID		-- INT						
								,@AffectedRows = @@rowcount		-- INT, NULL
								,@ProcedureID = @@PROCID		-- INT, NULL
								,@Parameters = @CurrentParameters	-- NVARCHAR(MAX), NULL
								,@EventMessage = @EventMessage		-- NVARCHAR(MAX)

		-------------------------------------------------------------
		-----			    	   Price		    	        -----
		-------------------------------------------------------------	

		-- Insert new Price for new Product
		INSERT INTO Shop.ProductPrices(
			 ProductID
			,UnitPrice
			,StartVersion)
		VALUES(
			 @NewProductID
			,@UnitPrice
			,10000);

		-- throw event
		EXEC Logs.sp_SetEvent	 @RunID = @CurrentRunID		-- INT						
								,@AffectedRows = @@rowcount		-- INT, NULL
								,@ProcedureID = @@PROCID		-- INT, NULL
								,@Parameters = @CurrentParameters	-- NVARCHAR(MAX), NULL
								,@EventMessage = 'Added price for new Product'		-- NVARCHAR(MAX)


		-- to keep new VersionTypeID
		DECLARE @NewVersionTypeID INT;	

		-- Insert new VersionType for new Version
		INSERT INTO Logs.VersionTypes(
			 VersionTypeName
			,EntityID
			,Description)
		VALUES(
			 'Product price version'
			,@NewProductID
			,CONCAT('Version of product price. EntityID refers to ProductID. Created on OperationRun: ',@CurrentRunID));

		SET @NewVersionTypeID = SCOPE_IDENTITY();

		-- throw event
		EXEC Logs.sp_SetEvent	 @RunID = @CurrentRunID		-- INT						
								,@AffectedRows = @@rowcount		-- INT, NULL
								,@ProcedureID = @@PROCID		-- INT, NULL
								,@Parameters = @CurrentParameters	-- NVARCHAR(MAX), NULL
								,@EventMessage = 'Added VersionType for new Version'		-- NVARCHAR(MAX)
		

		-- Insert new Version for new Price
		INSERT INTO Logs.Versions(
			 VersionTypeID
			,OperationRunID
			,VersionNumber
			,Description
			,CreateDate)
		VALUES(
			 @NewVersionTypeID
			,@CurrentRunID
			,10000
			,CONCAT('Initial Price for new Product ''', @ProductName ,''' with ID: ', @NewProductID)
			,CURRENT_TIMESTAMP);

		-- throw event
		EXEC Logs.sp_SetEvent	 @RunID = @CurrentRunID		-- INT						
								,@AffectedRows = @@rowcount		-- INT, NULL
								,@ProcedureID = @@PROCID		-- INT, NULL
								,@Parameters = @CurrentParameters	-- NVARCHAR(MAX), NULL
								,@EventMessage = 'Added Version for new Price'		-- NVARCHAR(MAX)

													   			 		  		  		 	   		
		-- Complete Operation
		EXEC Logs.sp_CompleteOperation   @OperationRunID = 	@CurrentRunID	 -- INT       -- get from sp_StartOperation
										,@OperationRunParameters = @CurrentParameters  -- NVARCHAR(MAX), NULL

		RETURN @NewProductID;

	END TRY
	BEGIN CATCH
	
		-- throw Error
		EXEC Logs.sp_SetError	 @RunID = @CurrentRunID 		-- INT       -- get from sp_StartOperation
								,@ProcedureID = @@PROCID	-- INT, NULL
								,@Parameters = @CurrentParameters	-- NVARCHAR(MAX), NULL
								,@ErrorMessage = 'Can not create Product'	-- NVARCHAR(MAX), NULL

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
	(7,'Shop.sp_CreateProduct','Create new Product, return new ProductID');
SET IDENTITY_INSERT Logs.Operations OFF;
GO
--SELECT * FROM Logs.Operations
