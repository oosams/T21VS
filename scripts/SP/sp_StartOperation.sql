USE MASTER;
GO

USE T21;
GO


-- Create new OperationRun 

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

print 1
		-- for logging
		DECLARE @curentParameters NVARCHAR(MAX) =  CONCAT(
			CHAR(9), '@OperationID = ', @OperationID, CHAR(13), CHAR(10),
			CHAR(9), '@Description = ', @Description, CHAR(13), CHAR(10),
			CHAR(9), '@OperationRunParameters = ', @OperationRunParameters, CHAR(13), CHAR(10)); 
print 1	DECLARE @eventMessage NVARCHAR(MAX) = CONCAT('Operation ''', @OperationName, ''' has been started with Parameters: ', @OperationRunParameters);
print 1	DECLARE @errorMessage NVARCHAR(MAX) = CONCAT('Cant log the start of operation ''', @OperationName, '''  with Parameters: ', @OperationRunParameters);
print 2
		-- to keep new OperationRunID 
		DECLARE @curentRunID INT;		
print 3
		INSERT INTO Logs.OperationRuns(
			StatusID,
			OperationID,
			StartTime,
			Description)
		VALUES(
			1, -- R,Running in Logs.OperationStatuses
			@OperationID,
			CURRENT_TIMESTAMP,
			CONCAT(@Description, ' ', @OperationDescription));
print 4
			 
		SET @curentRunID = SCOPE_IDENTITY();
print @curentRunID
		-- throw event
		EXEC logs.sp_SetEvent	 @runID = @curentRunID		-- INT						
								,@affectedRows = @@rowcount		-- INT, NULL
								,@procedureID = @@PROCID		-- INT, NULL
								,@parameters = @curentParameters	-- NVARCHAR(MAX), NULL
								,@eventMessage = @eventMessage		-- NVARCHAR(MAX)
print 5
		RETURN @curentRunID;

	END TRY
	BEGIN CATCH
print 6
		--not needed?
		--EXEC logs.sp_SetError	 @runID = @curentRunID		-- INT
		--						,@procedureID = @@PROCID		-- INT, NULL
		--						,@parameters = @curentParameters	-- NVARCHAR(MAX), NULL
		--						,@errorMessage = @errorMessage	-- NVARCHAR(MAX), NULL

		   
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






DECLARE @time datetime
set @time = '2020-12-09 00:13:23.363'
SELECT @time 