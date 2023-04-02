﻿use UNIVER

--task 1
--На основе таблиц FACULTY, GROUPS, STUDENT и PROGRESS разработать SE-LECT-запрос, в котором выводятся специ-альность,
--дисциплины и средние оценки при сдаче экзаменов на факультете ТОВ. 
--Использовать группировку по полям FACULTY, PROFESSION, SUBJECT.
--Добавить в запрос конструкцию ROLLUP и проанализировать результат. 

SELECT GROUPS.FACULTY [FACULTY], GROUPS.PROFESSION [PROFESSION], PROGRESS.SUBJECT [PROGRESS],
round(avg(cast(PROGRESS.NOTE AS float(4))), 2) [AVG]
FROM GROUPS, STUDENT, PROFESSION, PROGRESS
WHERE GROUPS.FACULTY in ('ТОВ')
GROUP BY ROLLUP (GROUPS.FACULTY, GROUPS.PROFESSION,PROGRESS.SUBJECT);

--task 2
--Выполнить SELECT-запрос из п. 1 с ис-пользованием CUBE-группировки. 
--Проанализировать результат.

SELECT GROUPS.FACULTY [FACULTY], GROUPS.PROFESSION [PROFESSION], PROGRESS.SUBJECT [PROGRESS],
round(avg(cast(PROGRESS.NOTE AS float(4))), 2) [AVG]
FROM GROUPS, STUDENT, PROFESSION, PROGRESS
WHERE GROUPS.FACULTY in ('ТОВ')
GROUP BY CUBE (GROUPS.FACULTY, GROUPS.PROFESSION,PROGRESS.SUBJECT);

--task 3
--На основе таблиц GROUPS, STUDENT и PROGRESS разработать SELECT-запрос, в котором определяются результаты сдачи экзаменов.
--В запросе должны отражаться специаль-ности, дисциплины, средние оценки студен-тов на факультете ТОВ.
--Отдельно разработать запрос, в котором определяются результаты сдачи экзаменов на факультете ХТиТ.
--Объединить результаты двух запросов с использованием операторов UNION и UN-ION ALL. Объяснить результаты. 


SELECT	
GROUPS.PROFESSION [PROFESSION],
PROGRESS.SUBJECT [PROGRESS],
round(avg(cast(PROGRESS.NOTE AS float(4))), 2) [AVG]
FROM GROUPS, STUDENT, PROFESSION, PROGRESS
WHERE GROUPS.FACULTY in ('ТОВ')
GROUP BY GROUPS.FACULTY,
GROUPS.PROFESSION, 
PROGRESS.SUBJECT
UNION
SELECT	
GROUPS.PROFESSION [PROFESSION],
PROGRESS.SUBJECT [PROGRESS],
round(avg(cast(PROGRESS.NOTE AS float(4))), 2) [AVG]
FROM GROUPS, STUDENT, PROFESSION, PROGRESS
WHERE GROUPS.FACULTY in ('ХТиТ')
GROUP BY GROUPS.FACULTY,
GROUPS.PROFESSION, 
PROGRESS.SUBJECT
----------------------------------------------------------------
SELECT	
GROUPS.PROFESSION [PROFESSION],
PROGRESS.SUBJECT [PROGRESS],
round(avg(cast(PROGRESS.NOTE AS float(4))), 2) [AVG]
FROM GROUPS, STUDENT, PROFESSION, PROGRESS
WHERE GROUPS.FACULTY in ('ТОВ')
GROUP BY GROUPS.FACULTY,
GROUPS.PROFESSION, 
PROGRESS.SUBJECT
UNION all
SELECT	
GROUPS.PROFESSION [PROFESSION],
PROGRESS.SUBJECT [PROGRESS],
round(avg(cast(PROGRESS.NOTE AS float(4))), 2) [AVG]
FROM GROUPS, STUDENT, PROFESSION, PROGRESS
WHERE GROUPS.FACULTY in ('ХТиТ')
GROUP BY GROUPS.FACULTY,
GROUPS.PROFESSION, 
PROGRESS.SUBJECT

--task 4
--Получить пересечение двух множеств строк, созданных в результате выполнения запросов пункта 3. Объяснить результат.
--Использовать оператор INTERSECT.

SELECT	
GROUPS.PROFESSION [PROFESSION],
PROGRESS.SUBJECT [PROGRESS],
round(avg(cast(PROGRESS.NOTE AS float(4))), 2) [AVG]
FROM GROUPS, STUDENT, PROFESSION, PROGRESS
WHERE GROUPS.FACULTY in ('ТОВ')
GROUP BY GROUPS.FACULTY,
GROUPS.PROFESSION, 
PROGRESS.SUBJECT
INTERSECT
SELECT	
GROUPS.PROFESSION [PROFESSION],
PROGRESS.SUBJECT [PROGRESS],
round(avg(cast(PROGRESS.NOTE AS float(4))), 2) [AVG]
FROM GROUPS, STUDENT, PROFESSION, PROGRESS
WHERE GROUPS.FACULTY in ('ХТиТ')
GROUP BY GROUPS.FACULTY,
GROUPS.PROFESSION, 
PROGRESS.SUBJECT

--task 5
--Получить разницу между множеством строк, созданных в результате запросов пункта 3. Объяснить результат. 
--Использовать оператор EXCEPT.

SELECT	
GROUPS.PROFESSION [PROFESSION],
PROGRESS.SUBJECT [PROGRESS],
round(avg(cast(PROGRESS.NOTE AS float(4))), 2) [AVG]
FROM GROUPS, STUDENT, PROFESSION, PROGRESS
WHERE GROUPS.FACULTY in ('ТОВ')
GROUP BY GROUPS.FACULTY,
GROUPS.PROFESSION, 
PROGRESS.SUBJECT
EXCEPT
SELECT	
GROUPS.PROFESSION [PROFESSION],
PROGRESS.SUBJECT [PROGRESS],
round(avg(cast(PROGRESS.NOTE AS float(4))), 2) [AVG]
FROM GROUPS, STUDENT, PROFESSION, PROGRESS
WHERE GROUPS.FACULTY in ('ХТиТ')
GROUP BY GROUPS.FACULTY,
GROUPS.PROFESSION, 
PROGRESS.SUBJECT