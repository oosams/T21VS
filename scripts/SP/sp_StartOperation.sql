USE T21;
GO

--Truncate and populate all tables in database from provided folder


CREATE OR ALTER PROCEDURE logs.sp_StartOperation
	@OperationID nvarchar(1000),
	@Description nvarchar(255) = NULL

AS
BEGIN
	BEGIN TRY

		--to keep new OperationRunID 
		DECLARE @curentRunID INT;



		INSERT INTO Logs.OperationRuns(
			StatusID,
			OperationID,
			StartTime,
			EndTime,
			Description)
		VALUES(
			1,
			@OperationID,
			CURRENT_TIMESTAMP,
			,
			Description);

		SET @curentRunID = SCOPE_IDENTITY()


		SELECT CURRENT_TIMESTAMP 2020-12-08 18:12:43.647

		--TODO EXEC sp_SetEvent

		RETURN @curentRunID

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