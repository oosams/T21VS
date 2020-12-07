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
	BEGIN TRY

		DECLARE @procName NVARCHAR(1024) = OBJECT_SCHEMA_NAME(@procedureID) + '.' + OBJECT_NAME(@procedureID);
		DECLARE @curentErrorMessage NVARCHAR(4000) = ERROR_MESSAGE();  
		DECLARE @curentErrorSeverity INT = ERROR_SEVERITY();  
		DECLARE @curentErrorState INT = ERROR_STATE();
		
		INSERT INTO Logs.ErrorLogs(
			OperationRunID,
			ErrorNumber,
			ErrorProcName,
			Parameters,
			ErrorMessage,
			ErrorDateTime)		
		VALUES(
			@runID,
			ERROR_NUMBER(),
			@procName,
			@parameters,
			CONCAT(@errorMessage,' ',@curentErrorMessage),
			CURRENT_TIMESTAMP);
		
		RAISERROR(
			@curentErrorMessage,   
			@curentErrorSeverity,   
			@curentErrorState);    
		
	END TRY
	BEGIN CATCH

		SELECT   
			@curentErrorMessage = ERROR_MESSAGE(),  
			@curentErrorSeverity = ERROR_SEVERITY(),  
			@curentErrorState = ERROR_STATE();  
		
		RAISERROR(
			@curentErrorMessage,   
			@curentErrorSeverity,   
			@curentErrorState); 

	END CATCH
END
GO

--------DEBUG---------
DECLARE @parameters NVARCHAR(1024) =  CONCAT(
		CHAR(9), '@par1 = ', 'par1', CHAR(13), CHAR(10),
		CHAR(9), '@par1 = ', 'par1', CHAR(13), CHAR(10)
		)

BEGIN TRY
select 1/0
END TRY
BEGIN CATCH
--SELECT ERROR_MESSAGE(), ERROR_SEVERITY(), ERROR_STATE(), ERROR_NUMBER()
EXEC logs.sp_SetError	 @runID = 112
						,@procedureID = 111
						,@parameters = @parameters
						,@errorMessage = 'Test Error Message.'
END CATCH

select * FROM Logs.ErrorLogs

