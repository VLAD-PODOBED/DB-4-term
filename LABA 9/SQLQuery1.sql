use UNIVER
--task 1
--Разработать скрипт, в котором: 
--объявить переменные типа char, varchar, datetime, time, int, smallint, tinint, numeric(12, 5); 
--первые две переменные проинициа-лизировать в операторе объявления;
--присвоить произвольные значения переменным с помощью операторов SET и SELECT; 
--значения одних переменных выве-сти с помощью оператора SELECT, зна-чения других переменных распечатать с помощью оператора PRINT. 
--Проанализировать результаты.
DECLARE @c char ='a', --1
		@v varchar(4)='VLAD', --1
		@d datetime,--8
		@t time,--3-5
		@i int = 4,	--4		
		@s smallint = 1,--2
		@ti tinyint = 1,--1
		@n numeric(12,5);--5-17
SET @d=GETDATE();

SELECT @t='12:59:34.21';
SELECT @c c, @v v, @d d, @t t, @i i;
SELECT @s=345, @ti=1, @n=1234567.12345;
print (cast(@s as varchar(10)));
print (cast(@ti as varchar(10)));
print (cast(@n as varchar(13)));
--task 2
--Разработать скрипт, в котором опреде-ляется общая вместимость аудиторий.
--Если общая вместимость превышает 200, то вывести количество аудиторий, 
--среднюю вместимость аудиторий, коли-чество аудиторий, вместимость которых меньше средней, и процент таких ауди-торий. 
--Если общая вместимость аудиторий меньше 200, то вывести сообщение о размере общей вместимости.

DECLARE @v1 int, @v2 int, @v3 int, @v4 int 
SELECT @v1 = SUM(AUDITORIUM_CAPACITY) FROM AUDITORIUM 
if @v1 > 200 
begin 
select	@v2 = (select COUNT(*) as [количество_аудиторий] from AUDITORIUM), 
		@v3 = (select AVG(AUDITORIUM_CAPACITY) as [вместимость_аудиторий] from AUDITORIUM) 
set	@v4 = (select COUNT(*) as [коли-чество_аудиторий] from AUDITORIUM where AUDITORIUM_CAPACITY < @v3) 
select @v2 'Количесво аудиторий', @v3 'Типо вместимость в аудитории', @v4 'Вместимость которых меньше средней',	
       100*(cast(@v4 as float)/cast(@v2 as float)) '% Процент таких аудиторий'			
end 
else print 's'+cast(@v1 as varchar(10))

--task 3 
--Разработать T-SQL-скрипт, ко-торый выводит на печать глобальные переменные: 
--@@ROWCOUNT (число обрабо-танных строк); 
--@@VERSION (версия SQL Server);
--@@SPID (возвращает системный идентификатор процесса, назначен-ный сервером текущему подключе-нию); 
--@@ERROR (код последней ошибки); 
--@@SERVERNAME (имя сервера); 
--@@TRANCOUNT (возвращает уровень вложенности транзакции); 
--@@FETCH_STATUS (проверка ре-зультата считывания строк результи-рующего набора); 
--@@NESTLEVEL (уровень вложен-ности текущей процедуры).
--Проанализировать результат.

select	@@ROWCOUNT 'число обработанных строк',
		@@VERSION 'версия SQL Server',
		@@SPID 'возвращает системный идентификатор процесса, назначен-ный сервером текущему подключе-нию',
		@@ERROR 'код последней ошибки',
		@@SERVERNAME 'имя сервера',
		@@TRANCOUNT 'возвращает уровень вложенности транзакции',
		@@FETCH_STATUS 'проверка результата считывания строк результи-рующего набора',
		@@NESTLEVEL 'уровень вложенности текущей процедуры'
--task 4 

declare @tt int=3, @x float=4, @z float;
if (@tt>@x) set @z=power(SIN(@tt),2);
if (@tt<@x) set @z=4*(@tt+@x);
if (@tt=@x) set @z=1-exp(@x-2);
print 'z='+cast(@z as varchar(10));

--преобразование полного ФИО студента в сокращенное (например, Макейчик Та-тьяна Леонидовна в Макейчик Т. Л.);

declare @fio varchar(100)=(select top 1 NAME from STUDENT)
select substring(@fio, 1, charindex(' ', @fio))
		+substring(@fio, charindex(' ', @fio)+1,1)+'.'
		+substring(@fio, charindex(' ', @fio, charindex(' ', @fio)+1)+1,1)+'.'

--поиск студентов, у которых день рож-дения в следующем месяце, и определе-ние их возраста;

select NAME,BDAY, 2022-YEAR(BDAY) [k]	
from STUDENT 
where MONTH(BDAY)=MONTH(getdate())+1

--поиск дня недели, в который студенты некоторой группы сдавали экзамен по БД.

declare @gr integer = 6, @wd date
set @wd = (select top(1) PROGRESS.PDATE from PROGRESS 
join STUDENT on STUDENT.IDSTUDENT = PROGRESS.IDSTUDENT
where STUDENT.IDGROUP = @gr and PROGRESS.SUBJECT = 'ОАиП')
print @wd

--task 5
--Продемонстрировать конструкцию IF… ELSE на примере анализа данных таб-лиц базы данных Х_UNIVER.

declare @idgr integer = 4, @avg numeric(5,2)
declare @count integer = (select count(*) from STUDENT where IDGROUP = @idgr)
if (@count > 5)
begin
set @avg = (select avg (cast (PROGRESS.NOTE as real))
from STUDENT join PROGRESS on STUDENT.IDSTUDENT = PROGRESS.IDSTUDENT)
print 'Больше 5: '+cast(@avg as varchar)
end
else print 'Меньше 5: '+cast(@count as varchar)

--task 6
--Разработать сценарий, в котором с по-мощью CASE анализируются оценки,
--полученные студентами некоторого фа-культета при сдаче экзаменов.

select student.NAME [Студент], student.IDGROUP [IDGROUP],
case when progress.NOTE between 0 and 3 then 'плохо'
when progress.NOTE between 4 and 6 then 'хорошо'
when progress.NOTE between 7 and 8 then 'отлично'
else 'no'
end степень, COUNT(*)[количество]
from student, PROGRESS where student.IDGROUP=6
group by student.NAME, student.IDGROUP,
case when progress.NOTE between 0 and 3 then 'плохо'
when progress.NOTE between 4 and 6 then 'хорошо'
when progress.NOTE between 7 and 8 then 'отлично'
else 'no'
end

--task 7
--Создать временную локальную таблицу из трех столбцов и 10 строк, 
--заполнить ее и вывести содержимое. Использовать оператор WHILE.

CREATE table #PET(
age int,
name varchar(50),
relatives int)
declare @ii int=0;
while @ii<10
begin
insert #PET(age, name, relatives) 
values (floor(24*RAND()), replicate('что-то',2), floor(26*RAND()));
set @ii=@ii+1;
end
select * from #PET
--drop table #PET

--task 8
--Разработать скрипт, демонстрирующий использование оператора RETURN.
declare @xx int = 1
while @xx < 10
begin
print @xx
set @xx=@xx+1
if (@xx > 5) return
end

--task 9
--Разработать сценарий с ошибками, в ко-тором используются для обработки ошибок блоки TRY и CATCH. 
--Применить функции ER-ROR_NUMBER (код последней ошиб-ки), ERROR_MESSAGE (сообщение об ошибке),
--ERROR_LINE (номер строки с ошибкой), ERROR_PROCEDURE (имя процедуры или NULL), ER-ROR_SEVERITY (уровень серьезности ошибки),
--ERROR_STATE (метка ошиб-ки). Проанализировать результат.

begin try
  declare @Err int;
  select @Err = 1 / 0;
end try
begin catch
  print ERROR_NUMBER()
  print ERROR_MESSAGE()
  print ERROR_LINE()
  print ERROR_PROCEDURE()
  print ERROR_SEVERITY()
  print ERROR_STATE()
end catch