use UNIVER
--����� ������,��� ���� ������� ����� ������� ������ ��������������� ������ ������ �� �������
--1 ����������� ��������, ����������� ������ ��������� �� ������� ����. � ����� ������ 
--���� �������� ������� �������� ��������� �� ������� SUBJECT � ���� ������ ����� �������. 
--���� 1 ������ �� ������� ������ � ���������� ��������� �� ��������� �����
DECLARE @nm char(20), @t char (300)='';
  Declare NQSame CURSOR
	for SELECT SUBJECT from SUBJECT 
where PULPIT like '����';
	OPEN NQSame ;
FETCH NQSame into @nm;
	print'��������';
	while @@FETCH_STATUS=0
begin
	set @t=RTRIM(@nm)+','+@t;
	fetch NQSame into @nm;
end;
	print @t;
		CLOSE NQSame;
--2 ����������� ��������, ������������-��� ������� ����������� ������� �� ���������� �� ������� ���� ������ UNIVER.  -----
--����� ������ � ������ ������ ��� � ���, ����� ��� ��� �����, ������������� ����� ����� ���������� ������ ������.                          

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
  --3 ����������� ��������, ������������-��� ������� ����������� �������� �������� ������������ ������� �������� 
  --� �������� ��������������� ������ �� ��������� ������� 
  --�� ������������ �� ������� ���� ������ UNIVER.
  DECLARE @facult varchar(50), @profession varchar(50), @year int;  
DECLARE Groups_cur CURSOR LOCAL STATIC                              
						for SELECT FACULTY, PROFESSION, YEAR_FIRST FROM GROUPS where Faculty = '���';				   
	open Groups_cur;
	print  '���������� ����� : ' + cast(@@CURSOR_ROWS as varchar(5)); 
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
						for SELECT FACULTY, PROFESSION, YEAR_FIRST FROM GROUPS where Faculty = '���';				   
	open Groups_cur;
	print  '���������� ����� : ' + cast(@@CURSOR_ROWS as varchar(5)); 
    UPDATE GROUPS set YEAR_FIRST = 2012 where PROFESSION = '1-36 07 01';
	DELETE GROUPS where IDGROUP = 1;
	
	FETCH  Groups_cur into @facult1, @profession1, @year1;     
	while @@fetch_status = 0                                 
      begin 
          print @facult1 + ' '+ @profession1 + ' '+ convert(varchar(4),@year1);      
          fetch Groups_cur into @facult1, @profession1, @year1; 
       end;          
   CLOSE Groups_cur;

  --4 ����������� ��������, ������������-��� �������� ��������� � ����������-���� ������ ������� � ��������� SCROLL �� ������� ���� ������ UNIVER.
DECLARE  @tc int, @rn char(50);  
DECLARE Primer1 cursor local dynamic SCROLL                               
for SELECT row_number() over (order by SUBJECT) S,
SUBJECT FROM dbo.SUBJECT  where PULPIT = '����' 
	OPEN Primer1;
	FETCH  Primer1 into  @tc, @rn;                 
	print '��������� ������: ' + cast(@tc as varchar(3))+ rtrim(@rn);      
	FETCH  LAST from  Primer1 into @tc, @rn;       
	print '��������� ������: ' +  cast(@tc as varchar(3))+ rtrim(@rn);      
	FETCH  NEXT from  Primer1 into @tc, @rn;       
	print '��������� ������ �� �������: ' +  cast(@tc as varchar(3))+ rtrim(@rn); 
   	FETCH  PRIOR from  Primer1 into @tc, @rn;       
	print '���������� ������ �� �������: ' +  cast(@tc as varchar(3))+ rtrim(@rn); 
	FETCH  ABSOLUTE 3 from  Primer1 into @tc, @rn;       
	print '������ �� ������: ' +  cast(@tc as varchar(3))+ rtrim(@rn); 	
	FETCH  ABSOLUTE -3 from  Primer1 into @tc, @rn;       
	print '������ �� �����: ' +  cast(@tc as varchar(3))+ rtrim(@rn); 	
	FETCH  RELATIVE 4 from  Primer1 into @tc, @rn;       
	print '������ ������ �� �������: ' +  cast(@tc as varchar(3))+ rtrim(@rn); 	
	FETCH  RELATIVE -4 from  Primer1 into @tc, @rn;       
	print '������ ����� �� �������: ' +  cast(@tc as varchar(3))+ rtrim(@rn); 	
	CLOSE Primer1;
--5 ������� ������, ��������������� ���������� ����������� CURRENT OF � ������ WHERE � �������������� ���������� UPDATE � DELETE.
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

--6 ����������� SELECT-������, � ����-��� �������� �� ������� PROGRESS ��������� ������, ���������� ��-�������� � 
--���������, ���������� ������ ���� 4 (������������ ������-����� ������ PROGRESS, STUDENT, GROUPS). 
--����������� SELECT-������, � ��-����� �������� � ������� PROGRESS ��� �������� � ���������� ������� IDSTUDENT �������������� ������ (������������� �� �������).
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
    print concat('������� ', @name ,  ' �������� �� ������ ', @mark);
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