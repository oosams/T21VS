USE MASTER;
GO

USE T21;
GO

-- Create new Contact, return new ContactID

-------------
CREATE OR ALTER PROCEDURE Shop.sp_CreateContact
	 @Title NVARCHAR(50) = NULL
	,@FirstName NVARCHAR(255) 
	,@MiddleName NVARCHAR(255) = NULL 
	,@LastName NVARCHAR(255) 
	,@Gender NVARCHAR(50) 
	,@BirthDay NVARCHAR(50) 
	,@Email NVARCHAR(255) 
	,@Phone NVARCHAR(50)

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
			CHAR(9), '@Phone = ', @Phone, CHAR(13), CHAR(10));

		
		-- to keep new OperationRunID 
		DECLARE @CurrentRunID INT;	

		-- Start Operation and get new OperationRunID
		EXEC @CurrentRunID = 
			Logs.sp_StartOperation   @OperationID = 3	-- INT     OperationID for Shop.sp_CreateContact  from Logs.Operations
									,@Description = NULL	-- NVARCHAR(255), NULL
									,@OperationRunParameters = @CurrentParameters	-- NVARCHAR(MAX), NULL
		
		-- to keep new ContactID
		DECLARE @NewContactID INT;		

		-- Create new Contact
		INSERT INTO Shop.Contacts(
			 Title
			,FirstName
			,MiddleName
			,LastName
			,Gender
			,BirthDay
			,Email
			,Phone)
		VALUES(
			 @Title
			,@FirstName
			,@MiddleName
			,@LastName
			,@Gender
			,@BirthDay
			,@Email
			,@Phone);
			 
		SET @NewContactID = SCOPE_IDENTITY();

		-- throw event
		DECLARE @EventMessage NVARCHAR(MAX) = CONCAT('Created new Contact with ID: ', @NewContactID);
		EXEC Logs.sp_SetEvent	 @RunID = @CurrentRunID		-- INT						
								,@AffectedRows = @@rowcount		-- INT, NULL
								,@ProcedureID = @@PROCID		-- INT, NULL
								,@Parameters = @CurrentParameters	-- NVARCHAR(MAX), NULL
								,@EventMessage = @EventMessage		-- NVARCHAR(MAX)


		-- Complete Operation
		EXEC Logs.sp_CompleteOperation   @OperationRunID = 	@CurrentRunID	 -- INT       -- get from sp_StartOperation
										,@OperationRunParameters = @CurrentParameters  -- NVARCHAR(MAX), NULL

		RETURN @NewContactID;

	END TRY
	BEGIN CATCH
	
		-- throw Error
		EXEC Logs.sp_SetError	 @RunID = @CurrentRunID 		-- INT       -- get from sp_StartOperation
								,@ProcedureID = @@PROCID	-- INT, NULL
								,@Parameters = @CurrentParameters	-- NVARCHAR(MAX), NULL
								,@ErrorMessage = 'Can not create Contact'	-- NVARCHAR(MAX), NULL

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
	(3,'Shop.sp_CreateContact','Create new Contact, return new ContactID');
SET IDENTITY_INSERT Logs.Operations OFF;
GO
--SELECT * FROM Logs.Operations
