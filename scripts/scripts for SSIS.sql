
-----------run proc from SSIS----------------------------

EXEC Shop.sp_UpdateProduct   
	 @ProductID = ?		-- INT
	,@UnitPrice =  ? -- MONEY, NULL
	,@Quantity =   ? -- INT, NULL


----------------------------------------------------

DECLARE @ProductID int = ?
DECLARE @CategoryID int = ? 
DECLARE @CategoryName NVARCHAR(255) =  ?	 
DECLARE @CategoryDescription NVARCHAR(255) =  ?	 
DECLARE @ProductName NVARCHAR(255) = ?    
DECLARE @UnitPrice MONEY =  ?   
DECLARE @Quantity INT =   ?   
DECLARE @ProductDescription NVARCHAR(MAX) = ?
DECLARE @CategoryGUID uniqueidentifier = ?
DECLARE @ProductGUID uniqueidentifier = ?



EXEC @ProductID = Shop.sp_CreateProduct   
	 @CategoryID = @CategoryID  OUTPUT	-- INT, NULL
	,@CategoryName =  @CategoryName	 -- NVARCHAR(255), NULL
	,@CategoryDescription =  @CategoryDescription	 -- NVARCHAR(MAX), NULL
	,@ProductName = @ProductName   -- NVARCHAR(255)
	,@UnitPrice =  @UnitPrice  -- MONEY
	,@Quantity =   @Quantity  -- INT
	--,@IsActive = 1   -- INT, 1
	,@Description = @ProductDescription

INSERT INTO Staging.VendorDeliveryNewMapping(
	 Make_id
	,Make_Name
--	,Make_Desc
	,Make_Guid
	,Product_Model_id
	,Product_Model_Name
--	,Model_Desc
	,Model_Guid)
VALUES(
	  @CategoryID
	 ,@CategoryName
--	 ,@CategoryDescription
	 ,@CategoryGUID
	 ,@ProductID
	 ,@ProductName
--	 ,@ProductDescription
	 ,@ProductGUID)


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

DECLARE @TableCOL NVARCHAR(1000) = ' "SELECT ''Make_id'' ,''Make_name'' ,''Make_guid'' ,''Product_Model_id'' ,''Product_Model_Name'' ,''Model_guid'' UNION ALL SELECT CAST(Make_id as NVARCHAR(100)) ,Make_name ,CAST(Make_guid as NVARCHAR(100)) ,CAST(Product_Model_id as NVARCHAR(100)) ,Product_Model_Name	,CAST(Model_guid as NVARCHAR(100)) FROM [T21].[Staging].[VendorDeliveryNewMapping]" '
 
DECLARE @Table  NVARCHAR(255) = '" SELECT * FROM [T21].[Staging].[VendorDeliveryNewMapping]"' 
DECLARE @File NVARCHAR(255) = ' d:\work\21\mapping\VendorToShopProductMapping.csv '

-- out
	DECLARE @bcp_cmd NVARCHAR(2000) = 'BCP ' + @TableCOL  + ' queryout  ' + @File + ' -c -t "," -r "\n" -T -S LV4788 -U SOFTSERVE\osams'
	EXEC master..xp_cmdSHELL @bcp_cmd
	   
GO	   
sp_configure 'xp_cmdshell', '0';
RECONFIGURE;
GO		
sp_configure 'show advanced options', '0';
RECONFIGURE;
GO

SELECT 
	 'Make_id'
	,'Make_name'
	,'Make_guid'
	,'Product_Model_id'
	,'Product_Model_Name'
	,'Model_guid'
UNION ALL
SELECT 
	CAST(Make_id as NVARCHAR(100)) 
	,Make_name 
	,CAST(Make_guid as NVARCHAR(100)) 
	,CAST(Product_Model_id as NVARCHAR(100)) 
	,Product_Model_Name 	
	,CAST(Model_guid as NVARCHAR(100))

FROM [T21].[Staging].[VendorDeliveryNewMapping]

DECLARE @TableCOL NVARCHAR(255) = '" 
SELECT 
	 ''Make_id''
	,''Make_name''
	,''Make_guid''
	,''Product_Model_id''
	,''Product_Model_Name''
	,''Model_guid''
UNION ALL
SELECT 
	CAST(Make_id as NVARCHAR(100)) 
	,Make_name 
	,CAST(Make_guid as NVARCHAR(100)) 
	,CAST(Product_Model_id as NVARCHAR(100)) 
	,Product_Model_Name 	
	,CAST(Model_guid as NVARCHAR(100))

FROM [T21].[Staging].[VendorDeliveryNewMapping]"'

 