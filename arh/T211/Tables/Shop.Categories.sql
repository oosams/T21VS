/*==============================================================*/
/* Table: Categories                                            */
/*==============================================================*/
create table Shop.Categories (
   CategoryID           int                  identity,
   CategoryName         nvarchar(255)        not null,
   Description          nvarchar(Max)        not null,
   constraint PK_CATEGORIES primary key (CategoryID)
)