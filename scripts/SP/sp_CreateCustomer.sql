USE MASTER;
GO

USE T21;
GO

-- Create new Customer, return new CustomerID

-------------
CREATE OR ALTER PROCEDURE shop.sp_CreateCustomer
	@Title NVARCHAR(50) = NULL,
	@FirstName NVARCHAR(255),
	@MiddleName NVARCHAR(255) = NULL,
	@LastName NVARCHAR(255),
	@Gender NVARCHAR(50),
	@BirthDay NVARCHAR(50),
	@Email NVARCHAR(255),
	@Phone NVARCHAR(50),
	@AddressLine1 NVARCHAR(500),
	@AddressLine2 NVARCHAR(500) = NULL,
	@City NVARCHAR(255),
	@Region NVARCHAR(255) = NULL,
	@Country NVARCHAR(255),
	@PostalCode NVARCHAR(100) = NULL,
	@Discount float = NULL
AS
BEGIN
	BEGIN TRY

		-- for logging
		DECLARE @curentParameters NVARCHAR(MAX) =  CONCAT(
			CHAR(9), '@Title = ', @Title, CHAR(13), CHAR(10),
			CHAR(9), '@FirstName = ', @FirstName, CHAR(13), CHAR(10),
			CHAR(9), '@MiddleName = ', @MiddleName, CHAR(13), CHAR(10),
			CHAR(9), '@LastName = ', @LastName, CHAR(13), CHAR(10),
			CHAR(9), '@Gender = ', @Gender, CHAR(13), CHAR(10),
			CHAR(9), '@BirthDay = ', @BirthDay, CHAR(13), CHAR(10),
			CHAR(9), '@Email = ', @Email, CHAR(13), CHAR(10),
			CHAR(9), '@Phone = ', @Phone, CHAR(13), CHAR(10),
			CHAR(9), '@AddressLine1 = ', @AddressLine1, CHAR(13), CHAR(10),
			CHAR(9), '@AddressLine2 = ', @AddressLine2, CHAR(13), CHAR(10),
			CHAR(9), '@City = ', @City, CHAR(13), CHAR(10),
			CHAR(9), '@Region = ', @Region, CHAR(13), CHAR(10),
			CHAR(9), '@Country = ', @Country, CHAR(13), CHAR(10),
			CHAR(9), '@PostalCode = ', @PostalCode, CHAR(13), CHAR(10),
			CHAR(9), '@Discount = ', @Discount, CHAR(13), CHAR(10));

		
		-- to keep new OperationRunID 
		DECLARE @curentRunID INT;	

		-- Start Operation and get new OperationRunID
		EXEC @curentRunID = 
			logs.sp_StartOperation   @OperationID = 4	-- INT     OperationID for Shop.sp_CreateCustomer from Logs.Operations
									,@Description = NULL	-- NVARCHAR(255), NULL
									,@OperationRunParameters = @curentParameters	-- NVARCHAR(MAX), NULL
		
		-------------------------------------------------------------
		-----			    	   Customer			    	    -----
		-------------------------------------------------------------
		-- to keep new CustomerID
		DECLARE @newCustomerID INT;		

		-- Create new Customer
		INSERT INTO Shop.Customers(
			Discount)
		VALUES(
			@Discount);
			 
		SET @newCustomerID = SCOPE_IDENTITY();

		-- throw event
		DECLARE @eventMessageCustomer NVARCHAR(MAX) = CONCAT('Created new Customer with ID: ', @newCustomerID);
		EXEC logs.sp_SetEvent	 @runID = @curentRunID		-- INT						
								,@affectedRows = @@rowcount		-- INT, NULL
								,@procedureID = @@PROCID		-- INT, NULL
								,@parameters = @curentParameters	-- NVARCHAR(MAX), NULL
								,@eventMessage = @eventMessageCustomer		-- NVARCHAR(MAX)
								
		-------------------------------------------------------------
		-----			    	   Contact			    	    -----
		-------------------------------------------------------------
		-- to keep new ContactID
		DECLARE @newContactID INT;

		-- Create new contact for Customer
		EXEC @newContactID = 
			shop.sp_CreateContact    @Title = @Title	 -- NVARCHAR(50), NULL
									,@FirstName = @FirstName  -- NVARCHAR(255)
									,@MiddleName = @MiddleName  -- NVARCHAR(255), NULL
									,@LastName = @LastName  -- NVARCHAR(255)
									,@Gender = @Gender  -- NVARCHAR(50)
									,@BirthDay = @BirthDay  -- NVARCHAR(50)
									,@Email = @Email  -- NVARCHAR(255)
									,@Phone = @Phone  -- NVARCHAR(50)

		-- throw event
		DECLARE @eventMessageContact NVARCHAR(MAX) = CONCAT('Created new Contact: ', @newContactID,' for Customer with ID: ', @newCustomerID);
		EXEC logs.sp_SetEvent	 @runID = @curentRunID		-- INT						
								,@affectedRows = @@rowcount		-- INT, NULL
								,@procedureID = @@PROCID		-- INT, NULL
								,@parameters = @curentParameters	-- NVARCHAR(MAX), NULL
								,@eventMessage = @eventMessageContact		-- NVARCHAR(MAX)
															   								 
		-- New ContactCustomer
		INSERT INTO Shop.ContactCustomer(
			CustomerID,
			ContactID)
		VALUES(
			@newCustomerID,
			@newContactID);

		-- throw event
		EXEC logs.sp_SetEvent	 @runID = @curentRunID		-- INT						
								,@affectedRows = @@rowcount		-- INT, NULL
								,@procedureID = @@PROCID		-- INT, NULL
								,@parameters = @curentParameters	-- NVARCHAR(MAX), NULL
								,@eventMessage = 'Added New ContactCustomer connection'		-- NVARCHAR(MAX)


		-------------------------------------------------------------
		-----			    	   Address			    	    -----
		-------------------------------------------------------------
		-- to keep new AddressID
		DECLARE @newAddressID INT;	
		
		-- Create new Address for Customer
		EXEC @newAddressID = 
			shop.sp_CreateAddress    @AddressLine1 = @AddressLine1	 -- NVARCHAR(500) 
									,@AddressLine2 = @AddressLine2  -- NVARCHAR(500), NULL
									,@City = @City  -- NVARCHAR(255)
									,@Region = @Region  -- NVARCHAR(255), NULL
									,@Country = @Country  -- NVARCHAR(255)
									,@PostalCode = @PostalCode  -- NVARCHAR(100), NULL

		-- throw event
		DECLARE @eventMessageAddress NVARCHAR(MAX) = CONCAT('Created new Address: ', @newAddressID,' for Customer with ID: ', @newCustomerID);
		EXEC logs.sp_SetEvent	 @runID = @curentRunID		-- INT						
								,@affectedRows = @@rowcount		-- INT, NULL
								,@procedureID = @@PROCID		-- INT, NULL
								,@parameters = @curentParameters	-- NVARCHAR(MAX), NULL
								,@eventMessage = @eventMessageAddress		-- NVARCHAR(MAX)
															   								 
		-- New AddressCustomer
		INSERT INTO Shop.AddressCustomer(
			CustomerID,
			AddressID)
		VALUES(
			@newCustomerID,
			@newAddressID);

		-- throw event
		EXEC logs.sp_SetEvent	 @runID = @curentRunID		-- INT						
								,@affectedRows = @@rowcount		-- INT, NULL
								,@procedureID = @@PROCID		-- INT, NULL
								,@parameters = @curentParameters	-- NVARCHAR(MAX), NULL
								,@eventMessage = 'Added New AddressCustomer connection'		-- NVARCHAR(MAX)

					
					
		-- Complete Operation
		EXEC logs.sp_CompleteOperation   @OperationRunID = 	@curentRunID	 -- INT       -- get from sp_StartOperation
										,@OperationRunParameters = @curentParameters  -- NVARCHAR(MAX), NULL

		RETURN @newCustomerID;

	END TRY
	BEGIN CATCH
	
		-- throw Error
		EXEC logs.sp_SetError	 @runID = @curentRunID 		-- INT       -- get from sp_StartOperation
								,@procedureID = @@PROCID	-- INT, NULL
								,@parameters = @curentParameters	-- NVARCHAR(MAX), NULL
								,@errorMessage = 'Can not create Customer'	-- NVARCHAR(MAX), NULL

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
	(4,'Shop.sp_CreateCustomer','Create new customer, return new CustomerID');
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
	EXEC @iddd = shop.sp_CreateCustomer  @Title = 'Tv'	 -- NVARCHAR(50), NULL
									,@FirstName = 'Yuri'  -- NVARCHAR(255)
									,@MiddleName = NULL  -- NVARCHAR(255), NULL
									,@LastName = 'Ogarkov'  -- NVARCHAR(255)
									,@Gender = 'Male'  -- NVARCHAR(50)
									,@BirthDay = '1915-01-01'  -- NVARCHAR(50)
									,@Email = 'YuriOgarkov@MVD.com'  -- NVARCHAR(255)
									,@Phone = '66552956'  -- NVARCHAR(50)
									,@AddressLine1 = 'test Address 21 str App 89'	 -- NVARCHAR(500) 
									,@AddressLine2 = NULL  -- NVARCHAR(500), NULL
									,@City = 'testCityName'  -- NVARCHAR(255)
									,@Region = NULL  -- NVARCHAR(255), NULL
									,@Country = 'testUSA'  -- NVARCHAR(255)
									,@PostalCode = '11665 69 7'  -- NVARCHAR(100), NULL
									,@Discount = 2  -- float,  NULL


INSERT INTO #testID (id)
SELECT @iddd
SELECT Top 1 id FROM #testID


DELETE Shop.Customers
WHERE CustomerID =  (SELECT Top 1 id FROM #testID) 

DELETE Shop.AddressCustomer
WHERE CustomerID =  (SELECT Top 1 id FROM #testID) 

DELETE Shop.ContactCustomer
WHERE CustomerID =  (SELECT Top 1 id FROM #testID) 

DBCC CHECKIDENT ('Shop.Customers')
DBCC CHECKIDENT ('Shop.Customers', RESEED, 130)  
  
SELECT SCOPE_IDENTITY()

SELECT * FROM Shop.Customers
SELECT * FROM Shop.Addresses
SELECT * FROM Shop.Contacts
SELECT * FROM Shop.AddressCustomer
SELECT * FROM Shop.ContactCustomer

SELECT * FROM Logs.EventLogs
SELECT * FROM Logs.ErrorLogs
SELECT * FROM Logs.OperationRuns
SELECT * FROM Logs.Operations










