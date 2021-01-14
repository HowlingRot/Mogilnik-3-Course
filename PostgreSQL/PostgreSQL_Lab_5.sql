--Михайлов Илья 31гр
--Лабораторная №5
--Секционирование таблиц.
--1.Для Вашей представленной базы данных выбрать 1 или несколько таблиц для секционирования. Обосновать выбор. Выбрать ключ и выполнить разделение на секции.

CREATE TABLE profiles(
user_id bigint REFERENCES users(id) NOT NULL,
name varchar(30) NOT NULL,
foto varchar(255) NOT NULL,
sex varchar(1) NOT NULL,
birth_day date NOT NULL,
dossier text NULL,
hobby varchar(30)[] NULL,
profession varchar,
PRIMARY KEY(user_id,profession)
)PARTITION BY LIST(profession);



CREATE TABLE profiles_designer PARTITION OF profiles
  FOR VALUES IN ('designer');

CREATE TABLE profiles_programmer PARTITION OF profiles
  FOR VALUES IN ('programmer');

CREATE TABLE profiles_screenwriter PARTITION OF profiles
  FOR VALUES IN ('screenwriter');
  
  CREATE TABLE profiles_editor PARTITION OF profiles
  FOR VALUES IN ('editor');

--2.Написать триггер, который будет вставлять новые записи в соответствующие секции. Продемонстрировать работу секционирования, используя генерацию тестовых данных.

CREATE FUNCTION insert_profiles() 
RETURNS TRIGGER AS $$
BEGIN
    IF (NEW.profession = 'designer') 
    THEN INSERT INTO profiles_designer SELECT NEW.*;
    ELSEIF (NEW.profession = 'programmer') 
    THEN INSERT INTO profiles_programmer SELECT NEW.*;
	ELSEIF (NEW.profession = 'screenwriter') 
    THEN INSERT INTO profiles_screenwriter SELECT NEW.*;
	ELSEIF (NEW.profession = 'editor') 
    THEN INSERT INTO profiles_editor SELECT NEW.*;
    END IF;
  RETURN NEW;
  END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trigger_user_films
  BEFORE INSERT ON profiles
  EXECUTE PROCEDURE insert_profiles();

--3.Написать несколько запросов SELECT для демонстрации выборки данных из Вашей секционированной таблицы.
SELECT * FROM profiles_designer;

SELECT * FROM profiles_programmer;

SELECT * FROM profiles_screenwriter;

SELECT * FROM profiles_editor;

