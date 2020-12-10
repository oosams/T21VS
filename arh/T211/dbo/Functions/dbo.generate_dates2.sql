CREATE FUNCTION generate_dates2 (
    @date_var VARCHAR(10)
)
RETURNS @T table(days DATE)
AS
BEGIN
	DECLARE @date DATE = CONVERT(DATE, @date_var, 103)
	
	;WITH dates AS(
	SELECT 1 AS day
	UNION ALL
	SELECT day + 1 from dates
	where day < DAY(EOMONTH(@date, 103)))
INSERT INTO @T SELECT DATEFROMPARTS(YEAR(@date), MONTH(@date), day) as days FROM dates
RETURN
END
