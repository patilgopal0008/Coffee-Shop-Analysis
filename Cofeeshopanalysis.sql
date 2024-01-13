-- creating database
create database cafe;
use cafe;


-- creating table & importing values in that table 
 
create table cofeeshop (
transaction_id int primary key,	
transaction_date varchar(15),
transaction_time time,
transaction_qty	int,
store_id int not null,
store_location varchar(100),
product_id	int,
unit_price	int,
product_category varchar(100),
product_type varchar(100),	
product_detail varchar(100)
);


select * from cofeeshop;


-- data cleaning

-- checking for null values in all columns

SELECT * FROM cofeeshop WHERE COALESCE(transaction_id, transaction_date, 
transaction_time,transaction_qty,store_id,store_location,product_id,
unit_price,product_category,product_type,product_detail) IS  NULL;


-- checking for duplicate values

SELECT transaction_id, transaction_date, 
transaction_time,transaction_qty,store_id,store_location,product_id,
unit_price,product_category,product_type,product_detail,COUNT(*) AS count
FROM cofeeshop
GROUP BY transaction_id, transaction_date, 
transaction_time,transaction_qty,store_id,store_location,product_id,
unit_price,product_category,product_type,product_detail
HAVING count > 1;


-- adding a new column day

select * from cofeeshop;
alter table cofeeshop add column day varchar(15);

UPDATE cofeeshop
SET transaction_date = STR_TO_DATE(transaction_date, '%d-%m-%Y');

alter table cofeeshop modify column transaction_date date;


update cofeeshop set day =dayname(transaction_date);


-- adding another column day_time 

alter table cofeeshop add column day_time varchar(10);

UPDATE cofeeshop
SET day_time = 
    CASE
        WHEN TIME(transaction_time) BETWEEN '00:00:00' AND '11:59:59' THEN 'morning'
        WHEN TIME(transaction_time) BETWEEN '12:00:00' AND '17:59:59' THEN 'afternoon'
        WHEN TIME(transaction_time) BETWEEN '18:00:00' AND '23:59:59' THEN 'night'
        ELSE 'unknown'
    END;


-- Overview Questions:

-- What is the total number of records in the dataset?
select count(*) 
from cofeeshop;

-- How many unique products are included in the dataset?
select count(product_detail)
from cofeeshop;

-- What is the time range covered by the dataset?;
SELECT MIN(transaction_date) AS start_date, MAX(transaction_date) AS end_date
FROM cofeeshop;

-- total items sold in each month

select monthname(transaction_date),sum(transaction_qty) 
from cofeeshop
group by monthname(transaction_date);



-- total no.of items sold in each store 

select store_location,sum(transaction_qty) 
from cofeeshop
group by store_location;


-- transactions count of each store

select store_location,count(transaction_id) 
from cofeeshop
group by store_location;


-- no of items sold on each day of the week

select day,sum(transaction_qty) 
from cofeeshop
group by day;

-- transactions count of each store

select store_location,count(transaction_id) 
from cofeeshop
group by store_location;

-- count of items sold on each day of week

select day,count(product_category)
from cofeeshop
group by day;


-- Sales Analysis:

-- What is the total sales revenue for all products?
select sum(transaction_qty*unit_price) as total_revenue
from cofeeshop;

-- Which product has the highest sales revenue?
SELECT product_category,product_type,product_detail, SUM(transaction_qty*unit_price) AS total_revenue
FROM cofeeshop
GROUP BY product_category,product_type,product_detail
ORDER BY total_revenue DESC
LIMIT 1;

-- Can you identify the top 5 products by sales?
SELECT product_category,product_type,product_detail, SUM(transaction_qty*unit_price) AS total_revenue
FROM cofeeshop
GROUP BY product_category,product_type,product_detail
ORDER BY total_revenue DESC
LIMIT 5;

-- what are the sales of each category in all week
select day,product_category,count(product_category) as cnt
from cofeeshop
group by product_category,day
order by cnt desc;


-- Time-Based Analysis:

-- What is the monthly sales trend over the entire period?
select monthname(transaction_date),sum(transaction_qty*unit_price) as total_revenue
from cofeeshop
group by monthname(transaction_date);

-- Are there any seasonal patterns in sales?
select monthname(transaction_date),sum(transaction_qty*unit_price) as total_revenue
from cofeeshop
group by monthname(transaction_date);

-- Which day of the week has the highest sales on average?
select day,avg(transaction_qty*unit_price)
from cofeeshop
group by day;

-- count of transactions at different day time
select day_time,count(transaction_id) 
from cofeeshop
group by day_time;

-- count of items sold on each day of week

select day,count(product_category)
from cofeeshop
group by day;



-- Customer Analysis:

-- How many unique customers made purchases?
select count(distinct(transaction_id)) 
from cofeeshop;

-- What is the average number of products purchased per customer?
select transaction_id,avg(transaction_qty)
from cofeeshop
group by transaction_id;

-- Who are the top 5 customers in terms of total spending?
select transaction_id,sum(transaction_qty*unit_price) as total_spending
from cofeeshop
group by transaction_id
order by total_spending desc
limit 5;


-- Product Performance:

-- What are the best-selling products in terms of quantity sold?
select product_detail,count(product_detail) as quantity
from cofeeshop
group by product_detail
order by quantity
limit 1;

-- What is the average price per unit for each product?
select product_detail,avg(unit_price)
from cofeeshop
group by product_detail;

-- Are there any products that consistently underperform?
select product_detail,avg(transaction_qty*unit_price)
from cofeeshop
group by product_detail
having avg(transaction_qty*unit_price) < (select avg(transaction_qty*unit_price) from cofeeshop);


-- Category Analysis:

-- How are sales distributed across different product categories?
select product_category,sum(transaction_qty*unit_price)
from cofeeshop
group by product_category;

-- Is there a correlation between product category and sales performance?
select product_category,sum(transaction_qty*unit_price) as sales
from cofeeshop
group by product_category;


-- Geographical Analysis:

--  how do sales vary across different regions?
select store_location,sum(transaction_qty*unit_price)
from cofeeshop
group by store_location;

-- Are there specific locations with higher sales?
select store_location,sum(transaction_qty*unit_price) as sales
from cofeeshop
group by store_location 
order by sales desc;




select  distinct transaction_id from cofeeshop;
select * from cofeeshop;
