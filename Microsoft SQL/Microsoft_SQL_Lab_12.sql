--Михайлов Илья 31гр
--Лабораторная №12
--Создайте триггеры.

USE DreamHome;

--1.Для удаления из таблиц PROPERTY и VIEWING объекта собственности, по которому заключается контракт. Выполнить удаление данных о владельце этого объекта, если у него нет других объектов. 
--Проверьте работоспособность триггера.

CREATE TRIGGER dieContract
ON CONTRACT
AFTER INSERT
AS
BEGIN
DELETE FROM PROPERTY 
WHERE PROPERTY.Property_no = (SELECT Property_no FROM INSERTED)

DELETE FROM VIEWING 
WHERE (SELECT Property_no FROM INSERTED) = VIEWING.Property_no
END

--2.Для вывода сообщения о превышении количества объектов собственности, закрепленных за сотрудником, при вводе нового объекта в таблицу PROPERTY(количество объектов не должно быть больше трех).
--Проверьте работоспособность триггера.

CREATE TRIGGER AlertStaff
ON PROPERTY
AFTER INSERT
AS
BEGIN
IF (SELECT count(PROPERTY.Staff_no) FROM PROPERTY WHERE PROPERTY.Staff_no = (SELECT Staff_no FROM INSERTED)) > 3
RAISERROR('Превышение количества объектов собственности, закрепленных за сотрудником',16,1) WITH NOWAIT;
END