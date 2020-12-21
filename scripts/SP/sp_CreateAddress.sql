USE MASTER;
GO

USE T21;
GO

-- Create new Address, return new AddressID

-------------
CREATE OR ALTER PROCEDURE Shop.sp_CreateAddress
	 @AddressLine1 NVARCHAR(500)
	,@AddressLine2 NVARCHAR(500) = NULL
	,@City NVARCHAR(255)
	,@Region NVARCHAR(255) = NULL
	,@Country NVARCHAR(255)
	,@PostalCode NVARCHAR(100) = NULL

AS
BEGIN
	BEGIN TRY

		-- for logging
		DECLARE @CurrentParameters NVARCHAR(MAX) =  CONCAT(
			CHAR(9), '@AddressLine1 = ', @AddressLine1, CHAR(13), CHAR(10),
			CHAR(9), '@AddressLine2 = ', @AddressLine2, CHAR(13), CHAR(10),
			CHAR(9), '@City = ', @City, CHAR(13), CHAR(10),
			CHAR(9), '@Region = ', @Region, CHAR(13), CHAR(10),
			CHAR(9), '@Country = ', @Country, CHAR(13), CHAR(10),
			CHAR(9), '@PostalCode = ', @PostalCode, CHAR(13), CHAR(10));

		
	

		-- to keep new OperationRunID 
		DECLARE @CurrentRunID INT;	

		-- Start Operation and get new OperationRunID
		EXEC @CurrentRunID = 
			Logs.sp_StartOperation   @OperationID = 2	-- INT     OperationID for Shop.sp_CreateAddress  from Logs.Operations
									,@Description = NULL	-- NVARCHAR(255), NULL
									,@OperationRunParameters = @CurrentParameters	-- NVARCHAR(MAX), NULL
		
		-- to keep new AddressID
		DECLARE @NewAddressID INT;		

		-- Create new Address
		INSERT INTO Shop.Addresses(
			 AddressLine1
			,AddressLine2
			,City
			,Region
			,Country
			,PostalCode)
		VALUES(
			 @AddressLine1
			,@AddressLine2
			,@City
			,@Region
			,@Country
			,@PostalCode);
			 
		SET @NewAddressID = SCOPE_IDENTITY();

		-- throw event
		DECLARE @EventMessage NVARCHAR(MAX) = CONCAT('Created new Address with ID: ', @NewAddressID);
		EXEC Logs.sp_SetEvent	 @RunID = @CurrentRunID		-- INT						
								,@AffectedRows = @@rowcount		-- INT, NULL
								,@ProcedureID = @@PROCID		-- INT, NULL
								,@Parameters = @CurrentParameters	-- NVARCHAR(MAX), NULL
								,@EventMessage = @EventMessage		-- NVARCHAR(MAX)


		-- Complete Operation
		EXEC Logs.sp_CompleteOperation   @OperationRunID = 	@CurrentRunID	 -- INT       -- get from sp_StartOperation
										,@OperationRunParameters = @CurrentParameters  -- NVARCHAR(MAX), NULL

		RETURN @NewAddressID;

	END TRY
	BEGIN CATCH
	
		-- throw Error
		EXEC Logs.sp_SetError	 @RunID = @CurrentRunID 		-- INT       -- get from sp_StartOperation
								,@ProcedureID = @@PROCID	-- INT, NULL
								,@Parameters = @CurrentParameters	-- NVARCHAR(MAX), NULL
								,@ErrorMessage = 'Can not create Address'	-- NVARCHAR(MAX), NULL

		-- Fail Operation
		EXEC Logs.sp_FailOperation   @OperationRunID = 	@CurrentRunID	 -- INT       -- get from sp_StartOperation
									,@OperationRunParameters = @CurrentParameters  -- NVARCHAR(MAX), NULL

		RETURN -1

	END CATCH
END
GO

----Add info in Logs.Operations------


SET IDENTITY_INSERT Logs.Operations ON;  

INSERT INTO Logs.Operations(
	 OperationID
	,OperationName
	,Description)
VALUES
	(2,'Shop.sp_CreateAddress','Create new Address, return new AddressID');
SET IDENTITY_INSERT Logs.Operations OFF;
GO
SELECT * FROM Logs.Operations

--------DEBUG---------
DROP TABLE IF EXISTS #testID 
CREATE TABLE #testID 
(
	id INT
);
declare @iddd int
EXEC @iddd = 
	Shop.sp_CreateAddress    @AddressLine1 = 'test Address 21 str App 89'	 -- NVARCHAR(500) 
							,@AddressLine2 = NULL  -- NVARCHAR(500), NULL
							,@City = 'testCityName'  -- NVARCHAR(255)
							,@Region = NULL  -- NVARCHAR(255), NULL
							,@Country = 'testUSA'  -- NVARCHAR(255)
							,@PostalCode = '11665 69 7'  -- NVARCHAR(100), NULL

INSERT INTO #testID (id)
SELECT @iddd
SELECT Top 1 id FROM #testID

DELETE Shop.Addresses
WHERE AddressID =  (SELECT Top 1 id FROM #testID) 

DBCC CHECKIDENT ('Shop.Addresses')
DBCC CHECKIDENT ('Shop.Addresses', RESEED, 130)  
  
SELECT SCOPE_IDENTITY()

SELECT * FROM Shop.Addresses

SELECT * FROM Logs.EventLogs
SELECT * FROM Logs.ErrorLogs
SELECT * FROM Logs.OperationRuns
SELECT * FROM Logs.Operations

