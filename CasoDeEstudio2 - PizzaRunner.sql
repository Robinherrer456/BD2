DROP DATABASE IF EXISTS pizza_runner;

CREATE database pizza_runner;

USE pizza_runner;

DROP TABLE IF EXISTS runners;

CREATE TABLE runners (
  runner_id INTEGER PRIMARY KEY,
  registration_date DATE
);

INSERT INTO runners
  (runner_id, registration_date)
VALUES
  (1, '2021-01-01'),
  (2, '2021-01-03'),
  (3, '2021-01-08'),
  (4, '2021-01-15');

DROP TABLE IF EXISTS customer_orders;

CREATE TABLE customer_orders (
  order_id INTEGER,
  customer_id INTEGER,
  pizza_id INTEGER,
  exclusions VARCHAR(10),
  extras VARCHAR(10),
  order_time TIMESTAMP
);

INSERT INTO customer_orders
  (order_id, customer_id, pizza_id, exclusions, extras, order_time)
VALUES
  ('1', '101', '1', '', '', '2020-01-01 18:05:02'),
  ('2', '101', '1', '', '', '2020-01-01 19:00:52'),
  ('3', '102', '1', '', '', '2020-01-02 23:51:23'),
  ('3', '102', '2', '', NULL, '2020-01-02 23:51:23'),
  ('4', '103', '1', '4', '', '2020-01-04 13:23:46'),
  ('4', '103', '1', '4', '', '2020-01-04 13:23:46'),
  ('4', '103', '2', '4', '', '2020-01-04 13:23:46'),
  ('5', '104', '1', 'null', '1', '2020-01-08 21:00:29'),
  ('6', '101', '2', 'null', 'null', '2020-01-08 21:03:13'),
  ('7', '105', '2', 'null', '1', '2020-01-08 21:20:29'),
  ('8', '102', '1', 'null', 'null', '2020-01-09 23:54:33'),
  ('9', '103', '1', '4', '1, 5', '2020-01-10 11:22:59'),
  ('10', '104', '1', 'null', 'null', '2020-01-11 18:34:49'),
  ('10', '104', '1', '2, 6', '1, 4', '2020-01-11 18:34:49');


DROP TABLE IF EXISTS runner_orders;

CREATE TABLE runner_orders (
  order_id INTEGER PRIMARY KEY,
  runner_id INTEGER,
  pickup_time VARCHAR(19),
  distance VARCHAR(7),
  duration VARCHAR(10),
  cancellation VARCHAR(23)
);

INSERT INTO runner_orders
  (order_id, runner_id, pickup_time, distance, duration, cancellation)
VALUES
  ('1', '1', '2020-01-01 18:15:34', '20km', '32 minutes', ''),
  ('2', '1', '2020-01-01 19:10:54', '20km', '27 minutes', ''),
  ('3', '1', '2020-01-03 00:12:37', '13.4km', '20 mins', NULL),
  ('4', '2', '2020-01-04 13:53:03', '23.4', '40', NULL),
  ('5', '3', '2020-01-08 21:10:57', '10', '15', NULL),
  ('6', '3', 'null', 'null', 'null', 'Restaurant Cancellation'),
  ('7', '2', '2020-01-08 21:30:45', '25km', '25mins', 'null'),
  ('8', '2', '2020-01-10 00:15:02', '23.4 km', '15 minute', 'null'),
  ('9', '2', 'null', 'null', 'null', 'Customer Cancellation'),
  ('10', '1', '2020-01-11 18:50:20', '10km', '10minutes', 'null');

DROP TABLE IF EXISTS pizza_names;

CREATE TABLE pizza_names (
  pizza_id INTEGER PRIMARY KEY,
  pizza_name TEXT
);

INSERT INTO pizza_names
  (pizza_id, pizza_name)
VALUES
  ('1', 'Meatlovers'),
  ('2', 'Vegetarian');


DROP TABLE IF EXISTS pizza_recipes;
CREATE TABLE pizza_recipes (
  pizza_id INTEGER PRIMARY KEY,
  toppings TEXT
);
INSERT INTO pizza_recipes
  (pizza_id, toppings)
VALUES
  ('1', '1, 2, 3, 4, 5, 6, 8, 10'),
  ('2', '4, 6, 7, 9, 11, 12');


DROP TABLE IF EXISTS pizza_toppings;

CREATE TABLE pizza_toppings (
  topping_id INTEGER,
  topping_name TEXT
);

INSERT INTO pizza_toppings
  (topping_id, topping_name)
VALUES
  (1, 'Bacon'),
  (2, 'BBQ Sauce'),
  (3, 'Beef'),
  (4, 'Cheese'),
  (5, 'Chicken'),
  (6, 'Mushrooms'),
  (7, 'Onions'),
  (8, 'Pepperoni'),
  (9, 'Peppers'),
  (10, 'Salami'),
  (11, 'Tomatoes'),
  (12, 'Tomato Sauce');
  
 -- RELACIONES.
 
ALTER TABLE runner_orders                                
ADD FOREIGN KEY (runner_id) REFERENCES runners(runner_id);   
	
ALTER TABLE customer_orders
ADD FOREIGN KEY (order_id) REFERENCES runner_orders(order_id);

ALTER TABLE customer_orders
ADD FOREIGN KEY (pizza_id) REFERENCES pizza_names(pizza_id);

ALTER TABLE customer_orders
ADD FOREIGN KEY (pizza_id) REFERENCES pizza_recipes(pizza_id);

-- LIMPIEZA TABLA customer_orders

DROP TABLE IF EXISTS customer_orders_temp;

CREATE TEMPORARY TABLE customer_orders_temp AS
SELECT order_id,
       customer_id,
       pizza_id,
       CASE
           WHEN exclusions = '' THEN NULL
           WHEN exclusions = 'null' THEN NULL
           ELSE exclusions
       END AS exclusions,
       CASE
           WHEN extras = '' THEN NULL
           WHEN extras = 'null' THEN NULL
           ELSE extras
       END AS extras,
       CAST(order_time AS DATETIME)  AS order_time
FROM customer_orders;

-- LIMPIEZA TABLA runner_orders

DROP TABLE IF EXISTS runner_orders_temp;

CREATE TEMPORARY TABLE runner_orders_temp AS
	SELECT order_id,
		   runner_id,
		   CASE
			   WHEN pickup_time LIKE 'null' OR pickup_time IS NULL THEN NULL
			   ELSE CAST(STR_TO_DATE(pickup_time, '%Y-%m-%d %H:%i:%s') AS DATETIME )
		   END AS pickup_time,
		   CASE
			   WHEN distance LIKE 'null' THEN NULL	
			   ELSE CAST(regexp_replace(distance, '[a-z]+', '') AS FLOAT)
		   END AS distance,
		   CASE
			   WHEN duration LIKE 'null' THEN NULL
			   ELSE CAST(regexp_replace(duration, '[a-z]+', '') AS FLOAT)
		   END AS duration,
		   CASE
			   WHEN cancellation LIKE '' THEN NULL
			   WHEN cancellation LIKE 'null' THEN NULL
			   ELSE cancellation
		   END AS cancellation
	FROM runner_orders;


-- A. PIZZA METRICS
-- 1. Cuantas pizzas se pidieron?
SELECT COUNT(*) AS 'Total de pizzas ordenadas'
FROM customer_orders;

-- 2. Cuantos pedidos de clientes unicos se realizaron?
SELECT 
  COUNT(DISTINCT order_id) AS 'Pedidos unicos de clientes'
FROM customer_orders;

-- 3. Cuantos pedidos entregados con exito fueron realizados por cada runner?
SELECT 
  runner_id, 
  COUNT(order_id) AS 'Pedidos exitosos'
FROM runner_orders_temp
WHERE cancellation IS NULL
GROUP BY runner_id;

-- 4. Cuantas pizzas de cada tipo se entregaron?
SELECT 
  p.pizza_name, 
  COUNT(c.pizza_id) AS 'Pizzas entregadas'
FROM customer_orders AS c
JOIN runner_orders AS r
  ON c.order_id = r.order_id
JOIN pizza_names AS p
  ON c.pizza_id = p.pizza_id
WHERE r.distance != 0
GROUP BY p.pizza_name;

-- 5. Cuantas vegetarian y meatlover pidio cada cliente?
SELECT 
  c.customer_id, 
  p.pizza_name, 
  COUNT(p.pizza_name) AS order_count
FROM customer_orders AS c
JOIN pizza_names AS p
  ON c.pizza_id= p.pizza_id
GROUP BY c.customer_id, p.pizza_name
ORDER BY c.customer_id;

-- 6. Cual fue el numero maximo de pizzas entregadas en un solo pedido?
WITH pizza_count_cte AS
(
  SELECT 
    c.order_id, 
    COUNT(c.pizza_id) AS pizza_per_order
  FROM customer_orders AS c
  JOIN runner_orders AS r
    ON c.order_id = r.order_id
  WHERE r.distance != 0
  GROUP BY c.order_id
)

SELECT 
  MAX(pizza_per_order) AS pizza_count
FROM pizza_count_cte;

-- 7. cuántas pizzas entregadas tuvieron al menos 1 cambio 
-- y cuántas no tuvieron cambios?
SELECT
	cot.customer_id,
	SUM(CASE
			WHEN cot.exclusions IS NOT NULL OR cot.extras IS NOT NULL THEN 1
			ELSE 0
		END) AS 'Pizza has atleast 1 Change',
	SUM(CASE
			WHEN cot.exclusions IS NULL AND cot.extras IS NULL THEN 1
			ELSE 0
		END) AS 'Pizza NOT Changed'      
FROM customer_orders_temp As cot 
	INNER JOIN runner_orders_temp AS rot ON cot.order_id=rot.order_id
WHERE cancellation IS NULL
GROUP BY cot.customer_id
ORDER BY cot.customer_id;

-- 8. Cuantas pizzas se entregaron que tenian exclusiones y extras?
SELECT  
	cot.customer_id,
	SUM(CASE
			WHEN cot.exclusions IS NOT NULL AND cot.extras IS NOT NULL THEN 1
			ELSE 0
			END) AS 'Contador de pizza con cambios'
FROM customer_orders_temp As cot 
	INNER JOIN runner_orders_temp AS rot ON cot.order_id=rot.order_id
WHERE cancellation IS NULL
GROUP BY cot.customer_id
ORDER BY cot.customer_id;

-- 9. Cual fue el volumen total de pizzas pedidas durante cada hora del dia?
SELECT 
	HOUR(order_time) AS Hour_of_Day,
	COUNT(order_id) AS Volume_of_Pizza_ordered
FROM customer_orders_temp
GROUP BY Hour_of_Day
ORDER BY Hour_of_Day ;

-- 10. Cual fue el volumen de pedidos para cada dia de la semana?
SELECT 
	DAYNAME(order_time) AS Day_of_week,
	COUNT(order_id) AS Volume_of_Pizza_ordered
FROM customer_orders_temp
GROUP BY Day_of_week
ORDER BY Volume_of_Pizza_ordered DESC ;