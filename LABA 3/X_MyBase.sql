--task 1
USE master;
go 
CREATE database P_MyBase

on primary 
(
	name= N'MYBASE_mdf',
	filename = N'D:\sql\LABA 3\MYBASE_mdf.mdf',
	size= 10240Kb,
	maxsize = unlimited,
	filegrowth = 1024Kb
),

filegroup FG1
(
	name= N'MYBASE_fg1_1',
	filename = N'D:\sql\LABA 3\MYBASE_fgq-1.ndf',
	size= 10240Kb,
	maxsize = 1Gb,
	filegrowth = 25%
),

(
	name= N'MYBASE_fg1_2',
	filename = N'D:\sql\LABA 3\MYBASE_fqg-2.ndf',
	size= 10240Kb, maxsize = 1Gb,
	filegrowth = 25%
)
log on
(
	name= N'MYBASE_log',
	filename = N'D:\sql\LABA 3\MYBASE_log.ldf',
	size= 10240Kb,
	maxsize = 2048Gb,
	filegrowth =10%
)

go
--task 2

USE P_MyBase;

CREATE TABLE ���������
(   ������������_����� nvarchar(20) primary key,
	    ����� nvarchar(50),
	    ������� nvarchar(10),
		����������_���� nvarchar(20),
)on FG1 ;

CREATE TABLE ������
(       ������������_������ nvarchar(20) primary key,
	    ���� money,
	    �������� text,
);

CREATE TABLE ������
(	    �����_������ int primary key,
	    �������� nvarchar(20) foreign key references ���������(������������_�����),
	    ����������_����� nvarchar(20) foreign key references ������(������������_������),
		����������_�����������_������ int,
		����_�������� date,
);

--task 3

ALTER TABLE ������ ADD ���_�������� nvarchar(10) default '������' check (���_�������� in ('������','�������'));

ALTER TABLE ������ DROP Column ����_��������;

--task 4 

INSERT into ���������(������������_�����, �����, �������, ����������_����)
	Values ('kfc', 'kirova 2', '1285589', '�������1'),
		   ('bk', 'sverdlova 15', '552563', '�������2');
INSERT into ������(������������_������, ����, ��������)
	values ('stol', 90, 'jobijtrijifjvcfrgk jhbdfue uvsdueyr3e evfg'),
			('stul', 12, 'lekjg ejfue xggw hu hyd ');
INSERT into ������ (�����_������, ��������, ����������_�����, ����������_�����������_������)
	values (1, 'kfc', 'stul', 20);

--task 5

select * from ���������;
select �����, ������� from ���������;
select count(*) from ������;
select ������������_������ from ������ where ���� < 40;
select distinct top(1) *from ������;

update ������ set ���� = ����+1 Where ������������_������ = 'stol';
select ����, ������������_������ from  ������ where  ������������_������= 'stol';

select ������������_������ From ������ where ������������_������ like 's%'
select ����, ������������_������ from  ������ where ���� between 11 and 100;
select ����, ������������_������ from  ������ where ���� in (5, 94);
