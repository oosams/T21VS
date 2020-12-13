USE MASTER;
GO

USE T21;
GO

-- Create new OperationRun, return new OperationRunID 

-------------
CREATE OR ALTER PROCEDURE logs.sp_StartOperation
	@OperationID INT,
	@Description NVARCHAR(255) = NULL,
	@OperationRunParameters NVARCHAR(MAX) = NULL

AS
BEGIN
	BEGIN TRY

		-- get Operation Name and Description
		DECLARE @OperationName NVARCHAR(255);
		DECLARE @OperationDescription NVARCHAR(MAX);
		
		SELECT 
			@OperationName = OperationName,
			@OperationDescription = Description
		FROM Logs.Operations
		WHERE OperationID = @OperationID;


		-- for logging
		DECLARE @curentParameters NVARCHAR(MAX) =  CONCAT(
			CHAR(9), '@OperationID = ', @OperationID, CHAR(13), CHAR(10),
			CHAR(9), '@Description = ', @Description, CHAR(13), CHAR(10),
			CHAR(9), '@OperationRunParameters = ', @OperationRunParameters, CHAR(13), CHAR(10)); 

		DECLARE @eventMessage NVARCHAR(MAX) = CONCAT('Started. Operation ''', @OperationName, ''' has been started with Parameters: ', @OperationRunParameters);
	
		-- to keep new OperationRunID 
		DECLARE @curentRunID INT;		

		-- log New OperationRun
		INSERT INTO Logs.OperationRuns(
			StatusID,
			OperationID,
			StartTime,
			Description)
		VALUES(
			1,	-- R,Running in Logs.OperationStatuses
			@OperationID,
			CURRENT_TIMESTAMP,
			CONCAT(@OperationDescription, ' ', @Description));

			 
		SET @curentRunID = SCOPE_IDENTITY();

		-- throw event
		EXEC logs.sp_SetEvent	 @runID = @curentRunID		-- INT						
								,@affectedRows = @@rowcount		-- INT, NULL
								,@procedureID = @@PROCID		-- INT, NULL
								,@parameters = @curentParameters	-- NVARCHAR(MAX), NULL
								,@eventMessage = @eventMessage		-- NVARCHAR(MAX)

		RETURN @curentRunID;

	END TRY
	BEGIN CATCH

		DECLARE @curentErrorMessage NVARCHAR(4000) = ERROR_MESSAGE();  
		DECLARE @curentErrorSeverity INT = ERROR_SEVERITY();  
		DECLARE @curentErrorState INT = ERROR_STATE();

		RAISERROR(
			@curentErrorMessage,   
			@curentErrorSeverity,   
			@curentErrorState); 

	END CATCH
END
GO


--------DEBUG---------


EXEC logs.sp_StartOperation  @OperationID = 1	-- INT
							,@Description = 'test1Description'	-- NVARCHAR(255), NULL
							,@OperationRunParameters = 'test1OperationRunParameters'	-- NVARCHAR(MAX), NULL


select * FROM Logs.EventLogs
select * FROM Logs.ErrorLogs
select * FROM Logs.OperationRuns

