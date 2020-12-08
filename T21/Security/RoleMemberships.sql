ALTER SERVER ROLE [sysadmin] ADD MEMBER [SOFTSERVE\osams];


GO
ALTER SERVER ROLE [sysadmin] ADD MEMBER [NT SERVICE\SQLWriter];


GO
ALTER SERVER ROLE [sysadmin] ADD MEMBER [NT SERVICE\Winmgmt];


GO
ALTER SERVER ROLE [sysadmin] ADD MEMBER [NT Service\MSSQLSERVER];


GO
ALTER SERVER ROLE [sysadmin] ADD MEMBER [NT SERVICE\SQLSERVERAGENT];


GO
ALTER SERVER ROLE [sysadmin] ADD MEMBER [l_certSignSmDetach];


GO
ALTER SERVER ROLE [sysadmin] ADD MEMBER [l_certSignPolyBaseAuthorize];


GO
ALTER SERVER ROLE [sysadmin] ADD MEMBER [sqlex];


GO
ALTER SERVER ROLE [securityadmin] ADD MEMBER [sqlex];


GO
ALTER SERVER ROLE [serveradmin] ADD MEMBER [sqlex];


GO
ALTER SERVER ROLE [setupadmin] ADD MEMBER [sqlex];


GO
ALTER SERVER ROLE [processadmin] ADD MEMBER [sqlex];


GO
ALTER SERVER ROLE [diskadmin] ADD MEMBER [sqlex];


GO
ALTER SERVER ROLE [dbcreator] ADD MEMBER [sqlex];

