
-- Step 1: Database and Table Preparation

CREATE DATABASE lab_exp2;

\c lab_exp2;

DROP TABLE IF EXISTS customer_orders;

CREATE TABLE customer_orders (
    order_id      SERIAL PRIMARY KEY,
    customer_name VARCHAR(50) NOT NULL,
    product       VARCHAR(50) NOT NULL,
    quantity      INT NOT NULL,
    price         NUMERIC(10,2) NOT NULL,
    order_date    DATE NOT NULL
);

INSERT INTO customer_orders
(customer_name, product, quantity, price, order_date)
VALUES
('Amit',   'Laptop',      1, 55000, '2024-01-05'),
('Amit',   'Mouse',       2,   800, '2024-01-05'),
('Priya',  'Mobile',      1, 25000, '2024-01-10'),
('Rohit',  'Headphones',  1,  1500, '2024-01-12'),
('Neha',   'Laptop',      1, 60000, '2024-02-01'),
('Rohit',  'Mobile',      2, 24000, '2024-02-10'),
('Amit',   'Headphones',  1,  1200, '2024-02-15'),
('Priya',  'Laptop',      1, 52000, '2024-02-20');

-- Step 2: Filtering Data Using Conditions (WHERE)

-- price > 20000
SELECT *
FROM customer_orders
WHERE price > 20000;



-- Step 3: Sorting Query Results (ORDER BY)

SELECT order_id, customer_name, product, price
FROM customer_orders
ORDER BY price ASC;


-- Step 4: Grouping Data for Aggregation (GROUP BY)

SELECT product,
       SUM(quantity) AS total_quantity
FROM customer_orders
GROUP BY product;

  
-- Step 5: Applying Conditions on Aggregated Data (HAVING)

SELECT product,
       SUM(quantity * price) AS total_sales
FROM customer_orders
GROUP BY product
HAVING SUM(quantity * price) > 50000;


-- Step 6: Filtering vs Aggregation Conditions

SELECT product,
       SUM(quantity * price) AS feb_sales
FROM customer_orders
WHERE order_date >= '2024-02-01'
  AND order_date <= '2024-02-29'
GROUP BY product;

