use UNIVER
--task 1
--На основе таблиц AUDITORIUM и AUDI-TORIUM_TYPE разработать запрос, вы-числяющий для каждого типа аудиторий максимальную, 
--минимальную, среднюю вместимость аудиторий, суммарную вме-стимость всех аудиторий и общее количе-ство аудиторий данного типа. 
--Результирующий набор должен содер-жать столбец с наименованием типа ауди-торий и столбцы с вычисленными величи-нами. 
--Использовать внутреннее соединение таблиц, секцию GROUP BY и агрегатные функции. 

SELECT AUDITORIUM.AUDITORIUM_TYPE,
min(AUDITORIUM_CAPACITY) [Минимальная вместимость аудиторий],
max(AUDITORIUM_CAPACITY) [Максимальная вместимость аудиторий],
avg(AUDITORIUM_CAPACITY) [Средняя вместимость аудиторий],
count (*) [Количество], --общее количе-ство аудиторий данного типа
sum(AUDITORIUM_CAPACITY) [Суммарная вместимость всех аудиторий]
FROM AUDITORIUM Inner Join AUDITORIUM_TYPE
On AUDITORIUM.AUDITORIUM_TYPE = AUDITORIUM_TYPE.AUDITORIUM_TYPE
GROUP BY AUDITORIUM.AUDITORIUM_TYPE;

--task 2
--На основе таблиц AUDITORIUM и AUDI-TORIUM_TYPE разработать запрос, вы-числяющий для каждого типа аудиторий максимальную, 
--минимальную, среднюю вместимость аудиторий, суммарную вме-стимость всех аудиторий и общее количе-ство аудиторий данного типа. 
--Результирующий набор должен содер-жать столбец с наименованием типа ауди-торий и столбцы с вычисленными величи-нами. 
--Использовать внутреннее соединение таблиц, секцию GROUP BY и агрегатные функции. 

SELECT AUDITORIUM.AUDITORIUM_TYPE,
min(AUDITORIUM_CAPACITY) [Минимальная вместимость аудиторий],
max(AUDITORIUM_CAPACITY) [Максимальная вместимость аудиторий],
avg(AUDITORIUM_CAPACITY) [Средняя вместимость аудиторий],
count (*) [Количество], --общее количе-ство аудиторий данного типа
sum(AUDITORIUM_CAPACITY) [Суммарная вместимость всех аудиторий]
FROM AUDITORIUM Inner Join AUDITORIUM_TYPE
On AUDITORIUM.AUDITORIUM_TYPE = AUDITORIUM_TYPE.AUDITORIUM_TYPE
GROUP BY AUDITORIUM.AUDITORIUM_TYPE;

--task 3
--Разработать запрос на основе таблицы PROGRESS, который будет содержать значения экзаменационных оценок 
--и их ко-личество в заданном интервале. 
--Сортировка строк должна осуществлять-ся в порядке, обратном величине оценки.
--Использовать подзапрос в секции FROM, в подзапросе применить GROUP BY и CASE. 

SELECT * FROM(SELECT CASE
WHEN NOTE = 10 then '10'
WHEN NOTE between 8 and 9 then '8-9'
WHEN NOTE between 6 and 7 then '6-7'
WHEN NOTE between 4 and 5 then '4-5'
END [Пределы оценок], COUNT(*) as [Количество]
FROM PROGRESS 
GROUP BY CASE
WHEN NOTE = 10 then '10'
WHEN NOTE between 8 and 9 then '8-9'
WHEN NOTE between 6 and 7 then '6-7'
WHEN NOTE between 4 and 5 then '4-5'
END) AS T
ORDER BY Case [Пределы оценок]
WHEN '10' then 4
WHEN '8-9' then 3
WHEN '6-7' then 2
WHEN '4-5' then 1
ELSE 0
END;

--task 4
--Разработать SELECT-запроса на основе таблиц FACULTY, GROUPS, STUDENT и PROGRESS, который содержит среднюю экзаменационную оценку
--для каждого кур-са каждой специальности и факультета. 
--Строки отсортировать в порядке убыва-ния средней оценки.
--Средняя оценка должна рассчитываться с точностью до двух знаков после запятой.
--Использовать внутреннее соединение таблиц, агрегатную функцию AVG и встро-енные функции CAST и ROUND.

select a.FACULTY,
	   b.PROFESSION, 
	   round(avg(cast(PROGRESS.NOTE as float(4))),2) [AVG NOTE(Средняя оценка)]
from ((FACULTY a inner join GROUPS b on a.FACULTY = b.FACULTY)
inner join STUDENT on b.IDGROUP = STUDENT.IDGROUP) 
inner join PROGRESS on STUDENT.IDSTUDENT = PROGRESS.IDSTUDENT
group by a.FACULTY,
		 b.PROFESSION	

--task 5
--Переписать SELECT-запрос, разработанный в задании 4, так чтобы в расчете среднего значения оценок использовались 
--оценки только по дисциплинам с кодами БД и ОАиП. Использовать WHERE.

select a.FACULTY,
	   b.PROFESSION,
	   round(avg(cast(PROGRESS.NOTE as float(4))),2) [AVG NOTE]
from ((FACULTY a inner join GROUPS b on a.FACULTY = b.FACULTY)
inner join STUDENT on b.IDGROUP = STUDENT.IDGROUP) 
inner join PROGRESS on STUDENT.IDSTUDENT = PROGRESS.IDSTUDENT
where PROGRESS.SUBJECT = 'БД' or PROGRESS.SUBJECT = 'ОАиП'
group by a.FACULTY,
		 b.PROFESSION

--task 6
--На основе таблиц FACULTY, GROUPS, STUDENT и PROGRESS разработать за-прос, в котором выводятся специальность,
--дисциплины и средние оценки при сдаче эк-заменов на факультете ТОВ. 

SELECT GROUPS.FACULTY [FACULTY], GROUPS.PROFESSION [PROFESSION], PROGRESS.SUBJECT [PROGRESS],
round(avg(cast(PROGRESS.NOTE AS float(4))), 2) [AVG]
FROM GROUPS, STUDENT, PROFESSION, PROGRESS
WHERE GROUPS.FACULTY in ('ТОВ')
GROUP BY GROUPS.FACULTY, GROUPS.PROFESSION,PROGRESS.SUBJECT;

--task 7
--На основе таблицы PROGRESS определить для каждой дисциплины количество сту-дентов, получивших оценки 8 и 9. 
--Использовать группировку, секцию HAVING, сортировку. 

select p1.SUBJECT as 'PREDMET', 
	p1.NOTE as 'MARK', 
	(select count(*) from PROGRESS p2
	where p2.SUBJECT = p1.SUBJECT and p2.NOTE = p1.NOTE) as 'COUNT'
from PROGRESS p1
group by p1.SUBJECT, p1.NOTE
having NOTE in (8, 9)
