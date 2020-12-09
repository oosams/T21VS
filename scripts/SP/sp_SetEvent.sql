USE MASTER;
GO

USE T21;
GO

-------------
CREATE OR ALTER PROC logs.sp_SetEvent 
	@runID INT,
	@affectedRows INT = NULL,
	@procedureID INT = NULL,
	@parameters NVARCHAR(MAX) = NULL,
	@eventMessage NVARCHAR(MAX)

AS
BEGIN
	BEGIN TRY
		
		-- for logging
		DECLARE @curentParameters NVARCHAR(MAX) =  CONCAT(
			CHAR(9), '@runID = ', @runID, CHAR(13), CHAR(10),
			CHAR(9), '@affectedRows = ', @affectedRows, CHAR(13), CHAR(10),
			CHAR(9), '@procedureID = ', @procedureID, CHAR(13), CHAR(10),
			CHAR(9), '@parameters = ', @parameters, CHAR(13), CHAR(10),
			CHAR(9), '@eventMessage = ', @eventMessage, CHAR(13), CHAR(10));
		
		-- concat Proc Name
		DECLARE @procName NVARCHAR(1024) = OBJECT_SCHEMA_NAME(@procedureID) + '.' + OBJECT_NAME(@procedureID);

		INSERT INTO Logs.EventLogs(
			OperationRunID,
			UserName,
			AffectedRows,
			EventProcName,
			Parameters,
			EventMessage,
			EventDateTime)
		VALUES(
			@runID,
			CURRENT_USER,
			@affectedRows,
			@procName,
			@parameters,
			@eventMessage,
			CURRENT_TIMESTAMP);
						
	END TRY
	BEGIN CATCH

		-- throw error		
		EXEC logs.sp_SetError	 @runID = @runID	-- INT
								,@procedureID = @@PROCID	-- INT, NULL
								,@parameters = @curentParameters	-- NVARCHAR(MAX), NULL
								,@errorMessage = 'Cant log the event. '		-- NVARCHAR(MAX)

	END CATCH
END
GO


--------DEBUG---------
DECLARE @curentParameters NVARCHAR(MAX) =  CONCAT(
		CHAR(9), '@par1 = ', 'par1', CHAR(13), CHAR(10),
		CHAR(9), '@par1 = ', 'par1', CHAR(13), CHAR(10)
		)

EXEC logs.sp_SetEvent	 @runID = -113	-- INT					
						,@affectedRows = @@rowcount		-- INT, NULL
						,@procedureID = -111	-- INT, NULL
						,@parameters = @curentParameters	-- NVARCHAR(MAX), NULL
						,@eventMessage = 'Test event Message. '		-- NVARCHAR(MAX)
						
						
select * FROM Logs.EventLogs
select * FROM Logs.ErrorLogs
select * FROM Logs.OperationRuns


