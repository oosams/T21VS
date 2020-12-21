USE MASTER;
GO

USE T21;
GO

-- Truncate and populate all tables in database from provided folder

-------------
CREATE OR ALTER PROCEDURE config.sp_InitialLoad 
	 @Path NVARCHAR(1000)
	,@FileExt NVARCHAR(255)

AS
BEGIN
	BEGIN TRY

		-- for logging
		DECLARE @CurrentParameters NVARCHAR(MAX) =  CONCAT(
			CHAR(9), '@Path = ', @Path, CHAR(13), CHAR(10),
			CHAR(9), '@FileExt = ', @FileExt, CHAR(13), CHAR(10));

		-- to keep new OperationRunID 
		DECLARE @CurrentRunID INT;	

		-- Start Operation and get new OperationRunID
		EXEC @CurrentRunID = 
			Logs.sp_StartOperation   @OperationID = 1	-- INT     OperationID for Config.sp_InitialLoad   from Logs.Operations
									,@Description = NULL	-- NVARCHAR(255), NULL
									,@OperationRunParameters = @CurrentParameters	-- NVARCHAR(MAX), NULL
		   

		-- check path existence, throw error and fail operation if doesn't exist
		DECLARE @VFileExists Table (FileExists INT, FileDir INT, ParentDirExists INT);

		INSERT INTO @VFileExists 
		   EXEC xp_fileexist @Path;

		IF (SELECT FileDir FROM @VFileExists) = 0 
			BEGIN
				-- throw Error
				EXEC Logs.sp_SetError	 @RunID = @CurrentRunID		-- INT       -- get from sp_StartOperation
										,@ProcedureID = @@PROCID	-- INT, NULL
										,@Parameters = @CurrentParameters	-- NVARCHAR(MAX), NULL
										,@ErrorMessage = 'The path does not exists. '	-- NVARCHAR(MAX), NULL

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
								,@EventMessage = 'Path exists. Starting the cursor.'		-- NVARCHAR(MAX)
			
		-- to concat table name from INFORMATION_SCHEMA.TABLES
		DECLARE @Table NVARCHAR (1000);

		-- CURSOR to get table names from entire db
		-- throw error if file or table doesn't exists and fetch next one
		DECLARE CUR CURSOR FAST_FORWARD FOR

--TODO rebuild tebleinfo

			--SELECT 
			--	table_schema + '.' + table_name AS tablename
			--FROM   INFORMATION_SCHEMA.TABLES
			SELECT tablename AS tablename
			FROM Config.temp_tableinfo

		OPEN CUR
		FETCH NEXT FROM CUR INTO @Table
		WHILE @@FETCH_STATUS = 0
		BEGIN
			BEGIN TRY
--TODO rebuild error handling or bulkinsert, change to bcp at once?

				-- truncate each table and insert @Path + @Table +@FileExt 
				EXECUTE('truncate table ' + @Table +
					'; BULK INSERT ' + @Table +
					' FROM '''+ @Path + @Table +@FileExt+''' '+
					' with (fieldterminator = '','',rowterminator = ''0x0a'',FIRSTROW = 2, KEEPIDENTITY)')
				
				-- throw Event
				DECLARE @EventMessage NVARCHAR(MAX) = CONCAT('The ''', @Table,  @FileExt,''' was inserted successfully');	
				EXEC Logs.sp_SetEvent	 @RunID = @CurrentRunID	-- INT					
										,@AffectedRows = @@rowcount		-- INT, NULL
										,@ProcedureID = @@PROCID	-- INT, NULL
										,@Parameters = @CurrentParameters	-- NVARCHAR(MAX), NULL
										,@EventMessage = @EventMessage		-- NVARCHAR(MAX)

			END TRY
			BEGIN CATCH

				-- throw Event
				DECLARE @SkipMessage NVARCHAR(MAX) = CONCAT('Warning! ''', @table,  @FileExt,''' was not found and was skipped. Check file existence');	
				EXEC Logs.sp_SetEvent	 @RunID = @CurrentRunID	-- INT					
										,@AffectedRows = @@rowcount		-- INT, NULL
										,@ProcedureID = @@PROCID	-- INT, NULL
										,@Parameters = @CurrentParameters	-- NVARCHAR(MAX), NULL
										,@EventMessage = @SkipMessage		-- NVARCHAR(MAX)

			END CATCH
			FETCH NEXT FROM CUR INTO @Table
		END
		CLOSE CUR
		DEALLOCATE CUR

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
	(1,'Config.sp_InitialLoadd','First Initial Load after db is created');
SET IDENTITY_INSERT Logs.Operations OFF;
GO
SELECT * FROM Logs.Operations


-------------DEBUG----------------------------


EXEC Config.sp_InitialLoad   @Path = 'D:\_Work\GitHub\T21VS\scripts\generatedData\mockaroo\20201203\1\' -- NVARCHAR(1000) 
							,@FileExt = '.csv';		-- NVARCHAR(255)

SELECT * FROM Logs.EventLogs
SELECT * FROM Logs.ErrorLogs
SELECT * FROM Logs.OperationRuns
SELECT * FROM Logs.Operations
						  	 