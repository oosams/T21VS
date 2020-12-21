USE MASTER
GO

:setvar path "D:\_Work\GitHub\T21VS\scripts\OneRun"
--:r $(path)\test.sql
:r $(path)\CreateAll.sql

:r $(path)\additional objects\InserHystOperationData.sql
:r $(path)\additional objects\temp_tableinfo.sql
:r $(path)\additional objects\types.sql


:r $(path)\sp\1.sql












