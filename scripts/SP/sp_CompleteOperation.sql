USE MASTER;
GO

USE T21;
GO

-- Update OperationRun as completed

-------------
CREATE OR ALTER PROCEDURE logs.sp_CompleteOperation
	@OperationRunID INT,
	@OperationRunParameters NVARCHAR(MAX) = NULL

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
		DECLARE @curentParameters NVARCHAR(MAX) =  CONCAT(
			CHAR(9), '@OperationRunID = ', @OperationRunID, CHAR(13), CHAR(10),
			CHAR(9), '@OperationRunParameters = ', @OperationRunParameters, CHAR(13), CHAR(10));

		DECLARE @eventMessage NVARCHAR(MAX) = CONCAT('Completed. Operation ''', @OperationName, ''' has been completed with Parameters: ', @OperationRunParameters);
		DECLARE @errorMessage NVARCHAR(MAX) = CONCAT('Unable to log the completion of operation ''', @OperationName, '''  with Parameters: ', @OperationRunParameters);	
				
		-- log OperationRun as completed
		UPDATE Logs.OperationRuns
		SET
			StatusID = 3,	-- C,Completed in Logs.OperationStatuses
			EndTime = CURRENT_TIMESTAMP
		WHERE OperationRunID = @OperationRunID
			   		 
					 
		-- throw event
		EXEC logs.sp_SetEvent	 @runID = @OperationRunID		-- INT						
								,@affectedRows = @@rowcount		-- INT, NULL
								,@procedureID = @@PROCID		-- INT, NULL
								,@parameters = @curentParameters	-- NVARCHAR(MAX), NULL
								,@eventMessage = @eventMessage		-- NVARCHAR(MAX)

	END TRY
	BEGIN CATCH

		-- throw error
		EXEC logs.sp_SetError	 @runID = @OperationRunID		-- INT
								,@procedureID = @@PROCID		-- INT, NULL
								,@parameters = @curentParameters	-- NVARCHAR(MAX), NULL
								,@errorMessage = @errorMessage	-- NVARCHAR(MAX), NULL

	END CATCH
END
GO


--------DEBUG---------


EXEC logs.sp_CompleteOperation   @OperationRunID = 	2	 -- INT       -- get from sp_StartOperation
								,@OperationRunParameters = 'test1OperationRunParameters'  -- NVARCHAR(MAX), NULL


SELECT * FROM Logs.EventLogs
SELECT * FROM Logs.ErrorLogs
SELECT * FROM Logs.OperationRuns

