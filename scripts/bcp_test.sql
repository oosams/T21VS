USE MASTER
GO
USE T21
GO
 
----------bcp

sp_configure 'show advanced options', '1';
RECONFIGURE;
GO
sp_configure 'xp_cmdshell', '1';
RECONFIGURE;
GO
-----table for testing bcp-----------
DROP TABLE IF EXISTS   [Shop].[Products11] 
SELECT * INTO [Shop].[Products11]
FROM [Shop].[Products]
DELETE [Shop].[Products11]


DECLARE @EXE NVARCHAR(255) = 'call "C:\Program Files\Microsoft SQL Server\Client SDK\ODBC\170\Tools\Binn\BCP.EXE" '
DECLARE @Tableout NVARCHAR(255) = '"[T21].[Shop].[Products]"'
DECLARE @Tablein NVARCHAR(255) = '"[T21].[Shop].[Products11]"'
DECLARE @File NVARCHAR(255) = ' d:\work\21\bcp\Products.csv '
 
-- out
	DECLARE @bcp_cmd NVARCHAR(2000) = @EXE + @Tableout + ' out ' + @File + ' -c -t "," -r "\n" -T -S LV4788 -U SOFTSERVE\osams'
	EXEC master..xp_cmdSHELL @bcp_cmd

-- in
	SET @bcp_cmd = 'BCP ' + @Tablein + ' in ' + @File   + ' -c -t "," -r "\n" -T -S LV4788 -U SOFTSERVE\osams'
	EXEC master..xp_cmdSHELL @bcp_cmd


DROP TABLE IF EXISTS   [Shop].[Products11] ;
GO
sp_configure 'xp_cmdshell', '0';
RECONFIGURE;
GO		
sp_configure 'show advanced options', '0';
RECONFIGURE;
GO
		
-----VENDOR MAPPING FILE------

--SELECT * FROM  Staging.VendorDeliveryNewMapping 

--VendorToShopProductMapping.csv
GO
sp_configure 'show advanced options', '1';
RECONFIGURE;
GO
sp_configure 'xp_cmdshell', '1';
RECONFIGURE;
GO

 
DECLARE @Table  NVARCHAR(255) = '"[T21].[Staging].[VendorDeliveryNewMapping]"' 
DECLARE @File NVARCHAR(255) = ' d:\work\21\mapping\VendorToShopProductMapping.csv '
 
-- out
	DECLARE @bcp_cmd NVARCHAR(2000) = 'BCP ' + @Table  + ' out ' + @File + ' -c -t "," -r "\n" -T -S LV4788 -U SOFTSERVE\osams'
	EXEC master..xp_cmdSHELL @bcp_cmd
	   
GO	   
sp_configure 'xp_cmdshell', '0';
RECONFIGURE;
GO		
sp_configure 'show advanced options', '0';
RECONFIGURE;
GO