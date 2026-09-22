USE ecommerce_analytics;

-- Update the file paths below if MySQL cannot access the project folder.
LOAD DATA LOCAL INFILE 'data/products.csv'
INTO TABLE products
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(product_id, product_name, category, unit_price);

LOAD DATA LOCAL INFILE 'data/ecommerce_sales.csv'
INTO TABLE ecommerce_sales
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(order_id, order_date, customer_id, city, customer_segment,
 product_id, product_name, category, quantity, unit_price,
 discount_pct, discount_amount, sales_amount, profit_amount,
 payment_mode, order_status, customer_rating, delivery_days);
