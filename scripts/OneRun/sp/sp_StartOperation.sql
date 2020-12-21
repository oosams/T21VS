USE MASTER;
GO

USE T21;
GO

-- Create new OperationRun, return new OperationRunID 

-------------
CREATE OR ALTER PROCEDURE Logs.sp_StartOperation
	 @OperationID INT
	,@Description NVARCHAR(255) = NULL 
	,@OperationRunParameters NVARCHAR(MAX) = NULL

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
		DECLARE @CurrentParameters NVARCHAR(MAX) =  CONCAT(
			CHAR(9), '@OperationID = ', @OperationID, CHAR(13), CHAR(10),
			CHAR(9), '@Description = ', @Description, CHAR(13), CHAR(10),
			CHAR(9), '@OperationRunParameters = ', @OperationRunParameters, CHAR(13), CHAR(10)); 


		-- to keep new OperationRunID 
		DECLARE @CurrentRunID INT;		

		-- log New OperationRun
		INSERT INTO Logs.OperationRuns(
			 StatusID 
			,OperationID 
			,StartTime 
			,Description)
		VALUES(
			1 	-- R,Running in Logs.OperationStatuses
			,@OperationID 
			,CURRENT_TIMESTAMP 
			,CONCAT(@OperationDescription, ' ', @Description));

			 
		SET @CurrentRunID = SCOPE_IDENTITY();

		DECLARE @EventMessage NVARCHAR(MAX) = CONCAT('Started. Operation ''', @OperationName, ''' has been started with:', CHAR(13), CHAR(10),
																			CHAR(9), 'OperationRunID: ', @CurrentRunID, '.', CHAR(13), CHAR(10), 
																			CHAR(9), 'Parameters: ', CHAR(13), CHAR(10), @OperationRunParameters);

		-- throw event
		EXEC Logs.sp_SetEvent	 @RunID = @CurrentRunID		-- INT						
								,@AffectedRows = @@rowcount		-- INT, NULL
								,@ProcedureID = @@PROCID		-- INT, NULL
								,@Parameters = @CurrentParameters	-- NVARCHAR(MAX), NULL
								,@EventMessage = @EventMessage		-- NVARCHAR(MAX)

		RETURN @CurrentRunID;

	END TRY
	BEGIN CATCH

		DECLARE @CurrentErrorMessage NVARCHAR(4000) = ERROR_MESSAGE();  
		DECLARE @CurrentErrorSeverity INT = ERROR_SEVERITY();  
		DECLARE @CurrentErrorState INT = ERROR_STATE();

		RAISERROR(
			 @CurrentErrorMessage   
			,@CurrentErrorSeverity    
			,@CurrentErrorState); 

	END CATCH
END
GO

 
