use UNIVER

--task 1
--Определить все индексы, которые имеются в БД UNIVER. 
exec sp_helpindex 'PULPIT'
exec sp_helpindex 'SUBJECT'	
exec sp_helpindex 'FACULTY'
exec sp_helpindex 'TEACHER'

--Создать временную локальную таблицу. Заполнить ее данными (не менее 1000 строк). 
create table #temp_table(	
some_ind int, 
some_field varchar(20))
set nocount on
DECLARE @i int = 0
while @i < 1000
begin
insert #temp_table(some_ind, some_field)
values(FLOOR(RAND()*10000), REPLICATE('хочу автомат',3))
SET @i = @i + 1; 
end

SELECT count(*)[количество строк] from #temp_table
SELECT * from #temp_table

--Разработать SELECT-запрос. По-лучить план запроса и определить его стоимость. 
select * from #temp_table where some_ind between 1500 and 5000 
checkpoint			--фиксация БД
DBCC DROPCLEANBUFFERS	--очистить буферный кэш

--Создать кластеризованный индекс, уменьшающий стоимость SELECT-запроса.
CREATE clustered index #temp_table_cl on #temp_table(some_ind asc)
--drop table #temp_table

--task 2
--Создать временную локальную таб-лицу. Заполнить ее данными (10000 строк или больше). 
create table #temp_table_1(
some_ind int, 
some_field varchar(20),
cc int identity(1,1))
SET nocount on
DECLARE @j int = 0
while @j < 10000
begin
insert #temp_table_1(some_ind, some_field)
values(FLOOR(RAND()*10000), REPLICATE('ыам',3))
SET @j = @j + 1
end

SELECT count(*)[количество строк] from #temp_table_1
SELECT * from #temp_table_1

--Разработать SELECT-запрос. По-лучить план запроса и определить его стоимость. 
select * from #temp_table_1 where cc >500 and some_ind between 1500 and 5000 

--Создать некластеризованный не-уникальный составной индекс. 
CREATE index #temp_table_1_nonclu on #temp_table_1(some_ind, CC)
select CC from #temp_table_1 where some_ind > 500
--drop table #temp_table_1

--task 3
--Создать временную локальную таб-лицу. Заполнить ее данными (не ме-нее 10000 строк). 
create table #temp_table_2(
some_ind int, 
some_field varchar(20),
cc int identity(1,1))
SET nocount on
DECLARE @k int = 0
while @k < 10000
begin
insert #temp_table_2(some_ind, some_field)
values(FLOOR(RAND()*30000), REPLICATE('Fadva',3) );
SET @k = @k + 1; 
end

--Разработать SELECT-запрос. По-лучить план запроса и определить его стоимость. 
select * from #temp_table_2 where cc >500 and some_ind between 1500 and 5000 

--Создать некластеризованный ин-декс покрытия, уменьшающий сто-имость SELECT-запроса. 
CREATE index #temp_table_2_nonclu_2 on #temp_table_2(some_ind) INCLUDE(cc)
select CC from #temp_table_2 where some_ind > 500
--drop table #temp_table_2

--task 4
--Создать и заполнить временную ло-кальную таблицу. 
--Разработать SELECT-запрос, по-лучить план запроса и определить его стоимость. 
--Создать некластеризованный фильтруемый индекс, уменьшаю-щий стоимость SELECT-запроса.

SELECT some_ind from  #temp_table_2 where some_ind between 5000 and 19999; 
SELECT some_ind from  #temp_table_2 where some_ind>15000 and  some_ind < 20000  
SELECT some_ind from  #temp_table_2 where some_ind=17000

 CREATE  index #temp_table_WHERE on #temp_table_2(some_ind) 
 where (some_ind>15000 and  some_ind  < 20000)
--drop index #temp_table_WHERE on #temp_table_2

-- task 5
--созд.врем.лок.табл
use tempdb
CREATE index #temp_table_2_ind  on #temp_table_2(some_ind)

INSERT top(10000) #temp_table_2(some_ind, some_field) 
select some_ind, some_field from #temp_table_2

--созд. некластериз.индекс,оценить фрагментацию индекса
SELECT	name [Индекс], avg_fragmentation_in_percent [Фрагментация(%)] 
FROM sys.dm_db_index_physical_stats(DB_ID(N'TEMPDB'), 
OBJECT_ID(N'#temp_table_2'), NULL, NULL, NULL) ss
JOIN sys.indexes ii on ss.object_id = ii.object_id and ss.index_id = ii.index_id 
where name is not null

--Выполнить процедуру реорганизации индекса , перестройки
ALTER index #temp_table_2_ind on #temp_table_2 reorganize
ALTER index #temp_table_2_ind  on #temp_table_2 rebuild with (online = off)
--drop index #temp_table_2_ind on #temp_table_2

--task 6
--Разработать пример, демонстриру-ющий применение параметра FILL-FACTOR при создании некластери-зованного индекса.
CREATE index #temp_table_2_ind1  on #temp_table_2(some_ind)with (fillfactor = 65)

INSERT top(50)percent into #temp_table_2(some_ind, some_field)
select some_ind, some_field  from #temp_table_2

SELECT	name [Индекс], avg_fragmentation_in_percent [Фрагментация(%)] 
FROM sys.dm_db_index_physical_stats(DB_ID(N'TEMPDB'), 
OBJECT_ID(N'#temp_table_2'), NULL, NULL, NULL) ss
JOIN sys.indexes ii on ss.object_id = ii.object_id and ss.index_id = ii.index_id 
where name is not null
--drop index #temp_table_2_ind1 on #temp_table_2