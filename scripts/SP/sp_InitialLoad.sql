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

	-- Start operation and get new OperationRunID
	EXEC @curentRunID = 
		logs.sp_StartOperation   @OperationID = 1	-- INT     OperationID for sp_InitialLoad  from Logs.Operations
								,@Description = NULL	-- NVARCHAR(255), NULL
								,@OperationRunParameters = @curentParameters	-- NVARCHAR(MAX), NULL
		   

	-- check path existing
	DECLARE @vFileExists Table (FileExists INT, FileDir INT, ParentDirExists INT);

	INSERT INTO @vFileExists 
       EXEC xp_fileexist @Path;

	IF (SELECT FileDir FROM @vFileExists) = 0 
		BEGIN
			-- throw Error
			EXEC logs.sp_SetError	 @runID = -112 		-- INT       -- get from sp_StartOperation
									,@procedureID = @@PROCID	-- INT, NULL
									,@parameters = @curentParameters	-- NVARCHAR(MAX), NULL
									,@errorMessage = 'The path does not exists. '	-- NVARCHAR(MAX), NULL

			-- Fail Operation
			EXEC logs.sp_FailOperation   @OperationRunID = 	@curentRunID	 -- INT
										,@OperationRunParameters = @curentParameters  -- NVARCHAR(MAX), NULL

			RETURN -1
		END
			
	-- to concat table name from INFORMATION_SCHEMA.TABLES
	DECLARE @table NVARCHAR (1000);

	-- CURSOR to get table names from entire db
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

		END TRY
		BEGIN CATCH
		
			-- throw Error
			EXEC logs.sp_SetError	 @runID = -112 		-- INT       -- get from sp_StartOperation
									,@procedureID = @@PROCID	-- INT, NULL
									,@parameters = @curentParameters	-- NVARCHAR(MAX), NULL
									,@errorMessage = CONCAT('Failed to insert from file @table.@FileExt '	-- NVARCHAR(MAX), NULL

		END CATCH
		FETCH NEXT FROM CUR INTO @table
	END
	CLOSE CUR
	DEALLOCATE CUR

	-- TODO EXEC  sp_CompleteOperation

END
GO

----Add info in Logs.Operations------

SET IDENTITY_INSERT Logs.Operations ON;  

INSERT INTO Logs.Operations(
	OperationID,
	OperationName,
	Description)
VALUES(
	1,
	'sp_InitialLoad', 
	'First Initial Load after db is created');
SET IDENTITY_INSERT Logs.Operations OFF;
GO
SELECT * FROM Logs.Operations


-------------DEBUG----------------------------


EXEC dbo.InitialLoad @Path = 'D:\_Work\GitHub\T21VS\scripts\generatedData\mockaroo\20201203\', @FileExt = '.csv';

select * FROM Logs.EventLogs
select * FROM Logs.ErrorLogs
select * FROM Logs.OperationRuns
------------------------------------------




--------

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