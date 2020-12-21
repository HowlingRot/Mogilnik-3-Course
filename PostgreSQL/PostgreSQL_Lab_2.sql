--Михайлов Илья 31гр
--Лабораторная №2
--Выборка данных в PostgreSQL


--I.Создаём таблицы

--Оплата заказов
CREATE TABLE payments (
    id            bigint        PRIMARY KEY NOT NULL,
    name          varchar(255)  NOT NULL,
    description   text          NOT NULL
);

CREATE TABLE users (
    id            bigint        PRIMARY KEY NOT NULL,
    login         varchar(255)  NOT NULL,
    password      varchar(255)  NOT NULL
);

--Список заказов
CREATE TABLE orders (
    id              bigint      PRIMARY KEY NOT NULL,
    user_id         bigint      REFERENCES users(id) NOT NULL,
    status          varchar(1)  NOT NULL,
    price           money       NOT NULL,
    discount        money       NOT NULL,
    create_at       timestamp   DEFAULT NOW()
);

CREATE TABLE payments_orders (
    id              bigint      PRIMARY KEY NOT NULL,
    order_id        bigint      REFERENCES orders(id) NOT NULL,
    value           money       NOT NULL,
    payment_id      bigint      REFERENCES payments(id) NULL,
    from_account    boolean     NOT NULL,
    create_at       timestamp   DEFAULT NOW()
);

CREATE TABLE delivery (
    id            bigint        PRIMARY KEY NOT NULL,
    name          varchar(255)  NOT NULL,
    description   text          NULL,
    price         money         NOT NULL
);

CREATE TABLE delivery_orders (
    id              bigint NOT NULL PRIMARY KEY,
    order_id        bigint REFERENCES orders(id) NOT NULL,
    delivery_id     bigint REFERENCES delivery(id) NOT NULL,
    delivery_date   date
);

--Внутренний счёт в магазине
CREATE TABLE accounts (
    id              bigint      PRIMARY KEY NOT NULL,
    user_id         bigint      REFERENCES users(id) NOT NULL,
    value           money       NOT NULL,
    is_vip          boolean     NOT NULL
);

--Список покупателей
CREATE TABLE customers (
    id              bigint      PRIMARY KEY NOT NULL,
    user_id         bigint      REFERENCES users(id) NULL,
    create_at       timestamp   DEFAULT NOW()
);

CREATE TABLE categories (
    id              bigint        PRIMARY KEY NOT NULL,
    name            varchar(255)  NOT NULL
);

--Список товаров
CREATE TABLE products (
    id              bigint        PRIMARY KEY NOT NULL,
    name            varchar(255)  NOT NULL,
    price           money         NOT NULL,
    quantity        int           NOT NULL,
    discount        money         NOT NULL,
    category_id     bigint        REFERENCES categories(id) NOT NULL
);

--Записи о положенных в корзину товарах
CREATE TABLE basket (
    id              bigint      PRIMARY KEY NOT NULL,
    order_id        bigint      REFERENCES orders(id) NULL,
    customer_id     bigint      REFERENCES customers(id) NOT NULL,
    product_id      bigint      REFERENCES products(id) NOT NULL,
    price           money       NOT NULL,
    discount        money       NOT NULL,
    quantity        int         NOT NULL,
    create_at       timestamp   DEFAULT NOW()
);

--II.Заполняем таблицы

--payments
INSERT INTO payments VALUES(1,'25353','???');
INSERT INTO payments VALUES(2,'25356','???');
INSERT INTO payments VALUES(3,'25355','???');

--users
INSERT INTO users VALUES (1,'login1','pas1');
INSERT INTO users VALUES (2,'login2','pas2');
INSERT INTO users VALUES (3,'login3','pas3');

--orders
INSERT INTO orders VALUES (1,1,'N',2000,3);
INSERT INTO orders VALUES (2,1,'D',3000,3);
INSERT INTO orders VALUES (3,2,'P',4000,5);
INSERT INTO orders VALUES (4,3,'F',2000,1);
INSERT INTO orders VALUES (5,3,'C',1000,1);
INSERT INTO orders VALUES (6,1,'C',500,3);

--payments_orders
INSERT INTO payments_orders VALUES(1,1,3000,NULL,FALSE);
INSERT INTO payments_orders VALUES(2,3,3000,1,TRUE);
INSERT INTO payments_orders VALUES(3,3,1000,1,TRUE);
INSERT INTO payments_orders VALUES(4,4,1000,1,TRUE);
INSERT INTO payments_orders VALUES(5,5,900,1,TRUE);
INSERT INTO payments_orders VALUES(6,5,200,1,TRUE);


--delivery
INSERT INTO delivery VALUES(1,'Ваня','Ленивый',150);
INSERT INTO delivery VALUES(2,'Ян','Позитивный',180);
INSERT INTO delivery VALUES(3,'Виталя','Алкоголик',155);

--delivery_orders
INSERT INTO delivery_orders VALUES (1,1,1,'17.12.2020');
INSERT INTO delivery_orders VALUES (2,2,2,'18.12.2020');
INSERT INTO delivery_orders VALUES (3,4,2,'17.12.2020');
INSERT INTO delivery_orders VALUES (4,3,3,'23.12.2020');
INSERT INTO delivery_orders VALUES (5,5,3,'05.01.2021');
INSERT INTO delivery_orders VALUES (6,6,1,'30.12.2020');

--accounts
INSERT INTO accounts VALUES (5,1,15000,FALSE);
INSERT INTO accounts VALUES (6,2,12000,FALSE);
INSERT INTO accounts VALUES (7,3,30000,TRUE);

--customers
INSERT INTO customers VALUES(1,1);
INSERT INTO customers VALUES(2,2);
INSERT INTO customers VALUES(3,3);

--categories
INSERT INTO categories VALUES(1,'Овощи');
INSERT INTO categories VALUES(2,'Фрукты');
INSERT INTO categories VALUES(3,'Мемы');

--products
INSERT INTO products VALUES(1,'Огурцы',15,50,13,1);
INSERT INTO products VALUES(2,'Помидоры',15,50,13,1);
INSERT INTO products VALUES(3,'Бананы',15,50,13,1);
INSERT INTO products VALUES(4,'Яблоко',15,12,13,2);

--basket
INSERT INTO basket VALUES(1,1,1,1,1000,3,5);
INSERT INTO basket VALUES(2,2,1,1,1000,3,5);
INSERT INTO basket VALUES(3,3,1,1,1000,3,5);
INSERT INTO basket VALUES(4,4,1,1,1000,3,5);
INSERT INTO basket VALUES(5,5,1,1,1000,3,5);
INSERT INTO basket VALUES(6,6,1,1,1000,3,5);
INSERT INTO basket VALUES(7,NULL,1,4,1000,3,15);


--1. Вывести количество товаров для каждой категории.
SELECT products.category_id, COUNT(*)  
FROM products
GROUP BY products.category_id;
  
--2. Вывести список пользователей, которые не оплатили хотя бы 1 заказ полностью.
SELECT users.id, users.login
FROM users JOIN orders s ON users.id=s.user_id 
WHERE s.price > (SELECT SUM(payments_orders.value) 
FROM payments_orders JOIN orders ON payments_orders.order_id = orders.id
GROUP BY payments_orders.order_id
HAVING payments_orders.order_id = s.id)
GROUP BY users.id, users.login;

--3. Удалить товары, которые ни разу не были куплены (отсутствуют информация в таблице basket).
DELETE FROM products
WHERE products.id NOT IN (
    SELECT basket.product_id
    FROM basket);

--4. Вывести заказы, которые оплачены только частично.
SELECT s.id, s.price
FROM users JOIN orders s ON users.id=s.user_id 
WHERE s.price > (SELECT SUM(payments_orders.value) 
FROM payments_orders JOIN orders ON payments_orders.order_id = orders.id
GROUP BY payments_orders.order_id
HAVING payments_orders.order_id = s.id) AND (SELECT SUM(payments_orders.value) 
FROM payments_orders JOIN orders ON payments_orders.order_id = orders.id
GROUP BY payments_orders.order_id
HAVING payments_orders.order_id = s.id) > '0'
GROUP BY s.id, s.price;


--5. Вывести для каждого покупателя количество его заказов по статусам.
SELECT users.id,
  COUNT(orders.*) filter (WHERE orders.status = 'N') AS num_n,
  COUNT(orders.*) filter (WHERE orders.status = 'D') AS num_d,
  COUNT(orders.*) filter (WHERE orders.status = 'P') AS num_p,
  COUNT(orders.*) filter (WHERE orders.status = 'F') AS num_f,
  COUNT(orders.*) filter (WHERE orders.status = 'C') AS num_c
FROM users RIGHT JOIN orders ON orders.user_id = users.id
GROUP BY users.id;

--6. Вывести средний чек для выполненных заказов (status="F").
SELECT AVG(orders.price::numeric::float8) AS avgprice 
FROM orders
WHERE orders.status='F';

--7. Вывести топ-10 самых продаваемых товаров по суммарной прибыли (заказы для этих товаров должны быть полностью оплачены).
SELECT products.*, SUM(basket.price) AS b_num
FROM products
RIGHT JOIN basket ON basket.product_id = products.id,(
SELECT orders.id, orders.price, SUM(payments_orders.value) AS paid_num
FROM orders RIGHT JOIN payments_orders ON payments_orders.order_id = orders.id
GROUP BY orders.id, payments_orders.value) AS orders_num
WHERE orders_num.price <= orders_num.paid_num
GROUP BY products.id
ORDER BY b_num DESC LIMIT 10;

--8. Вывести список товаров, которые лежат пока только в корзине и не привязаны к заказу, и их количества не хватает на складе для продажи (считается, что товар списывается со склада только тогда, когда заказ будет доставлен).
SELECT products.*
FROM products 
RIGHT JOIN basket ON basket.product_id = products.id and basket.order_id IS NULL
GROUP BY products.id
HAVING SUM(basket.quantity)<SUM(products.quantity);

--9. Вывести список пользователей, которые "бросили" свои корзины (не оформили заказ) за последние 30 дней.
SELECT users.id, users.login
FROM users JOIN customers ON users.id = customers.user_id
JOIN basket ON customers.id = basket.customer_id
WHERE basket.order_id IS NULL AND basket.create_at >= (SELECT NOW()-INTERVAL '30' DAY)
ORDER BY users.id;

--10. Добавить скидку 10% на все товары, которые покупались (статус заказов "P" или "F") не более 10 раз.
UPDATE products 
SET discount=discount* 1.1 
WHERE products.id IN (
    SELECT basket.product_id
    FROM basket 
    RIGHT JOIN orders ON basket.order_id=orders.id
    WHERE orders.status SIMILAR TO 'P|F'
    GROUP BY basket.product_id
    HAVING COUNT(orders.*) <= 10);

--11. Вывести количество заказов оплаченных полностью с внутреннего счета.
SELECT COUNT(*) AS 'Количество_заказов' FROM orders
JOIN payments_orders ON orders.id=payments_orders.order_id
WHERE orders.status= 'P' AND payments_orders.payment_id IS NULL AND payments_orders.from_account IS TRUE
GROUP BY orders.id;

--12. Сделать скидку 50% (без доставки, только на товары) на новые заказы (статус "N") для VIP-пользователей.
UPDATE orders
SET discount = discount*1.5 
WHERE orders.user_id IN (
    SELECT users.id 
    FROM users
    RIGHT JOIN accounts ON accounts.user_id = users.id
    WHERE accounts.is_vip = true
    GROUP BY users.id)  
AND  orders.status = 'N';

--13. Вывести самую популярную доставку и самый популярный способ оплаты (результат из 2 записей)
SELECT best_delivery.*, best_payment.*
FROM(
    SELECT delivery.*, COUNT(delivery_orders.*) AS orders_num
    FROM delivery
    LEFT JOIN delivery_orders ON delivery_orders.delivery_id = delivery.id 
    GROUP BY delivery.id 
    ORDER BY orders_num DESC LIMIT 1
    ) AS best_delivery,
(
    SELECT payments.*, COUNT(payments_orders .*) AS orders_num 
    FROM payments 
    LEFT JOIN payments_orders ON payments_orders.payment_id = payments.id 
    GROUP BY payments.id 
    ORDER BY orders_num DESC LIMIT 1
    ) AS best_payment;

--14. Удалить пустые категории.
DELETE 
FROM categories
WHERE categories.id NOT IN (
    SELECT products.category_id 
    FROM products);

--15. Вывести список заказов, которые были оплачены полностью не более чем через час, с момента добавления первого товара в корзину.
SELECT orders.id
FROM orders
LEFT JOIN payments_orders ON payments_orders.order_id = orders.id
LEFT JOIN basket ON basket.order_id = orders.id
WHERE orders.price <= (SELECT SUM(payments_orders.value) FROM payments_orders WHERE payments_orders.order_id = orders.id)
AND (SELECT date_part('hour', (SELECT MAX(payments_orders.create_at)-MIN(basket.create_at) FROM payments_orders, basket))) <= 1;
GROUP BY orders.id;

--16. Вернуть все деньги пользователей на внутренний счет для заказов, которые были оплачены (как внутренним счетом, так и некоторым способом оплаты) и были отменены (status = "С").
WITH ReturnMyMoney (order_id,order_user_id,price,sum) AS  (
    SELECT orders.id , orders.user_id, orders.price, SUM(payments_orders.value)
    FROM orders 
    LEFT JOIN payments_orders ON payments_orders.order_id = orders.id 
    WHERE orders.status = 'C'
    GROUP BY orders.id
    HAVING orders.price<=SUM(payments_orders.value) 
  )
UPDATE accounts
SET value =  value + ReturnMyMoney.sum
FROM ReturnMyMoney 
WHERE accounts.user_id = ReturnMyMoney.order_user_id 
