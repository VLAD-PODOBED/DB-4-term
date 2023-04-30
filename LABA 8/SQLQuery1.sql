use UNIVER;
--task 1
--Разработать представление с именем Препода-ватель. Представление должно быть построено на основе SELECT-запроса к таблице TEACHER и
--содержать следующие столбцы: код, имя преподавателя, пол, код кафедры. 
go
CREATE or alter VIEW [Преподаватель]
AS
select TEACHER [код], 
TEACHER_NAME [имя преподавателя],
GENDER [пол],
PULPIT [код кафедры]
FROM TEACHER;
go
select *from [Преподаватель]
drop view [Преподаватель]

--task 2
--Разработать и создать представление с именем Количество кафедр. 
--Представление должно быть построено на основе SELECT-запроса к таблицам FACULTY и PULPIT.
--Представление должно содержать следую-щие столбцы: факультет, количество кафедр (вычисляется на основе строк таблицы PULPIT).
go
create or alter view [Количество кафедр]
as select FACULTY.FACULTY_NAME [факультет], 
count(PULPIT.FACULTY)	[количество кафедр]
from FACULTY inner join PULPIT
on PULPIT.FACULTY=FACULTY.FACULTY
group by FACULTY.FACULTY_NAME 
go
select * from [Количество кафедр]
drop view [Количество кафедр]

--task 3
--Разработать и создать представление с именем Аудитории. Представление должно быть 
--по-строено на основе таблицы AUDITORIUM и содержать столбцы: код, наименование ауди-тории. 
--Представление должно отображать только лекционные аудитории (в столбце AUDITO-RIUM_ TYPE строка, начинающаяся с симво-ла ЛК) 
--и допускать выполнение оператора IN-SERT, UPDATE и DELETE.
go
create view [Аудитории]
  as select AUDITORIUM.AUDITORIUM [Код],
        AUDITORIUM.AUDITORIUM_NAME [Наименование аудитории]
      from AUDITORIUM
      where AUDITORIUM.AUDITORIUM_TYPE like 'ЛК%';
go
      select * from [Аудитории];
	  go
alter view [Аудитории]
  as select AUDITORIUM.AUDITORIUM [Код],
        AUDITORIUM.AUDITORIUM_NAME [Наименование аудитории],
        AUDITORIUM.AUDITORIUM_TYPE [Тип аудитории]
      from AUDITORIUM
      where AUDITORIUM.AUDITORIUM_TYPE like 'ЛК%';
go
select * from [Аудитории];
drop view [Аудитории];
 --task 4
--Разработать и создать представление с именем Лекционные_аудитории. 
--Представление должно быть построено на основе SELECT-запроса к таблице AUDITO-RIUM и содержать следующие столбцы: код, наименование аудитории. 
--Представление должно отображать только лекционные аудитории (в столбце AUDITO-RIUM_TYPE строка, начинающаяся с симво-лов ЛК). 
go
create or alter view [Лекционные аудитории]
  as select AUDITORIUM.AUDITORIUM [Код],
        AUDITORIUM.AUDITORIUM_NAME [Наименование аудитории]
      from AUDITORIUM
      where AUDITORIUM.AUDITORIUM_TYPE like 'ЛК%' WITH CHECK OPTION;
go
select * from [Лекционные аудитории]
insert [Лекционные аудитории] values ('333-1', '333-1');
drop view [Лекционные аудитории];
					

--task 5
--Разработать представление с именем Дисци-плины. Представление должно быть построено на основе SELECT-запроса к таблице SUB-JECT, 
--отображать все дисциплины в алфавит-ном порядке и содержать следующие столбцы: код, наименование дисциплины и код ка-федры. 
--Использовать TOP и ORDER BY.
go
create or alter view [Дисциплины]
as select top 150 SUBJECT [код],
SUBJECT_NAME [наименование],
PULPIT [код кафедры]
from SUBJECT
order by наименование
go
select * from [Дисциплины]
drop view [Дисциплины];

--task 6
--Изменить представление Количество_кафедр, созданное в задании 2 так, чтобы оно было привязано к базовым таблицам.
--Продемонстрировать свойство привязанно-сти представления к базовым таблицам. 
--Использовать опцию SCHEMABINDING
go
alter view [Количество кафедр] with schemabinding
as select FACULTY.FACULTY_NAME [факультет], 
count(PULPIT.FACULTY)	[количество кафедр]
from dbo.FACULTY inner join dbo.PULPIT
on PULPIT.FACULTY=FACULTY.FACULTY
group by FACULTY.FACULTY_NAME 
go
select * from [Количество кафедр];
