--Михайлов Илья 31гр
--Лабораторная №4
--Индексы.План запроса.
--1.Для Вашей представленной базы данных сгенерировать тестовые данные.



--users
INSERT INTO users(id,login,password,email,role_id)
SELECT 
seq AS id,
'user_' || seq  AS login, 
'pass_' || seq  AS password, 
'email_' || seq || '@' || (
    CASE (RANDOM() * 2)::INT
      WHEN 0 THEN 'gmail'
      WHEN 1 THEN 'hotmail'
      WHEN 2 THEN 'yahoo'
    END
  ) || '.com' AS email,
(
    CASE (RANDOM() * 2)::INT
      WHEN 0 THEN 1
      WHEN 1 THEN 2
      WHEN 2 THEN 3
    END
  ) AS role_id
FROM GENERATE_SERIES(6, 100) seq;



--profiles
INSERT INTO profiles(user_id,name,foto,sex,birth_day,dossier,profession)
SELECT
seq AS user_id,
'name_' || seq AS name,
'foto_' || seq AS foto,
(
CASE (RANDOM() * 1)::INT
WHEN 0 THEN 'М'
WHEN 1 THEN 'Ж'
END
) AS sex,
now() - INTERVAL '1 day' * round(random() * 100) AS birth_day,
'dossier_' || seq AS dossier,
(
    CASE (RANDOM() * 3)::INT
      WHEN 0 THEN 'designer'
      WHEN 1 THEN 'programmer'
    WHEN 2 THEN 'screenwriter'
    WHEN 3 THEN 'editor'
  END
  ) AS profession
FROM GENERATE_SERIES(6, 100) seq;



--advertisements
INSERT INTO advertisements(id,preview,atext,creator_id)
SELECT 
seq AS id,
'foto_' || seq  AS preview, 
'atext_' || seq  AS atext, 
seq AS creator_id
FROM GENERATE_SERIES(6, 100) seq;



--messages
INSERT INTO messages(id,mtext,sender_id,receiver_id)
SELECT 
seq AS id,
'mtext_' || seq  AS atext, 
seq AS sender_id,
seqq AS receiver_id
FROM GENERATE_SERIES(6, 51) seq, GENERATE_SERIES(100, 54,-1) seqq;




--2.Разработать запрос, который будет делать выборку по крайней мере из 3 связных таблиц, использовать фильтрацию, сортировку и вывод конкретного диапазона записей (WHERE, ORDER BY, LIMIT). 
--Запрос должен выполняться несколько секунд (для этого можно увеличить количество тестовых данных или сложность запроса).
SELECT *
FROM users JOIN roles ON roles.id = users.role_id
LEFT JOIN profiles ON profiles.user_id = users.id
WHERE roles.position = 'user' AND profiles.birth_day > '25.04.2010'
ORDER BY users.id DESC LIMIT 10;

--3.Вывести план запроса и объяснить последовательность действий при его выполнении.
EXPLAIN (analyse) SELECT *
FROM users JOIN roles ON roles.id = users.role_id
JOIN profiles ON profiles.user_id = users.id
WHERE roles.position = 'user' AND profiles.birth_day > '25.04.2010'
ORDER BY users.id DESC LIMIT 10;


--4.Добавить необходимые индексы к Вашему запросу, чтобы скорость запроса была увеличена в несколько раз (возможно предложить его оптимизацию). 
--Вывести план запроса и объяснить, за счет чего была получена прибавка в скорости выполнения запроса.

CREATE INDEX mdeIndex ON profiles(birth_day)

EXPLAIN (analyse) SELECT *
FROM users JOIN roles ON roles.id = users.role_id
JOIN profiles ON profiles.user_id = users.id
WHERE roles.position = 'user' AND profiles.birth_day > '25.04.2010'
ORDER BY users.id DESC LIMIT 10;