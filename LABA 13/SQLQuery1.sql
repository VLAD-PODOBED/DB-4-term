--1--
-- хранимая процедура без параметров, формирует результирующий набор на основе таблицы SUBJECT
create procedure PSUBJECT
as begin 
declare @k int=(select COUNT(*) from SUBJECT);
select SUBJECT [КОД], SUBJECT_NAME [ДИСЦИПЛИНА], PULPIT [КАФЕДРА] from SUBJECT;
return @k;
end;
declare @i int=0;
exec @i=PSUBJECT;
print 'Количество предметов: '+cast(@i as varchar(3));

--2--
--строки, соответствующие коду кафедры, заданному параметром @p. 
--@с, равное количеству строк в результирующем наборе, равное общему количеству дисциплин 
go
ALTER procedure [dbo].[PSUBJECT] @p varchar(20), @c int output
as begin 
declare @k int=(select COUNT(*) from SUBJECT);
print 'Параметры: @p='+@p+', @c='+cast(@c as varchar(3));
select SUBJECT [КОД], SUBJECT_NAME [ДИСЦИПЛИНА], PULPIT [КАФЕДРА] from SUBJECT where PULPIT = @p;
set @c=@@ROWCOUNT;
return @k;
end;

declare @temp_2 int = 0, @out_2 int = 0;
exec @temp_2 = PSUBJECT 'ИСиТ', @out_2 output;
print 'Дисциплин всего: ' + convert(varchar, @temp_2);
print 'Дисциплин на кафедре ИСиТ: ' + convert(varchar, @out_2);

--3--
-- временная локальная таблица, изменить процедуру, insert
-- изменения в процедуру с помощью ALTER:
ALTER procedure PSUBJECT @p varchar(20)
as begin
SELECT * from SUBJECT where SUBJECT.PULPIT = @p;
end;
--drop procedure PSUBJECT;

CREATE table #SUBJECT
(Код varchar(10) primary key,
Дисциплина varchar(50),
Кафедра varchar(10));
--drop table #SUBJECT;

insert #SUBJECT exec PSUBJECT @p = 'ИСиТ'; 
SELECT * from #SUBJECT;

--4--
-- Процедура 4 вх.парам (значения столбцов), доб. строку в табл.AUDITORIUM
create procedure PAUDITORIUM_INSERT @a char(20), @n varchar(50),  @c int=0, @t char(10)
as begin try
insert into AUDITORIUM(AUDITORIUM, AUDITORIUM_TYPE, AUDITORIUM_CAPACITY, AUDITORIUM_NAME)
values (@a, @n, @c, @t)
return 1;
end try
begin catch
print 'Номер ошибки: ' + cast(error_number() as varchar(6));	
print 'Сообщение: ' + error_message();
print 'Уровень: ' + cast(error_severity() as varchar(6));
print 'Метка: ' + cast(error_state() as varchar(8));
print 'Номер строки: ' + cast(error_line() as varchar(8));
if error_procedure() is not null   
print 'Имя процедуры: ' + error_procedure();
return -1;
end catch;
--drop procedure PAUDITORIUM_INSERT;

DECLARE @rc int; 
exec @rc=PAUDITORIUM_INSERT @a='322-1', @n='ЛК', @c=60, @t='322-1';
print 'Код: '+cast(@rc as varchar(3));
--delete AUDITORIUM where AUDITORIUM='322-1';

select * from AUDITORIUM;

--5--
-- вывести дисциплины на кафедре через запятую:
create procedure SUBJECT_REPORT @p char(10)
as declare @rc int = 0;
begin try
if not exists (select SUBJECT from SUBJECT where PULPIT = @p)
raiserror('Ошибка в параметрах', 11, 1);
declare @subs_list char(300) = '', @sub char(10);
declare SUBJECTS_L12 cursor for select SUBJECT from SUBJECT where PULPIT = @p;
open SUBJECTS_L12;
fetch SUBJECTS_L12 into @sub;
while (@@FETCH_STATUS = 0)
begin
set @subs_list = rtrim(@sub) + ', ' + @subs_list;
set @rc += 1;
fetch SUBJECTS_L12 into @sub;
end;
print 'Дисциплины на кафедре ' + rtrim(@p) + ':';
print rtrim(@subs_list);
close SUBJECTS_L12;
deallocate SUBJECTS_L12;
return @rc;
end try
begin catch
print 'Номер ошибки: ' + convert(varchar, error_number());
print 'Сообщение: ' + error_message();
print 'Уровень: ' + convert(varchar, error_severity());
print 'Метка: ' + convert(varchar, error_state());
print 'Номер строки: ' + convert(varchar, error_line());
if error_procedure() is not null
print 'Имя процедуры: ' + error_procedure();
return @rc;
end catch;
go
--drop procedure SUBJECT_REPORT

declare @temp_5 int;
exec @temp_5 = SUBJECT_REPORT 'ИСиТ';
print 'Количество дисциплин: ' + convert(varchar, @temp_5);
go

--6--
-- транзакция serializable; @tn для AUDITORIUM_TYPE.AUDITORIUM_TYPENAME 
--Процедура добавляет две строки. Первая строка добавляется в таблицу AUDITORIUM_TYPE.
--Вторая строка добавляется путем вызова процедуры PAUDITORIUM_INSERT.
create proc PAUDITORIUM_INSERTX 
@AUD char(20), @NAME varchar(50), @CAPACITY int = 0,
@AUD_TYPE char(10), @AUD_TYPENAME varchar(70)
as begin try
set transaction isolation level SERIALIZABLE
begin tran
insert into AUDITORIUM_TYPE (AUDITORIUM_TYPE, AUDITORIUM_TYPENAME) values (@NAME, @AUD_TYPENAME)
exec PAUDITORIUM_INSERT @AUD, @NAME, @CAPACITY, @AUD_TYPE
commit tran
end try
begin catch
print 'Код ошибки:  ' + cast(ERROR_NUMBER() as varchar)
print 'Серьёзность: ' + cast(ERROR_SEVERITY() as varchar)
print 'Сообщение:   ' + cast(ERROR_MESSAGE() as varchar)
if @@TRANCOUNT > 0 
rollback tran
return -1
end catch
--drop procedure PAUDITORIUM_INSERTX;

exec PAUDITORIUM_INSERTX @AUD = '323-1', @NAME = 'ЛkК', 
@CAPACITY = 50, @AUD_TYPE = '323-1', @AUD_TYPENAME = 'Лаб'
--delete AUDITORIUM_TYPE where AUDITORIUM_TYPE='ЛkК
--delete AUDITORIUM where AUDITORIUM_TYPE='ЛkК';
select * from AUDITORIUM_TYPE;