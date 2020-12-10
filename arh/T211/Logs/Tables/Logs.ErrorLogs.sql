/*==============================================================*/
/* Table: ErrorLogs                                             */
/*==============================================================*/
create table Logs.ErrorLogs (
   ErrorID              int                  identity,
   OperationRunID       int                  not null,
   ErrorNumber          int                  null,
   ErrorProcName        nvarchar(1024)       null,
   Parameters           nvarchar(Max)       null,
   ErrorMessage         nvarchar(Max)        not null,
   ErrorDateTime        datetime             not null,
   constraint PK_ERRORLOGS primary key (ErrorID)
)


GO
CREATE NONCLUSTERED INDEX [Event_Error_FK]
    ON [Logs].[ErrorLogs]([EventID] ASC);


GO
/*==============================================================*/
/* Index: OperationRun_Log_FK                                   */
/*==============================================================*/
create index OperationRun_Log_FK on Logs.ErrorLogs (
OperationRunID ASC
)

