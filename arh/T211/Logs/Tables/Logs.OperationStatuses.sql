/*==============================================================*/
/* Table: OperationStatuses                                     */
/*==============================================================*/
create table Logs.OperationStatuses (
   StatusID             int                  identity,
   Status               nvarchar(50)         not null,
   StatusName           nvarchar(100)        not null,
   Description          nvarchar(Max)        not null,
   constraint PK_OPERATIONSTATUSES primary key (StatusID)
)

