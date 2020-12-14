USE MASTER;
GO

USE T21;
GO

-- Create new Contact, return new ContactID

-------------
CREATE OR ALTER PROCEDURE shop.sp_CreateContact
	@Title NVARCHAR(50) = NULL,
	@FirstName NVARCHAR(255),
	@MiddleName NVARCHAR(255) = NULL,
	@LastName NVARCHAR(255),
	@Gender NVARCHAR(50),
	@BirthDay NVARCHAR(50),
	@Email NVARCHAR(255),
	@Phone NVARCHAR(50)

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
			CHAR(9), '@Phone = ', @Phone, CHAR(13), CHAR(10));

		DECLARE @eventMessage NVARCHAR(MAX) = CONCAT('Created new Contact with Parameters: ', @curentParameters);
	

		-- to keep new OperationRunID 
		DECLARE @curentRunID INT;	

		-- Start Operation and get new OperationRunID
		EXEC @curentRunID = 
			logs.sp_StartOperation   @OperationID = 3	-- INT     OperationID for Shop.sp_CreateContact  from Logs.Operations
									,@Description = NULL	-- NVARCHAR(255), NULL
									,@OperationRunParameters = @curentParameters	-- NVARCHAR(MAX), NULL
		
		-- to keep new ContactID
		DECLARE @newContactID INT;		

		-- Create new Contact
		INSERT INTO Shop.Contacts(
			Title,
			FirstName,
			MiddleName,
			LastName,
			Gender,
			BirthDay,
			Email,
			Phone)
		VALUES(
			@Title,
			@FirstName,
			@MiddleName,
			@LastName,
			@Gender,
			@BirthDay,
			@Email,
			@Phone);
			 
		SET @newContactID = SCOPE_IDENTITY();

		-- throw event
		DECLARE @eventMessage NVARCHAR(MAX) = CONCAT('Created new Contact with Parameters: ', @curentParameters);
		EXEC logs.sp_SetEvent	 @runID = @curentRunID		-- INT						
								,@affectedRows = @@rowcount		-- INT, NULL
								,@procedureID = @@PROCID		-- INT, NULL
								,@parameters = @curentParameters	-- NVARCHAR(MAX), NULL
								,@eventMessage = @eventMessage		-- NVARCHAR(MAX)


		-- Complete Operation
		EXEC logs.sp_CompleteOperation   @OperationRunID = 	@curentRunID	 -- INT       -- get from sp_StartOperation
										,@OperationRunParameters = @curentParameters  -- NVARCHAR(MAX), NULL

		RETURN @newContactID;

	END TRY
	BEGIN CATCH
	
		-- throw Error
		EXEC logs.sp_SetError	 @runID = @curentRunID 		-- INT       -- get from sp_StartOperation
								,@procedureID = @@PROCID	-- INT, NULL
								,@parameters = @curentParameters	-- NVARCHAR(MAX), NULL
								,@errorMessage = 'Can not create Contact'	-- NVARCHAR(MAX), NULL

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
	(3,'Shop.sp_CreateContact','Create new Contact, return new ContactID');
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
EXEC @iddd = shop.sp_CreateContact   @Title = 'Tv'	 -- NVARCHAR(50), NULL
									,@FirstName = 'Yuri'  -- NVARCHAR(255)
									,@MiddleName = NULL  -- NVARCHAR(255), NULL
									,@LastName = 'Ogarkov'  -- NVARCHAR(255)
									,@Gender = 'Male'  -- NVARCHAR(50)
									,@BirthDay = '1915-01-01'  -- NVARCHAR(50)
									,@Email = 'YuriOgarkov@MVD.com'  -- NVARCHAR(255)
									,@Phone = '66552956'  -- NVARCHAR(50)

INSERT INTO #testID (id)
SELECT @iddd
SELECT Top 1 id FROM #testID


DELETE Shop.Contacts
WHERE ContactID =  (SELECT Top 1 id FROM #testID) 

DBCC CHECKIDENT ('Shop.Contacts')
DBCC CHECKIDENT ('Shop.Contacts', RESEED, 130)  
  
SELECT SCOPE_IDENTITY()

SELECT * FROM Shop.Contacts

SELECT * FROM Logs.EventLogs
SELECT * FROM Logs.ErrorLogs
SELECT * FROM Logs.OperationRuns
SELECT * FROM Logs.Operations

