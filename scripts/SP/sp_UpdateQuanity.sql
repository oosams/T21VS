USE MASTER;
GO

USE T21;
GO

-- Update Product Quantity, return 1 if succeed

-------------
CREATE OR ALTER PROCEDURE shop.sp_UpdateQuantity
	@ProductID INT,
	@Quantity INT

AS
BEGIN
	BEGIN TRY

		-- for logging
		DECLARE @curentParameters NVARCHAR(MAX) =  CONCAT(
			CHAR(9), '@ProductID = ', @ProductID, CHAR(13), CHAR(10),
			CHAR(9), '@Quantity = ', @Quantity, CHAR(13), CHAR(10));
					
		-- to keep new OperationRunID 
		DECLARE @curentRunID INT;	

		-- Start Operation and get new OperationRunID
		EXEC @curentRunID = 
			logs.sp_StartOperation   @OperationID = 8	-- INT     OperationID for Shop.sp_UpdateQuantity from Logs.Operations
									,@Description = NULL	-- NVARCHAR(255), NULL
									,@OperationRunParameters = @curentParameters	-- NVARCHAR(MAX), NULL
		
		-- Update Product Quantity in Shop.Products
		UPDATE Shop.Products
		SET
			Quantity = @Quantity
		WHERE ProductID = @ProductID;

		-- throw event
		DECLARE @eventMessage NVARCHAR(MAX) = CONCAT('Updated Product id: ', @ProductID, ' with quantity: ', @Quantity );
		EXEC logs.sp_SetEvent	 @runID = @curentRunID		-- INT						
								,@affectedRows = @@rowcount		-- INT, NULL
								,@procedureID = @@PROCID		-- INT, NULL
								,@parameters = @curentParameters	-- NVARCHAR(MAX), NULL
								,@eventMessage = @eventMessage		-- NVARCHAR(MAX)

													   			 		  		  		 	   		
		-- Complete Operation
		EXEC logs.sp_CompleteOperation   @OperationRunID = 	@curentRunID	 -- INT       -- get from sp_StartOperation
										,@OperationRunParameters = @curentParameters  -- NVARCHAR(MAX), NULL
		
		RETURN 1
	END TRY
	BEGIN CATCH
	
		-- throw Error
		EXEC logs.sp_SetError	 @runID = @curentRunID 		-- INT       -- get from sp_StartOperation
								,@procedureID = @@PROCID	-- INT, NULL
								,@parameters = @curentParameters	-- NVARCHAR(MAX), NULL
								,@errorMessage = 'Can not update Product Quantity'	-- NVARCHAR(MAX), NULL

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
	(8,'Shop.sp_UpdateQuantity','Update Product Quantity, return 1 if succeed');
SET IDENTITY_INSERT Logs.Operations OFF;
GO
SELECT * FROM Logs.Operations


--------DEBUG---------

EXEC shop.sp_UpdateQuantity   @ProductID = 1		-- INT
							,@Quantity =  51		-- INT
									

SELECT * FROM Shop.Products

SELECT * FROM Logs.EventLogs
SELECT * FROM Logs.ErrorLogs
SELECT * FROM Logs.OperationRuns
SELECT * FROM Logs.Operations

