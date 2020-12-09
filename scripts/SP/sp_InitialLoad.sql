USE MASTER;
GO

USE T21;
GO

-- Truncate and populate all tables in database from provided folder

-------------
CREATE OR ALTER PROCEDURE sp_InitialLoad 
	@Path NVARCHAR(1000),
	@FileExt NVARCHAR(255)

AS
BEGIN
	BEGIN TRY

		-- for logging
		DECLARE @curentParameters NVARCHAR(MAX) =  CONCAT(
			CHAR(9), '@Path = ', @Path, CHAR(13), CHAR(10),
			CHAR(9), '@FileExt = ', @FileExt, CHAR(13), CHAR(10));

		-- to keep new OperationRunID 
		DECLARE @curentRunID INT;	

		-- Start Operation and get new OperationRunID
		EXEC @curentRunID = 
			logs.sp_StartOperation   @OperationID = 1	-- INT     OperationID for sp_InitialLoad  from Logs.Operations
									,@Description = NULL	-- NVARCHAR(255), NULL
									,@OperationRunParameters = @curentParameters	-- NVARCHAR(MAX), NULL
		   

		-- check path existence, throw error and fail operation if doesn't exist
		DECLARE @vFileExists Table (FileExists INT, FileDir INT, ParentDirExists INT);

		INSERT INTO @vFileExists 
		   EXEC xp_fileexist @Path;

		IF (SELECT FileDir FROM @vFileExists) = 0 
			BEGIN
				-- throw Error
				EXEC logs.sp_SetError	 @runID = @curentRunID		-- INT       -- get from sp_StartOperation
										,@procedureID = @@PROCID	-- INT, NULL
										,@parameters = @curentParameters	-- NVARCHAR(MAX), NULL
										,@errorMessage = 'The path does not exists. '	-- NVARCHAR(MAX), NULL

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
								,@eventMessage = 'Path exists. Starting the cursor.'		-- NVARCHAR(MAX)
			
		-- to concat table name from INFORMATION_SCHEMA.TABLES
		DECLARE @table NVARCHAR (1000);

		-- CURSOR to get table names from entire db
		-- throw error if file or table doesn't exists and fetch next one
		DECLARE CUR CURSOR FAST_FORWARD FOR

			SELECT 
				table_schema + '.' + table_name AS tablename
			FROM   INFORMATION_SCHEMA.TABLES

		OPEN CUR
		FETCH NEXT FROM CUR INTO @table
		WHILE @@FETCH_STATUS = 0
		BEGIN
			BEGIN TRY

				-- truncate each table and insert @Path + @table +@FileExt 
				EXECUTE('truncate table ' + @table +
					'; BULK INSERT ' + @table +
					' FROM '''+ @Path + @table +@FileExt+''' '+
					' with (fieldterminator = '','',rowterminator = ''0x0a'',FIRSTROW = 2, KEEPIDENTITY)')
				
				-- throw Event
				DECLARE @eventMessage NVARCHAR(MAX) = CONCAT('The ''', @table,  @FileExt,''' was inserted successfully');	
				EXEC logs.sp_SetEvent	 @runID = @curentRunID	-- INT					
										,@affectedRows = @@rowcount		-- INT, NULL
										,@procedureID = @@PROCID	-- INT, NULL
										,@parameters = @curentParameters	-- NVARCHAR(MAX), NULL
										,@eventMessage = @eventMessage		-- NVARCHAR(MAX)

			END TRY
			BEGIN CATCH

				-- throw Event
				DECLARE @skipMessage NVARCHAR(MAX) = CONCAT('Warning! ''', @table,  @FileExt,''' was not found and was skipped. Check file existence');	
				EXEC logs.sp_SetEvent	 @runID = @curentRunID	-- INT					
										,@affectedRows = @@rowcount		-- INT, NULL
										,@procedureID = @@PROCID	-- INT, NULL
										,@parameters = @curentParameters	-- NVARCHAR(MAX), NULL
										,@eventMessage = @skipMessage		-- NVARCHAR(MAX)

			END CATCH
			FETCH NEXT FROM CUR INTO @table
		END
		CLOSE CUR
		DEALLOCATE CUR

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

	END CATCH
END
GO

----Add info in Logs.Operations------

SET IDENTITY_INSERT Logs.Operations ON;  

INSERT INTO Logs.Operations(
	OperationID,
	OperationName,
	Description)
VALUES
	(1,'sp_InitialLoad','First Initial Load after db is created');
SET IDENTITY_INSERT Logs.Operations OFF;
GO
SELECT * FROM Logs.Operations


-------------DEBUG----------------------------


EXEC dbo.sp_InitialLoad  @Path = 'D:\_Work\GitHub\T21VS\scripts\generatedData\mockaroo\20201203\', @FileExt = '.csv';

select * FROM Logs.EventLogs
select * FROM Logs.ErrorLogs
select * FROM Logs.OperationRuns
select * FROM Logs.Operations

------------------------------------------
--CURSOR itself
------------------------------------------


DECLARE @table nvarchar (1000);
 DECLARE @Path nvarchar(1000) = 'D:\_Work\GitHub\T21VS\scripts\generatedData\mockaroo\20201203\', @FileExt nvarchar(1000) = '.csv';

	--CURSOR to get table names from entire db
	DECLARE CUR CURSOR FAST_FORWARD FOR
		SELECT 
			table_schema + '.' + table_name as tablename
		FROM   INFORMATION_SCHEMA.TABLES
	OPEN CUR
	FETCH NEXT FROM CUR INTO @table
	WHILE @@FETCH_STATUS = 0
	BEGIN
		--BEGIN TRY
			--truncate each table and insert @Path + @table +@FileExt 
			EXECUTE('truncate table ' + @table +
				'; BULK INSERT ' + @table +
				' FROM '''+ @Path + @table +@FileExt+''' '+
				' with (fieldterminator = '','',rowterminator = ''0x0a'',FIRSTROW = 2, KEEPIDENTITY)')
	--	END TRY
	--	BEGIN CATCH
		--EXEC  sp_SetError
		--EXEC  sp_FailOperation -- not using here?  
		--END CATCH
		FETCH NEXT FROM CUR INTO @table
	END
	CLOSE CUR
	DEALLOCATE CUR