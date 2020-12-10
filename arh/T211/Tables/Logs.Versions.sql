/*==============================================================*/
/* Table: Versions                                              */
/*==============================================================*/
create table Logs.Versions (
   VersionID            int                  identity,
   VersionTypeID        int                  not null,
   OperationRunID       int                  not null,
   VersionNumber        int                  not null,
   Description          nvarchar(Max)        not null,
   CreateDate           datetime             not null,
   constraint PK_VERSIONS primary key (VersionID)
)
GO
/*==============================================================*/
/* Index: VersionType_Version_FK                                */
/*==============================================================*/
create index VersionType_Version_FK on Logs.Versions (
VersionTypeID ASC
)
GO
/*==============================================================*/
/* Index: OperationRun_Version_FK                               */
/*==============================================================*/
create index OperationRun_Version_FK on Logs.Versions (
OperationRunID ASC
)
GO
/*==============================================================*/
/* Index: VersionNumber_FK                                      */
/*==============================================================*/
create index VersionNumber_FK on Logs.Versions (
VersionNumber ASC
)