CREATE FUNCTION generate_dates1 (
    @date varchar(10)
)
RETURNS TABLE
AS
RETURN(
WITH dates AS(
	SELECT 1 AS day
	UNION ALL
	SELECT day + 1 from dates
	where day < DAY(EOMONTH(CONVERT(DATE, @date, 103))))
SELECT datefromparts(year(CONVERT(DATE, @date, 103)), month(CONVERT(DATE, @date, 103)), day) as days FROM dates
)
