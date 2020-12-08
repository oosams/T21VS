USE MASTER;
GO

USE T21;
GO

-- Truncate and populate all tables in database from provided folder

-------------
CREATE OR ALTER PROCEDURE sp_InitialLoad 
	@Path nvarchar(1000),
	@FileExt nvarchar(255)

AS
BEGIN

	-- TODO EXEC sp_StartOperation ( opID from operations 1, 

	-- for logging
	DECLARE @curentParameters NVARCHAR(MAX) =  CONCAT(
		CHAR(9), '@Path = ', @Path, CHAR(13), CHAR(10),
		CHAR(9), '@FileExt = ', @FileExt, CHAR(13), CHAR(10));

	-- to concat table name from INFORMATION_SCHEMA.TABLES
	DECLARE @table nvarchar (1000); 
		
			 
	
	-- check path existing
	DECLARE @vFileExists Table (FileExists int, FileDir int, ParentDirExists int);

	INSERT INTO @vFileExists 
       EXEC xp_fileexist @Path

	IF (SELECT FileDir FROM @vFileExists) = 0 
		BEGIN
			-- set Error
			EXEC logs.sp_SetError	 @runID = -112 -- get from sp_StartOperation
									,@procedureID = @@PROCID
									,@parameters = @curentParameters
									,@errorMessage = 'The path does not exists. '

			-- TODO EXEC  sp_FailOperation
			RETURN -1
		END
			

	-- CURSOR to get table names from entire db
	DECLARE CUR CURSOR FAST_FORWARD FOR
		SELECT 
			table_schema + '.' + table_name as tablename
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


		-- EXEC sp_SetEvent
		-- EXEC  sp_SetError
		-- EXEC  sp_FailOperation -- not using here?  
		END CATCH
		FETCH NEXT FROM CUR INTO @table
	END
	CLOSE CUR
	DEALLOCATE CUR

	-- TODO EXEC  sp_CompleteOperation

END
GO

----Add info in Logs.Operations------

INSERT INTO Logs.Operations
VALUES(
	1,'sp_InitialLoad', 'First Initial Load after db created');
GO

-------------DEBUG----------------------------
EXEC dbo.InitialLoad @Path = 'D:\_Work\GitHub\T21VS\scripts\generatedData\mockaroo\20201203\', @FileExt = '.csv';
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