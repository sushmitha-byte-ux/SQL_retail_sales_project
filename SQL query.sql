select * from retail_sales;

-- data cleansing --
select * from retail_sales 
where
transactions_id is null
or 
sale_date is null 
or 
sale_time is null 
or 
gender is null
or 
category is null 
or 
quantiy is null 
or 
cogs is null
or 
total_sale is null; 

delete from retail_sales
where 
transactions_id is null
or 
sale_date is null 
or 
sale_time is null 
or 
gender is null
or 
category is null 
or 
quantiy is null 
or 
cogs is null
or 
total_sale is null;

-- data exploration -- 
-- how many sales we have 
select count(*) as total_sales from retail_sales;

-- how many customers we have 
select count(distinct customer_id) as cust_Id from retail_sales;

-- how many category 
select count(distinct category) as categories from retail_Sales;

-- data analysis and business problems --
-- query on retrieve all columns and sales made on '2022-11-05'
select * from retail_sales
where 
sale_date = '2022-11-05';

-- write a query to retrieve all transactions where the category is clothing and the quantity is more than 4 in the month of nov-2022
select category, sum(quantiy)
from retail_sales
where category = 'Clothing'
group by 1


select *
from retail_sales
where category = 'Clothing'
and
to_char(sale_date, 'yyyy-mm') = '2022-11'
and 
quantiy >= 4;

-- querry to find total_sales for every category 
select category, sum(total_sale) as net_sales,
count(*) as total_orders
from retail_sales
group by category;

-- find a avg age 
select round(avg(age), 2) 
as average_age 
from retail_sales
where category = 'Beauty'

-- all transactions greater than 1000
select * from retail_sales
where total_sale > 1000

--total number of transactions made by each gender in each category 
select category,gender,
count(*) as total_trans
from retail_sales
group by 1,2

-- avg sale of each month and best selling month in a year 
select extract(year from sale_date) as year,
extract(month from sale_date ) as month,
avg(total_sale) as avg_total,
rank() over(partition by extract(year from sale_date ) order by avg(total_sale)desc) as rank
from retail_sales
group by 1,2 

-- creating a subquery so you get best seling month in a year 
select
year,month,avg_sales 
from
(
select extract(year from sale_date) as year,
extract(month from sale_date ) as month,
avg(total_sale) as avg_sales,
RANK() over(partition by extract(year from sale_date ) order by avg(total_sale)desc) as rank
from retail_sales
group by 1,2
) as t1
where rank = 1

-- top 5 customers based on total_sales
select customer_id as customer,
sum(total_sale) as total_sales 
from retail_sales
group by 1
order by 2 desc
limit 5

-- find unique customer who purchased from each categories 
select category,
count(distinct customer_id) as unique_customer
from retail_sales
group by 1

-- create each shift and number of orders (example morning <12, afternoon between 12 and 17, evening > 17)
with hourly_sale
as
(
select *,
case 
 when extract(hour from sale_time) <12 then 'morning'
 when extract(hour from sale_time) between 12 and 17 then 'afternoon'
 else 'evening'
end as shift
from retail_sales
)
select 
shift, count(*) as total_orders
from hourly_sale
group by shift

--- END OF PROJECT ---
