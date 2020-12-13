USE MASTER;
GO

USE T21;
GO

-- Create new Address, return new AddressID

-------------
CREATE OR ALTER PROCEDURE shop.sp_CreateAddress
	@AddressLine1 NVARCHAR(500),
	@AddressLine2 NVARCHAR(500) = NULL,
	@City NVARCHAR(255),
	@Region NVARCHAR(255) = NULL,
	@Country NVARCHAR(255),
	@PostalCode NVARCHAR(100) = NULL

AS
BEGIN
	BEGIN TRY

		-- for logging
		DECLARE @curentParameters NVARCHAR(MAX) =  CONCAT(
			CHAR(9), '@OperationID = ', @OperationID, CHAR(13), CHAR(10),
			CHAR(9), '@Description = ', @Description, CHAR(13), CHAR(10),
			CHAR(9), '@OperationRunParameters = ', @OperationRunParameters, CHAR(13), CHAR(10)); 

		
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

EXEC logs.sp_CompleteOperation   @OperationRunID = 	2	 -- INT       -- get from sp_StartOperation
								,@OperationRunParameters = 'test1OperationRunParameters'  -- NVARCHAR(MAX), NULL


select * FROM Logs.EventLogs
select * FROM Logs.ErrorLogs
select * FROM Logs.OperationRuns

