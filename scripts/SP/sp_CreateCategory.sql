USE MASTER;
GO

USE T21;
GO

-- Create new Category, return new CategoryID

-------------
CREATE OR ALTER PROCEDURE Shop.sp_CreateCategory
	 @CategoryName NVARCHAR(255)
	,@Description NVARCHAR(MAX)

AS
BEGIN
	BEGIN TRY

		-- for logging
		DECLARE @CurrentParameters NVARCHAR(MAX) =  CONCAT(
			CHAR(9), '@CategoryName = ', @CategoryName, CHAR(13), CHAR(10),
			CHAR(9), '@Description = ', @Description, CHAR(13), CHAR(10));

		
		-- to keep new OperationRunID 
		DECLARE @CurrentRunID INT;	

		-- Start Operation and get new OperationRunID
		EXEC @CurrentRunID = 
			Logs.sp_StartOperation   @OperationID = 6	-- INT     OperationID for Shop.sp_CreateCategory  from Logs.Operations
									,@Description = NULL	-- NVARCHAR(255), NULL
									,@OperationRunParameters = @CurrentParameters	-- NVARCHAR(MAX), NULL
		
		-- to keep new CategoryID
		DECLARE @NewCategoryID INT;		

		-- Create new Category
		INSERT INTO Shop.Categories(
			 CategoryName 
			,Description)
		VALUES(
			 @CategoryName 
			,@Description);
			 
		SET @NewCategoryID = SCOPE_IDENTITY();

		-- throw event
		DECLARE @EventMessage NVARCHAR(MAX) = CONCAT('Created new Category with ID: ', @NewCategoryID);
		EXEC Logs.sp_SetEvent	 @RunID = @CurrentRunID		-- INT						
								,@AffectedRows = @@rowcount		-- INT, NULL
								,@ProcedureID = @@PROCID		-- INT, NULL
								,@Parameters = @CurrentParameters	-- NVARCHAR(MAX), NULL
								,@EventMessage = @EventMessage		-- NVARCHAR(MAX)


		-- Complete Operation
		EXEC Logs.sp_CompleteOperation   @OperationRunID = 	@CurrentRunID	 -- INT       -- get from sp_StartOperation
										,@OperationRunParameters = @CurrentParameters  -- NVARCHAR(MAX), NULL

		RETURN @NewCategoryID;

	END TRY
	BEGIN CATCH
	
		-- throw Error
		EXEC Logs.sp_SetError	 @RunID = @CurrentRunID 		-- INT       -- get from sp_StartOperation
								,@ProcedureID = @@PROCID	-- INT, NULL
								,@Parameters = @CurrentParameters	-- NVARCHAR(MAX), NULL
								,@ErrorMessage = 'Can not create Category'	-- NVARCHAR(MAX), NULL

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
	(6,'Shop.sp_CreateCategory','Create new Category, return new CategoryID');
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
EXEC @iddd = Shop.sp_CreateCategory  @CategoryName = 'TestCatName'	 -- NVARCHAR(255)
									,@Description = 'Test Category discription'  -- NVARCHAR(MAX)

INSERT INTO #testID (id)
SELECT @iddd
SELECT Top 1 id FROM #testID


DELETE Shop.Categories
WHERE CategoryID =  (SELECT Top 1 id FROM #testID) 

DBCC CHECKIDENT ('Shop.Categories')
DBCC CHECKIDENT ('Shop.Categories', RESEED, 10)  
  
SELECT SCOPE_IDENTITY()

SELECT * FROM Shop.Categories

SELECT * FROM Logs.EventLogs
SELECT * FROM Logs.ErrorLogs
SELECT * FROM Logs.OperationRuns
SELECT * FROM Logs.Operations

