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
		EXEC logs.sp_SetEvent	 @runID = @curentRunID		-- INT						
								,@affectedRows = @@rowcount		-- INT, NULL
								,@procedureID = @@PROCID		-- INT, NULL
								,@parameters = @curentParameters	-- NVARCHAR(MAX), NULL
								,@eventMessage = @eventMessage		-- NVARCHAR(MAX)

		RETURN @newAddressID;

	END TRY
	BEGIN CATCH

		DECLARE @curentErrorMessage NVARCHAR(4000) = ERROR_MESSAGE();  
		DECLARE @curentErrorSeverity INT = ERROR_SEVERITY();  
		DECLARE @curentErrorState INT = ERROR_STATE();

		RAISERROR(
			@curentErrorMessage,   
			@curentErrorSeverity,   
			@curentErrorState); 

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
	(2,'Shop.sp_CreateAddress','Create new address, return new AddressID');
SET IDENTITY_INSERT Logs.Operations OFF;
GO
SELECT * FROM Logs.Operations

--------DEBUG---------

EXEC shop.sp_CreateAddress   @OperationRunID = 	2	 -- INT       -- get from sp_StartOperation
							,@OperationRunParameters = 'test1OperationRunParameters'  -- NVARCHAR(MAX), NULL



	@AddressLine1 NVARCHAR(500),
	@AddressLine2 NVARCHAR(500) = NULL,
	@City NVARCHAR(255),
	@Region NVARCHAR(255) = NULL,
	@Country NVARCHAR(255),
	@PostalCode NVARCHAR(100) = NULL

select * FROM Logs.EventLogs
select * FROM Logs.ErrorLogs
select * FROM Logs.OperationRuns
select * FROM Logs.Operations

