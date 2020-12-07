USE MASTER
GO

USE T21
GO

-------------
CREATE OR ALTER PROC logs.sp_SetError
	@runID INT,
	@procedureID INT = NULL,
	@parameters NVARCHAR(1024) = NULL,
	@errorMessage NVARCHAR(MAX) = NULL

AS
BEGIN
	--BEGIN TRY

		DECLARE @procName NVARCHAR(1024) = OBJECT_SCHEMA_NAME(@procedureID) + '.' + OBJECT_NAME(@procedureID);

		INSERT INTO Logs.ErrorLogs
		(
			OperationRunID,
			ErrorNumber,
			ErrorProcName,
			Parameters,
			ErrorMessage,
			ErrorDateTime
		)
		VALUES
		(
			@runID,
			ERROR_NUMBER(),
			@procName,
			@parameters,
			@errorMessage,
			CURRENT_TIMESTAMP
		);

	--END TRY
	--BEGIN CATCH
		
	--	RAISERROR

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

BEGIN TRY
select 1/0
END TRY
BEGIN CATCH
--SELECT ERROR_MESSAGE(), ERROR_SEVERITY(), ERROR_STATE(), ERROR_NUMBER()
RAISERROR(
END CATCH

