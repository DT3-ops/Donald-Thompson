-- SQL Script to Answer Business Questions for AdventureWorks
-- Author: Donald Thompson
-- Date: [Today's Date]

-- Formatting guidelines: https://learnsql.com/blog/sql-formatting-standards/

-- Question 1: (Business User - Marginal Complexity)
-- Which product has the highest list price in the Product table?
-- Original Author: Donald Thompson
SELECT TOP 1 Name, ListPrice
FROM Production.Product
ORDER BY ListPrice DESC;

-- Question 2: (Business User - Marginal Complexity)
-- How many employees are there in the Employee table?
-- Original Author: Donald Thompson
SELECT COUNT(*) AS EmployeeCount
FROM HumanResources.Employee;

-- Question 3: (Business User - Moderate Complexity)
-- Which sales territory had the highest total sales last year, and what was the total sales amount?
-- Original Author: Donald Thompson
SELECT TOP 1 ST.Name AS TerritoryName, SUM(SOH.SubTotal) AS TotalSales
FROM Sales.SalesOrderHeader SOH
JOIN Sales.SalesTerritory ST ON SOH.TerritoryID = ST.TerritoryID
WHERE YEAR(SOH.OrderDate) = YEAR(GETDATE()) - 1
GROUP BY ST.Name
ORDER BY TotalSales DESC;

-- Question 4: (Business User - Moderate Complexity)
-- List the top three products by sales quantity for the past month, including their names and quantities sold.
-- Original Author: Donald Thompson
SELECT TOP 3 P.Name, SUM(SOD.OrderQty) AS TotalQuantitySold
FROM Sales.SalesOrderDetail SOD
JOIN Production.Product P ON SOD.ProductID = P.ProductID
JOIN Sales.SalesOrderHeader SOH ON SOD.SalesOrderID = SOH.SalesOrderID
WHERE SOH.OrderDate >= DATEADD(MONTH, -1, GETDATE())
GROUP BY P.Name
ORDER BY TotalQuantitySold DESC;

-- Question 5: (Business User - Increased Complexity)
-- As the sales manager, I need to know which salesperson had the highest sales in the last quarter. Additionally, provide the total sales amount they achieved during this period.
-- Original Author: Donald Thompson
WITH SalesLastQuarter AS (
    SELECT SalesPersonID, SUM(SubTotal) AS TotalSales
    FROM Sales.SalesOrderHeader
    WHERE OrderDate >= DATEADD(QUARTER, -1, GETDATE())
    GROUP BY SalesPersonID
)
SELECT TOP 1 SP.FirstName, SP.LastName, SLQ.TotalSales
FROM SalesLastQuarter SLQ
JOIN Sales.SalesPerson SP ON SLQ.SalesPersonID = SP.BusinessEntityID
ORDER BY SLQ.TotalSales DESC;

-- Question 6: (Business User - Increased Complexity)
-- As the inventory manager, I need a report on the product with the lowest stock level across all warehouses. Include the product name, current stock level, and the warehouse location.
-- Original Author: Donald Thompson
SELECT TOP 1 P.Name AS ProductName, SUM(PI.Quantity) AS TotalStock, W.Name AS WarehouseName
FROM Production.ProductInventory PI
JOIN Production.Product P ON PI.ProductID = P.ProductID
JOIN Production.Location W ON PI.LocationID = W.LocationID
GROUP BY P.Name, W.Name
ORDER BY TotalStock ASC;

-- Question 7: (Metadata - System Information Schema Views)
-- What is the definition of the 'ProductID' column in the Product table according to the information schema?
-- Original Author: Donald Thompson
SELECT COLUMN_NAME, DATA_TYPE, CHARACTER_MAXIMUM_LENGTH
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'Product' AND COLUMN_NAME = 'ProductID';

-- Question 8: (Metadata - System Information Schema Views)
-- How many tables exist in the AdventureWorks database according to the information schema, and what are their names?
-- Original Author: Donald Thompson
SELECT TABLE_NAME
FROM INFORMATION_SCHEMA.TABLES
WHERE TABLE_TYPE = 'BASE TABLE';
