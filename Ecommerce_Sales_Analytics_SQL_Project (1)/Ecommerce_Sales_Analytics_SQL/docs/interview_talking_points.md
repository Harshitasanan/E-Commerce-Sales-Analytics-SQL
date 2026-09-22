# Interview Talking Points

## 1. What was the project?
I built an E-Commerce Sales Analytics project using SQL to analyze transactional order data. The goal was to understand sales performance, profitability, customer behavior, product performance, and operational metrics.

## 2. What was the dataset?
The project uses 12,000 synthetic e-commerce orders with 18 columns covering order date, customer, city, product, category, quantity, price, discount, sales, profit, payment mode, order status, rating and delivery time.

## 3. What SQL did you use?
I used filtering, grouping, aggregate functions, CASE statements, subqueries, CTEs and window functions such as LAG, DENSE_RANK and cumulative SUM.

## 4. What KPIs did you calculate?
Total sales, total profit, units sold, average order value, profit margin, cancellation rate, return rate, repeat-customer rate and month-over-month sales growth.

## 5. Explain one advanced query.
For month-over-month growth, I first aggregated sales by month in a CTE. I then used LAG() to bring the previous month's sales into the same row and calculated the percentage change.

## 6. Why did you use window functions?
They allow comparisons across rows without collapsing the result set. For example, LAG() compares a month with the previous month, while DENSE_RANK() ranks products by sales.

## 7. How would you improve this project?
I would connect the SQL output to Power BI, create a star-schema model, add more customer-level behavioral analysis, and automate refreshes for a production environment.
