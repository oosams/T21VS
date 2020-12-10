/*==============================================================*/
/* Table: OperationRuns                                         */
/*==============================================================*/
create table Logs.OperationRuns (
   OperationRunID       int                  identity,
   StatusID             int                  not null,
   OperationID          int                  not null,
   StartTime            datetime             not null,
   EndTime              datetime             not null default {ts'9999-12-31 23:59:59'},

   Description          nvarchar(Max)        not null,
   constraint PK_OPERATIONRUNS primary key (OperationRunID)
)


GO
/*==============================================================*/
/* Index: OperationStatus_OperationRun_FK                       */
/*==============================================================*/
create index OperationStatus_OperationRun_FK on Logs.OperationRuns (
StatusID ASC
)


GO
/*==============================================================*/
/* Index: Operation_OperationRun_FK                             */
/*==============================================================*/
create index Operation_OperationRun_FK on Logs.OperationRuns (
OperationID ASC
)

