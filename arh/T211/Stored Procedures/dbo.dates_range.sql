CREATE PROCEDURE dates_range @start_date NVARCHAR(10), @end_date NVARCHAR(10)
AS
BEGIN
;WITH dates as(
	SELECT CONVERT(DATE, @start_date, 103) AS date
	UNION ALL
	SELECT DATEADD(d,1,date) AS date
	FROM dates
	WHERE date < CONVERT(DATE, @end_date, 103)
)
SELECT CONVERT(NVARCHAR(10), date, 103)
	FROM dates
END