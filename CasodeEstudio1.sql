CREATE DATABASE dannys_diner;
USE dannys_diner;

CREATE TABLE sales (
  customer_id VARCHAR(1),
  order_date DATE,
  product_id INT
);

INSERT INTO sales (customer_id, order_date, product_id) VALUES
  ('A', '2021-01-01', 1),
  ('A', '2021-01-01', 2),
  ('A', '2021-01-07', 2),
  ('A', '2021-01-10', 3),
  ('A', '2021-01-11', 3),
  ('A', '2021-01-11', 3),
  ('B', '2021-01-01', 2),
  ('B', '2021-01-02', 2),
  ('B', '2021-01-04', 1),
  ('B', '2021-01-11', 1),
  ('B', '2021-01-16', 3),
  ('B', '2021-02-01', 3),
  ('C', '2021-01-01', 3),
  ('C', '2021-01-01', 3),
  ('C', '2021-01-07', 3);

CREATE TABLE menu (
  product_id INT,
  product_name VARCHAR(10),
  price INT
);

INSERT INTO menu (product_id, product_name, price) VALUES
  (1, 'sushi', 10),
  (2, 'curry', 15),
  (3, 'ramen', 12);

CREATE TABLE members (
  customer_id VARCHAR(1),
  join_date DATE
);

INSERT INTO members (customer_id, join_date) VALUES
  ('A', '2021-01-07'),
  ('B', '2021-01-09');
  
#Ejercicio1
SELECT s.customer_id, SUM(m.price) AS total_gastado
FROM sales s
JOIN menu m ON s.product_id = m.product_id
GROUP BY s.customer_id;

#Ejercicio2
SELECT customer_id, COUNT(DISTINCT order_date) AS dias_visitados
FROM sales
GROUP BY customer_id;

#Ejercicio3
SELECT customer_id, product_name
FROM (
  SELECT s.customer_id, m.product_name, s.order_date,
         ROW_NUMBER() OVER (PARTITION BY s.customer_id ORDER BY s.order_date, s.product_id) AS rn
  FROM sales s
  JOIN menu m ON s.product_id = m.product_id
) AS ranked
WHERE rn = 1;
#Ejercicio 4 
SELECT m.product_name, COUNT(*) AS total_compras
FROM sales s
JOIN menu m ON s.product_id = m.product_id
GROUP BY m.product_name
ORDER BY total_compras DESC
LIMIT 1;

#Ejercicio 5 
SELECT customer_id, product_name
FROM (
  SELECT s.customer_id, m.product_name,
         COUNT(*) AS total,
         ROW_NUMBER() OVER (PARTITION BY s.customer_id ORDER BY COUNT(*) DESC, m.product_name) AS rn
  FROM sales s
  JOIN menu m ON s.product_id = m.product_id
  GROUP BY s.customer_id, m.product_name
) AS ranked
WHERE rn = 1;

#Ejercicio 6
SELECT customer_id, product_name
FROM (
  SELECT s.customer_id, m.product_name, s.order_date,
         ROW_NUMBER() OVER (PARTITION BY s.customer_id ORDER BY s.order_date, s.product_id) AS rn
  FROM sales s
  JOIN menu m ON s.product_id = m.product_id
  JOIN members mem ON s.customer_id = mem.customer_id
  WHERE s.order_date >= mem.join_date
) AS ranked
WHERE rn = 1;

#Ejercicio 7 
SELECT customer_id, product_name
FROM (
  SELECT s.customer_id, m.product_name, s.order_date,
         ROW_NUMBER() OVER (PARTITION BY s.customer_id ORDER BY s.order_date DESC) AS rn
  FROM sales s
  JOIN menu m ON s.product_id = m.product_id
  JOIN members mem ON s.customer_id = mem.customer_id
  WHERE s.order_date < mem.join_date
) AS ranked
WHERE rn = 1;

#Ejercicio 8 
SELECT s.customer_id, COUNT(*) AS total_items, SUM(m.price) AS total_gastado
FROM sales s
JOIN menu m ON s.product_id = m.product_id
JOIN members mem ON s.customer_id = mem.customer_id
WHERE s.order_date < mem.join_date
GROUP BY s.customer_id;

#Ejercicio 9
SELECT s.customer_id,
       SUM(
         CASE
           WHEN m.product_name = 'sushi' THEN m.price * 20
           ELSE m.price * 10
         END
       ) AS puntos
FROM sales s
JOIN menu m ON s.product_id = m.product_id
GROUP BY s.customer_id;

#Ejercicio 10 
SELECT s.customer_id,
       SUM(
         CASE
           WHEN s.order_date BETWEEN mem.join_date AND DATE_ADD(mem.join_date, INTERVAL 6 DAY) THEN m.price * 20
           WHEN m.product_name = 'sushi' THEN m.price * 20
           ELSE m.price * 10
         END
       ) AS puntos
FROM sales s
JOIN menu m ON s.product_id = m.product_id
JOIN members mem ON s.customer_id = mem.customer_id
WHERE s.customer_id IN ('A', 'B') AND s.order_date <= '2021-01-31'
GROUP BY s.customer_id;

#Ejercicio Adicional 1
SELECT s.customer_id, s.order_date, m.product_name, m.price, 
       IF(mem.customer_id IS NULL, 'NO', 'YES') AS member
FROM sales s
JOIN menu m ON s.product_id = m.product_id
LEFT JOIN members mem ON s.customer_id = mem.customer_id 
AND s.order_date >= mem.join_date
ORDER BY s.customer_id, s.order_date;
#Ejercicio Adicional 2 
SELECT s.customer_id, 
       s.order_date, 
       m.product_name, 
       m.price, 
       IF(mem.customer_id IS NULL, 'NO', 'YES') AS member,
       CASE 
           WHEN mem.customer_id IS NOT NULL THEN 
               RANK() OVER (PARTITION BY s.customer_id ORDER BY s.order_date) 
           ELSE NULL 
       END AS category
FROM sales s
JOIN menu m ON s.product_id = m.product_id
LEFT JOIN members mem ON s.customer_id = mem.customer_id
ORDER BY s.customer_id, s.order_date;








  
