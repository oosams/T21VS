USE MASTER;
GO

USE T21;
GO

-- Create new Customer, return new CustomerID

-------------
CREATE OR ALTER PROCEDURE Shop.sp_CreateCustomer
	 @Title NVARCHAR(50) = NULL
	,@FirstName NVARCHAR(255)
	,@MiddleName NVARCHAR(255) = NULL
	,@LastName NVARCHAR(255)
	,@Gender NVARCHAR(50)
	,@BirthDay NVARCHAR(50)
	,@Email NVARCHAR(255)
	,@Phone NVARCHAR(50)
	,@AddressLine1 NVARCHAR(500)
	,@AddressLine2 NVARCHAR(500) = NULL
	,@City NVARCHAR(255)
	,@Region NVARCHAR(255) = NULL
	,@Country NVARCHAR(255)
	,@PostalCode NVARCHAR(100) = NULL
	,@Discount float = NULL
AS
BEGIN
	BEGIN TRY

		-- for logging
		DECLARE @CurrentParameters NVARCHAR(MAX) =  CONCAT(
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
		DECLARE @CurrentRunID INT;	

		-- Start Operation and get new OperationRunID
		EXEC @CurrentRunID = 
			Logs.sp_StartOperation   @OperationID = 4	-- INT     OperationID for Shop.sp_CreateCustomer from Logs.Operations
									,@Description = NULL	-- NVARCHAR(255), NULL
									,@OperationRunParameters = @CurrentParameters	-- NVARCHAR(MAX), NULL
		
		-------------------------------------------------------------
		-----			    	   Customer			    	    -----
		-------------------------------------------------------------
		-- to keep new CustomerID
		DECLARE @NewCustomerID INT;		

		-- Create new Customer
		INSERT INTO Shop.Customers(
			Discount)
		VALUES(
			@Discount);
			 
		SET @NewCustomerID = SCOPE_IDENTITY();

		-- throw event
		DECLARE @EventMessageCustomer NVARCHAR(MAX) = CONCAT('Created new Customer with ID: ', @NewCustomerID);
		EXEC Logs.sp_SetEvent	 @RunID = @CurrentRunID		-- INT						
								,@AffectedRows = @@rowcount		-- INT, NULL
								,@ProcedureID = @@PROCID		-- INT, NULL
								,@Parameters = @CurrentParameters	-- NVARCHAR(MAX), NULL
								,@EventMessage = @EventMessageCustomer		-- NVARCHAR(MAX)
								
		-------------------------------------------------------------
		-----			    	   Contact			    	    -----
		-------------------------------------------------------------
		-- to keep new ContactID
		DECLARE @NewContactID INT;

		-- Create new contact for Customer
		EXEC @NewContactID = 
			Shop.sp_CreateContact    @Title = @Title	 -- NVARCHAR(50), NULL
									,@FirstName = @FirstName  -- NVARCHAR(255)
									,@MiddleName = @MiddleName  -- NVARCHAR(255), NULL
									,@LastName = @LastName  -- NVARCHAR(255)
									,@Gender = @Gender  -- NVARCHAR(50)
									,@BirthDay = @BirthDay  -- NVARCHAR(50)
									,@Email = @Email  -- NVARCHAR(255)
									,@Phone = @Phone  -- NVARCHAR(50)

		-- throw event
		DECLARE @EventMessageContact NVARCHAR(MAX) = CONCAT('Created new Contact: ', @NewContactID,' for Customer with ID: ', @NewCustomerID);
		EXEC Logs.sp_SetEvent	 @RunID = @CurrentRunID		-- INT						
								,@AffectedRows = @@rowcount		-- INT, NULL
								,@ProcedureID = @@PROCID		-- INT, NULL
								,@Parameters = @CurrentParameters	-- NVARCHAR(MAX), NULL
								,@EventMessage = @EventMessageContact		-- NVARCHAR(MAX)
															   								 
		-- New ContactCustomer
		INSERT INTO Shop.ContactCustomer(
			 CustomerID
			,ContactID)
		VALUES(
			 @NewCustomerID
			,@NewContactID);

		-- throw event
		EXEC Logs.sp_SetEvent	 @RunID = @CurrentRunID		-- INT						
								,@AffectedRows = @@rowcount		-- INT, NULL
								,@ProcedureID = @@PROCID		-- INT, NULL
								,@Parameters = @CurrentParameters	-- NVARCHAR(MAX), NULL
								,@EventMessage = 'Added New ContactCustomer connection'		-- NVARCHAR(MAX)


		-------------------------------------------------------------
		-----			    	   Address			    	    -----
		-------------------------------------------------------------
		-- to keep new AddressID
		DECLARE @NewAddressID INT;	
		
		-- Create new Address for Customer
		EXEC @NewAddressID = 
			Shop.sp_CreateAddress    @AddressLine1 = @AddressLine1	 -- NVARCHAR(500) 
									,@AddressLine2 = @AddressLine2  -- NVARCHAR(500), NULL
									,@City = @City  -- NVARCHAR(255)
									,@Region = @Region  -- NVARCHAR(255), NULL
									,@Country = @Country  -- NVARCHAR(255)
									,@PostalCode = @PostalCode  -- NVARCHAR(100), NULL

		-- throw event
		DECLARE @EventMessageAddress NVARCHAR(MAX) = CONCAT('Created new Address: ', @NewAddressID,' for Customer with ID: ', @NewCustomerID);
		EXEC Logs.sp_SetEvent	 @RunID = @CurrentRunID		-- INT						
								,@AffectedRows = @@rowcount		-- INT, NULL
								,@ProcedureID = @@PROCID		-- INT, NULL
								,@Parameters = @CurrentParameters	-- NVARCHAR(MAX), NULL
								,@EventMessage = @EventMessageAddress		-- NVARCHAR(MAX)
															   								 
		-- New AddressCustomer
		INSERT INTO Shop.AddressCustomer(
			 CustomerID
			,AddressID)
		VALUES(
			 @NewCustomerID
			,@NewAddressID);

		-- throw event
		EXEC Logs.sp_SetEvent	 @RunID = @CurrentRunID		-- INT						
								,@AffectedRows = @@rowcount		-- INT, NULL
								,@ProcedureID = @@PROCID		-- INT, NULL
								,@Parameters = @CurrentParameters	-- NVARCHAR(MAX), NULL
								,@EventMessage = 'Added New AddressCustomer connection'		-- NVARCHAR(MAX)

					
					
		-- Complete Operation
		EXEC Logs.sp_CompleteOperation   @OperationRunID = 	@CurrentRunID	 -- INT       -- get from sp_StartOperation
										,@OperationRunParameters = @CurrentParameters  -- NVARCHAR(MAX), NULL

		RETURN @NewCustomerID;

	END TRY
	BEGIN CATCH
	
		-- throw Error
		EXEC Logs.sp_SetError	 @RunID = @CurrentRunID 		-- INT       -- get from sp_StartOperation
								,@ProcedureID = @@PROCID	-- INT, NULL
								,@Parameters = @CurrentParameters	-- NVARCHAR(MAX), NULL
								,@ErrorMessage = 'Can not create Customer'	-- NVARCHAR(MAX), NULL

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
	(4,'Shop.sp_CreateCustomer','Create new Customer, return new CustomerID');
SET IDENTITY_INSERT Logs.Operations OFF;
GO
--SELECT * FROM Logs.Operations
