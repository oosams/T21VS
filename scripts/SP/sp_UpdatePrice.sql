USE MASTER;
GO

USE T21;
GO

-- Update Product Price

-------------
CREATE OR ALTER PROCEDURE shop.sp_UpdatePrice
	@ProductID INT,
	@Price INT

AS
BEGIN
	BEGIN TRY

		-- for logging
		DECLARE @curentParameters NVARCHAR(MAX) =  CONCAT(
			CHAR(9), '@ProductID = ', @ProductID, CHAR(13), CHAR(10),
			CHAR(9), '@Price = ', @Price, CHAR(13), CHAR(10));
					
		-- to keep new OperationRunID 
		DECLARE @curentRunID INT;	

		-- Start Operation and get new OperationRunID
		EXEC @curentRunID = 
			logs.sp_StartOperation   @OperationID = 9	-- INT     OperationID for Shop.sp_UpdatePrice from Logs.Operations
									,@Description = NULL	-- NVARCHAR(255), NULL
									,@OperationRunParameters = @curentParameters	-- NVARCHAR(MAX), NULL
	

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

		--get ProductName
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
		DECLARE @eventMessage1 NVARCHAR(MAX) = CONCAT('Price for Product: ', @ProductName, ' with id: ', @ProductID, ' was closed with Version: ', @Version + 10000);
		EXEC logs.sp_SetEvent	 @runID = @curentRunID		-- INT						
								,@affectedRows = @@rowcount		-- INT, NULL
								,@procedureID = @@PROCID		-- INT, NULL
								,@parameters = @curentParameters	-- NVARCHAR(MAX), NULL
								,@eventMessage = @eventMessage1		-- NVARCHAR(MAX)

		-- Insert new Price for Product
		INSERT INTO Shop.ProductPrices(
			ProductID,
			UnitPrice,
			StartVersion)
		VALUES(
			@ProductID,
			@Price,
			@Version + 10000);

		-- throw event
		DECLARE @eventMessage2 NVARCHAR(MAX) = CONCAT('New Price for Product: ', @ProductName, ' with id: ', @ProductID, ' was added with Version: ', @Version + 10000);
		EXEC logs.sp_SetEvent	 @runID = @curentRunID		-- INT						
								,@affectedRows = @@rowcount		-- INT, NULL
								,@procedureID = @@PROCID		-- INT, NULL
								,@parameters = @curentParameters	-- NVARCHAR(MAX), NULL
								,@eventMessage = @eventMessage2		-- NVARCHAR(MAX)
															   								 

		-- Insert new Version for new Price
		INSERT INTO Logs.Versions(
			VersionTypeID,
			OperationRunID,
			VersionNumber,
			Description,
			CreateDate)
		VALUES(
			@VersionType,
			@curentRunID,
			@Version + 10000,
			CONCAT('Update Price for the Product ''', @ProductName ,''' with ID: ', @ProductID),
			CURRENT_TIMESTAMP);

		-- throw event
		EXEC logs.sp_SetEvent	 @runID = @curentRunID		-- INT						
								,@affectedRows = @@rowcount		-- INT, NULL
								,@procedureID = @@PROCID		-- INT, NULL
								,@parameters = @curentParameters	-- NVARCHAR(MAX), NULL
								,@eventMessage = 'Added new Version for new Price'		-- NVARCHAR(MAX)

													   			 		  		  		 	   		
		-- Complete Operation
		EXEC logs.sp_CompleteOperation   @OperationRunID = 	@curentRunID	 -- INT       -- get from sp_StartOperation
										,@OperationRunParameters = @curentParameters  -- NVARCHAR(MAX), NULL

	END TRY
	BEGIN CATCH
	
		-- throw Error
		EXEC logs.sp_SetError	 @runID = @curentRunID 		-- INT       -- get from sp_StartOperation
								,@procedureID = @@PROCID	-- INT, NULL
								,@parameters = @curentParameters	-- NVARCHAR(MAX), NULL
								,@errorMessage = 'Can not update Product Price'	-- NVARCHAR(MAX), NULL

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
	(9,'Shop.sp_UpdatePrice','Update Product Price');
SET IDENTITY_INSERT Logs.Operations OFF;
GO
SELECT * FROM Logs.Operations


--------DEBUG---------

EXEC shop.sp_UpdatePrice   @ProductID = 102		-- INT
							,@Price=  51000		-- INT
									

SELECT * FROM Shop.ProductPrices

SELECT * FROM Logs.EventLogs
SELECT * FROM Logs.ErrorLogs
SELECT * FROM Logs.OperationRuns
SELECT * FROM Logs.Operations

