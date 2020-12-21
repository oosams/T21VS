USE MASTER;
GO

USE T21;
GO

-- Update Product Quantity, return 1 if succeed

-------------
CREATE OR ALTER PROCEDURE Shop.sp_UpdateQuantity
	 @ProductID INT
	,@Quantity INT

AS
BEGIN
	BEGIN TRY

		-- for logging
		DECLARE @CurrentParameters NVARCHAR(MAX) =  CONCAT(
			CHAR(9), '@ProductID = ', @ProductID, CHAR(13), CHAR(10),
			CHAR(9), '@Quantity = ', @Quantity, CHAR(13), CHAR(10));
					
		-- to keep new OperationRunID 
		DECLARE @CurrentRunID INT;	

		-- Start Operation and get new OperationRunID
		EXEC @CurrentRunID = 
			Logs.sp_StartOperation   @OperationID = 8	-- INT     OperationID for Shop.sp_UpdateQuantity from Logs.Operations
									,@Description = NULL	-- NVARCHAR(255), NULL
									,@OperationRunParameters = @CurrentParameters	-- NVARCHAR(MAX), NULL
		
		-- Update Product Quantity in Shop.Products
		UPDATE Shop.Products
		SET
			Quantity = @Quantity
		WHERE ProductID = @ProductID;

		-- throw event
		DECLARE @EventMessage NVARCHAR(MAX) = CONCAT('Updated Product id: ', @ProductID, ' with quantity: ', @Quantity );
		EXEC Logs.sp_SetEvent	 @RunID = @CurrentRunID		-- INT						
								,@AffectedRows = @@rowcount		-- INT, NULL
								,@ProcedureID = @@PROCID		-- INT, NULL
								,@Parameters = @CurrentParameters	-- NVARCHAR(MAX), NULL
								,@EventMessage = @EventMessage		-- NVARCHAR(MAX)

													   			 		  		  		 	   		
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
								,@ErrorMessage = 'Can not update Product Quantity'	-- NVARCHAR(MAX), NULL

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
	(8,'Shop.sp_UpdateQuantity','Update Product Quantity, return 1 if succeed');
SET IDENTITY_INSERT Logs.Operations OFF;
GO
SELECT * FROM Logs.Operations


--------DEBUG---------

EXEC Shop.sp_UpdateQuantity  @ProductID = 1		-- INT
							,@Quantity =  51	-- INT
									

SELECT * FROM Shop.Products

SELECT * FROM Logs.EventLogs
SELECT * FROM Logs.ErrorLogs
SELECT * FROM Logs.OperationRuns
SELECT * FROM Logs.Operations

