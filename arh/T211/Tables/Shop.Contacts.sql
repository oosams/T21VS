/*==============================================================*/
/* Table: Contacts                                              */
/*==============================================================*/
create table Shop.Contacts (
   ContactID            int                  identity,
   Title                nvarchar(50)         null,
   FirstName            nvarchar(255)        not null,
   MiddleName           nvarchar(255)        null,
   LastName             nvarchar(255)        not null,
   Gender               nvarchar(50)         not null,
   BirthDay             nvarchar(50)         not null,
   Email                nvarchar(255)        not null,
   Phone                nvarchar(50)         not null,
   constraint PK_CONTACTS primary key (ContactID)
)