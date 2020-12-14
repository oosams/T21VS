USE MASTER;
GO

USE T21;
GO

-- Create new Product, return new ProductID

-------------
CREATE OR ALTER PROCEDURE shop.sp_CreateProduct
	@CategoryID INT = NULL,
	@ProductName NVARCHAR(255),
	@UnitPrice MONEY,
	@Quantity INT,
	@IsActive INT = 1,
	@Description NVARCHAR(max)

AS
BEGIN
	BEGIN TRY

		-- for logging
		DECLARE @curentParameters NVARCHAR(MAX) =  CONCAT(
			CHAR(9), '@CategoryID = ', @CategoryID, CHAR(13), CHAR(10),
			CHAR(9), '@ProductName = ', @ProductName, CHAR(13), CHAR(10),
			CHAR(9), '@UnitPrice = ', @UnitPrice, CHAR(13), CHAR(10),
			CHAR(9), '@Quantity = ', @Quantity, CHAR(13), CHAR(10),
			CHAR(9), '@IsActive = ', @IsActive, CHAR(13), CHAR(10),
			CHAR(9), '@Description = ', @Description, CHAR(13), CHAR(10));
					
		-- to keep new OperationRunID 
		DECLARE @curentRunID INT;	

		-- Start Operation and get new OperationRunID
		EXEC @curentRunID = 
			logs.sp_StartOperation   @OperationID = 6	-- INT     OperationID for Shop.sp_CreateCategory  from Logs.Operations
									,@Description = NULL	-- NVARCHAR(255), NULL
									,@OperationRunParameters = @curentParameters	-- NVARCHAR(MAX), NULL
		
		-- to keep new CategoryID
		DECLARE @newCategoryID INT;		

		-- Create new Category
		INSERT INTO Shop.Categories(
			CategoryName,
			Description)
		VALUES(
			@CategoryName,
			@Description);
			 
		SET @newCategoryID = SCOPE_IDENTITY();

		-- throw event
		DECLARE @eventMessage NVARCHAR(MAX) = CONCAT('Created new Category with ID: ', @newCategoryID);
		EXEC logs.sp_SetEvent	 @runID = @curentRunID		-- INT						
								,@affectedRows = @@rowcount		-- INT, NULL
								,@procedureID = @@PROCID		-- INT, NULL
								,@parameters = @curentParameters	-- NVARCHAR(MAX), NULL
								,@eventMessage = @eventMessage		-- NVARCHAR(MAX)


		-- Complete Operation
		EXEC logs.sp_CompleteOperation   @OperationRunID = 	@curentRunID	 -- INT       -- get from sp_StartOperation
										,@OperationRunParameters = @curentParameters  -- NVARCHAR(MAX), NULL

		RETURN @newCategoryID;

	END TRY
	BEGIN CATCH
	
		-- throw Error
		EXEC logs.sp_SetError	 @runID = @curentRunID 		-- INT       -- get from sp_StartOperation
								,@procedureID = @@PROCID	-- INT, NULL
								,@parameters = @curentParameters	-- NVARCHAR(MAX), NULL
								,@errorMessage = 'Can not create Category'	-- NVARCHAR(MAX), NULL

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
	(7,'Shop.sp_CreateProduct','Create new Product, return new ProductID');
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
EXEC @iddd = shop.sp_CreateCategory  @CategoryName = 'TestCatName'	 -- NVARCHAR(255)
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

