--Михайлов Илья 31гр
--Лабораторная №11
--Создайте триггеры.

USE DreamHome;

--1.Для удаления из таблиц PROPERTY  и VIEWING объекта недвижимости, по которому заключается контракт.
--(Предварительно удалить связь с таблицей CONTRACT)Вывести сообщение о том, что сотрудник, отвечавший за объект, совершил сделку, повысить ему заработную плату на 5%.
--Проверьте работоспособность триггера.

CREATE TRIGGER dieProperty
ON CONTRACT
AFTER INSERT
AS
BEGIN

DELETE FROM PROPERTY 
WHERE PROPERTY.Property_no = (SELECT Property_no FROM INSERTED)

DELETE FROM VIEWING 
WHERE (SELECT Property_no FROM INSERTED) = VIEWING.Property_no

SELECT STAFF.Staff_no
FROM STAFF 
WHERE STAFF.Staff_no = (SELECT Staff_no FROM PROPERTY WHERE PROPERTY.Property_no = (SELECT Property_no FROM INSERTED))

UPDATE STAFF
SET Salary = Salary + Salary*0.05
FROM STAFF 
WHERE STAFF.Staff_no = (SELECT Staff_no FROM PROPERTY WHERE PROPERTY.Property_no = (SELECT Property_no FROM INSERTED))
END

--2.Для вывода сообщения о превышении количества объектов собственности, закрепленных за сотрудником, при вводе нового объекта в таблицу PROPERTY 
--(количество объектов не должно быть больше трех).
--Проверьте работоспособность триггера.

CREATE TRIGGER AlertStaff
ON PROPERTY
AFTER INSERT
AS
BEGIN
IF (SELECT count(PROPERTY.Staff_no) FROM PROPERTY WHERE PROPERTY.Staff_no = (SELECT Staff_no FROM INSERTED)) > 3
RAISERROR('Превышение количества объектов собственности, закрепленных за сотрудником',16,1) WITH NOWAIT;
END

--3.Для снижения заработной платы сотрудника на 5%, если квартира, за которую он овечает осматривается в третий раз,  
--в поле Comments таблицы VIEWING вводится значение ”не согласен” и если его зарплата превышает среднюю заработную плату отделения в котором он работает.
--Проверьте работоспособность триггера.

CREATE TRIGGER cheakProperty
ON VIEWING
AFTER INSERT
AS
BEGIN
DECLARE @Property_no varchar(20)	
SET @Property_no=Property_no FROM INSERTED
IF EXISTS (
	SELECT PROPERTY.Property_no,VIEWING.Property_no 
	FROM PROPERTY 
	JOIN VIEWING ON PROPERTY.Property_no = VIEWING.Property_no 
	WHERE PROPERTY.Property_no=@Property_no AND VIEWING.Comments = 'Не согласен'
	GROUP BY PROPERTY.Property_no, VIEWING.Property_no
	HAVING count(VIEWING.Property_no)>=3
	)
IF EXISTS(
	SELECT STAFF.Staff_no, Property_no FROM PROPERTY
	LEFT JOIN STAFF ON PROPERTY.Staff_no=STAFF.Staff_no
	JOIN BRANCH as KKKK ON KKKK.Branch_no=STAFF.Branch_no
	WHERE @Property_no=PROPERTY.Property_no AND Salary
	>
	(SELECT AVG(Salary) 
	FROM BRANCH 
	JOIN STAFF ON BRANCH.Branch_no=STAFF.Branch_no
	WHERE BRANCH.Branch_no=KKKK.Branch_no
	GROUP BY BRANCH.Branch_no)
	)
	UPDATE STAFF 
	SET Salary=Salary-Salary*0.05
	WHERE @Property_no IN (SELECT PROPERTY.Property_no FROM PROPERTY WHERE STAFF.Staff_no=PROPERTY.Staff_no)
END

--4.Создать триггер, который при занесении данных в таблицу OWNER проверяет, 
--есть ли у этого владельца объекты проданные ранее (содержатся в таблице CONTRACT) и выводит сообщение, о дате заключения предыдущей сделки для этого владельца.  
--Проверьте работоспособность триггера.

CREATE TRIGGER insertOwner
AFTER INSERT
AS
BEGIN
DECLARE @Owner_no smallint
SET @Owner_no=Owner_no FROM INSERTED
IF EXISTS (
	SELECT * 
	FROM PROPERTY
	WHERE Owner_no=@Owner_no AND Property_no IN (SELECT Property_no FROM CONTRACT)
	)	
		SELECT Date_Contract 
		FROM CONTRACT LEFT JOIN PROPERTY ON PROPERTY.Property_no = CONTRACT.Property_no JOIN OWNER ON OWNER.Owner_no=PROPERTY.Owner_no
		WHERE OWNER.Owner_no=@Owner_no
		ORDER BY Date_Contract
END

--5.Для удаления данных о владельце недвижимости из таблицы OWNER, при продаже принадлежащего ему объекта недвижимости в том случае, если у него нет других объектов. 
--Проверьте работоспособность триггера.

CREATE TRIGGER deleteOwner
ON PROPERTY
AFTER DELETE
AS
BEGIN
IF (SELECT count(PROPERTY.Owner_no) FROM PROPERTY WHERE PROPERTY.Owner_no = (SELECT Owner_no FROM INSERTED)) = 0
	DELETE FROM OWNER 
	WHERE (SELECT Owner_no FROM INSERTED) = OWNER.Owner_no
END