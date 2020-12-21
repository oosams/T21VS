USE MASTER
GO

--:setvar path "D:\_Work\GitHub\T21VS\scripts\OneRun"
:setvar path "c:\Users\osams\source\repos\T21\scripts\OneRun"
-- :r $(path)\test.sql

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

EXEC Config.sp_InitialLoad   @Path = 'D:\_Work\GitHub\T21VS\scripts\generatedData\mockaroo\20201203\1\' -- NVARCHAR(1000) 
							,@FileExt = '.csv';		-- NVARCHAR(255)


 :r $(path)\sp\sp_CreateAddress.sql	  
 :r $(path)\sp\sp_CreateContact.sql

 :r $(path)\sp\sp_CreateCustomer.sql 
 :r $(path)\sp\sp_CreateEmployee.sql

 :r $(path)\sp\sp_CreateCategory.sql
 :r $(path)\sp\sp_CreateProduct.sql

 :r $(path)\sp\sp_CreateEmployee.sql
 :r $(path)\sp\sp_CreateCategory.sql

 :r $(path)\sp\sp_UpdatePrice.sql
 :r $(path)\sp\sp_UpdateQuantity.sql
 :r $(path)\sp\sp_UpdateProduct.sql 
 
 :r $(path)\sp\sp_CheckQuantity.sql
 :r $(path)\sp\sp_CreateOrder.sql
 :r $(path)\sp\sp_UpdateOrder.sql 

 :r $(path)\Constraint.sql
 
 
 
 
 
 
 
 
 
 