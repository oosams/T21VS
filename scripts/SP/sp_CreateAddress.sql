USE MASTER;
GO

USE T21;
GO

-- Create new Address, return new AddressID

-------------
CREATE OR ALTER PROCEDURE shop.sp_CreateAddress
	@AddressLine1 NVARCHAR(500),
	@AddressLine2 NVARCHAR(500) = NULL,
	@City NVARCHAR(255),
	@Region NVARCHAR(255) = NULL,
	@Country NVARCHAR(255),
	@PostalCode NVARCHAR(100) = NULL

AS
BEGIN
	BEGIN TRY

		-- for logging
		DECLARE @curentParameters NVARCHAR(MAX) =  CONCAT(
			CHAR(9), '@AddressLine1 = ', @AddressLine1, CHAR(13), CHAR(10),
			CHAR(9), '@AddressLine2 = ', @AddressLine2, CHAR(13), CHAR(10),
			CHAR(9), '@City = ', @City, CHAR(13), CHAR(10),
			CHAR(9), '@Region = ', @Region, CHAR(13), CHAR(10),
			CHAR(9), '@Country = ', @Country, CHAR(13), CHAR(10),
			CHAR(9), '@PostalCode = ', @PostalCode, CHAR(13), CHAR(10));

		DECLARE @eventMessage NVARCHAR(MAX) = CONCAT('Created new Address with Parameters: ', @curentParameters);
	

		-- to keep new OperationRunID 
		DECLARE @curentRunID INT;	

		-- Start Operation and get new OperationRunID
		EXEC @curentRunID = 
			logs.sp_StartOperation   @OperationID = 2	-- INT     OperationID for Shop.sp_CreateAddress  from Logs.Operations
									,@Description = NULL	-- NVARCHAR(255), NULL
									,@OperationRunParameters = @curentParameters	-- NVARCHAR(MAX), NULL
		
		-- to keep new AddressID
		DECLARE @newAddressID INT;		

		-- Create new Address
		INSERT INTO Shop.Addresses(
			AddressLine1,
			AddressLine2,
			City,
			Region,
			Country,
			PostalCode)
		VALUES(
			@AddressLine1,
			@AddressLine2,
			@City,
			@Region,
			@Country,
			@PostalCode);
			 
		SET @newAddressID = SCOPE_IDENTITY();

		-- throw event
		DECLARE @eventMessage NVARCHAR(MAX) = CONCAT('Created new Address with Parameters: ', @curentParameters);
		EXEC logs.sp_SetEvent	 @runID = @curentRunID		-- INT						
								,@affectedRows = @@rowcount		-- INT, NULL
								,@procedureID = @@PROCID		-- INT, NULL
								,@parameters = @curentParameters	-- NVARCHAR(MAX), NULL
								,@eventMessage = @eventMessage		-- NVARCHAR(MAX)


		-- Complete Operation
		EXEC logs.sp_CompleteOperation   @OperationRunID = 	@curentRunID	 -- INT       -- get from sp_StartOperation
										,@OperationRunParameters = @curentParameters  -- NVARCHAR(MAX), NULL

		RETURN @newAddressID;

	END TRY
	BEGIN CATCH
	
		-- throw Error
		EXEC logs.sp_SetError	 @runID = @curentRunID 		-- INT       -- get from sp_StartOperation
								,@procedureID = @@PROCID	-- INT, NULL
								,@parameters = @curentParameters	-- NVARCHAR(MAX), NULL
								,@errorMessage = 'Can not create Address'	-- NVARCHAR(MAX), NULL

		-- Fail Operation
		EXEC logs.sp_FailOperation   @OperationRunID = 	@curentRunID	 -- INT       -- get from sp_StartOperation
									,@OperationRunParameters = @curentParameters  -- NVARCHAR(MAX), NULL

		RETURN -1

	END CATCH
END
GO

----Add info in Logs.Operations------


SET IDENTITY_INSERT Logs.Operations ON;  

INSERT INTO Logs.Operations(
	OperationID,
	OperationName,
	Description)
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
	shop.sp_CreateAddress    @AddressLine1 = 'test Address 21 str App 89'	 -- NVARCHAR(500) 
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

