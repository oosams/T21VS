/*==============================================================*/
/* Table: EventLogs                                             */
/*==============================================================*/
create table Logs.EventLogs (
   EventID              int                  identity,
   OperationRunID       int                  not null,
   UserName             nvarchar(100)        null,
   AffectedRows         int                  null,
   EventProcName        nvarchar(1024)       null,
   Parameters           nvarchar(Max)       null,
   EventMessage         nvarchar(Max)        not null,
   EventDateTime        datetime             not null,
   constraint PK_EVENTLOGS primary key (EventID)
)


GO
/*==============================================================*/
/* Index: OperationRun_Event_FK                                 */
/*==============================================================*/
create index OperationRun_Event_FK on Logs.EventLogs (
OperationRunID ASC
)

