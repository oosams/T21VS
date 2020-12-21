USE MASTER;
GO

USE T21;
GO

-------------
CREATE OR ALTER PROC Logs.sp_SetEvent 
	 @RunID INT
	,@AffectedRows INT = NULL
	,@ProcedureID INT = NULL
	,@Parameters NVARCHAR(MAX) = NULL
	,@EventMessage NVARCHAR(MAX)

AS
BEGIN
	BEGIN TRY
		
		-- for logging
		DECLARE @CurrentParameters NVARCHAR(MAX) =  CONCAT(
			CHAR(9), '@RunID = ', @RunID, CHAR(13), CHAR(10),
			CHAR(9), '@AffectedRows = ', @AffectedRows, CHAR(13), CHAR(10),
			CHAR(9), '@ProcedureID = ', @ProcedureID, CHAR(13), CHAR(10),
			CHAR(9), '@Parameters = ', @Parameters, CHAR(13), CHAR(10),
			CHAR(9), '@EventMessage = ', @EventMessage, CHAR(13), CHAR(10));
		
		-- concat Proc Name
		DECLARE @ProcName NVARCHAR(1024) = OBJECT_SCHEMA_NAME(@ProcedureID) + '.' + OBJECT_NAME(@ProcedureID);

		INSERT INTO Logs.EventLogs(
			 OperationRunID
			,UserName
			,AffectedRows
			,EventProcName
			,Parameters
			,EventMessage
			EventDateTime)
		VALUES(
			 @RunID
			,CURRENT_USER
			,@AffectedRows
			,@ProcName
			,@Parameters
			,@EventMessage
			,CURRENT_TIMESTAMP);
						
	END TRY
	BEGIN CATCH

		-- throw error		
		EXEC Logs.sp_SetError	 @RunID = @RunID	-- INT
								,@ProcedureID = @@PROCID	-- INT, NULL
								,@Parameters = @CurrentParameters	-- NVARCHAR(MAX), NULL
								,@ErrorMessage = 'Cant log the event. '		-- NVARCHAR(MAX)

	END CATCH
END
GO


--------DEBUG---------
DECLARE @CurrentParameters NVARCHAR(MAX) =  CONCAT(
		CHAR(9), '@par1 = ', 'par1', CHAR(13), CHAR(10),
		CHAR(9), '@par1 = ', 'par1', CHAR(13), CHAR(10)
		)

EXEC Logs.sp_SetEvent	 @RunID = -113	-- INT					
						,@AffectedRows = @@rowcount		-- INT, NULL
						,@procedureID = -111	-- INT, NULL
						,@Parameters = @CurrentParameters	-- NVARCHAR(MAX), NULL
						,@EventMessage = 'Test event Message. '		-- NVARCHAR(MAX)
						
						
SELECT * FROM Logs.EventLogs
SELECT * FROM Logs.ErrorLogs
SELECT * FROM Logs.OperationRuns


