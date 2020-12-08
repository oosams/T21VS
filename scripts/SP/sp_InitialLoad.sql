USE T21;
GO

--Truncate and populate all tables in database from provided folder


CREATE OR ALTER PROCEDURE sp_InitialLoad 
	@Path nvarchar(1000),
	@FileExt nvarchar(255)
AS
BEGIN

	DECLARE @table nvarchar (1000); -- to concat table name from INFORMATION_SCHEMA.TABLES
	DECLARE @vFileExists Table (FileExists int, FileDir int, ParentDirExists int); --use to check path existing

	-- EXEC sp_StartOperation ( opID from operations,  
	
	--check path existing
	INSERT INTO @vFileExists 
       EXEC xp_fileexist @Path
	IF (SELECT FileDir FROM @vFileExists) = 0 
		BEGIN
			--set Error
			EXEC logs.sp_SetError	 @runID = -112
							,@procedureID = 111
							,@parameters = @parameters
							,@errorMessage = 'Test Error Message. '

			--EXEC  sp_FailOperation
			RETURN -1
		END
		
		


	

	--CURSOR to get table names from entire db
	DECLARE CUR CURSOR FAST_FORWARD FOR
		SELECT 
			table_schema + '.' + table_name as tablename
		FROM   INFORMATION_SCHEMA.TABLES
	OPEN CUR
	FETCH NEXT FROM CUR INTO @table
	WHILE @@FETCH_STATUS = 0
	BEGIN
		BEGIN TRY
			--truncate each table and insert @Path + @table +@FileExt 
			EXECUTE('truncate table ' + @table +
				'; BULK INSERT ' + @table +
				' FROM '''+ @Path + @table +@FileExt+''' '+
				' with (fieldterminator = '','',rowterminator = ''0x0a'',FIRSTROW = 2, KEEPIDENTITY)')
		END TRY
		BEGIN CATCH


		--EXEC sp_SetEvent
		--EXEC  sp_SetError
		--EXEC  sp_FailOperation -- not using here?  
		END CATCH
		FETCH NEXT FROM CUR INTO @table
	END
	CLOSE CUR
	DEALLOCATE CUR

	--EXEC  sp_CompleteOperation

END
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