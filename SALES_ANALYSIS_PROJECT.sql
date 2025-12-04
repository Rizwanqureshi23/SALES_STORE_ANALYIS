-- use my_project ;

-- DATA CLEANING ------------------------------------------------------------------------------------------------------------------------------
--  select * from sales ;

-- step 1 ---- To check for duplicate

-- select transaction_id from sales 
-- group by transaction_id
-- having count(transaction_id) > 1 ;

-- TXN855235
-- TXN342128
-- TXN240646
-- TXN981773


-- with my_cte as (select *, 
--      row_number() over (partition by transaction_id order by transaction_id) as Row_num
--      from sales )
--      
-- delete e from sales e  join my_cte as c on e.transaction_id = c.transaction_id 
-- where c.Row_num > 1

-- select * from my_cte
-- where  transaction_id in ('TXN855235',
-- 'TXN342128',
-- 'TXN240646',
-- 'TXN981773')



-- step 2 correction of headers--------------------------------------------------------------------------------------------------------------------------


-- select * from sales_store ;
-- alter table sales_store rename column quantiy to quantity ; 
-- alter table sales_store rename column prce to price ;
-- select * from sales_store


-- step 3 TO CHECK DATATYPE-------------------------------------------------------------------------------------------------------------------------

-- select column_name, data_type
-- from information_schema.columns 
-- where table_name = 'sales_store'


-- step 4 TO CHECK AND TREATING NULL VALUES / COUNT --------------------------------------------------------------------------------------------------

-- SELECT * from sales_store
-- where transaction_id is null
-- or customer_id is null or
-- customer_name is null or
-- customer_age is null or
-- gender is null or 
-- product_id is null or
-- product_name is null or
-- product_category is null or 
-- quantiy is null or 
-- prce is null
-- or payment_mode is null or 
-- purchase_date is null 
-- or time_of_purchase is null
-- or status is null ; 

-- step 4 DATA CLEANING-------------------------------------------------------------------------------------------------------------------------------

-- check distinc gender :-
-- SELECT distinct gender from sales_store ;

-- update sales_store 
-- set gender = 'female' 
-- where gender = 'F'

-- update sales_store 
-- set gender = 'male' 
-- where gender = 'M'

-- select distinct payment_mode
-- from sales_store;

-- update sales_store 
-- set payment_mode = 'Credit Card' 
-- where payment_mode = 'CC'

-- Data Analysis----------------------------------------------------------------------------------------------------------------------------------------------

--  Q1. What are the top 5 most selling products by quantity?

-- select product_name, sum(quantiy) as total_quantity 
-- from sales_store where status = 'delivered' group by product_name order by
-- total_quantity desc limit 5  ; 

-- bussiness problem :- We don't know which products are most in demand. 

-- Business Impact: Helps prioritize stock and boost sales through targeted promotions.

-- ------------------------------------------------------------------------------------------- ------------------------------------------------------------------------------------

-- Q2. Which products are most frequently cancelled?

-- select product_name, count(*) as order_count
-- from sales_store 
-- where status = 'cancelled'
-- group by product_name
-- order by order_count desc ;


-- Business Problem: Frequent cancellations affect revenue and customer trust.

-- Business Impact: Identify poor-performing products to improve quality or remove from catalog.

-- -------------------------------------------------------------------------------------------------------------------------------------------------------


--  Q3. What time of the day has the highest number of purchases?
 
-- select * from sales_store;
--    select 
--        case 
--            when extract(hour from time_of_purchase) between 0 and 5 then 'NIGHT'
--            when extract(hour from time_of_purchase) between 6 and 11 then 'MORNING'
--            when extract(hour from time_of_purchase) between 12 and 17 then 'AFTERNOON'
--            when extract(hour from time_of_purchase) between 18 and 23 then 'EVENING'
--   END as time_of_day,
--   count(*) as total_orders
--   from sales_store 
-- group by 
--             case 
--            when extract(hour from time_of_purchase) between 0 and 5 then 'NIGHT'
--            when extract(hour from time_of_purchase) between 6 and 11 then 'MORNING'
--            when extract(hour from time_of_purchase) between 12 and 17 then 'AFTERNOON'
--            when extract(hour from time_of_purchase) between 18 and 23 then 'EVENING'
--   END      
--       ORDER BY total_orders desc ;

-- Business Problem Solved: Find peak sales times.

-- Business Impact: Optimize staffing, promotions, and server loads.
-- -----------------------------------------------------------------------------------------------------------

-- Q4. Who are the top 5 highest spending customers?

-- select customer_name,(quantiy*prce) as total_spend
-- from sales_store
-- group by customer_name
-- order by total_spend desc
-- limit 5  ;


-- Business Problem Solved: Identify VIP customers.

-- Business Impact: Personalized offers, loyalty rewards, and retention.

-- -----------------------------------------------------------------------------------------------------------

-- ️ Q5. Which product categories generate the highest revenue?

-- select * from sales_store;

-- select product_category, sum(quantiy*prce)as total_revanue
-- from sales_store group by product_category
-- order by total_revanue desc ;

-- --Business Problem Solved: Identify top-performing product categories.

-- --Business Impact: Refine product strategy, supply chain, and promotions.
-- --allowing the business to invest more in high-margin or high-demand categories.

-----------------------------------------------------------------------------------------------------------

-- Q6. What is the return/cancellation rate per product category?

-- SELECT * FROM sales

-- cancellation
-- SELECT product_category,
-- 	COUNT(CASE WHEN status='cancelled' THEN 1 END)*100.0/COUNT(*) AS cancelled_percent
-- FROM sales 
-- GROUP BY product_category
-- ORDER BY cancelled_percent DESC


-- -Return
-- SELECT product_category,
-- 	COUNT(CASE WHEN status='returned' THEN 1 END)*100.0/COUNT(*) AS returned_percent
-- FROM sales 
-- GROUP BY product_category
-- ORDER BY returned_percent DESC


-- Business Problem Solved: Monitor dissatisfaction trends per category.

-- Business Impact: Reduce returns, improve product descriptions/expectations.
-- Helps identify and fix product or logistics issues.

-- -------------------------------------------------------------------------------------------------------------

-- Q7. What is the most preferred payment mode? 

-- select * from sales_store;

-- select payment_mode, count(*) as using_count
-- from sales_store group by payment_mode 
-- order by using_count desc limit 1 ;


-- Business Problem Solved: Know which payment options customers prefer.

-- Business Impact: Streamline payment processing, prioritize popular modes.

-- -----------------------------------------------------------------------------------------------------------

--  Q8. How does age group affect purchasing behavior?

-- select min(customer_age), max(customer_age) from sales_store;

-- SELECT 
-- 	CASE	
-- 		WHEN customer_age BETWEEN 18 AND 25 THEN '18-25'
-- 		WHEN customer_age BETWEEN 26 AND 35 THEN '26-35'
-- 		WHEN customer_age BETWEEN 36 AND 50 THEN '36-50'
-- 		ELSE '51+'
-- 	END AS customer_age,
-- 	SUM(price*quantity) AS total_purchase
-- FROM sales 
-- GROUP BY CASE	
-- 		WHEN customer_age BETWEEN 18 AND 25 THEN '18-25'
-- 		WHEN customer_age BETWEEN 26 AND 35 THEN '26-35'
-- 		WHEN customer_age BETWEEN 36 AND 50 THEN '36-50'
-- 		ELSE '51+'
-- 	END
-- ORDER BY SUM(price*quantity) DESC

-- --Business Problem Solved: Understand customer demographics.

-- --Business Impact: Targeted marketing and product recommendations by age group.

-----------------------------------------------------------------------------------------------------------
-- Q9. What’s the monthly sales trend?

-- select year(purchase_date) as years,
-- 	   month(purchase_date) as months,
--        sum(quantity*price) as total_revanue
-- 	from sales_store group by year(purchase_date),month(purchase_date)
--     order by total_revanue desc ;


-- Business Problem: Sales fluctuations go unnoticed. 

-- Business Impact: Plan inventory and marketing according to seasonal trends.

-- ---------------------------------------------------------------------------------------------------------------------------------------------------------  

-- Q10. Are certain genders buying more specific product categories?

-- SELECT 
--     gender,
--     product_category,
--     SUM(quantity * price) AS total_spent
-- FROM
--     sales_store
-- GROUP BY gender , product_category
-- ORDER BY total_spent DESC;

-- Business Problem Solved: Gender-based product preferences.

-- Business Impact: Personalized ads, gender-focused campaigns.


-- END PROJECT
-- ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------


