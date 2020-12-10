/*==============================================================*/
/* Table: VersionTypes                                          */
/*==============================================================*/
create table Logs.VersionTypes (
   VersionTypeID        int                  identity,
   VersionTypeName      nvarchar(255)        not null,
   EntityID             int                  not null,
   Description          nvarchar(Max)        not null,
   constraint PK_VERSIONTYPES primary key (VersionTypeID)
)
GO
/*==============================================================*/
/* Index: EnityID_FK                                            */
/*==============================================================*/
create index EnityID_FK on Logs.VersionTypes (
EntityID ASC
)