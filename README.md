# Walmart Sales Data Analysis (SQL Project)

## 📊 Project Overview

This project explores Walmart sales data using **SQL queries**. It involves **data cleaning**, **feature engineering**, and **answering real-world business questions** related to sales, revenue, product performance, and customer behavior.

---

## 🏗️ Database Setup & Structure

### Database & Table Creation

```sql
CREATE DATABASE IF NOT EXISTS SalesDataWalmart;
USE SalesDataWalmart;

CREATE TABLE IF NOT EXISTS sales(
  invoice_id VARCHAR(30) NOT NULL PRIMARY KEY,
  branch VARCHAR(5) NOT NULL,
  city VARCHAR(30) NOT NULL,
  customer_type VARCHAR(30) NOT NULL,
  gender VARCHAR(30) NOT NULL,
  product_line VARCHAR(30) NOT NULL,
  unit_price DECIMAL(10,2) NOT NULL,
  quantity INT NOT NULL,
  vat FLOAT(6, 4) NOT NULL,
  total DECIMAL(12, 4) NOT NULL,
  date DATETIME NOT NULL,
  time TIME NOT NULL,
  payment_method VARCHAR(15) NOT NULL,
  cogs DECIMAL(10, 2) NOT NULL,
  gross_margin_pct FLOAT(11, 9),
  gross_income DECIMAL(12, 4) NOT NULL,
  rating DECIMAL(4, 2)
);
```

### Modifications & Safety Settings

```sql
SET sql_safe_updates = 0;
-- Perform updates/deletes
SET sql_safe_updates = 1;
```

---

## 🧪 Feature Engineering

Add derived time columns like `time_of_day`, `day_name`, and `month_name`.

```sql
ALTER TABLE sales ADD COLUMN time_of_day VARCHAR(20);
UPDATE sales
SET time_of_day = CASE
  WHEN TIME(time) BETWEEN '00:00:00' AND '11:59:59' THEN 'Morning'
  WHEN TIME(time) BETWEEN '12:00:00' AND '16:59:59' THEN 'Afternoon'
  ELSE 'Evening'
END;

ALTER TABLE sales ADD COLUMN day_name VARCHAR(10);
UPDATE sales SET day_name = DAYNAME(date);

ALTER TABLE sales ADD COLUMN month_name VARCHAR(10);
UPDATE sales SET month_name = MONTHNAME(date);
```

---

## ❓ Business Questions & SQL Queries

### 🏙️ City & Branch Insights

```sql
-- Unique cities
SELECT DISTINCT city FROM sales;
-- Branch-city mapping
SELECT DISTINCT city, branch FROM sales;
```

### 📦 Product Analysis

```sql
-- Unique product lines
SELECT COUNT(DISTINCT product_line) FROM sales;
-- The most selling product line
SELECT product_line, COUNT(*) FROM sales GROUP BY product_line ORDER BY COUNT(*) DESC;
-- Highest revenue product line
SELECT product_line, SUM(total) FROM sales GROUP BY product_line ORDER BY SUM(total) DESC;
```

### 💸 Revenue & Tax

```sql
-- Revenue by month
SELECT month_name, SUM(total) FROM sales GROUP BY month_name ORDER BY SUM(total) DESC;
-- Month with the highest COGS
SELECT month_name, SUM(cogs) FROM sales GROUP BY month_name ORDER BY SUM(cogs) DESC;
-- Average VAT by product line
SELECT product_line, AVG(vat) AS avg_vat FROM sales GROUP BY product_line ORDER BY avg_vat DESC;
```

### 🧑‍🤝‍🧑 Customer Insights

```sql
-- Unique customer types
SELECT DISTINCT customer_type FROM sales;
-- Most common customer type
SELECT customer_type, COUNT(*) FROM sales GROUP BY customer_type ORDER BY COUNT(*) DESC LIMIT 1;
-- Gender distribution
SELECT gender, COUNT(*) FROM sales GROUP BY gender;
-- Gender distribution by branch
SELECT branch, gender, COUNT(*) FROM sales GROUP BY branch, gender;
```

### ⏰ Time & Rating Analysis

```sql
-- Average rating by product line
SELECT product_line, ROUND(AVG(rating), 2) FROM sales GROUP BY product_line ORDER BY AVG(rating) DESC;
-- Rating by time of day
SELECT time_of_day, ROUND(AVG(rating), 2) FROM sales GROUP BY time_of_day ORDER BY AVG(rating) DESC;
-- Best-rated day
SELECT day_name, ROUND(AVG(rating), 2) FROM sales GROUP BY day_name ORDER BY AVG(rating) DESC;
-- Best-rated day by branch
SELECT branch, day_name, ROUND(AVG(rating), 2) FROM sales GROUP BY branch, day_name ORDER BY ROUND(AVG(rating), 2) DESC;
```

### 🧾 Sales Breakdown

```sql
-- Sales count by time of day on Sunday
SELECT time_of_day, COUNT(*) FROM sales WHERE day_name = 'Sunday' GROUP BY time_of_day ORDER BY COUNT(*) DESC;
-- Revenue by customer type
SELECT customer_type, ROUND(SUM(total), 2) FROM sales GROUP BY customer_type ORDER BY SUM(total) DESC;
-- VAT by city
SELECT city, AVG(vat) FROM sales GROUP BY city ORDER BY AVG(vat) DESC;
```

---

## 📚 Summary

This SQL project showcases:

* Feature engineering in SQL (derived time columns)
* Exploratory data analysis (EDA) using queries
* Answering business questions using grouping, aggregation, and filtering

You can use this project as part of your **portfolio** to demonstrate your ability to:

* Work with raw structured data
* Perform SQL-based data analysis
* Derive insights for decision-making

---

## 📌 To Run the Project

1. Clone this repository
2. Load the dataset into MySQL
3. Run queries section-by-section
4. Modify/add more queries as needed

---

## 🙋‍♂️ Need help?

Feel free to open an issue or reach out via GitHub or LinkedIn!




🙋‍♂️ Need help?
Feel free to open an issue or reach out via GitHub or LinkedIn!

