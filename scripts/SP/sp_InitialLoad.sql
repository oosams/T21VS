USE T21;
GO

--Truncate and populate all tables in database from provided folder
--EXEC dbo.InitialLoad @Path = 'D:\_Work\GitHub\T21VS\scripts\mockaroo\20201203\', @FileExt = '.csv';

CREATE OR ALTER PROCEDURE sp_InitialLoad 
	@Path nvarchar(1000),
	@FileExt nvarchar(255)
AS
BEGIN

	DECLARE @sqlCommand nvarchar(1000);		
	DECLARE @table nvarchar (1000);

	-- exec  sp_StartOperation ( opID from operations,  


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
		--to add
		END CATCH
		FETCH NEXT FROM CUR INTO @table
	END
	CLOSE CUR
	DEALLOCATE CUR

	-- exec  sp_CompleteOperation

END
GO

EXEC dbo.InitialLoad @Path = 'D:\_Work\GitHub\T21VS\scripts\mockaroo\20201203\', @FileExt = '.csv';





