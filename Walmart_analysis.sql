CREATE DATABASE IF NOT EXISTS WalmartSales;

create table if not exists sales(
      invoice_id varchar(30) not null primary key,
      branch varchar(5) not null,
      city varchar(30) not null,
      customer_type varchar(30) not null,
      gender varchar(10) not null,
      product_line varchar(100) not null,
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
      
      -- ------------------------------------------------------------------
--       ------------------------------------------------------------------
      
      -- FEATURE ENGINEERING --
      
      -- 1> time of day
SELECT 
    time,
    (CASE
        WHEN time BETWEEN '00:00:00' AND '11:59:59' THEN 'Morning'
        WHEN time BETWEEN '12:00:00' AND '15:59:59' THEN 'Afternoon'
        ELSE 'Evening'
    END) AS time_of_day
FROM
    sales;

alter table sales add column time_of_day varchar(20);

UPDATE sales 
SET 
    time_of_day = (CASE
        WHEN time BETWEEN '00:00:00' AND '11:59:59' THEN 'Morning'
        WHEN time BETWEEN '12:00:00' AND '15:59:59' THEN 'Afternoon'
        ELSE 'Evening'
    END);
      
      
      -- 2> day_name
SELECT 
    date, DAYNAME(date)
FROM
    sales;    
    
    Alter table sales add column day_name varchar(10);
    
UPDATE sales 
SET 
    day_name = DAYNAME(date);
    
    
    -- 3> month_name
SELECT 
    date, MONTHNAME(date)
FROM
    sales;
    
    alter table sales add column month_name varchar(10);
    
UPDATE sales 
SET 
    month_name = MONTHNAME(date);
    
    -- ----------------------------------------------------------------------------
--     --------------------------Generic_Question---------------------------------

-- How many unique cities does the data have?
SELECT DISTINCT
    city
FROM
    sales;
    
    
-- In which city is each branch?
SELECT DISTINCT
    city, branch
FROM
    sales;    
    
    -- ----------------------------------------------------------------------------
--     -------------------------------Product_ANALYSIS----------------------------------

-- How many unique product lines does the data have?
SELECT DISTINCT
    product_line
FROM
    sales;
    
-- What is the most common payment method?
SELECT 
    payment_method, COUNT(payment_method) AS count
FROM
    sales
GROUP BY payment_method
ORDER BY count DESC;    

-- What is the most selling product line?
SELECT 
    product_line, COUNT(product_line) AS cnt
FROM
    sales
GROUP BY product_line
ORDER BY cnt DESC
LIMIT 1;

-- What is the total revenue by month?
SELECT 
    month_name, SUM(total) AS Revenue
FROM
    sales
GROUP BY month_name
ORDER BY Revenue DESC;

-- What month had the largest COGS?
SELECT 
    month_name, SUM(cogs) AS Cogs
FROM
    sales
GROUP BY month_name
ORDER BY Cogs DESC;

-- What product line had the largest revenue?
SELECT 
    product_line, SUM(total) AS revenue
FROM
    sales
GROUP BY product_line
ORDER BY revenue DESC;

-- What is the city with the largest revenue?
SELECT 
    city, SUM(total) AS revenue
FROM
    sales
GROUP BY city
ORDER BY revenue DESC;

-- What product line had the largest VAT?
SELECT 
    product_line, avg(vat) AS avg_tax
FROM
    sales
GROUP BY product_line
ORDER BY avg_tax DESC;

-- Which branch sold more products than average product sold?
SELECT 
    branch, SUM(quantity) AS qty
FROM
    sales
GROUP BY branch
HAVING SUM(quantity) > (SELECT 
        AVG(quantity)
    FROM
        sales);

-- What is the most common product line by gender?
SELECT 
    gender, product_line, COUNT(gender) AS total_cnt
FROM
    sales
GROUP BY gender , product_line
ORDER BY total_cnt DESC;

-- What is the average rating of each product line?
SELECT 
    product_line, ROUND(AVG(rating), 2) AS avg_rating
FROM
    sales
GROUP BY product_line
ORDER BY avg_rating DESC;

-- ------------------------------------------------------------------------------------------
-- -----------------------------------SALES_ANALYSIS----------------------------------------------

-- Number of sales made in each time of the day per weekday
 SELECT 
    time_of_day, COUNT(*) AS total_sales
FROM
    sales
    where day_name = "Sunday"
GROUP BY time_of_day;

-- Which of the customer types brings the most revenue?
SELECT 
    customer_type, SUM(total) AS revenue
FROM
    sales
GROUP BY customer_type
ORDER BY revenue DESC;

-- Which city has the largest tax percent/ VAT (Value Added Tax)?
SELECT 
    city, AVG(vat) AS VAT
FROM
    sales
GROUP BY city
ORDER BY VAT DESC;

-- Which customer type pays the most in VAT?
SELECT 
    customer_type, AVG(vat) AS VAT
FROM
    sales
GROUP BY customer_type
ORDER BY VAT DESC;

-- ------------------------------------------------------------------------------------------
-- --------------------------------CUSTOMER_ANALYSIS-------------------------------------------

-- How many unique customer types does the data have?
SELECT DISTINCT
    customer_type
FROM
    sales;
    
-- How many unique payment methods does the data have?
SELECT DISTINCT
    payment_method
FROM
    sales;
    
-- What is the most common customer type?
SELECT 
    customer_type, COUNT(*) AS Count
FROM
    sales
GROUP BY customer_type
ORDER BY Count DESC;

-- What is the gender of most of the customers?
SELECT 
    gender, COUNT(*) AS count
FROM
    sales
GROUP BY gender
ORDER BY count DESC;

-- What is the gender distribution per branch?
SELECT
    branch,
    gender,
    COUNT(*) AS count
FROM sales
WHERE branch IN ('A', 'B', 'C')
GROUP BY branch, gender
ORDER BY branch, gender;

-- Which time of the day do customers give most ratings?
SELECT 
    time_of_day, avg(rating) AS avg_ratings
FROM
    sales
GROUP BY time_of_day
ORDER BY avg_ratings desc;

-- Which time of the day do customers give most ratings per branch?
SELECT 
    branch, time_of_day, AVG(rating) AS avg_ratings
FROM
    sales
WHERE
    branch IN ('A' , 'B', 'C')
GROUP BY time_of_day , branch
ORDER BY branch , avg_ratings desc;

-- Which day fo the week has the best avg ratings?
SELECT 
    day_name, AVG(rating) AS avg_ratings
FROM
    sales
GROUP BY day_name
ORDER BY avg_ratings DESC;

-- Which day of the week has the best average ratings per branch?
SELECT 
    branch, day_name, AVG(rating) AS avg_ratings
FROM
    sales
WHERE
    branch IN ('A' , 'B', 'C')
GROUP BY branch , day_name
ORDER BY branch , avg_ratings DESC;








    
    
    
    
      