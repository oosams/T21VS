USE MASTER;
GO

USE T21;
GO


-- Create new OperationRun 

-------------
CREATE OR ALTER PROCEDURE logs.sp_StartOperation
	@OperationID INT,
	@Description nvarchar(255) = NULL

AS
BEGIN
	BEGIN TRY

		-- for logging
		DECLARE @curentParameters NVARCHAR(MAX) =  CONCAT(
			CHAR(9), '@OperationID = ', @OperationID, CHAR(13), CHAR(10),
			CHAR(9), '@Description = ', @Description, CHAR(13), CHAR(10));
		DECLARE @eventMessage

		-- to keep new OperationRunID 
		DECLARE @curentRunID INT;

		-- get Operation Name and Description
		DECLARE @OperationName nvarchar(255);
		DECLARE @OperationDescription nvarchar(MAX);
		
		SELECT 
			@OperationName = OperationName,
			@OperationDescription = Description
		FROM Logs.Operations
		WHERE OperationID = @OperationID;


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

		SET @curentRunID = SCOPE_IDENTITY();

		-- throw event

		DECLARE @curentRunID int = -1
		EXEC logs.sp_SetEvent	 @runID = @curentRunID						
								,@affectedRows = @@rowcount
								,@procedureID = @@PROCID
								,@parameters = '1'--@curentParameters
								,@eventMessage = CONCAT('Operation ''', @OperationName, ''' has been started. ')

		RETURN @curentRunID;

	END TRY
	BEGIN CATCH

		--TODO EXEC  sp_SetError

	END CATCH
END
GO





--------DEBUG---------
DECLARE @curentParameters NVARCHAR(MAX) =  CONCAT(
		CHAR(9), '@par1 = ', 'par1', CHAR(13), CHAR(10),
		CHAR(9), '@par1 = ', 'par1', CHAR(13), CHAR(10)
		)

EXEC logs.sp_StartOperation 