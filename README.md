# Retail Sales Analysis SQL Project

## Project Overview

**Project Title**: Retail Sales Analysis  
**Level**: Beginner  
**Database**: `sql_retail_project`

This project is designed to demonstrate SQL skills and techniques typically used by data analysts to explore, clean, and analyze retail sales data. The project involves setting up a retail sales database, performing exploratory data analysis (EDA), and answering specific business questions through SQL queries. This project is ideal for those who are starting their journey in data analysis and want to build a solid foundation in SQL.

## Objectives

1. **Set up a retail sales database**: Create and populate a retail sales database with the provided sales data.
2. **Data Cleaning**: Identify and remove any records with missing or null values.
3. **Exploratory Data Analysis (EDA)**: Perform basic exploratory data analysis to understand the dataset.
4. **Business Analysis**: Use SQL to answer specific business questions and derive insights from the sales data.

## Tools Used
- PostgreSQL
- pgAdmin 4
- SQL
Dataset Information

## The dataset contains retail transaction records including:

- Transaction ID
- Sale Date
- Sale Time
- Customer Age
- Gender
- Category
- Quantity Sold
- Price per Unit
- Total Sale
## Project Structure

### 1. Database Setup

- **Database Creation**: The project starts by creating a database named `sql_retail_project`.
- **Table Creation**: A table named `retail_sales_table` is created to store the sales data. The table structure includes columns for transaction ID, sale date, sale time, customer ID, gender, age, product category, quantity sold, price per unit, cost of goods sold (COGS), and total sale amount.

```sql
CREATE DATABASE sql_retail_project;

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
              );
```

### 2. Data Exploration & Cleaning

- **Record Count**: Determine the total number of records in the dataset.
- **Customer Count**: Find out how many unique customers are in the dataset.
- **Category Count**: Identify all unique product categories in the dataset.
- **Null Value Check**: Check for any null values in the dataset and delete records with missing data.

```sql
-- count no of TRANSACTION
SELECT count(*) FROM retail_sales_table;
-- How many uniqe customers we have
SELECT count(DISTINCT customer_id) FROM retail_sales_table;
-- How many uniqe category we have
SELECT count(DISTINCT category) FROM retail_sales_table;
SELECT distinct category from retail_sales_table;

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
```

### 3. Data Analysis & Findings

The following SQL queries were developed to answer specific business questions:

1. **Write a SQL query to retrieve all columns for sales made on '2022-11-05**:
```sql
SELECT * 
from retail_sales_table 
where sale_date = '2022-11-05';
```

2. **Write a SQL query to retrieve all transactions where the category is 'Clothing' and the quantity sold is more than 4 in the month of Nov-2022**:
```sql
SELECT *
from retail_sales_table
where category='Clothing' 
      and 
	  quantiy>=4 
	  and 
	  to_char(sale_date,'YYYY-MM')='2022-11'
```

3. **Write a SQL query to calculate the total sales (total_sale) for each category.**:
```sql
select  
      category,
	  sum(total_sale) as Net_sale,
	  count(*) as Number_of_Transaction
from retail_sales_table 
group by 1;
```

4. **Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category.**:
```sql
SELECT round(avg(age),2) as average_age
from retail_sales_table
where category='Beauty'; 
```

5. **Write a SQL query to find all transactions where the total_sale is greater than 1000.**:
```sql
SELECT * 
from retail_sales_table 
where total_sale > 1000;
```

6. **Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category.**:
```sql
SELECT Category,gender,count(transactions_id) as total_transactions 
from retail_sales_table 
group by Category,gender order by 1;
```

7. **Write a SQL query to calculate the average sale for each month. Find out best selling month in each year**:
```sql
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
```
8. **Write a SQL query to find Top 5 customers Based on total Numebr of  purchase **:
```sql
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
```

9. **Write a SQL query to find the top 5 customers based on the highest total sales **:
```sql
SELECT 
    customer_id,
    SUM(total_sale) as total_sales
FROM retail_sales
GROUP BY 1
ORDER BY 2 DESC
LIMIT 5
```

10. **Write a SQL query to find the number of unique customers who purchased items from each category.**:
```sql
select category,count(distinct customer_id) as count_unique_customers
from retail_sales_table 
group by 1 ;
```

11. **Write a SQL query to find the number of  customers who purchased items from all 3  category.**:
```sql
select customer_id,count(distinct category) as total_puchased_category
from retail_sales_table 
group by 1 
having count(distinct category)=3;
```

12. **Write a SQL query to create each shift and number of orders (Example Morning <12, Afternoon Between 12 & 17, Evening >17)**:
```sql
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
```

## Findings

- **Customer Demographics**: The dataset includes customers from various age groups, with sales distributed across different categories such as Clothing and Beauty.
- **High-Value Transactions**: Several transactions had a total sale amount greater than 1000, indicating premium purchases.
- **Sales Trends**: Monthly analysis shows variations in sales, helping identify peak seasons.
- **Customer Insights**: The analysis identifies the top-spending customers and the most popular product categories.

## Key Findings
- The highest revenue-generating category was Electronics with total sales of 311445.
- The average age of customers purchasing Beauty products was 40.42 years.
- A total of 306 high-value transactions exceeded 1000 in sales value.
- The best-performing month was july,2022 with an average sale of 541.34.
- The top customer(customer_id=3 ) generated in total sales.
- Clothing category  had the highest number of unique customers(149).
- Female/Male customers contributed the highest number of transactions in clothing category.
- The Evening shift recorded the highest order volume.

## Reports Generated
### Sales Performance Report
- Category-wise sales analysis
- Monthly sales trends
- High-value transaction identification
### Customer Analysis Report
- Top spending customers
- Customer age analysis
- Unique customer distribution by category
### Operational Analysis Report
- Transaction distribution by shift
- Gender-wise transaction analysis
- Category performance comparison

## Conclusion

This project serves as a comprehensive introduction to SQL for data analysts, covering database setup, data cleaning, exploratory data analysis, and business-driven SQL queries. The findings from this project can help drive business decisions by understanding sales patterns, customer behavior, and product performance.
The project highlights practical SQL skills commonly used by Data Analysts, including:

- Data filtering and exploration
- Aggregate analysis
- Customer segmentation
- Time-based analysis
- Business performance reporting

## Author - Saiful Islam

This project is part of my portfolio, showcasing the SQL skills essential for data analyst roles. If you have any questions, feedback, or would like to collaborate, feel free to get in touch!

For more content on SQL, data analysis, and other data-related topics, make sure to follow me on linkedin:
- **LinkedIn**: [Connect with me professionally](https://www.linkedin.com/in/saiful-islam-7b7a64268/)


Thank you for your support, and I look forward to connecting with you!
