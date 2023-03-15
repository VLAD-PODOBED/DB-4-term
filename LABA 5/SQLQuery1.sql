use UNIVER;
--На основе таблиц FACULTY, PULPIT и PROFESSION сформировать список наименований кафедр, которые находятся на факультете,
--обеспечивающем подго-товку по специальности, в наименовании которого содержится слово технология или технологии. 
--Использовать в секции WHERE преди-кат IN c некоррелированным подзапросом к таблице PROFESSION
--task 1
select DISTINCT FACULTY.FACULTY_NAME, PULPIT.PULPIT_NAME
from FACULTY, PULPIT, PROFESSION
where FACULTY.FACULTY = PULPIT.FACULTY and PULPIT.FACULTY = PROFESSION.FACULTY
and PROFESSION_NAME IN (select  PROFESSION.PROFESSION_NAME from PROFESSION 
where (PROFESSION_NAME like '%технология%' or PROFESSION_NAME like '%технологии%' ))

--Переписать запрос пункта 1 таким обра-зом, чтобы тот же подзапрос был записан в конструкции INNER JOIN секции FROM внешнего запроса. 
--При этом результат вы-полнения запроса должен быть аналогич-ным результату исходного запроса. 
--task 2
select DISTINCT FACULTY.FACULTY_NAME, PULPIT.PULPIT_NAME
from (FACULTY INNER JOIN PULPIT ON FACULTY.FACULTY = PULPIT.FACULTY) INNER JOIN PROFESSION ON PULPIT.FACULTY = PROFESSION.FACULTY 
WHERE PROFESSION_NAME in (select PROFESSION_NAME from  PROFESSION
where (PROFESSION_NAME like '%технология%' or PROFESSION_NAME like '%технологии%'))

--Переписать запрос, реализующий 1 пункт без использования подзапроса. 
--Примеча-ние: использовать соединение INNER JOIN трех таблиц. 
--task 3
select DISTINCT FACULTY.FACULTY_NAME, PULPIT.PULPIT_NAME
from (FACULTY INNER JOIN PULPIT ON FACULTY.FACULTY = PULPIT.FACULTY) INNER JOIN PROFESSION ON PULPIT.FACULTY = PROFESSION.FACULTY 
where (PROFESSION_NAME like '%технология%' or PROFESSION_NAME like '%технологии%')

--На основе таблицы AUDITORIUM сфор-мировать список аудиторий самых боль-ших вместимостей для каждого типа ауди-тории.
--При этом результат следует отсор-тировать в порядке убывания вместимо-сти.
--Примечание: использовать коррели-руемый подзапрос c секциями TOP и OR-DER BY. 
--task 4
select AUDITORIUM_TYPE,AUDITORIUM_CAPACITY from AUDITORIUM A
where AUDITORIUM_CAPACITY = (select top(1) AUDITORIUM_CAPACITY from AUDITORIUM R 
where  R.AUDITORIUM_TYPE= A.AUDITORIUM_TYPE 
order by AUDITORIUM_CAPACITY desc)

--На основе таблиц FACULTY и PULPIT сформировать список наименований фа-культетов на котором нет ни одной кафед-ры (таблица PULPIT). 
--Использовать предикат EXISTS и кор-релированный подзапрос. 
--task 5
select FACULTY.FACULTY_NAME from FACULTY
where not exists (select *from PULPIT where PULPIT.FACULTY = FACULTY.FACULTY_NAME)

--На основе таблицы PROGRESS сформи-ровать строку, содержащую средние зна-чения оценок (столбец NOTE) по дисци-плинам, имеющим следующие 
--коды: ОАиП, БД и СУБД. 
--Примечание: исполь-зовать три некоррелированных подзапроса в списке SELECT; 
--в подзапросах приме-нить агрегатные функции AVG. 
--task 6
 select top 1
	(select avg(NOTE) from PROGRESS where SUBJECT like 'ОАиП') [ОАиП],
	(select avg(NOTE) from PROGRESS where SUBJECT like 'БД ') [БД] ,
	(select avg(NOTE) from PROGRESS where SUBJECT like 'СУБД') [СУБД]
	from PROGRESS

--Разработать SELECT-запрос, демонстри-рующий способ применения ALL совмест-но с подзапросом.
--task 7
select SUBJECT,  NOTE from PROGRESS
where NOTE >=all (select NOTE from PROGRESS where IDSTUDENT between 1000 and 1008)

--Разработать SELECT-запрос, демонстри-рующий принцип применения ANY сов-местно с подзапросом.
--task 8
select SUBJECT,  NOTE from PROGRESS
where NOTE >=any (select NOTE from PROGRESS where IDSTUDENT between 1000 and 1008)

--Найти в таблице STUDENT студентов, у которых день рождения в один и тот же день. Объяснить решение.
--task 10*
select STUDENT.NAME,Day(BDAY)[dnyha], STUDENT.BDAY FROM STUDENT WHERE DAY(BDAY)
IN ( 
	SELECT DAY(BDAY) 
	FROM STUDENT  
	GROUP BY DAY(BDAY) 
	HAVING COUNT(DAY(BDAY)) > 1) 
group by Day(Bday),STUDENT.NAME,STUDENT.BDAY
order by 'dnyha' asc;