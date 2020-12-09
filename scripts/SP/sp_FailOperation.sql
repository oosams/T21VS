USE MASTER;
GO

USE T21;
GO


-- Update OperationRun as failed 

-------------
CREATE OR ALTER PROCEDURE logs.sp_FailOperation
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

		DECLARE @eventMessage NVARCHAR(MAX) = CONCAT('Failed. Operation ''', @OperationName, ''' has been failed with Parameters: ', @OperationRunParameters);
		DECLARE @errorMessage NVARCHAR(MAX) = CONCAT('Cant log the fail of operation ''', @OperationName, '''  with Parameters: ', @OperationRunParameters);	
				
		-- log OperationRun as failed
		UPDATE Logs.OperationRuns
		SET
			StatusID = 2,	-- F,Failed in Logs.OperationStatuses
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


EXEC logs.sp_FailOperation   @OperationRunID = 	2	 -- INT
							,@OperationRunParameters = 'test1OperationRunParameters'  -- NVARCHAR(MAX), NULL


select * FROM Logs.EventLogs
select * FROM Logs.ErrorLogs
select * FROM Logs.OperationRuns

