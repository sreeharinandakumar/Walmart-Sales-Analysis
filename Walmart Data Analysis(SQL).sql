create database if not exists Salestdatawalmart ;

set sql_safe_updates=0;  /* to ON update and delete key */
set sql_safe_updates=1;  /* to OFF update and delete key */


show databases ;
use Salestdatawalmart ;

create table if not exists sales(
	invoice_id varchar(30) not null primary key,
    branch varchar(5) not null,
    city varchar(30) not null,
    customer_type varchar(30) not null,
    gender varchar(30) not null,
    product_line varchar(30) not null,
    unit_price decimal(10,2) not null,
    quantity int not null,
    vat float(6, 4) not null,
    total decimal(12, 4) not null,
    date datetime not null,
    time time not null,
    payment_method varchar(15) not null,
    cogs decimal(10, 2) not null,
    gross_margin_pct float(11, 9),
    gross_income decimal(12, 4) not null,
    rating float(2, 1)
    );
    
    ALTER TABLE sales
MODIFY COLUMN rating DECIMAL(4, 2);         /* This changes the data type from FLOAT(2,1) to DECIMAL(3,1), allowing values like 10 */
    
    desc sales ;    -- This is show the tables datatypes which means ( varchar, datetime, null or not null ..etc )
    
   select * from sales;
   
-- ---------------------------------------------------------------------------------------------------------------------------------------------------------------------   
 --  -------------------------------------- FEATURE ENGINEERING----------------------------------------------------------------------------------------------------------
SELECT time, 
       CASE
           WHEN TIME(time) BETWEEN '00:00:00' AND '11:59:59' THEN 'Morning'
           WHEN TIME(time) BETWEEN '12:00:00' AND '16:59:59' THEN 'Afternoon'
           ELSE 'Evening'
       END AS time_of_date 
FROM sales;      												 /* BOTH THE QUERIES CAN BE USED .. INSTEAD OF `time` use TIME(time)  will be more useful  */

SELECT time, 
       CASE
           WHEN `Time` BETWEEN '00:00:00' AND '11:59:59' THEN 'Morning'
           WHEN `time` BETWEEN '12:00:00' AND '16:59:59' THEN 'Afternoon'
           ELSE 'Evening'
       END AS time_of_date 
FROM sales;  													 /* this is same above query in diff form */


-- This below query written for adding the above query as a column to the table ↓ TIME_OF_DAY
alter table sales add column time_of_day varchar(20) ;

  select * from sales;
  
  update sales
  set time_of_day =  (
	   CASE
			   WHEN `Time` BETWEEN '00:00:00' AND '11:59:59' THEN 'Morning'
			   WHEN `time` BETWEEN '12:00:00' AND '16:59:59' THEN 'Afternoon'
			   ELSE 'Evening'
		   END 
);			

-- DAY_NAME ....... Adding this name as column to the Sales table and update the values of day names..

SELECT date, DAYNAME(date) AS day_name
FROM sales ;

alter table sales add column day_name varchar(10) ;

update sales set day_name = dayname(date);   -- IT says that take the values from the DATE column and change it to day name (mon, tue, wed...) in DAY_NAME column..

-- MONTH_NAME ...

select date, monthname(date) as month_name from sales ; -- Adding this name as column to the Sales table and update the values of month names..

alter table sales add column month_name varchar(10) ;

update sales set month_name = monthname(date) ;  -- IT says that take the values from the DATE column and change it to day name (jan, feb, mar, apr...) in MONTH_NAME column..


-- -------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- ----------------------------------------------------------- GENERIC QUESTIONS --------------------------------------------------------------------------------------------------------
-- 1. How many unique cities does the data have?...

select distinct city from sales ;

-- 2. in which city is each branch? ...

select distinct city, branch from sales ; /* This brings city unique names (no duplicates) along with branches . */




-- ----------------------------------------------------------- PRODUCT QUESTIONS --------------------------------------------------------------------------------------------------------

-- 1. How many unique product lines does the data have?..
select count(distinct product_line)  as cnt_of_productln from sales; 

-- 2.What is the most common payment method?..
select payment_method, count(payment_method) as cnt from sales group by payment_method order by  cnt desc ; 

select payment_method, count(payment_method) as cnt from sales group by payment_method having cnt > 340 ;   -- ++ for example When using HAVING, you must use conditions on aggregated results (like SUM(), COUNT(), etc.).

-- 3. What is the most selling product line?. 
select product_line, count(product_line) as cnt_of_prod from sales group by product_line order by  cnt_of_prod desc ; 

-- 4.What is the total revenue by month?..
select month_name as month, sum(total) as total_monthrev from sales group by month order by total_monthrev desc ;



-- 5. What month had the largest COGS?..
select month_name as month, sum(cogs) as cogs from sales group by month order by cogs desc ;

-- 6. What product line had the largest revenue? .. 
select product_line, sum(total) as total from sales group by product_line order by total desc ;

-- 7. Which city has the largest revenue? ..
select city, branch, sum(total) as total from sales group by city, branch order by total desc ;

-- 8. What is the average VAT by product line, sorted from highest to lowest?
select product_line, avg(vat) as avg_vat from sales group by product_line order by avg_vat desc ;

-- 9. List products whose total sales quantity is above the average of all sales quantities? 
select branch, sum(quantity) as qty from sales group by branch having sum(quantity) > (select avg(quantity) from sales) ;


-- 10.How many purchases were made by each gender for each product line? order by product line
SELECT gender, product_line, COUNT(gender) AS cnt_of_gender_per_product
FROM sales
GROUP BY gender, product_line
ORDER BY product_line desc ;

-- What is the average rating of each product line?
SELECT product_line, round(avg(rating), 2)  as avg_rating from sales group by product_line order by avg_rating desc;   -- round off function is used ..

-- ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- ----------------------------------------------------------- SALES QUESTIONS --------------------------------------------------------------------------------------------------------

-- 1. Number of sales made in each time of the day per weekday 
select time_of_day, count(*) as total_sales from sales where day_name= "sunday" group by time_of_day order by total_sales desc ;       /* this result will be based on day_name and where is used. */

-- 2. Which of the customer types brings the most revenue?
 select customer_type, round(sum(total), 3) as total_rev from sales group by customer_type order by total_rev ;
 
 -- 3. Which city has the largest tax percent/ VAT (Value Added Tax)?
 select city, avg(vat) as avg_vat from sales group by city order by avg_vat desc ;
 
 -- 4. Which customer type pays the most in VAT?
 SELECT customer_type, AVG(vat) AS avg_vat
FROM sales
GROUP BY customer_type
ORDER BY avg_vat DESC
LIMIT 1; 

 -- ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- ----------------------------------------------------------- CUSTOMER QUESTIONS --------------------------------------------------------------------------------------------------------

-- 1. How many unique customer types does the data have?
SELECT distinct customer_type from sales ;
	
-- 2. How many unique payment methods does the data have?
select distinct payment_method from sales ;

-- 3. What is the most common customer type?
select customer_type, count(*) as cnt_of_custmrs from sales group by customer_type order by cnt_of_custmrs desc limit 1  ; -- LIMIT 1 brings only one result which is highest 

-- 4. Which gender represents the majority of customers?
select gender, count(*) as cnt_of_gndr from sales group by gender order by cnt_of_gndr desc limit 1 ;

-- 5. How is customer gender distributed per branch? 
 select branch, gender, count(*) as cnt_of_gndr from sales group by gender, branch order by branch desc ; 
 
 -- 6. Which time of day receives the highest number of customer ratings?
 select time_of_day, round(avg(rating), 2) as avg_rtg from sales group by time_of_day order by avg_rtg desc ;
 
 -- 7. Which day of the week has the highest average rating?
 select day_name, round(avg(rating), 2) as avg_rtg from sales group by day_name order by avg_rtg desc ; 
 
 -- 8. Which day of the week has the highest average rating in each branch?
  select branch, day_name, round(avg(rating), 2) as avg_rtg from sales group by day_name, branch order by avg_rtg desc ; /* Brings all branch and ratings for every day */
  
   select branch, day_name, round(avg(rating), 2) as avg_rtg from sales WHERE branch IN ('A', 'B') group by day_name, branch order by avg_rtg desc ;  /* brings for a and b branches */