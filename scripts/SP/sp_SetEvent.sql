USE MASTER
GO

USE T21
GO

-------------
CREATE OR ALTER PROC logs.sp_SetEvent 
	@runID INT,
	@affectedRows INT = NULL,
	@procedureID INT = NULL,
	@parameters NVARCHAR(1024) = NULL,
	@eventMessage NVARCHAR(MAX)

AS
BEGIN
	--BEGIN TRY

		DECLARE @procName NVARCHAR(1024) = OBJECT_SCHEMA_NAME(@procedureID) + '.' + OBJECT_NAME(@procedureID);

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
DECLARE @parameters NVARCHAR(1024) =  CONCAT(
		CHAR(9), '@par1 = ', 'par1', CHAR(13), CHAR(10),
		CHAR(9), '@par1 = ', 'par1', CHAR(13), CHAR(10)
		)

EXEC logs.sp_SetEvent	 @runID = 112
						
						,@affectedRows = @@rowcount
						,@procedureID = 111
						,@parameters = @parameters
						,@eventMessage = 'Test Message'
						


select * FROM Logs.EventLogs