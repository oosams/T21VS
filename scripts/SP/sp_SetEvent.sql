
CREATE OR ALTER PROC logs.sp_SetEvent 
	@runID INT,
	@affectedRows INT = NULL,
	@procedureID INT = NULL,
	@parameters NVARCHAR(1024) = NULL,
	@eventMessage NVARCHAR(MAX)

AS
BEGIN
	--BEGIN TRY

		DECLARE @procName NVARCHAR(1024) = OBJECT_NAME(@procedureID) + '.' +	OBJECT_SCHEMA_NAME(@procedureID);

		INSERT INTO Logs.EventLogs
		(
			OperationRunID,
			UserName,
			AffectedRows,
			EventProcName,
			Parameters,
			EventMessage,
			EventDateTime
		)
		VALUES
		(
			@runID,
			CURRENT_USER,
			@affectedRows,
			@procName,
			@parameters,
			@eventMessage,
			CURRENT_TIMESTAMP
		);

	--END TRY
	--BEGIN CATCH
		
	--	EXEC logs.sp_SetError

	--END CATCH
END
GO
--------------
EXEC logs.sp_SetEvent	 @runID = 111
						
						,@affectedRows = NULL
						,@procedureID = NULL
						,@parameters = NULL
						,@eventMessage = 'Test Message'
						


