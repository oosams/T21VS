USE MASTER;
GO
USE T21;
GO

-----to keep integrity with data from InitialLoad 
SET IDENTITY_INSERT Logs.Operations ON;  

INSERT INTO Logs.Operations(
	OperationID,
	OperationName,
	Description)
VALUES
	(-1,'sp_InitialLoad','Hystorical - First Initial Load after db created');
SET IDENTITY_INSERT Logs.Operations OFF;
GO

SET IDENTITY_INSERT Logs.OperationRuns ON;  

INSERT INTO Logs.OperationRuns(
	OperationRunID,
	StatusID,
	OperationID,
	StartTime,
	EndTime,
	Description)
VALUES
	(-1,3,-1,'2020-12-04','2020-12-04','Hystorical - First Initial Load after db created.');
SET IDENTITY_INSERT Logs.OperationRuns OFF;
GO


