# E-Commerce Sales Analytics — SQL

## Project Overview
A portfolio-ready SQL analytics project based on a synthetic e-commerce sales dataset. The project is designed to demonstrate how SQL can be used to turn transactional sales data into business KPIs and insights.

**Important:** All data in this project is synthetic and created for portfolio/learning purposes. It is not company-confidential data.

## Dataset
- 12,000 order records
- 18 transactional columns
- 3,000 possible customer IDs
- 80 products
- 5 product categories
- 10 cities
- Multiple payment methods and order statuses

## Business Questions
The SQL analysis answers questions such as:
1. What are total sales, profit, units sold and average order value?
2. How do sales and profit change month by month?
3. Which categories and products generate the most sales?
4. Which products rank highest by revenue?
5. Which cities and customer segments contribute the most sales?
6. Which payment modes are most frequently used?
7. What are the cancellation and return rates?
8. How do discounts affect profit?
9. Who are the highest-value customers?
10. What is the repeat-customer rate?
11. How does customer rating vary by category?
12. What is the average delivery time?
13. What is month-over-month sales growth?
14. What is cumulative sales over time?
15. Are there data-quality issues?

## SQL Concepts Demonstrated
- SELECT / WHERE / ORDER BY
- GROUP BY and HAVING
- INNER/LEFT JOIN concepts
- Aggregate functions
- CASE statements
- Subqueries
- Common Table Expressions (CTEs)
- Window functions: LAG, DENSE_RANK, SUM OVER
- Date functions
- Conditional aggregation
- Data-quality validation
- KPI calculations

## Project Structure
```text
Ecommerce_Sales_Analytics_SQL/
├── data/
│   ├── ecommerce_sales.csv
│   └── products.csv
├── sql/
│   ├── 01_schema.sql
│   ├── 02_load_data.sql
│   └── 03_analysis_queries.sql
├── docs/
│   ├── resume_bullets.txt
│   └── interview_talking_points.md
└── README.md
```

## How to Run
1. Install MySQL 8+.
2. Open MySQL Workbench.
3. Run `sql/01_schema.sql`.
4. Run `sql/02_load_data.sql`.
5. If `LOAD DATA LOCAL INFILE` is disabled, enable local file loading in your MySQL client or import the CSV files through MySQL Workbench.
6. Run `sql/03_analysis_queries.sql`.

## Portfolio Tip
After running the project, take screenshots of:
- Executive KPI query
- Monthly sales trend
- Category performance
- Top products ranking
- Month-over-month growth

Then upload the project folder to GitHub and link the repository on your resume.
