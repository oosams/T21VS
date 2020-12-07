USE MASTER
GO

USE T21
GO

--sample

CREATE OR ALTER PROCEDURE sp_sampleForLogging

AS
BEGIN
	DECLARE @parameters NVARCHAR(MAX) =  CONCAT(
		CHAR(9), '@par1 = ', 'par1', CHAR(13), CHAR(10),
		CHAR(9), '@par1 = ', 'par1', CHAR(13), CHAR(10))
 
 
	-- EXEC sp_StartOperation ( opID from operations,  
	
	-- EXEC sp_SetEvent start some checks
	--some checks with errors
	IF 1 = 0 
		BEGIN

 
		--EXEC  sp_SetEvent
		--EXEC  sp_SetError
		--EXEC  sp_FailOperation
		RETURN -1
		END
	-- EXEC sp_SetEvent start some checks completed	

	-- EXEC sp_SetEvent some action started	
	BEGIN TRY
		--some code
		SELECT 1
		--SELECT 1/ 0
	END TRY
	BEGIN CATCH
		--EXEC sp_SetEvent
		--EXEC  sp_SetError
		--EXEC  sp_FailOperation  
		RETURN -1
	END CATCH
	
	--EXEC  sp_CompleteOperation

END
GO
-----------------------------------------
EXEC sp_sampleForLogging;
------------------------------------------
