-- create sql retail sales database 
create database sql_retail_project

-- create table
drop table if exists retail_sales_table;
create table retail_sales_table
             (

				transactions_id	int primary key,
				sale_date date,
				sale_time time,
				customer_id	int,
				gender varchar(15),
				age	int,
				category varchar(15),	
				quantiy	int,
				price_per_unit float,	
				cogs float,
				total_sale float
              )


select * from retail_sales_table LIMIT 10;

-- count no of TRANSACTION
SELECT count(*) FROM retail_sales_table;




-- DATA CLEANING 
-- Find all rows which contain null value 
select * from retail_sales_table
WHERE 
     transactions_id is null
	 or
	 sale_date is null
	 or 
	 sale_time is null
	 or
	 customer_id is null
	 or
	 gender is null
	 or
	 age is null
	 or
	 category is null
	 or
	 quantiy is null
	 or
	 price_per_unit is null
	 or
	 cogs is null
	 or
	 total_sale is null;

-- Delete all rows which contain null value 
DELETE from retail_sales_table
WHERE 
     transactions_id is null
	 or
	 sale_date is null
	 or 
	 sale_time is null
	 or
	 customer_id is null
	 or
	 gender is null
	 or
	 age is null
	 or
	 category is null
	 or
	 quantiy is null
	 or
	 price_per_unit is null
	 or
	 cogs is null
	 or
	 total_sale is null;


-- DATA EXPLORATION

-- How many sales we have
select count(*) as Total_number_of_sales from retail_sales_table;

-- How many uniqe customers we have
SELECT count(DISTINCT customer_id) FROM retail_sales_table;
-- How many uniqe category we have
SELECT count(DISTINCT category) FROM retail_sales_table;
SELECT distinct category from retail_sales_table;



--DATA ANALYSIS AND BUSINESS KEY PROBLEMS & ANSWER

--(Q-1)Write a SQL query to retrieve all columns for sales made on '2022-11-05:
SELECT * 
from retail_sales_table 
where sale_date = '2022-11-05';

--(Q-2)Write a SQL query to retrieve all transactions where the category is 'Clothing' and the quantity sold is more than 4 in the month of Nov-2022:
SELECT *
from retail_sales_table
where category='Clothing' 
      and 
	  quantiy>=4 
	  and 
	  to_char(sale_date,'YYYY-MM')='2022-11'

--(Q-3)Write a SQL query to calculate the total sales (total_sale) for each category.:

select  
      category,
	  sum(total_sale) as Net_sale,
	  count(*) as Number_of_Transaction
from retail_sales_table 
group by 1;

--(Q-4)Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category.:

SELECT round(avg(age),2) as average_age
from retail_sales_table
where category='Beauty'; 

--(Q-5)Write a SQL query to find all transactions where the total_sale is greater than 1000.
SELECT * 
from retail_sales_table 
where total_sale > 1000;

--(Q-6)Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category.:
SELECT Category,gender,count(transactions_id) as total_transactions 
from retail_sales_table 
group by Category,gender order by 1;

--(Q-7)Write a SQL query to calculate the average sale for each month. Find out best selling month in each year:

with year_month_cal as (
   select 
   extract(year from sale_date) as year,
   extract(month from sale_date) as month,
   avg(total_sale) as avg_sale,
   rank() over(partition by extract(year from sale_date) order by avg(total_sale) desc) as rnk
   from retail_sales_table 
   group by 1,2
)

select year,month,avg_sale from year_month_cal where rnk=1;

--(q-8) Top 5 customers Based on total Numebr of  purchase
WITH transaction_customer as (
  select 
        customer_id,count(*) as transaction_number 
  from retail_sales_table 
  GROUP by customer_id
)

select 
      customer_id,
	  transaction_number 
from transaction_customer 
order by transaction_number desc 
limit 5;

--(Q-9)**Write a SQL query to find the top 5 customers based on the highest total sales **:

select 
     customer_id,
	 sum(total_sale) as total_purchase 
from retail_sales_table 
group by 1 
order by 2 desc 
limit 5;

--(Q-10)Write a SQL query to find the number of unique customers who purchased items from each category.:
select category,count(distinct customer_id) as count_unique_customers
from retail_sales_table 
group by 1 ;

--(Q-11)Write a SQL query to find the number of  customers who purchased items from all 3  category.:
select customer_id,count(distinct category) as total_puchased_category
from retail_sales_table 
group by 1 
having count(distinct category)=3;

--(Q-12)Write a SQL query to create each shift and number of orders (Example Morning <12, Afternoon Between 12 & 17, Evening >17):

with hourly_sale as(
  select *,
  case
      when extract(hour from sale_time)<12 then'Morning'
      when extract(hour from sale_time) between 12 and 17 then 'Afternoon'
      else 'Evening'
  end as shift
  from retail_sales_table
)

select shift,count(*) as total_orders
from hourly_sale group by 1;











	 
