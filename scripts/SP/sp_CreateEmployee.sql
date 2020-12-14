USE MASTER;
GO

USE T21;
GO

-- Create new Employee, return new EmployeeID

-------------
CREATE OR ALTER PROCEDURE shop.sp_CreateEmployee
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
	@ManagerID INT = NULL,
	@RoleTitle NVARCHAR(255),
	@HireDate DATETIME,
	@IsActive TINYINT = 1
	
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
			CHAR(9), '@ManagerID = ', @ManagerID, CHAR(13), CHAR(10),
			CHAR(9), '@RoleTitle = ', @RoleTitle, CHAR(13), CHAR(10),
			CHAR(9), '@HireDate = ', @HireDate, CHAR(13), CHAR(10),
			CHAR(9), '@IsActive = ', @IsActive, CHAR(13), CHAR(10));

		
		-- to keep new OperationRunID 
		DECLARE @curentRunID INT;	

		-- Start Operation and get new OperationRunID
		EXEC @curentRunID = 
			logs.sp_StartOperation   @OperationID = 5	-- INT     OperationID for Shop.sp_CreateEmployee from Logs.Operations
									,@Description = NULL	-- NVARCHAR(255), NULL
									,@OperationRunParameters = @curentParameters	-- NVARCHAR(MAX), NULL
		
		-------------------------------------------------------------
		-----			    	   Employee			    	    -----
		-------------------------------------------------------------
		-- to keep new EmployeeID
		DECLARE @newEmployeeID INT;		

		-- Create new Employee
		INSERT INTO Shop.Employees(
			ManagerID,
			RoleTitle,
			HireDate,
			IsActive)
		VALUES(
			@ManagerID,
			@RoleTitle,
			@HireDate,
			@IsActive);
			 
		SET @newEmployeeID = SCOPE_IDENTITY();

		-- throw event
		DECLARE @eventMessageEmployee NVARCHAR(MAX) = CONCAT('Created new Employee with ID: ', @newEmployeeID);
		EXEC logs.sp_SetEvent	 @runID = @curentRunID		-- INT						
								,@affectedRows = @@rowcount		-- INT, NULL
								,@procedureID = @@PROCID		-- INT, NULL
								,@parameters = @curentParameters	-- NVARCHAR(MAX), NULL
								,@eventMessage = @eventMessageEmployee		-- NVARCHAR(MAX)
								
		-------------------------------------------------------------
		-----			    	   Contact			    	    -----
		-------------------------------------------------------------
		-- to keep new ContactID
		DECLARE @newContactID INT;

		-- Create new contact for Employee
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
		DECLARE @eventMessageContact NVARCHAR(MAX) = CONCAT('Created new Contact: ', @newContactID,' for Employee with ID: ', @newEmployeeID);
		EXEC logs.sp_SetEvent	 @runID = @curentRunID		-- INT						
								,@affectedRows = @@rowcount		-- INT, NULL
								,@procedureID = @@PROCID		-- INT, NULL
								,@parameters = @curentParameters	-- NVARCHAR(MAX), NULL
								,@eventMessage = @eventMessageContact		-- NVARCHAR(MAX)
															   								 
		-- New ContactEmployee
		INSERT INTO Shop.ContactEmployee(
			EmployeeID,
			ContactID)
		VALUES(
			@newEmployeeID,
			@newContactID);

		-- throw event
		EXEC logs.sp_SetEvent	 @runID = @curentRunID		-- INT						
								,@affectedRows = @@rowcount		-- INT, NULL
								,@procedureID = @@PROCID		-- INT, NULL
								,@parameters = @curentParameters	-- NVARCHAR(MAX), NULL
								,@eventMessage = 'Added New ContactEmployee connection'		-- NVARCHAR(MAX)


		-------------------------------------------------------------
		-----			    	   Address			    	    -----
		-------------------------------------------------------------
		-- to keep new AddressID
		DECLARE @newAddressID INT;	
		
		-- Create new Address for Employee
		EXEC @newAddressID = 
			shop.sp_CreateAddress    @AddressLine1 = @AddressLine1	 -- NVARCHAR(500) 
									,@AddressLine2 = @AddressLine2  -- NVARCHAR(500), NULL
									,@City = @City  -- NVARCHAR(255)
									,@Region = @Region  -- NVARCHAR(255), NULL
									,@Country = @Country  -- NVARCHAR(255)
									,@PostalCode = @PostalCode  -- NVARCHAR(100), NULL

		-- throw event
		DECLARE @eventMessageAddress NVARCHAR(MAX) = CONCAT('Created new Address: ', @newAddressID,' for Employee with ID: ', @newEmployeeID);
		EXEC logs.sp_SetEvent	 @runID = @curentRunID		-- INT						
								,@affectedRows = @@rowcount		-- INT, NULL
								,@procedureID = @@PROCID		-- INT, NULL
								,@parameters = @curentParameters	-- NVARCHAR(MAX), NULL
								,@eventMessage = @eventMessageAddress		-- NVARCHAR(MAX)
															   								 
		-- New AddressEmployee
		INSERT INTO Shop.AddressEmployee(
			EmployeeID,
			AddressID)
		VALUES(
			@newEmployeeID,
			@newAddressID);

		-- throw event
		EXEC logs.sp_SetEvent	 @runID = @curentRunID		-- INT						
								,@affectedRows = @@rowcount		-- INT, NULL
								,@procedureID = @@PROCID		-- INT, NULL
								,@parameters = @curentParameters	-- NVARCHAR(MAX), NULL
								,@eventMessage = 'Added New AddressEmployee connection'		-- NVARCHAR(MAX)

					
					
		-- Complete Operation
		EXEC logs.sp_CompleteOperation   @OperationRunID = 	@curentRunID	 -- INT       -- get from sp_StartOperation
										,@OperationRunParameters = @curentParameters  -- NVARCHAR(MAX), NULL

		RETURN @newEmployeeID;

	END TRY
	BEGIN CATCH
	
		-- throw Error
		EXEC logs.sp_SetError	 @runID = @curentRunID 		-- INT       -- get from sp_StartOperation
								,@procedureID = @@PROCID	-- INT, NULL
								,@parameters = @curentParameters	-- NVARCHAR(MAX), NULL
								,@errorMessage = 'Can not create Employee'	-- NVARCHAR(MAX), NULL

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
	(5,'Shop.sp_CreateEmployee','Create new Employee, return new EmployeeID');
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
	EXEC @iddd = shop.sp_CreateEmployee  @Title = 'Tv'	 -- NVARCHAR(50), NULL
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
									,@ManagerID = NULL  -- INT, NULL
									,@RoleTitle = 'TestManager'  -- NVARCHAR(255)
									,@HireDate = '2020-11-20'  -- DATETIME
									,@IsActive = 1  -- TINYINT,  NULL
									

INSERT INTO #testID (id)
SELECT @iddd
SELECT Top 1 id FROM #testID


DELETE Shop.Employees
WHERE EmployeeID =  (SELECT Top 1 id FROM #testID) 

DELETE Shop.AddressEmployee
WHERE EmployeeID =  (SELECT Top 1 id FROM #testID) 

DELETE Shop.ContactEmployee
WHERE EmployeeID =  (SELECT Top 1 id FROM #testID) 

DBCC CHECKIDENT ('Shop.Employees')
DBCC CHECKIDENT ('Shop.Employees', RESEED, 23)  
  
SELECT SCOPE_IDENTITY()

SELECT * FROM Shop.Employees
SELECT * FROM Shop.Addresses
SELECT * FROM Shop.Contacts
SELECT * FROM Shop.AddressEmployee
SELECT * FROM Shop.ContactEmployee

SELECT * FROM Logs.EventLogs
SELECT * FROM Logs.ErrorLogs
SELECT * FROM Logs.OperationRuns
SELECT * FROM Logs.Operations










