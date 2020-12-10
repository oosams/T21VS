CREATE   FUNCTION dsi_FNFirstThree (@input VARCHAR(MAX))
RETURNS VARCHAR(3)
AS
BEGIN
	DECLARE @output VARCHAR(3);
	SET @output = LEFT(@input, 3);
	RETURN @output
END