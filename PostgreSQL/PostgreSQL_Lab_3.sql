--Михайлов Илья 31гр
--Лабораторная №3
--Расширенные возможности PostgreSQL

--Запросы
--1.Написать представление, которое будет выводить список пользователей и их средний чек для выполненных заказов(login пользователя, средний чек).
CREATE VIEW avg_check
AS
SELECT users.login, AVG(orders.price::numeric::float)
FROM users JOIN orders ON orders.user_id = users.id
WHERE orders.status = 'P'
GROUP BY users.login, orders.price;

--2.Написать пользовательскую функцию, которая будет списывать сумму с вашего счета, если это возможно (входные параметры - login пользователя, сумма, возвращаемое значение - остаток на счете).
CREATE FUNCTION StealMoney
(varchar(255), money) RETURNS void
AS $$
UPDATE accounts
SET value = value - $2
FROM users
WHERE accounts.user_id = users.id AND users.login = $1 AND accounts.value >= $2;
$$LANGUAGE SQL;

--Проверка
SELECT StealMoney('login1'::varchar(255), 3000::money);

--3.Написать хранимую процедуру, которая будет рассчитывать сумму заказа пользователя и скидку на заказ, исходя из стоимости доставки (если таковая имеется) и стоимости товаров в корзине.
CREATE FUNCTION OrderCalculation (bigint) RETURNS VOID AS $$
DECLARE
order_price money;

BEGIN
SELECT ((SUM(basket.price) + SUM(delivery.price))::numeric::float * ((avg(s.discount::numeric::float))/100))::numeric::money into order_price
FROM orders s
LEFT JOIN basket on basket.order_id = s.id
LEFT JOIN delivery_orders on delivery_orders.order_id = s.id
LEFT JOIN delivery on delivery_orders.delivery_id = delivery.id
WHERE s.id = $1;

UPDATE orders s
SET price = order_price
FROM orders
WHERE s.id = $1;
END;
$$ language plpgsql;

--Проверка
SELECT OrderCalculation(1);

--4.Написать триггер, который будет пересчитывать сумму заказа пользователя и скидку на заказ, при изменении корзины товаров в заказе.
CREATE OR REPLACE FUNCTION update_trigger() RETURNS trigger AS $$ 
BEGIN
  PERFORM  OrderCalculation(NEW.order_id);
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;


CREATE TRIGGER trigger_basket_update
AFTER INSERT OR UPDATE OF price ON basket FOR EACH row
EXECUTE PROCEDURE update_trigger();

--Проверка
INSERT INTO basket VALUES(8,1,1,1,1000,3,5);

--5.Написать триггер, который будет устанавливать статус заказа "Оплачен", если заказ полностью оплачен, и списывать с остатков на складе то количество товара, которое было в заказе.
CREATE OR REPLACE FUNCTION update_orders() RETURNS trigger AS $$ 
declare 
is_paid boolean;
BEGIN
SELECT (orderz.price <= sum(payment_order.value)) INTO is_paid
FROM orders orderz RIGHT JOIN payments_orders payment_order ON payment_order.order_id = orderz.id
WHERE orderz.id = NEW.order_id
GROUP BY orderz.id;

IF is_paid THEN
UPDATE orders
SET status = 'P'
WHERE orders.id = NEW.order_id;

UPDATE products
SET quantity = products.quantity - basket.quantity
FROM basket
WHERE basket.order_id = NEW.order_id AND basket.product_id = products.id;
      
END IF;
return NEW;
END;
$$ LANGUAGE plpgsql;

--Проверка
INSERT INTO payments_orders VALUES(7,6,700,1,TRUE);

CREATE TRIGGER trigger_order_update
AFTER INSERT OR UPDATE on payments_orders 
for each row
EXECUTE PROCEDURE update_orders();

--6.Написать запрос, используя оконную функцию, который для заданного пользователя (login) будет выводить прогресс по сумме его выполненных заказов 
--(каждая строка должна содержать 3 столбца: login пользователя, сумму заказа и сумму заказов начиная с первого до текущего (прогрессирующая сумма)).

SELECT
  users.login AS login,
  orders.price AS price,
  SUM(orders.price) OVER (
PARTITION BY users.login ORDER BY orders.create_at ASC
  ) AS sum
FROM  orders 
  LEFT JOIN users ON orders.user_id = users.id
ORDER BY users.login ASC;
