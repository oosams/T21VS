USE MASTER;
GO

USE T21;
GO

-------------
CREATE OR ALTER PROC Logs.sp_SetError
	 @RunID INT
	,@ProcedureID INT = NULL
	,@Parameters NVARCHAR(MAX) = NULL
	,@ErrorMessage NVARCHAR(MAX) = NULL

AS
BEGIN
	BEGIN TRY

		-- concat Proc Name
		DECLARE @ProcName NVARCHAR(1024) = OBJECT_SCHEMA_NAME(@ProcedureID) + '.' + OBJECT_NAME(@ProcedureID);

		-- collect error info
		DECLARE @CurrentErrorMessage NVARCHAR(4000) = ERROR_MESSAGE();  
		DECLARE @CurrentErrorSeverity INT = ERROR_SEVERITY();  
		DECLARE @CurrentErrorState INT = ERROR_STATE();
		
		INSERT INTO Logs.ErrorLogs(
			 OperationRunID
			,ErrorNumber
			,ErrorProcName
			,Parameters
			,ErrorMessage
			,ErrorDateTime)		
		VALUES(
			 @RunID
			,ERROR_NUMBER()
			,@ProcName
			,@Parameters
			,CONCAT(@CurrentErrorMessage,' ',@ErrorMessage)
			,CURRENT_TIMESTAMP);
		
		RAISERROR(
			 @CurrentErrorMessage   
			,@CurrentErrorSeverity   
			,@CurrentErrorState);    
		
	END TRY
	BEGIN CATCH

		SELECT   
			 @CurrentErrorMessage = ERROR_MESSAGE()  
			,@CurrentErrorSeverity = ERROR_SEVERITY()  
			,@CurrentErrorState = ERROR_STATE();  
		
		RAISERROR(
			 @CurrentErrorMessage   
			,@CurrentErrorSeverity  
			,@CurrentErrorState); 

	END CATCH
END
GO


--------DEBUG---------
DECLARE @CurrentParameters NVARCHAR(MAX) =  CONCAT(
		CHAR(9), '@par1 = ', 'par1', CHAR(13), CHAR(10),
		CHAR(9), '@par1 = ', 'par1', CHAR(13), CHAR(10))

BEGIN TRY
	SELECT 1/0
END TRY
BEGIN CATCH
-- SELECT ERROR_MESSAGE(), ERROR_SEVERITY(), ERROR_STATE(), ERROR_NUMBER()

EXEC Logs.sp_SetError	 @RunID = -112		-- INT
						,@ProcedureID = -111		-- INT, NULL
						,@Parameters = @CurrentParameters	-- NVARCHAR(MAX), NULL
						,@ErrorMessage = 'Test Error Message. '	-- NVARCHAR(MAX), NULL

END CATCH

SELECT * FROM Logs.ErrorLogs


