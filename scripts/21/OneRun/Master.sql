USE MASTER
GO

--:setvar path "D:\_Work\GitHub\T21VS\scripts\21\OneRun"
:setvar path "c:\Users\osams\source\repos\T21\scripts\21\OneRun"


-- create database and tables
:r $(path)\CreateAll.sql


:r $(path)\additional_objects\InserHystOperationData.sql	  
:r $(path)\additional_objects\temp_tableinfo.sql
:r $(path)\additional_objects\types.sql

--logging sp
:r $(path)\sp\sp_SetError.sql
:r $(path)\sp\sp_SetEvent.sql  

:r $(path)\sp\sp_StartOperation.sql
:r $(path)\sp\sp_FailOperation.sql
:r $(path)\sp\sp_CompleteOperation.sql

-- initialLoad
:r $(path)\sp\sp_InitialLoad.sql

EXEC Config.sp_InitialLoad   --@Path = 'D:\_Work\GitHub\T21VS\scripts\generatedData\mockaroo\20201203\1\' -- NVARCHAR(1000) 
							 @Path = 'd:\work\21\initialLoad\' -- NVARCHAR(1000)
							,@FileExt = '.csv';		-- NVARCHAR(255)


 :r $(path)\sp\sp_CreateAddress.sql	  
 :r $(path)\sp\sp_CreateContact.sql

 :r $(path)\sp\sp_CreateCustomer.sql 
 :r $(path)\sp\sp_CreateEmployee.sql

 :r $(path)\sp\sp_CreateCategory.sql
 :r $(path)\sp\sp_CreateProduct.sql

 :r $(path)\sp\sp_UpdatePrice.sql
 :r $(path)\sp\sp_UpdateQuantity.sql
 :r $(path)\sp\sp_UpdateProduct.sql 
 
 :r $(path)\sp\sp_CheckQuantity.sql
 :r $(path)\sp\sp_CreateOrder.sql
 :r $(path)\sp\sp_UpdateOrder.sql 

 -- Constraints
 :r $(path)\Constraint.sql
 
 ---- staging Vendor Delivery ----

DROP TABLE IF EXISTS Staging.VendorDelivery
CREATE TABLE Staging.VendorDelivery(
	 rowID					INT IDENTITY(1,1)
	,File_Name				NVARCHAR(MAX)
	,Load_Date				NVARCHAR(MAX)
	,Make_Name				NVARCHAR(MAX)
	,Make_Desc				NVARCHAR(MAX)
	,Make_Guid				uniqueidentifier			
	,Product_Model_Name		NVARCHAR(MAX)			
	,Model_Desc				NVARCHAR(MAX)
	,Model_Guid				uniqueidentifier
	,Model_Specifications_1	NVARCHAR(MAX)
	,Model_Specifications_2	NVARCHAR(MAX)
	,Quantity				INT
	,Unit_Price				INT
	,Add_Field_1			NVARCHAR(MAX)
	,Add_Field_2			NVARCHAR(MAX)
	,Add_Field_3			NVARCHAR(MAX)
	,Add_Field_4			NVARCHAR(MAX)
	,Add_Field_5			NVARCHAR(MAX)
	,Add_Field_6			NVARCHAR(MAX)
	,Add_Field_7			NVARCHAR(MAX)
	,Add_Field_8			NVARCHAR(MAX)
	,Add_Field_9			NVARCHAR(MAX)
	,Add_Field_10			NVARCHAR(MAX)
)
GO
-----mapped
DROP TABLE IF EXISTS Staging.VendorDeliveryMapped
CREATE TABLE Staging.VendorDeliveryMapped(
	 rowID					INT IDENTITY(1,1)
	,Make_id				INT
	,Product_Model_id		INT
	,File_Name				NVARCHAR(MAX)
	,Load_Date				NVARCHAR(MAX)
	,Make_Name				NVARCHAR(MAX)
	,Make_Desc				NVARCHAR(MAX)
	,Make_Guid				uniqueidentifier			
	,Product_Model_Name		NVARCHAR(MAX)			
	,Model_Desc				NVARCHAR(MAX)
	,Model_Guid				uniqueidentifier
	,Model_Specifications_1	NVARCHAR(MAX)
	,Model_Specifications_2	NVARCHAR(MAX)
	,Quantity				INT
	,Unit_Price				INT
	,Add_Field_1			NVARCHAR(MAX)
	,Add_Field_2			NVARCHAR(MAX)
	,Add_Field_3			NVARCHAR(MAX)
	,Add_Field_4			NVARCHAR(MAX)
	,Add_Field_5			NVARCHAR(MAX)
	,Add_Field_6			NVARCHAR(MAX)
	,Add_Field_7			NVARCHAR(MAX)
	,Add_Field_8			NVARCHAR(MAX)
	,Add_Field_9			NVARCHAR(MAX)
	,Add_Field_10			NVARCHAR(MAX)
)
GO

-----to keep new mapping
DROP TABLE IF EXISTS Staging.VendorDeliveryNewMapping
CREATE TABLE Staging.VendorDeliveryNewMapping(
	 Make_id				INT
	,Make_Name				NVARCHAR(MAX)	 
	--,Make_Desc				NVARCHAR(MAX)
	,Make_Guid				uniqueidentifier
	,Product_Model_id		INT			
	,Product_Model_Name		NVARCHAR(MAX)			
	--,Model_Desc				NVARCHAR(MAX)
	,Model_Guid				uniqueidentifier 
)
GO
 