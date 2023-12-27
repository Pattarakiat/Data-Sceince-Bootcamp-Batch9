-- Create the customers table
CREATE TABLE customers (
  customer_id INT,
  customer_name VARCHAR(255),
  customer_address VARCHAR(255),
  customer_phone_number VARCHAR(255),
  customer_email VARCHAR(255),
  PRIMARY KEY (customer_id)
);
-- Insert data into customers table
INSERT INTO customers VALUES
  (1, 'John Doe', '123 Main St', '+47 22 44 22 22', 'oqibz@gmail.com'),
  (2, 'Jane Smith', '456 Elm St', '+43 01 5134505', 'tugrp@gmail.com'),
  (3, 'Bob Johnson', '789 Oak St', '+1 (650) 253-0000', 'xcvkp@gmail.com'),
  (4, 'Camille	Bernard', '4, Rue Milton', '+33 01 49 70 65 65', 'camille.bernard@yahoo.com'),
  (5, 'Puja	Srivastava', '3,Raj Bhavan Road', '+91 080 22289999', 'puja_srivastava@yahoo.com'),
  (6, 'Mark	Philips', '8210 111 ST NW', '+1 (780) 434-4554', 'mphilips12@shaw.com'),
  (7, 'Jennifer	Peterson', '700 W Pender Street', '+1 (604) 688-2255', 'jenniferp@rogers.com'),
  (8, 'Jack	Smith', '1 Microsoft Way', '+1 (425) 882-8080', 'jacksmith@microsoft.com'),
  (9, 'Frank	Ralston', '162 E Superior Street', '+1 (312) 332-3232', 'fralston@gmail.com'),
  (10, 'Robert	Brown', '796 Dundas Street West', '+1 (416) 363-8888', 'robbrown@outlook.com');
  
-- Create the orders table
CREATE TABLE orders (
  order_id INT,
  customer_id INT,
  order_date DATE,
  pizza_menu_id INT,
  order_total DECIMAL(10,2),
  PRIMARY KEY (order_id),
  FOREIGN KEY (customer_id) REFERENCES customers(customer_id)
);
-- Insert data into orders table
INSERT INTO orders VALUES
  (1, 1, '2023-11-01',   2, 299.00),
  (2, 2, '2023-11-02',   4, 199.00),
  (3, 3, '2023-11-02',   5, 299.00),
  (4, 4, '2023-11-03',   2, 299.00),
  (5, 5, '2023-11-03',   9, 399.00),
  (6, 6, '2023-11-03',   8, 299.00),
  (7, 7, '2023-11-04',   6, 399.00),
  (8, 8, '2023-11-04',   2, 299.00),
  (9, 9, '2023-11-05',   3, 399.00),
  (10, 10, '2023-11-06', 7, 199.00);

-- Create the invoices table
CREATE TABLE invoices (
  invoice_id INT,
  customer_id INT,
  invoice_date DATE,
  invoice_total DECIMAL(10,2),
  payment_method_id INT,
  PRIMARY KEY (invoice_id),
  FOREIGN KEY (customer_id) REFERENCES customers(customer_id)
);
-- Insert data into invoices table
INSERT INTO invoices VALUES 
  (1, 1, '2023-11-01', 299.00, 1),
  (2, 2, '2023-11-02', 199.00, 2),
  (3, 3, '2023-11-02', 299.00, 3),
  (4, 4, '2023-11-03', 299.00, 1),
  (5, 5, '2023-11-03', 399.00, 2),
  (6, 6, '2023-11-03', 299.00, 3),
  (7, 7, '2023-11-04', 399.00, 1),
  (8, 8, '2023-11-04', 299.00, 2),
  (9, 9, '2023-11-05', 399.00, 3),
  (10, 10, '2023-11-06', 199.00, 1);

-- Create the pizza_menus table
CREATE TABLE pizza_menus (
  pizza_menu_id INT,
  pizza_name VARCHAR(255),
  pizza_size VARCHAR(255),
  pizza_price DECIMAL(10,2),
  PRIMARY KEY (pizza_menu_id)
);
-- insert data into pizza_menus table
INSERT INTO pizza_menus VALUES
  (1, 'Margherita', 'Small', 199.00),
  (2, 'Margherita', 'Medium', 299.00),
  (3, 'Margherita', 'Large', 399.00),
  (4, 'Pepperoni', 'Small', 199.00),
  (5, 'Pepperoni', 'Medium', 299.00),
  (6, 'Pepperoni', 'Large', 399.00),
  (7, 'Hawaiian', 'Small', 199.00),
  (8, 'Hawaiian', 'Medium', 299.00),
  (9, 'Hawaiian', 'Large', 399.00);
  
-- Create the payment_methods table
CREATE TABLE payment_methods (
  payment_method_id INT,
  payment_method_name VARCHAR(255),
  PRIMARY KEY (payment_method_id)
);
-- Insert data into payment_methods table
INSERT INTO payment_methods VALUES
(1, 'Cash'),
(2, 'Credit Card'),
(3, 'Bank Transfer');

-- 1st qurey: join
.mode box
SELECT 
  c.customer_id,
  c.customer_name,
  i.invoice_total,
  pm.payment_method_name
FROM customers   AS c
JOIN orders      AS o ON c.customer_id = o.customer_id
JOIN pizza_menus AS p ON o.pizza_menu_id = p.pizza_menu_id
JOIN invoices    As i ON c.customer_id = i.customer_id
JOIN payment_methods AS pm on i.payment_method_id = pm.payment_method_id
WHERE invoice_total > 200
AND payment_method_name = 'Cash';

-- 2nd qurey: aggregate function
.mode box
SELECT
  count(*),
  SUM(order_total),
  AVG(order_total),
  MAX(order_total),
  MIN(order_total)
FROM orders;

-- 3rd qurey: subquries
.mode box
SELECT 
  *,
  (SELECT MAX(order_total) 
    FROM orders) as max_order_price
FROM orders;

-- 4th qurey: with
.mode box
WITH large_size as (
  SELECT * FROM pizza_menus
  WHERE pizza_size = 'Large'
), customer as (
  SELECT * FROM customers
)

SELECT 
  customer_name, 
  customer_email, 
  pizza_price
FROM large_size AS t1
JOIN orders AS t2     
ON t1.pizza_menu_id = t2.pizza_menu_id
JOIN customer AS t3
ON t2.customer_id = t3.customer_id;
