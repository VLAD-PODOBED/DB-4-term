use UNIVER
--прогр констр,кот дает возможн польз обрабат строки результирующего набора запись за записью
--1 Разработать сценарий, формирующий список дисциплин на кафедре ИСиТ. В отчет должны 
--быть выведены краткие названия дисциплин из таблицы SUBJECT в одну строку через запятую. 
--счит 1 строку из результ набора и продвигает указатель на следующую строк
DECLARE @nm char(20), @t char (300)='';
  Declare NQSame CURSOR
	for SELECT SUBJECT from SUBJECT 
where PULPIT like 'ИСиТ';
	OPEN NQSame ;
FETCH NQSame into @nm;
	print'Предметы';
	while @@FETCH_STATUS=0
begin
	set @t=RTRIM(@nm)+','+@t;
	fetch NQSame into @nm;
end;
	print @t;
		CLOSE NQSame;
--2 Разработать сценарий, демонстрирую-щий отличие глобального курсора от локального на примере базы данных UNIVER.  -----
--может примен в рамках одного пак и рес, выдел ему при объяв, освобождаются сразу после завершения работы пакета.                          

DECLARE Mark CURSOR LOCAL
					for SELECT IDSTUDENT, NOTE FROM PROGRESS;
DECLARE @stud int, @note int;
	OPEN Mark;
	fetch Mark into @stud, @note;
	print '1. ' + convert(varchar(5),@stud) + convert(varchar(5),@note);
	go
DECLARE @stud int, @note int;
	fetch Mark into @stud, @note;
	print '2. ' + convert(varchar(5),@stud) + convert(varchar(5),@note);
	close Mark;
	deallocate Mark;
	go

DECLARE Marks CURSOR GLOBAL
					for SELECT IDSTUDENT, NOTE FROM PROGRESS;
DECLARE @stud int, @note int;
	OPEN Marks;
	fetch Marks into @stud, @note;
	print '1. ' + convert(varchar(5),@stud) + convert(varchar(5),@note);
	go
DECLARE @stud int, @note int;
	fetch Marks into @stud, @note;
	print '2. ' + convert(varchar(5),@stud) + convert(varchar(5),@note);
	close Marks;
	deallocate Marks;
	go
  --3 Разработать сценарий, демонстрирую-щий отличие статических курсоров Открытие статического курсора приводит 
  --к выгрузке результирующего набора во временную таблицу 
  --от динамических на примере базы данных UNIVER.
  DECLARE @facult varchar(50), @profession varchar(50), @year int;  
DECLARE Groups_cur CURSOR LOCAL STATIC                              
						for SELECT FACULTY, PROFESSION, YEAR_FIRST FROM GROUPS where Faculty = 'ТОВ';				   
	open Groups_cur;
	print  'Количество строк : ' + cast(@@CURSOR_ROWS as varchar(5)); 
    UPDATE GROUPS set YEAR_FIRST = 2012 where PROFESSION = '1-36 07 01';
	DELETE GROUPS where IDGROUP = 1;
	
	FETCH  Groups_cur into @facult, @profession, @year;     
	while @@fetch_status = 0                                 
      begin 
          print @facult + ' '+ @profession + ' '+ convert(varchar(4),@year);      
          fetch Groups_cur into @facult, @profession, @year; 
       end;          
   CLOSE Groups_cur;


     DECLARE @facult1 varchar(50), @profession1 varchar(50), @year1 int;  
DECLARE Groups_cur CURSOR LOCAL DYNAMIC                            
						for SELECT FACULTY, PROFESSION, YEAR_FIRST FROM GROUPS where Faculty = 'ТОВ';				   
	open Groups_cur;
	print  'Количество строк : ' + cast(@@CURSOR_ROWS as varchar(5)); 
    UPDATE GROUPS set YEAR_FIRST = 2012 where PROFESSION = '1-36 07 01';
	DELETE GROUPS where IDGROUP = 1;
	
	FETCH  Groups_cur into @facult1, @profession1, @year1;     
	while @@fetch_status = 0                                 
      begin 
          print @facult1 + ' '+ @profession1 + ' '+ convert(varchar(4),@year1);      
          fetch Groups_cur into @facult1, @profession1, @year1; 
       end;          
   CLOSE Groups_cur;

  --4 Разработать сценарий, демонстрирую-щий свойства навигации в результиру-ющем наборе курсора с атрибутом SCROLL на примере базы данных UNIVER.
DECLARE  @tc int, @rn char(50);  
DECLARE Primer1 cursor local dynamic SCROLL                               
for SELECT row_number() over (order by SUBJECT) S,
SUBJECT FROM dbo.SUBJECT  where PULPIT = 'ИСиТ' 
	OPEN Primer1;
	FETCH  Primer1 into  @tc, @rn;                 
	print 'следующая строка: ' + cast(@tc as varchar(3))+ rtrim(@rn);      
	FETCH  LAST from  Primer1 into @tc, @rn;       
	print 'последняя строка: ' +  cast(@tc as varchar(3))+ rtrim(@rn);      
	FETCH  NEXT from  Primer1 into @tc, @rn;       
	print 'следующая строка за текущей: ' +  cast(@tc as varchar(3))+ rtrim(@rn); 
   	FETCH  PRIOR from  Primer1 into @tc, @rn;       
	print 'предыдущая строка от текущей: ' +  cast(@tc as varchar(3))+ rtrim(@rn); 
	FETCH  ABSOLUTE 3 from  Primer1 into @tc, @rn;       
	print 'строка от начала: ' +  cast(@tc as varchar(3))+ rtrim(@rn); 	
	FETCH  ABSOLUTE -3 from  Primer1 into @tc, @rn;       
	print 'строка от конца: ' +  cast(@tc as varchar(3))+ rtrim(@rn); 	
	FETCH  RELATIVE 4 from  Primer1 into @tc, @rn;       
	print 'строка вперед от текущей: ' +  cast(@tc as varchar(3))+ rtrim(@rn); 	
	FETCH  RELATIVE -4 from  Primer1 into @tc, @rn;       
	print 'строка назад от текущей: ' +  cast(@tc as varchar(3))+ rtrim(@rn); 	
	CLOSE Primer1;
--5 Создать курсор, демонстрирующий применение конструкции CURRENT OF в секции WHERE с использованием операторов UPDATE и DELETE.
DECLARE @pol varchar(10), @name varchar(10), @top int;
DECLARE Auditor CURSOR GLOBAL DYNAMIC 
FOR SELECT a.AUDITORIUM, a.AUDITORIUM_TYPE, a.AUDITORIUM_CAPACITY FROM AUDITORIUM a FOR UPDATE;
OPEN Auditor
	FETCH Auditor INTO @pol, @name, @top;
	PRINT 'Selected row for update: ' + rtrim(@pol) + ', ' + rtrim(@name) + ', ' + convert(varchar(5), @top) + '.';
	UPDATE AUDITORIUM SET AUDITORIUM_CAPACITY = AUDITORIUM_CAPACITY + 1 WHERE CURRENT OF Auditor;
	FETCH Auditor INTO @pol, @name, @top;
	PRINT 'Selected row for delete: ' + rtrim(@pol) + ', ' + rtrim(@name) + ', ' + convert(varchar(5), @top) + '.';
	DELETE AUDITORIUM WHERE CURRENT OF Auditor;
CLOSE Auditor;
DEALLOCATE Auditor;

--6 Разработать SELECT-запрос, с помо-щью которого из таблицы PROGRESS удаляются строки, содержащие ин-формацию о 
--студентах, получивших оценки ниже 4 (использовать объеди-нение таблиц PROGRESS, STUDENT, GROUPS). 
--Разработать SELECT-запрос, с по-мощью которого в таблице PROGRESS для студента с конкретным номером IDSTUDENT корректируется оценка (увеличивается на единицу).
USE UNIVER;
go
  select GROUPS.FACULTY, STUDENT.NAME, PROGRESS.NOTE, STUDENT.IDSTUDENT 
  into #temp__table__BadStudent
  from STUDENT 
  Inner Join GROUPS on GROUPS.IDGROUP = STUDENT.IDGROUP
  Inner Join PROGRESS on PROGRESS.IDSTUDENT = STUDENT.IDSTUDENT

select * from #temp__table__BadStudent

declare @fuc nvarchar(4), @name nvarchar(30), @mark int, @id int

declare delCursor cursor local dynamic for 
select * from #temp__table__BadStudent;
open delCursor;

fetch delCursor into @fuc,@name,@mark,@id;

set nocount on;
while @@FETCH_STATUS = 0
begin
  if (@mark <= 4) 
  begin
    delete #temp__table__BadStudent where current of delCursor
    print concat('Студент ', @name ,  ' отчислен за оценку ', @mark);
  end;
  fetch delCursor into @fuc,@name,@mark,@id;
  
end

select * from #temp__table__BadStudent

close delCursor;
deallocate delCursor;

use UNIVER;
declare Prog CURSOR LOCAL DYNAMIC FOR
	SELECT p.IDSTUDENT, s.NAME, p.NOTE FROM PROGRESS p
	JOIN STUDENT s ON s.IDSTUDENT = p.IDSTUDENT
	WHERE p.IDSTUDENT = 1017
		FOR UPDATE
declare @id varchar(5), @nm varchar(50), @nt int

OPEN Prog
FETCH Prog INTO @id, @nm, @nt
UPDATE PROGRESS SET NOTE = NOTE + 1 WHERE CURRENT OF Prog
print @id + ': ' + @nm +  + cast(@nt as varchar) 
CLOSE Prog