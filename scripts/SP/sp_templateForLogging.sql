USE MASTER;
GO

USE T21;
GO

-- template

CREATE OR ALTER PROCEDURE sp_templateForLogging
	@par1 INT,
	@par2 NVARCHAR(255) = NULL

AS
BEGIN
	BEGIN TRY

		-- for logging
		DECLARE @curentParameters NVARCHAR(MAX) =  CONCAT(
			CHAR(9), '@par1 = ', @par1, CHAR(13), CHAR(10),
			CHAR(9), '@par2 = ', @par2, CHAR(13), CHAR(10));

		-- to keep new OperationRunID 
		DECLARE @curentRunID INT;	

		-- Start Operation and get new OperationRunID
		EXEC @curentRunID = 
			logs.sp_StartOperation   @OperationID = 1	-- INT     OperationID for sp_InitialLoad  from Logs.Operations
									,@Description = NULL	-- NVARCHAR(255), NULL
									,@OperationRunParameters = @curentParameters	-- NVARCHAR(MAX), NULL
		  
	
		-- EXEC sp_SetEvent start some checks
		-- some checks with errors
		IF 1 = 0 
			BEGIN 
				-- throw Error
				EXEC logs.sp_SetError	 @runID = @curentRunID		-- INT       -- get from sp_StartOperation
										,@procedureID = @@PROCID	-- INT, NULL
										,@parameters = @curentParameters	-- NVARCHAR(MAX), NULL
										,@errorMessage = 'check failed  '	-- NVARCHAR(MAX), NULL

				-- Fail Operation
				EXEC logs.sp_FailOperation   @OperationRunID = 	@curentRunID	 -- INT       -- get from sp_StartOperation
											,@OperationRunParameters = @curentParameters  -- NVARCHAR(MAX), NULL

				RETURN -1
			END

		-- throw Event
		EXEC logs.sp_SetEvent	 @runID = @curentRunID	-- INT					
								,@affectedRows = @@rowcount		-- INT, NULL
								,@procedureID = @@PROCID	-- INT, NULL
								,@parameters = @curentParameters	-- NVARCHAR(MAX), NULL
								,@eventMessage = 'Some checks completed. Starting the operation.'		-- NVARCHAR(MAX)
			

		BEGIN TRY


		--
		---
		---

		-- Complete Operation
		EXEC logs.sp_CompleteOperation   @OperationRunID = 	@curentRunID	 -- INT       -- get from sp_StartOperation
										,@OperationRunParameters = @curentParameters  -- NVARCHAR(MAX), NULL
		END TRY
		BEGIN CATCH
			 
		-- throw Error
		EXEC logs.sp_SetError	 @runID = @curentRunID 		-- INT       -- get from sp_StartOperation
								,@procedureID = @@PROCID	-- INT, NULL
								,@parameters = @curentParameters	-- NVARCHAR(MAX), NULL
								,@errorMessage = NULL	-- NVARCHAR(MAX), NULL

		-- Fail Operation
		EXEC logs.sp_FailOperation   @OperationRunID = 	@curentRunID	 -- INT       -- get from sp_StartOperation
									,@OperationRunParameters = @curentParameters  -- NVARCHAR(MAX), NULL

		RETURN -1
	END CATCH
END
GO
-----------------------------------------
EXEC sp_sampleForLogging;
------------------------------------------
