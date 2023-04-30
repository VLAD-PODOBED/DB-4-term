USE UNIVER
--task 1
--Разработать сценарий, демон-стрирующий работу в режиме неявной транзакции.
--Проанализировать пример, приведенный справа, в котором создается таблица Х, и создать сценарий для другой таблицы.

 --     set nocount on
	--if  exists (select * from  SYS.OBJECTS        -- таблица X есть?
	--            where OBJECT_ID= object_id(N'DBO.X') )	            
	--drop table X;           
	--declare @c int, @flag char = 'c';           -- commit или rollback?
	--SET IMPLICIT_TRANSACTIONS  ON   -- включ. режим неявной транзакции
	--CREATE table X(K int );                         -- начало транзакции 
	--	INSERT X values (1),(2),(3);
	--	set @c = (select count(*) from X);
	--	print 'количество строк в таблице X: ' + cast( @c as varchar(2));
	--	if @flag = 'c'  commit;                   -- завершение транзакции: фиксация 
	--          else   rollback;                                 -- завершение транзакции: откат  
 --     SET IMPLICIT_TRANSACTIONS  OFF   -- выключ. режим неявной транзакции
	
	--if  exists (select * from  SYS.OBJECTS       -- таблица X есть?
	--            where OBJECT_ID= object_id(N'DBO.X') )
	--print 'таблица X есть';  
 --     else print 'таблицы X нет'

	  set nocount on
if  exists (select * from  SYS.OBJECTS 
         where OBJECT_ID=object_id(N'DBO.TAB')) 
	drop table TAB;           
declare @c int, @flag char = 'c'; 

SET IMPLICIT_TRANSACTIONS ON -- включ. режим неявной транзакции
	create table TAB(K int );                   
	insert TAB values (1),(2),(3),(4),(5);
	set @c = (select count(*) from TAB);
	print 'количество строк в таблице TAB: ' + cast(@c as varchar(2));
	if @flag = 'c' commit  -- завершение транзакции: фиксация 
		else rollback;    -- завершение транзакции: откат                             
SET IMPLICIT_TRANSACTIONS OFF -- выключ. режим неявной транзакции


if  exists (select * from  SYS.OBJECTS 
          where OBJECT_ID= object_id(N'DBO.TAB')) print 'таблицы TAB да';  
else print 'таблицы TAB нет'

--task 2
--Разработать сценарий, демон-стрирующий свойство атомар-ности явной транзакции на примере базы данных UNIVER. 
--В блоке CATCH предусмот-реть выдачу соответствующих сообщений об ошибках. 
--Опробовать работу сценария при использовании различных операторов модификации таб-лиц.

begin try
	begin tran --начало явной транзакции 
		delete AUDITORIUM where AUDITORIUM_NAME = '311-1';
		insert into AUDITORIUM values('311-1','ЛБ-К','15','311-1');
		update AUDITORIUM set AUDITORIUM_CAPACITY = '30' where AUDITORIUM_NAME='311-1';
		print 'Транзакция прошла успешно'; 
	commit tran; -- фиксация транзакции 
end try
begin catch
	print 'Ошибка: ' + cast(error_number() as varchar(5)) + ' ' + error_message()
	if @@TRANCOUNT > 0 rollback tran;
end catch;

--task 3
--Разработать сценарий, демон-стрирующий применение опера-тора SAVE TRAN на примере базы данных UNIVER. 
--В блоке CATCH предусмот-реть выдачу соответствующих сообщений об ошибках. 
--Опробовать работу сценария при использовании различных контрольных точек и различных операторов модификации таб-лиц.

DECLARE @savepoint varchar(30); --макс.длина имени 32
begin try
	begin tran --начало явной транзакции
		set @savepoint = 'save1'; save tran @savepoint; --контрольная точка
		delete AUDITORIUM where AUDITORIUM_NAME = '311-1';									
		set @savepoint = 'save2'; save tran @savepoint;
		insert into AUDITORIUM values('311-1','ЛБ-К','15','311-1');							
		set @savepoint = 'save3'; save tran @savepoint;
		update AUDITORIUM set AUDITORIUM_CAPACITY = 30 where AUDITORIUM_NAME='311-1';		
		print 'Транзакция прошла успешно'; 
	commit tran; --фиксация транзакции
end try
begin catch
	print 'Ошибка: ' + cast(error_number() as varchar(5)) + ' ' + error_message()
	if @@TRANCOUNT > 0
		begin
			print 'Контрольная точка: ' + @savepoint;
			rollback tran @savepoint; --откат к контрольной точке 
			commit tran; --фиксация изменений, выполненных до контрольной точки
		end;
end catch;

--task 4
--Разработать два сценария A и B на примере базы данных UNIVER. 
--Сценарий A представляет со-бой явную транзакцию с уров-нем изолированности READ UNCOMMITED, 
--сценарий B – явную транзакцию с уровнем изолированности READ COM-MITED (по умолчанию). 
--Сценарий A должен демон-стрировать, что уровень READ UNCOMMITED допускает не-подтвержденное, неповторяю-щееся и фантомное чтение.
set transaction isolation level READ UNCOMMITTED
begin transaction
-----t1---------
select @@SPID, 'insert FACULTY' 'результат', *
from FACULTY WHERE FACULTY = 'ИТ';
select @@SPID, 'update PULPIT' 'результат', *
from PULPIT WHERE FACULTY = 'ИТ';
commit;
-----B–-------
--явную транзакцию с уровнем изолированности READ COMMITED (по умолч) 
-----t2---------
begin transaction
select @@SPID
insert FACULTY values('ИТt','Информационных технологий');
update PULPIT set FACULTY = 'ИТ' WHERE PULPIT = 'ИСиТ'
-----t1----------
-----t2----------
ROLLBACK;

SELECT * FROM FACULTY;
SELECT * FROM PULPIT;
--task 5
--Разработать два сценария A и B на примере базы данных UNI-VER. 
--Сценарии A и В представля-ют собой явные транзакции с уровнем изолированности READ COMMITED. 
--Сценарий A должен демон-стрировать, что уровень READ COMMITED не допускает не-подтвержденного чтения, но при этом возможно неповторя-ющееся и фантомное чтение. 

SELECT * from PULPIT;
-----A--------
set transaction isolation level READ COMMITTED
begin transaction
select count(*) from PULPIT where FACULTY = 'ИТ';
-----t1-------
-----t2-------
select 'update PULPIT' 'результат', count(*) --здесь результат 2, т.к. произошло изменение
from PULPIT where FACULTY = 'ИТ'; --работает неповторяющееся чтение
commit;
-----B----
begin transaction
------t1-----
update PULPIT set FACULTY = 'ИТ' where PULPIT = 'ИСиТ';
commit;
------t2------

--task 6
--Разработать два сценария A и B на примере базы данных UNI-VER. 
--Сценарий A представляет со-бой явную транзакцию с уров-нем изолированности RE-PEATABLE READ. Сценарий B – явную транзакцию с уровнем изолированности READ COM-MITED. 
--Сценарий A должен демон-стрировать, что уровень REAPETABLE READ не допус-кает неподтвержденного чтения и неповторяющегося чтения, но при этом возможно фантомное чтение. 

set transaction isolation level REPEATABLE READ
begin transaction
select PULPIT FROM PULPIT WHERE FACULTY = 'ИЭФ';
--------t1---------
--------t2---------
select case
when PULPIT = 'ЭТиМ' then 'insert'  
else ' ' 
end,
PULPIT from PULPIT where FACULTY = 'ИЭФ'
commit
--- B ---	
begin transaction 	  
--------t1---------
insert PULPIT values ('ЭТ', 'что-то про экономику','ИЭФ');
commit
--------t2---------
--delete PULPIT where PULPIT='ЭТ' 

--task 7
--Разработать два сценария A и B на примере базы данных UNI-VER. 
--Сценарий A представляет со-бой явную транзакцию с уров-нем изолированности SERIAL-IZABLE. 
--Сценарий B – явную транзак-цию с уровнем изолированно-сти READ COMMITED.
--Сценарий A должен демон-стрировать отсутствие фантом-ного, неподтвержденного и не-повторяющегося чтения.

--------A---------
set transaction isolation level SERIALIZABLE 
begin transaction 
delete AUDITORIUM where AUDITORIUM = '123-4'
insert AUDITORIUM values ('123-4', 'ЛК-К', 10, 'Луч')
update AUDITORIUM set AUDITORIUM_NAME = 'Луч' where AUDITORIUM = '123-4'
select AUDITORIUM from AUDITORIUM where AUDITORIUM = '123-4'
--------t1---------
select AUDITORIUM from AUDITORIUM where AUDITORIUM = '123-4'
--------t2---------
commit 	
--- B ---	
begin transaction 	  
delete AUDITORIUM where AUDITORIUM_NAME = 'Луч' 
insert AUDITORIUM values ('123-4', 'ЛК-К', 10, 'Луч')
update AUDITORIUM set AUDITORIUM_NAME = 'Луч' where AUDITORIUM = '123-4'
select AUDITORIUM from AUDITORIUM  where AUDITORIUM = '123-4'
--------t1---------
commit
select AUDITORIUM from AUDITORIUM  where AUDITORIUM = '123-4'
--------t2---------

select * from AUDITORIUM 

--task 8
--Разработать сценарий, демон-стрирующий свойства вложен-ных транзакций, на примере ба-зы данных UNIVER. 
begin tran --внешняя транзакция 
insert AUDITORIUM_TYPE values ('ЛБ-М', 'какой то тип')
begin tran --внутренняя транзакция 
update AUDITORIUM set AUDITORIUM_CAPACITY = '100' where AUDITORIUM_TYPE = 'ЛК-К'
commit --внутрення транзакиця 
if @@TRANCOUNT > 0 --внешняя транзакция 
rollback

select (select count(*) from AUDITORIUM where AUDITORIUM_TYPE = 'ЛБ-М') Аудитории,
(select count(*) from AUDITORIUM_TYPE where AUDITORIUM_TYPE = 'ЛБ-М') Тип

select * from AUDITORIUM
select * from AUDITORIUM_TYPE
delete  AUDITORIUM_TYPE where  AUDITORIUM_TYPE = 'ЛБ-М'; 