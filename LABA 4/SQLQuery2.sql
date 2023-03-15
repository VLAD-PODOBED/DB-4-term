USE UNIVER;
--На основе таблиц AUDITORIUM_ TYPE и AUDITORIUM сформировать перечень кодов аудиторий и соответствующих им наименований типов аудиторий. 
--Использовать соединение таблиц INNER JOIN. 

--1
SELECT AUDITORIUM.AUDITORIUM, AUDITORIUM_TYPE.AUDITORIUM_TYPENAME


FROM AUDITORIUM INNER JOIN AUDITORIUM_TYPE
ON AUDITORIUM.AUDITORIUM_TYPE = AUDITORIUM_TYPE.AUDITORIUM_TYPE;

--На основе таблиц AUDITORIUM_TYPE и AUDITORIUM сформировать перечень ко-дов аудиторий и соответствующих им наименований типов аудиторий,
--выбрав только те аудитории, в наименовании кото-рых присутствует подстрока компьютер.
--Использовать соединение таблиц INNER JOIN и предикат LIKE. 

--2
SELECT AUDITORIUM.AUDITORIUM, AUDITORIUM_TYPE.AUDITORIUM_TYPENAME
FROM AUDITORIUM INNER JOIN AUDITORIUM_TYPE
ON AUDITORIUM.AUDITORIUM_TYPE = AUDITORIUM_TYPE.AUDITORIUM_TYPE AND AUDITORIUM_TYPE.AUDITORIUM_TYPENAME LIKE '%компьютер%'

--3
select a2.AUDITORIUM_TYPENAME ,a1.AUDITORIUM 
from AUDITORIUM a1, AUDITORIUM_TYPE a2
where a1.AUDITORIUM_TYPE=a2.AUDITORIUM_TYPE and a2.AUDITORIUM_TYPENAME LIKE '%компьютер%'

--На основе таблиц PULPIT и TEACHER по-лучить полный перечень кафедр и препода-вателей на этих кафедрах. 
--Результирующий набор должен содержать два столбца: Кафедра и 
--Преподаватель. Если на кафедре нет преподавателей, то в столбце Преподаватель должна быть выве-дена строка ***. 
--Примечание: использовать соединение таблиц LEFT OUTER JOIN и функцию isnull.

--4
SELECT isnull(TEACHER.TEACHER_NAME, '***')[TEACHER], PULPIT.PULPIT_NAME
FROM PULPIT LEFT OUTER JOIN TEACHER
ON TEACHER.PULPIT = PULPIT.PULPIT


--4.1

select PROGRESS.NOTE, STUDENT.NAME,GROUPS.IDGROUP, SUBJECT.SUBJECT,PULPIT.PULPIT,FACULTY.FACULTY,
case 
when (PROGRESS.NOTE =6) then 'шесть'
when (PROGRESS.NOTE =7) then 'семь'
when (PROGRESS.NOTE =8) then 'восемь'
end [Оценка]
from PROGRESS inner join STUDENT 
on PROGRESS.IDSTUDENT=STUDENT.IDSTUDENT and PROGRESS.NOTE between 6 and 8
inner join GROUPS on STUDENT.IDGROUP =GROUPS.IDGROUP 
inner join SUBJECT on PROGRESS.SUBJECT=SUBJECT.SUBJECT
inner join FACULTY on GROUPS.FACULTY= FACULTY.FACULTY
inner join PULPIT on SUBJECT.PULPIT= PULPIT.PULPIT
order by PROGRESS.NOTE desc, FACULTY.FACULTY, PULPIT.PULPIT, STUDENT. NAME

--Создать три новых запроса:


--− запрос, результат которого содержит дан-ные левой (в операции FULL OUTER JOIN) таблицы и не содержит данные правой; 
--− запрос, результат которого содержит дан-ные правой таблицы и не содержащие данные левой; 
--− запрос, результат которого содержит дан-ные правой таблицы и левой таблиц;

--5.1
SELECT PULPIT.FACULTY, PULPIT.PULPIT, PULPIT.PULPIT_NAME
FROM PULPIT FULL OUTER JOIN TEACHER
ON PULPIT.PULPIT = TEACHER.PULPIT
WHERE TEACHER.TEACHER IS NULL

--5.2
SELECT TEACHER.TEACHER_NAME, TEACHER.TEACHER, TEACHER.PULPIT,TEACHER.GENDER 
FROM PULPIT FULL OUTER JOIN TEACHER
ON PULPIT.PULPIT = TEACHER.PULPIT
WHERE TEACHER.TEACHER IS NOT NULL

--5.3
SELECT * FROM PULPIT FULL OUTER JOIN TEACHER
ON PULPIT.PULPIT = TEACHER.PULPIT

--Разработать SELECT-запрос на основе CROSS JOIN-соединения таблиц AUDITO-RIUM_TYPE и AUDITORIUM, формиру-ющего результат, 
--6
SELECT AUDITORIUM.AUDITORIUM, AUDITORIUM_TYPE.AUDITORIUM_TYPENAME 
FROM AUDITORIUM CROSS JOIN AUDITORIUM_TYPE
WHERE AUDITORIUM.AUDITORIUM_TYPE = AUDITORIUM_TYPE.AUDITORIUM_TYPE;