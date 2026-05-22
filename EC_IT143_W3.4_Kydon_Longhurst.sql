
/***********************************************************************************
******************************
NAME: EC_IT143_W3.4_Kydon_Longhurst
PURPOSE: Demonstrate sql Questions and Answers
MODIFICATION LOG:
-------------------------------------------------------------------------------
V1.0 05/22/2026 
NOTES:
This is my '3.4 Adventure Works—Create Answers' Answers
***********************************************************************************/

-- Q1:What are the five most expensive products by list price? - Tamale Emmanuel
-- A1: Orders by list price greatest to least, then takes the first 5
SELECT TOP (5) [Name]
      ,[ProductNumber]
      ,[ListPrice]
  FROM SalesLT.Product
ORDER BY ListPrice DESC


-- Q2: Which product do we make the most profit on? - Kydon Longhurst
-- A2: Subtracts standard cost from the list price, then orders from greatest to least
SELECT ProductID, Name, (ListPrice-StandardCost) AS Profit
FROM SalesLT.Product
ORDER BY Profit DESC

-- Q3: Management needs to identify underperforming products. List the products with the lowest quantity sold but still active in inventory - Otis Dente Addai
-- A3: Get list of all products sold and how many, order from least to greatest
SELECT ProductID, SUM(OrderQty) AS OrderQty
FROM SalesLT.SalesOrderDetail
GROUP BY ProductID
ORDER BY OrderQty ASC

-- Q4: Which customers placed the largest total order during the past year, and how many orders did each customer submit? - Kydon Longhurst
-- A4:  Get a list of all the customers, then filter by year, and count how many orders per customer
SELECT CustomerID, SUM(TotalDue) AS TotalDue, COUNT(CustomerID) AS OrderCount
  FROM SalesLT.SalesOrderHeader
  WHERE YEAR(OrderDate) = 2008
  GROUP BY CustomerID
  ORDER BY TotalDue DESC


-- Q5:What is the slowest sales month, highest sales month so we can balance inventory.- Moira B Henrie
-- A5:Get each month with how many sales were made, then pick out the highest and lowest number of sales

WITH MonthlySales AS (
    SELECT MONTH(OrderDate) AS MonthNum, COUNT(SalesOrderID) AS NumberOfOrders
    FROM SalesLT.SalesOrderHeader
    GROUP BY MONTH(OrderDate)
)

SELECT MonthNum, NumberOfOrders AS [Max&MinOrders]
FROM MonthlySales
WHERE NumberOfOrders = (SELECT MAX(NumberOfOrders) AS MaxOrders FROM MonthlySales)
OR NumberOfOrders = (SELECT MIN(NumberOfOrders) AS MinOrders FROM MonthlySales)

-- Q6We need to understand customer behavior. For customers who have placed more than 5 orders, show me their customer ID, full name, number of orders, and total purchase amount. Sort by total purchase amount descending.- Sandra Chueze
-- A6: Find how many orders each customer placed, return only the customers with more than 5 orders, add other columns

SELECT SalesOrderHeader.CustomerID, COUNT(SalesOrderID) AS NumOfOrders, SUM(TotalDue) AS TotalPurchaseAmount, FirstName, MiddleName, LastName
  FROM SalesLT.SalesOrderHeader
  JOIN SalesLT.Customer as c ON SalesOrderHeader.CustomerID = c.CustomerID 
  GROUP BY SalesOrderHeader.CustomerID, FirstName, MiddleName, LastName
  HAVING COUNT(SalesOrderID) > 5
  ORDER BY SUM(TotalDue) DESC

-- Q7:Which AdventureWorks tables contain the columns ProductID or ProductSubcategoryID using Information Schema Views? - Abiola Ivy Flora Ogundare
-- A7: Get all the column statistics, search for ProductID and ProductSubcategoryID
SELECT TABLE_NAME,COLUMN_NAME
FROM INFORMATION_SCHEMA.COLUMNS
WHERE COLUMN_NAME = 'ProductID' OR COLUMN_NAME = 'ProductSubcategoryID'
-- Q8:I need to find all columns in the database that have ‘rate’ in their name. List the table name, column name, and data type for each. - Zamukulungisa Gcukumana
-- A8:Get all the column statistics, search for anything with 'rate' in the name, then select other columns we need
SELECT TABLE_NAME,COLUMN_NAME, DATA_TYPE
FROM INFORMATION_SCHEMA.COLUMNS
WHERE COLUMN_NAME = '%rate%'
