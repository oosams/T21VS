USE MASTER;
GO

USE T21;
GO

-- template

CREATE OR ALTER PROCEDURE Logs.sp_templateForLogging
	 @Par1 INT
	,@Par2 NVARCHAR(255) = NULL

AS
BEGIN
	BEGIN TRY

		-- for logging
		DECLARE @CurrentParameters NVARCHAR(MAX) =  CONCAT(
			CHAR(9), '@Par1 = ', @Par1, CHAR(13), CHAR(10),
			CHAR(9), '@Par2 = ', @Par2, CHAR(13), CHAR(10));

		-- to keep new OperationRunID 
		DECLARE @CurrentRunID INT;	

		-- Start Operation and get new OperationRunID
		EXEC @CurrentRunID = 
			Logs.sp_StartOperation   @OperationID = 999	-- INT     OperationID for Log.sp_templateForLogging  from Logs.Operations
									,@Description = NULL	-- NVARCHAR(255), NULL
									,@OperationRunParameters = @CurrentParameters	-- NVARCHAR(MAX), NULL
		  
	
		-- EXEC sp_SetEvent start some checks
		-- some checks with errors
		IF 1 = 0 
			BEGIN 
				-- throw Error
				EXEC Logs.sp_SetError	 @RunID = @CurrentRunID		-- INT       -- get from sp_StartOperation
										,@ProcedureID = @@PROCID	-- INT, NULL
										,@Parameters = @CurrentParameters	-- NVARCHAR(MAX), NULL
										,@ErrorMessage = 'check failed  '	-- NVARCHAR(MAX), NULL

				-- Fail Operation
				EXEC Logs.sp_FailOperation   @OperationRunID = 	@CurrentRunID	 -- INT       -- get from sp_StartOperation
											,@OperationRunParameters = @CurrentParameters  -- NVARCHAR(MAX), NULL

				RETURN -1
			END

		-- throw Event
		EXEC Logs.sp_SetEvent	 @RunID = @CurrentRunID	-- INT					
								,@AffectedRows = @@rowcount		-- INT, NULL
								,@ProcedureID = @@PROCID	-- INT, NULL
								,@Parameters = @CurrentParameters	-- NVARCHAR(MAX), NULL
								,@EventMessage = 'Some checks completed. Starting the operation.'		-- NVARCHAR(MAX)
			

		


		--
		---
		---

		-- Complete Operation
		EXEC Logs.sp_CompleteOperation   @OperationRunID = 	@CurrentRunID	 -- INT       -- get from sp_StartOperation
										,@OperationRunParameters = @CurrentParameters  -- NVARCHAR(MAX), NULL
	END TRY
	BEGIN CATCH
			 
		-- throw Error
		EXEC Logs.sp_SetError	 @RunID = @CurrentRunID 		-- INT       -- get from sp_StartOperation
								,@ProcedureID = @@PROCID	-- INT, NULL
								,@Parameters = @CurrentParameters	-- NVARCHAR(MAX), NULL
								,@ErrorMessage = NULL	-- NVARCHAR(MAX), NULL

		-- Fail Operation
		EXEC Logs.sp_FailOperation   @OperationRunID = 	@CurrentRunID	 -- INT       -- get from sp_StartOperation
									,@OperationRunParameters = @CurrentParameters  -- NVARCHAR(MAX), NULL

		RETURN -1
	END CATCH
END
GO

----Add info in Logs.Operations------

SET IDENTITY_INSERT Logs.Operations ON;  

INSERT INTO Logs.Operations(
	 OperationID
	,OperationName 
	,Description)
VALUES
	(999,'Logs.sp_templateForLogging ','template proc, not for running');
SET IDENTITY_INSERT Logs.Operations OFF;
GO
SELECT * FROM Logs.Operations

-----------------------------------------
EXEC sp_sampleForLogging @Par1 = 1 -- INT
						,@Par2 = '2' --  NVARCHAR(255), NULL
------------------------------------------
