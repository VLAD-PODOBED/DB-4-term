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

CREATE TABLE Заказчики
(   Наименование_фирмы nvarchar(20) primary key,
	    Адрес nvarchar(50),
	    Телефон nvarchar(10),
		Контактное_лицо nvarchar(20),
)on FG1 ;

CREATE TABLE Товары
(       Наименование_товара nvarchar(20) primary key,
	    Цена money,
	    Описание text,
);

CREATE TABLE Заказы
(	    Номер_заказа int primary key,
	    Заказчик nvarchar(20) foreign key references Заказчики(Наименование_фирмы),
	    Заказанный_товар nvarchar(20) foreign key references Товары(Наименование_товара),
		Количество_заказанного_товара int,
		Дата_поставки date,
);

--task 3

ALTER TABLE Заказы ADD Вид_доставки nvarchar(10) default 'эконом' check (Вид_доставки in ('эконом','комфорт'));

ALTER TABLE Заказы DROP Column Дата_поставки;

--task 4 

INSERT into Заказчики(Наименование_фирмы, Адрес, Телефон, Контактное_лицо)
	Values ('kfc', 'kirova 2', '1285589', 'Контакт1'),
		   ('bk', 'sverdlova 15', '552563', 'Контакт2');
INSERT into Товары(Наименование_товара, Цена, Описание)
	values ('stol', 90, 'jobijtrijifjvcfrgk jhbdfue uvsdueyr3e evfg'),
			('stul', 12, 'lekjg ejfue xggw hu hyd ');
INSERT into Заказы (Номер_заказа, Заказчик, Заказанный_товар, Количество_заказанного_товара)
	values (1, 'kfc', 'stul', 20);

--task 5

select * from Заказчики;
select Адрес, Телефон from Заказчики;
select count(*) from Товары;
select Наименование_товара from Товары where Цена < 40;
select distinct top(1) *from Заказы;

update Товары set Цена = Цена+1 Where Наименование_товара = 'stol';
select Цена, Наименование_товара from  Товары where  Наименование_товара= 'stol';

select Наименование_товара From Товары where Наименование_товара like 's%'
select Цена, Наименование_товара from  Товары where Цена between 11 and 100;
select Цена, Наименование_товара from  Товары where Цена in (5, 94);
