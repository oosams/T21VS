/*==============================================================*/
/* Table: Operations                                            */
/*==============================================================*/
create table Logs.Operations (
   OperationID          int                  identity,
   OperationName        nvarchar(255)        not null,
   Description          nvarchar(Max)        not null,
   constraint PK_OPERATIONS primary key (OperationID)
)

