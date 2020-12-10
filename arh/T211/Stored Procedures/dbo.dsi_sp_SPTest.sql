CREATE   PROC dsi_sp_SPTest
AS
BEGIN
	SELECT object_schema_name(object_id('dsi_sp_SPTest'))
END;