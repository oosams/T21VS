USE MASTER;
GO

USE T21;
GO

-- Update OperationRun as completed

-------------
CREATE OR ALTER PROCEDURE Logs.sp_CompleteOperation
	 @OperationRunID INT
	,@OperationRunParameters NVARCHAR(MAX) = NULL

AS
BEGIN
	BEGIN TRY

		-- get Operation Name by OperationRunID
		DECLARE @OperationName NVARCHAR(255);		
		
		SELECT 
			@OperationName = OperationName
		FROM Logs.Operations op
		JOIN Logs.OperationRuns opr ON op.OperationID = opr.OperationID
		WHERE OperationRunID = @OperationRunID;

		-- for logging
		DECLARE @CurrentParameters NVARCHAR(MAX) =  CONCAT(
			CHAR(9), '@OperationRunID = ', @OperationRunID, CHAR(13), CHAR(10),
			CHAR(9), '@OperationRunParameters = ', @OperationRunParameters, CHAR(13), CHAR(10));

		DECLARE @EventMessage NVARCHAR(MAX) = CONCAT('Completed. Operation ''', @OperationName, ''' has been completed with Parameters: ', CHAR(13), CHAR(10), @OperationRunParameters);
		DECLARE @ErrorMessage NVARCHAR(MAX) = CONCAT('Unable to log the completion of operation ''', @OperationName, '''  with Parameters: ', CHAR(13), CHAR(10), @OperationRunParameters);	
				
		-- log OperationRun as completed
		UPDATE Logs.OperationRuns
		SET
			 StatusID = 3	-- C,Completed in Logs.OperationStatuses
			,EndTime = CURRENT_TIMESTAMP
		WHERE OperationRunID = @OperationRunID
			   		 
					 
		-- throw event
		EXEC Logs.sp_SetEvent	 @RunID = @OperationRunID		-- INT						
								,@AffectedRows = @@rowcount		-- INT, NULL
								,@ProcedureID = @@PROCID		-- INT, NULL
								,@Parameters = @CurrentParameters	-- NVARCHAR(MAX), NULL
								,@EventMessage = @EventMessage		-- NVARCHAR(MAX)

	END TRY
	BEGIN CATCH

		-- throw error
		EXEC Logs.sp_SetError	 @RunID = @OperationRunID		-- INT
								,@ProcedureID = @@PROCID		-- INT, NULL
								,@Parameters = @CurrentParameters	-- NVARCHAR(MAX), NULL
								,@ErrorMessage = @ErrorMessage	-- NVARCHAR(MAX), NULL

	END CATCH
END
GO



