use AdventureWorks2022
go

create nonclustered index IX_my_Index
on dbo.person_new (LastName)

go

select * 
from dbo.person_New
