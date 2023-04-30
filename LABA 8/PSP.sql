use UNIVER;
--task 1
--����������� ������������� � ������ �������-������. ������������� ������ ���� ��������� �� ������ SELECT-������� � ������� TEACHER �
--��������� ��������� �������: ���, ��� �������������, ���, ��� �������. 
go
CREATE or alter VIEW [�������������]
AS
select TEACHER [���], 
TEACHER_NAME [��� �������������],
GENDER [���],
PULPIT [��� �������]
FROM TEACHER;
go
select *from [�������������]
insert [�������������] values ('csdds','vlad','�','��')
select *from TEACHER

drop view [�������������]

--task 2
--����������� � ������� ������������� � ������ ���������� ������. 
--������������� ������ ���� ��������� �� ������ SELECT-������� � �������� FACULTY � PULPIT.
--������������� ������ ��������� ������-��� �������: ���������, ���������� ������ (����������� �� ������ ����� ������� PULPIT).
go
create or alter view [���������� ������]
as select FACULTY.FACULTY_NAME [���������], 
count(PULPIT.FACULTY)	[���������� ������]
from FACULTY inner join PULPIT
on PULPIT.FACULTY=FACULTY.FACULTY
group by FACULTY.FACULTY_NAME 
go
select * from [���������� ������]
drop view [���������� ������]

--task 3
--����������� � ������� ������������� � ������ ���������. ������������� ������ ���� 
--��-������� �� ������ ������� AUDITORIUM � ��������� �������: ���, ������������ ����-�����. 
--������������� ������ ���������� ������ ���������� ��������� (� ������� AUDITO-RIUM_ TYPE ������, ������������ � �����-�� ��) 
--� ��������� ���������� ��������� IN-SERT, UPDATE � DELETE.
go
create view [���������]
  as select AUDITORIUM.AUDITORIUM [���],
        AUDITORIUM.AUDITORIUM_NAME [������������ ���������]
      from AUDITORIUM
      where AUDITORIUM.AUDITORIUM_TYPE like '��%';
go
      select * from [���������];
	  go
alter view [���������]
  as select AUDITORIUM.AUDITORIUM [���],
        AUDITORIUM.AUDITORIUM_NAME [������������ ���������],
        AUDITORIUM.AUDITORIUM_TYPE [��� ���������]
      from AUDITORIUM
      where AUDITORIUM.AUDITORIUM_TYPE like '��%';
go
select * from [���������];
drop view [���������];
 --task 4 --
--����������� � ������� ������������� � ������ ����������_���������. 
--������������� ������ ���� ��������� �� ������ SELECT-������� � ������� AUDITO-RIUM � ��������� ��������� �������: ���, ������������ ���������. 
--������������� ������ ���������� ������ ���������� ��������� (� ������� AUDITO-RIUM_TYPE ������, ������������ � �����-��� ��). 
go
create or alter view [���������� ���������]
  as select AUDITORIUM.AUDITORIUM [���],
        AUDITORIUM.AUDITORIUM_NAME [������������ ���������]
      from AUDITORIUM
      where AUDITORIUM.AUDITORIUM_TYPE like '��%' WITH CHECK OPTION;
go
select * from [���������� ���������]
--insert [���������� ���������] values ('333-1', '333-1');
drop view [���������� ���������];
					

--task 5
--����������� ������������� � ������ �����-�����. ������������� ������ ���� ��������� �� ������ SELECT-������� � ������� SUB-JECT, 
--���������� ��� ���������� � �������-��� ������� � ��������� ��������� �������: ���, ������������ ���������� � ��� ��-�����. 
--������������ TOP � ORDER BY.
go
create or alter view [����������]
as select top 150 SUBJECT [���],
SUBJECT_NAME [������������],
PULPIT [��� �������]
from SUBJECT
order by ������������
go
select * from [����������]
drop view [����������];

--task 6 --
--�������� ������������� ����������_������, ��������� � ������� 2 ���, ����� ��� ���� ��������� � ������� ��������.
--������������������ �������� ����������-��� ������������� � ������� ��������. 
--������������ ����� SCHEMABINDING
go
create or alter view [���������� ������] with schemabinding
as select FACULTY.FACULTY_NAME [���������], 
count(PULPIT.FACULTY)	[���������� ������]
from dbo.FACULTY inner join dbo.PULPIT
on PULPIT.FACULTY=FACULTY.FACULTY
group by FACULTY.FACULTY_NAME 
go
select * from [���������� ������];
drop view [���������� ������];
