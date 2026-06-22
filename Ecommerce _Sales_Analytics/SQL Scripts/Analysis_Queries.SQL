-- TOTAL REVENUE
-- How much revenue did the company generate?
-- SELECT
-- SUM(O.Quantity*P.Price) AS Total_Revenue
-- FROM Orders O
-- INNER JOIN Products P
-- ON O.Product_ID=P.Product_ID;


-- Revenue by Product
-- Which products make the most money?
-- SELECT
-- P.Product_Name, P.Product_ID, SUM(P.Price*O.Quantity) As Total_Revenue
-- FROM Products P
-- INNER JOIN Orders O
-- ON P.Product_ID=O.Product_ID
-- GROUP BY Product_ID, Product_Name
-- ORDER BY Total_Revenue DESC
-- LIMIT 5;



-- TOP CUSTOMERS
-- Which customers spend the most?
-- SELECT
-- C.Customer_ID, C.Customer_Name, SUM(P.Price*O.Quantity) As Total_Revenue
-- FROM Products P
-- INNER JOIN Orders O
-- ON P.Product_ID=O.Product_ID
-- INNER JOIN Customers C
-- ON C.Customer_ID=O.Customer_ID
-- GROUP BY C.Customer_ID, C.Customer_Name
-- ORDER BY Total_Revenue DESC;



-- Which product category generates the highest revenue?
-- SELECT
-- P.Category, SUM(P.Price*O.Quantity) as Total_Revenue
-- FROM Products P
-- INNER JOIN Orders O
-- ON P.Product_ID=O.Product_ID
-- GROUP BY P.Category
-- ORDER BY Total_Revenue DESC;



-- Which states contribute the most revenue?
-- SELECT
-- C.State, SUM(P.Price*O.Quantity) as Total_Revenue
-- FROM Products P
-- INNER JOIN Orders O
-- ON P.Product_ID=O.Product_ID
-- INNER JOIN Customers C 
-- ON C.Customer_ID=O.Customer_ID
-- GROUP BY C.State
-- ORDER BY Total_Revenue DESC;



-- Which products are sold the most? TOP 5
-- SELECT
-- P.Product_Name, P.Product_ID, SUM(P.Price*O.Quantity) As Total_Revenue
-- FROM Products P
-- INNER JOIN Orders O
-- ON P.Product_ID=O.Product_ID
-- GROUP BY Product_ID, Product_Name
-- ORDER BY Total_Revenue DESC
-- LIMIT 5;



-- What is the average value of an order?
-- SELECT    
-- ROUND(
--         SUM(o.Quantity * p.Price) / COUNT(DISTINCT o.Order_ID),
--         2
--     ) AS Average_Order_Value
-- FROM Orders o
-- JOIN Products p
-- ON o.Product_ID = p.Product_ID;



-- Which customers placed more than one order?
-- SELECT
-- C.Customer_ID, C.Customer_name, COUNT(O.Order_ID) AS Total_Orders
-- FROM Customers C
-- INNER JOIN Orders O
-- ON C.Customer_ID=O.Customer_ID
-- GROUP BY C.Customer_Name, C.Customer_ID
-- HAVING Total_Orders>1
-- ORDER BY Total_Orders DESC;



-- How has Revenue Changed Month by Month?
-- SELECT
-- DATE_FORMAT(O.Order_Date,'%Y-%m') AS Month,
-- SUM(O.Quantity*P.Price) AS Revenue
-- FROM Orders O
-- INNER JOIN Products P
-- ON O.Product_ID=P.Product_ID
-- GROUP BY Month
-- ORDER BY Month ASC;



-- Who is the most valuable customer?
-- SELECT
-- C.Customer_name, SUM(O.Quantity*P.Price) AS Revenue
-- FROM Customers C
-- INNER JOIN Orders O
-- ON C.Customer_ID=O.Customer_ID
-- INNER JOIN Products P
-- ON P.Product_ID=O.Product_ID
-- GROUP BY C.Customer_name
-- ORDER BY Revenue DESC
-- LIMIT 1;



-- Which products were never purchased?
-- SELECT
-- P.Product_ID
-- FROM Products P
-- LEFT JOIN Orders O
-- ON P.Product_ID=O.Product_ID
-- WHERE O.Product_ID IS NULL;



-- How much revenue has each customer generated overall?
-- SELECT
-- DISTINCT C.Customer_name, C.Customer_ID, SUM(O.Quantity*P.Price) AS Revenue
-- FROM Customers C
-- INNER JOIN Orders O
-- ON C.Customer_ID=O.Customer_ID
-- INNER JOIN Products P
-- ON P.Product_ID=O.Product_ID
-- GROUP BY C.Customer_name, C.Customer_ID
-- ORDER BY Revenue DESC;



-- What is the Total revenue that comes from each category?
-- SELECT
-- P.Category, SUM(P.Price*O.Quantity) AS Total_Revenue
-- FROM Products P 
-- INNER JOIN Orders O 
-- ON P.Product_ID=O.Product_ID
-- GROUP BY P.Category
-- ORDER BY Total_Revenue dESC;



-- What percentage of revenue comes from each category?
-- SELECT
-- P.Category,
-- ROUND (
-- SUM(O.Quantity*P.Price)*100 / 
-- (SELECT
-- SUM(O2.Quantity*P2.Price)
-- FROM Orders O2
-- INNER JOIN Products P2
-- ON O2.Product_ID=P2.Product_ID),
-- 2) AS Revenue_Percentage
-- FROM Orders O
-- INNER JOIN Products P
-- ON O.Product_ID=P.Product_ID
-- GROUP BY P.Category;



-- Which product performs best within each category?
-- WITH ProductLeaderboard AS(
-- SELECT
-- P.Category, P.Product_Name, SUM(P.Price*O.Quantity) AS Total_Revenue,
-- row_number() OVER(
-- PARTITION BY P.Category
-- ORDER BY SUM(P.Price*O.Quantity) DESC)
-- AS Inside_Rank
-- FROM Products P 
-- INNER JOIN Orders O
-- ON P.Product_ID=O.Product_ID
-- GROUP BY P.Category, P.Product_Name
-- )
-- SELECT 
-- Category,
-- Product_Name,
-- Total_Revenue
-- FROM ProductLeaderboard 
-- WHERE Inside_Rank=1
-- ORDER BY Total_Revenue DESC;



-- Did revenue increase or decrease compared to the previous month?
WITH 
MonthwiseRevenue AS
(
SELECT
DATE_FORMAT(O.Order_Date, '%Y-%m') AS MonthDate, SUM(P.Price*O.Quantity) AS Revenue
FROM Products P
JOIN Orders O 
ON P.Product_ID=O.Product_ID
Group BY MonthDate
ORDER BY MonthDate ASC),
Revenue_Previous AS(
SELECT
MonthDate, Revenue,
LAG(Revenue) OVER (ORDER BY MonthDate) AS Previous_Month
FROM MonthwiseRevenue)
SELECT
MonthDate, Revenue,
round(
(Revenue-Previous_Month)*100/Previous_month, 2) AS Growth
FROM Revenue_Previous;



-- Which customers are High Value, Medium Value, and Low Value customers?
-- WITH CustomerRevenue AS
-- (
--     SELECT
--         c.Customer_ID,
--         c.Customer_Name,
--         SUM(o.Quantity * p.Price) AS Revenue
--     FROM Orders o
--     JOIN Customers c
--         ON o.Customer_ID = c.Customer_ID
--     JOIN Products p
--         ON o.Product_ID = p.Product_ID
--     GROUP BY
--         c.Customer_ID,
--         c.Customer_Name
-- )

-- SELECT
--     Customer_ID,
--     Customer_Name,
--     Revenue,

--     CASE
--         WHEN Revenue >= 300000 THEN 'High Value'
--         WHEN Revenue >= 100000 THEN 'Medium Value'
--         ELSE 'Low Value'
--     END AS Customer_Segment

-- FROM CustomerRevenue
-- ORDER BY Revenue DESC;



-- Which customers contribute most of the revenue?
-- WITH CustomerRevenue AS
-- (
--     SELECT
--         c.Customer_ID,
--         c.Customer_Name,
--         SUM(o.Quantity * p.Price) AS Revenue
--     FROM Orders o
--     JOIN Customers c
--         ON o.Customer_ID = c.Customer_ID
--     JOIN Products p
--         ON o.Product_ID = p.Product_ID
--     GROUP BY
--         c.Customer_ID,
--         c.Customer_Name
-- )

-- SELECT
--     Customer_ID,
--     Customer_Name,
--     Revenue,

--     ROUND(
--         Revenue * 100 /
--         SUM(Revenue) OVER(),
--         2
--     ) AS Revenue_Percentage

-- FROM CustomerRevenue
-- ORDER BY Revenue DESC;



-- Which customers are most valuable based on: Recency, Frequency and Monetary_Value
-- SELECT
--     c.Customer_ID,
--     c.Customer_Name,

--     DATEDIFF(
--         MAX(o.Order_Date),
--         MIN(o.Order_Date)
--     ) AS Recency,

--     COUNT(o.Order_ID) AS Frequency,

--     SUM(o.Quantity * p.Price) AS Monetary_Value

-- FROM Orders o

-- JOIN Customers c
-- ON o.Customer_ID = c.Customer_ID

-- JOIN Products p
-- ON o.Product_ID = p.Product_ID

-- GROUP BY
--     c.Customer_ID,
--     c.Customer_Name

-- ORDER BY Monetary_Value DESC;



-- Do customers return after their first purchase?
-- WITH CustomerCohort AS
-- (
-- SELECT
--     Customer_ID,
--     MIN(
--         DATE_FORMAT(Order_Date,'%Y-%m')
--     ) AS Cohort_Month
-- FROM Orders
-- GROUP BY Customer_ID
-- )

-- SELECT *
-- FROM CustomerCohort;
-- WITH CustomerCohort AS
-- (
-- SELECT
--     Customer_ID,
--     MIN(
--         DATE_FORMAT(Order_Date,'%Y-%m')
--     ) AS Cohort_Month
-- FROM Orders
-- GROUP BY Customer_ID
-- )

-- SELECT
--     Cohort_Month,
--     COUNT(*) AS Customers
-- FROM CustomerCohort
-- GROUP BY Cohort_Month
-- ORDER BY Cohort_Month;



-- Which states contribute the highest percentage of revenue?
-- WITH StateRevenue AS
-- (
--     SELECT
--         c.State,
--         SUM(o.Quantity * p.Price) AS Revenue
--     FROM Orders o
--     JOIN Customers c
--         ON o.Customer_ID = c.Customer_ID
--     JOIN Products p
--         ON o.Product_ID = p.Product_ID
--     GROUP BY c.State
-- )

-- SELECT
--     State,
--     Revenue,

--     ROUND(
--         Revenue * 100 /
--         SUM(Revenue) OVER(),
--         2
--     ) AS Market_Share_Percentage

-- FROM StateRevenue
-- ORDER BY Revenue DESC;
