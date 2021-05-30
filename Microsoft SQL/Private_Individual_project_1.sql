--Михайлов Илья 31гр
--Индивидуальный проект
--Вариант 19
--Банк

--I.Создаём БД

CREATE DATABASE Bank
ON PRIMARY (NAME=Bank,
FILENAME = 'D:\Work\DB\Bank.mdf',
Size=3Mb,
Maxsize=15Mb,
FileGrowth=1Mb)
Log On
(NAME=lTaxiStation,
FILENAME = 'D:\Work\DB\Bank.ldf',
Size=3Mb,
Maxsize=15Mb,
FileGrowth=1Mb)

USE Bank
EXEC sp_addtype postcode, 'char(6)',NULL
EXEC sp_addtype member_no, 'smallint'
EXEC sp_addtype Phonenumber, 'char(17)',NULL
EXEC sp_addtype shortstring, 'varchar(20)',NULL

--II.Создаём таблицы

--Сотрудник
CREATE TABLE Staff(
Staff_no  member_no    NOT NULL PRIMARY KEY,
F_Name    shortstring  NOT NULL,
L_Name    shortstring  NOT NULL,
Age       smallint     NOT NULL,
Phone_no  Phonenumber  NOT NULL,
Passport  shortstring  NOT NULL,
Position  shortstring  NOT NULL,
Score     money        NOT NULL,
);

--Вклад
CREATE TABLE Deposit(
Deposit_no  	member_no    NOT NULL PRIMARY KEY,
Name    		shortstring  NOT NULL,
Min_period		smallint     NOT NULL DEFAULT 90,--минимальный срок вклада
Min_sum		    money        NOT NULL,--Минимальная сумма вклада
Interest_rate	smallint     NOT NULL,--Процентная ставка
Currency_code 	shortstring  NOT NULL,--код валюты
);

--Вкладчик
CREATE TABLE Contributor(
Contributor_no  member_no   	NOT NULL PRIMARY KEY,
F_Name    		shortstring  	NOT NULL,
L_Name    		shortstring  	NOT NULL,
Adress			shortstring  	NOT NULL,
Phone_no  		Phonenumber  	NOT NULL,
Passport  		shortstring  	NOT NULL,
);

--Договор
CREATE TABLE Contract(
Contract_no            member_no    NOT NULL PRIMARY KEY,
Date_in                date         NOT NULL DEFAULT GETDATE(),
Date_out               date         NOT NULL,
Sum_in                 money        NOT NULL,--Сумма положенная на счёт
Sum_out                money        NOT NULL,--Сумма на счету сейчас
Deposit_no 			   member_no   	NOT NULL,
Contributor_no 		   member_no   	NOT NULL,
Staff_no 			   member_no   	NOT NULL,
CONSTRAINT FK_Contract_Staff FOREIGN KEY(Staff_no) REFERENCES Staff,
CONSTRAINT FK_Contract_Contributor FOREIGN KEY(Contributor_no) REFERENCES Contributor ,
CONSTRAINT FK_Contract_Deposit FOREIGN KEY(Deposit_no) REFERENCES Deposit,
);

--III.Заполняем таблицы

-- Таблица Staff
INSERT Staff VALUES(1,'Ефим','Ботвинов',20,'57-12-48','BM27493','Категория 1',15000); 
INSERT Staff VALUES(2,'Ян','Степанов',21,'62-08-19','BM27494','Категория 2',12000);
INSERT Staff VALUES(3,'Виталий','Бобоед',19,'26-32-48','BM27495','Категория 1',15000);
INSERT Staff VALUES(4,'Иван','Егоров',18,'21-72-25','BM27496','Категория 3',7000);

-- Таблица Deposit
INSERT Deposit VALUES(1,'Белорус А',120,500,10,'BYN'); 
INSERT Deposit VALUES(2,'Русский',95,300,5,'RUB');
INSERT INTO Deposit(Deposit_no, Name, Min_sum,Money_persent,Currency_code) VALUES(3,'Американец',200,3,'USD');
INSERT Deposit VALUES(4,'Белорус Б',360,700,8,'BYN');

-- Таблица Contributor
INSERT Contributor VALUES(1,'Илья','Михайлов','Московский пр-т','57-12-48','BM27493'); 
INSERT Contributor VALUES(2,'Анастасия','Паус','пр-т Победы','62-08-19','BM27494');
INSERT Contributor VALUES(3,'Юлия','Бразгун','Клиническая','26-32-48','BM27495');
INSERT Contributor VALUES(4,'Глеб','Белькевич','Московский пр-т','21-72-25','BM27496');

-- Таблица Contract
INSERT Contract VALUES(1,'12.07.2019','09.11.2019',600,720,1,1,1);
INSERT Contract VALUES(2,'12.12.2020','11.03.2021',400,490,2,2,2);
INSERT Contract VALUES(3,'10.8.2019','11.11.2019',210,260,3,3,3);
INSERT Contract VALUES(4,'12.07.2019','06.07.2020',360,400,4,4,4);
INSERT Contract VALUES(5,'12.07.2019','06.07.2020',360,400,3,4,2);
--IV.Запросы 

--Найти вкладчика, имеющего несколько вкладов.
SELECT Contributor.Contributor_no
FROM Contributor JOIN Contract ON Contributor.Contributor_no = Contract.Contributor_no
GROUP BY Contributor.Contributor_no
HAVING count(Contributor.Contributor_no) > 1

--Найти вкладчика, имеющего вклады во всех видах валюты.
SELECT Contributor.Contributor_no
FROM Contributor JOIN Contract ON Contributor.Contributor_no = Contract.Contributor_no JOIN Deposit ON Deposit.Deposit_no = Contract.Deposit_no
GROUP BY Contributor.Contributor_no
HAVING count(Deposit.Currency_code) = 3

--Вывести данные вкладчика, имеющего максимальный вклад в белорусских рублях.
SELECT TOP 1 Contributor.Contributor_no
FROM Contributor JOIN Contract ON Contributor.Contributor_no = Contract.Contributor_no JOIN Deposit ON Deposit.Deposit_no = Contract.Deposit_no
WHERE Deposit.Currency_code = 'BYN'
ORDER BY Contract.Sum_out ASC

--Какой из вкладов пользуется наибольшей популярностью.
SELECT TOP 1  Deposit.Name, count(Deposit.Name)
FROM Deposit JOIN Contract ON Deposit.Deposit_no = Contract.Deposit_no
GROUP BY Deposit.Name
ORDER BY Deposit.Name ASC

--Кто из сотрудников заключил максимальное число договоров.
SELECT TOP 1 Staff.Staff_no, count(Staff.Staff_no)
FROM Contract LEFT JOIN Staff ON Staff.Staff_no = Contract.Staff_no
GROUP BY Staff.Staff_no
ORDER BY count(Staff.Staff_no) DESC

--Вывести список вкладчиков, у которых срок вклада истекает завтра и суммы начислений, которые могут быть ими востребованы.
SELECT Contributor.Contributor_no, Contract.Sum_out
FROM Contributor JOIN Contract ON Contributor.Contributor_no = Contract.Contributor_no
WHERE Contract.Date_out = DATEADD(day, 1, GETDATE())

--Вывести список сотрудников, заключивших договоры на максимальную сумму за последний месяц. 
SELECT TOP 3 Staff.Staff_no, SUM(Contract.Sum_in)
FROM Staff JOIN Contract ON Staff.Staff_no = Contract.Staff_no
WHERE DATEDIFF(MONTH, Contract.Date_in, GETDATE()) < 1
GROUP BY Staff.Staff_no
ORDER BY SUM(Contract.Sum_in) DESC

--V.Создать представление, содержащее сведения обо всех сотрудниках банка и заключенных ими договорах за прошедший месяц.
CREATE VIEW bankInfo
AS
SELECT Contributor.Contributor_no, Contract.Contract_no
FROM Contributor JOIN Contract ON Contributor.Contributor_no = Contract.Contributor_no
WHERE DATEDIFF(MONTH, Contract.Date_in, GETDATE()) < 1

--VI.Создать хранимые процедуры.
--О текущей сумме вклада и сумме начисленного за месяц процента для заданного клиента.
CREATE PROCEDURE contractInfo
@Contract_no member_no
AS
BEGIN 
SELECT Contract.Sum_out, (Contract.Sum_in/100)*Deposit.Interest_rate
FROM Contract JOIN Deposit ON Deposit.Deposit_no = Contract.Deposit_no
WHERE Contract.Contract_no = @Contract_no
END;

--VII.Создать триггер для запрета выдачи денег клиенту, если остаток на счете оказывается меньше минимальной суммы вклада.
CREATE TRIGGER BanMoney
ON Contract
INSTEAD OF UPDATE
AS
IF ((SELECT INSERTED.Sum_out FROM INSERTED) < (SELECT Deposit.Min_sum FROM Deposit JOIN INSERTED ON Deposit.Deposit_no = INSERTED.Deposit_no))
	PRINT 'You cant withdraw money'
ELSE 
	UPDATE Contract
	SET  Sum_out = INSERTED.Sum_out
	FROM Contract JOIN INSERTED ON Contract.Contract_no = INSERTED.Contract_no
	WHERE Contract.Contract_no = INSERTED.Contract_no
