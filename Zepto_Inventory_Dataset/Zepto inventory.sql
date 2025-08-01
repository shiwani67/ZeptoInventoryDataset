drop table if exists zepto;

create table zepto(
serial_id SERIAL PRIMARY KEY,
category VARCHAR(120),
name VARCHAR(150) NOT NULL,
mrp NUMERIC(8,2),
discountPercent Numeric(5,2),
availableQuantity INTEGER,
discountedSellingPrice NUMERIC(8,2),
weightInGas INTEGER,
outofStock BOOLEAN,
quantity INTEGER
);

--data exploration

--count of rows

SELECT COUNT(*) FROM zepto;

--sample data
SELECT * FROM zepto
LIMIT 10;

--NULL Values
SELECT * FROM zepto
WHERE NAME IS NULL
OR
category IS NULL
OR
mrp IS NULL
OR
discountpercent IS NULL
OR
discountedSellingPrice IS NULL
OR
availableQuantity IS NULL
OR
outofStock IS NULL
OR
quantity IS NULL;

--different product categories
SELECT DISTINCT category 
FROM zepto
ORDER BY category;
--product in stock vs outof stock
SELECT outofStock,COUNT(serial_id)
FROM zepto
GROUP BY  outofStock;

--product names present multiple times
SELECT name,COUNT(serial_id) as "Number of serial"
FROM zepto
Group BY name
HAVING count(serial_id) > 1
ORDER BY count(serial_id) DESC;

--data cleaning

--products with price  = 0
SELECT * FROM zepto
WHERE mrp = 0 OR discountedSellingPrice = 0;

DELETE FROM zepto
WHERE mrp = 0;

--convert paise to rupees
UPDATE zepto
SET mrp = mrp/100.0,
discountedSellingPrice = discountedSellingPrice/100.0;

SELECT mrp, discountedSellingPrice FROM zepto

--Q1. Find the top 10 best-value products based on the discount percentage.
SELECT DISTINCT name,mrp,discountPercent
FROM zepto
ORDER BY discountPercent DESC
LIMIT 10;
--Q2.What are the Products with High MRP but Out of stocks
SELECT DISTINCT name,mrp
FROM zepto
WHERE outofStock = TRUE and mrp > 300
ORDER BY mrp DESC;
--Q3.Calculate Estimated Revenue for each delivery
SELECT category,
SUM(discountedSellingPrice + availableQuantity) AS total_revenue
FROM zepto
GROUP BY category
ORDER BY total_revenue;
--Q4.Find all the Products where MRP is greater than 500 and discount is less than 10%.
SELECT DISTINCT name, mrp, discountPercent
FROM zepto
WHERE mrp > 500 AND discountPercent < 10
ORDER BY mrp DESC, discountPercent DESC;


--Q5.Find the price per gram for products above 100g and sort by best value.
SELECT DISTINCT name, weightInGas,discountedSellingPrice,
ROUND(discountedSellingPrice/weightInGas,2)AS price_per_gram
FROM zepto
WHERE weightInGas >=100
ORDER BY price_per_gram;

--Q6.Identify the top 5 categories offering the highest average discount percentage.
SELECT category,
ROUND (AVG(discountPercent),2)AS avg_discount
FROM zepto
GROUP BY category
ORDER BY avg_discount DESC
LIMIT 5;

--Q7.Group the products into categories like low,medium,bulk.
SELECT DISTINCT name,weightInGas,
CASE WHEN weightInGas < 1000 THEN 'Low'
WHEN weightInGas < 5000 Then 'Medium'
ELSE 'Bulk'
END AS weight_category
FROM zepto;


--08.What is the total Inventory weight per Category
SELECT category,
SUM(weightInGas * availableQuantity) AS total_weight
FROM zepto
GROUP BY category
ORDER BY total_weight;


--Challenges faced with the dataset
-->NO null values,but still needed to ensure clean data
-->Units were inconsistent(paise instead of rupees)
-->Products with the same name across multiple rows
-->Revenue not directly availabe
-->Categorizing product size (e.g,Low,Medium,Bulk)

-------SOULTION
-->Focused on other data issues like zero pricing and duplicate names
-->Applied SQL update to scale values correctly
-->Used GROUP BY name and Having to detect repitions
-->Estimated revenue using a combination of price and qunatity fields
-->Implemented CASE logic to create customer product groupings


