USE MASTER;
GO

USE T21;
GO

-- Update Product Price, return 1 if succeed

-------------
CREATE OR ALTER PROCEDURE Shop.sp_UpdatePrice
	 @ProductID INT
	,@Price INT

AS
BEGIN
	BEGIN TRY

		-- for logging
		DECLARE @CurrentParameters NVARCHAR(MAX) =  CONCAT(
			CHAR(9), '@ProductID = ', @ProductID, CHAR(13), CHAR(10),
			CHAR(9), '@Price = ', @Price, CHAR(13), CHAR(10));
					
		-- to keep new OperationRunID 
		DECLARE @CurrentRunID INT;	

		-- Start Operation and get new OperationRunID
		EXEC @CurrentRunID = 
			Logs.sp_StartOperation   @OperationID = 9	-- INT     OperationID for Shop.sp_UpdatePrice from Logs.Operations
									,@Description = NULL	-- NVARCHAR(255), NULL
									,@OperationRunParameters = @CurrentParameters	-- NVARCHAR(MAX), NULL
	

		-- get the last Price version
		DECLARE @Version INT;
		SELECT @Version = StartVersion 
		FROM Shop.ProductPrices
		WHERE 1 = 1
			AND ProductID = @ProductID 
			AND EndVersion = 999999999;
		
		-- get VersionType
		DECLARE @VersionType INT;
		SELECT @VersionType = VersionTypeID 
		FROM Logs.VersionTypes
		WHERE 1 = 1
			AND EntityID = @ProductID;

		--get ProductName for logging
		DECLARE @ProductName NVARCHAR(255);
		SELECT @ProductName = ProductName
		FROM Shop.Products
		WHERE 1 = 1
			AND ProductID = @ProductID;



		-- end the current Price
		UPDATE Shop.ProductPrices
		SET EndVersion = @Version + 10000
		WHERE 1 = 1
			AND ProductID = @ProductID 
			AND EndVersion = 999999999;

		-- throw event
		DECLARE @EventMessage1 NVARCHAR(MAX) = CONCAT('Price for Product: ', @ProductName, ' with id: ', @ProductID, ' was closed with Version: ', @Version + 10000);
		EXEC Logs.sp_SetEvent	 @RunID = @CurrentRunID		-- INT						
								,@AffectedRows = @@rowcount		-- INT, NULL
								,@ProcedureID = @@PROCID		-- INT, NULL
								,@Parameters = @CurrentParameters	-- NVARCHAR(MAX), NULL
								,@EventMessage = @EventMessage1		-- NVARCHAR(MAX)

		-- Insert new Price for Product
		INSERT INTO Shop.ProductPrices(
			 ProductID
			,UnitPrice 
			,StartVersion)
		VALUES(
			 @ProductID 
			,@Price 
			,@Version + 10000);

		-- throw event
		DECLARE @EventMessage2 NVARCHAR(MAX) = CONCAT('New Price for Product: ', @ProductName, ' with id: ', @ProductID, ' was added with Version: ', @Version + 10000);
		EXEC Logs.sp_SetEvent	 @RunID = @CurrentRunID		-- INT						
								,@AffectedRows = @@rowcount		-- INT, NULL
								,@ProcedureID = @@PROCID		-- INT, NULL
								,@Parameters = @CurrentParameters	-- NVARCHAR(MAX), NULL
								,@EventMessage = @EventMessage2		-- NVARCHAR(MAX)
															   								 

		-- Insert new Version for new Price
		INSERT INTO Logs.Versions(
			 VersionTypeID
			,OperationRunID 
			,VersionNumber 
			,Description 
			,CreateDate)
		VALUES(
			 @VersionType 
			,@CurrentRunID 
			,@Version + 10000 
			,CONCAT('Update Price for the Product ''', @ProductName ,''' with ID: ', @ProductID) 
			,CURRENT_TIMESTAMP);

		-- throw event
		EXEC Logs.sp_SetEvent	 @RunID = @CurrentRunID		-- INT						
								,@AffectedRows = @@rowcount		-- INT, NULL
								,@ProcedureID = @@PROCID		-- INT, NULL
								,@Parameters = @CurrentParameters	-- NVARCHAR(MAX), NULL
								,@EventMessage = 'Added new Version for new Price'		-- NVARCHAR(MAX)

													   			 		  		  		 	   		
		-- Complete Operation
		EXEC Logs.sp_CompleteOperation   @OperationRunID = 	@CurrentRunID	 -- INT       -- get from sp_StartOperation
										,@OperationRunParameters = @CurrentParameters  -- NVARCHAR(MAX), NULL

		RETURN 1									
	END TRY
	BEGIN CATCH
	
		-- throw Error
		EXEC Logs.sp_SetError	 @RunID = @CurrentRunID 		-- INT       -- get from sp_StartOperation
								,@ProcedureID = @@PROCID	-- INT, NULL
								,@Parameters = @CurrentParameters	-- NVARCHAR(MAX), NULL
								,@ErrorMessage = 'Can not update Product Price'	-- NVARCHAR(MAX), NULL

		-- Fail Operation
		EXEC Logs.sp_FailOperation   @OperationRunID = 	@CurrentRunID	 -- INT       -- get from sp_StartOperation
									,@OperationRunParameters = @CurrentParameters  -- NVARCHAR(MAX), NULL

		RETURN -1
	END CATCH
END
GO

 
