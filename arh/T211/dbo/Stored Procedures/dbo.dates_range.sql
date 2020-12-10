CREATE PROCEDURE dates_range @start_date nvarchar(10), @end_date nvarchar(10)
AS
SELECT TOP (DATEDIFF(DAY, CONVERT(DATE, @start_date, 103), CONVERT(DATE, @end_date, 103)) + 1)
	CONVERT(VARCHAR(30), DATEADD(DAY, value - 1, CONVERT(DATE, @start_date, 103)), 103)  as date
FROM #T

------------------RUN
EXEC dates_range '12/09/2020', '17/09/2020'
---------------------





