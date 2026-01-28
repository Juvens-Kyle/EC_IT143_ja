use AdventureWorks2022;
go

/***********************************************************************
NAME: AdventureWorks2022
PURPOSE:Answers to the questions generated

MODIFICATION LOG:
Date                  Autor             Description
------               --------         ------------------
20.01.2026          Juvens Asifiwe    1. Built for IT 143

Runtime: 
1:30hr

**************************************************************************
*/

-- (1) Selectin Everything from Employee table. From other student
select * from HumanResources.employee

-- (2) TOP ten most expensive products in terms of list price? from other student. [From Other Student] Marginal Complexity - Sashaa Johnson
select top 10 ProductID
      ,Name 
      , ProductNumber
      , ListPrice
from Production.Product
order by ListPrice DESC;

-- (3) NET Revenue for the road bikes from [From Other Student] Moderate complexity - Curtis Anthony Chavez

select top 3 ProductID
      , Name 
      , ProductNumber
      , ListPrice - StandardCost as NetRevenues
from Production.Product
where name like '%Road%'

order by Netrevenues ASC;

-- (4) I’m trying to understand sales better. Could you show me the total sales amount for each product category, 
--- so I can compare them? [From Other student] - Lowell Yu
--- Moderate Complexity

select * from Sales.SalesOrderDetail;

SELECT 
    pc.Name AS Category,
    SUM(sod.LineTotal) AS TotalSales
FROM Sales.SalesOrderDetail AS sod
JOIN Production.Product AS p
    ON sod.ProductID = p.ProductID
JOIN Production.ProductSubcategory AS psc
    ON p.ProductSubcategoryID = psc.ProductSubcategoryID
JOIN Production.ProductCategory AS pc
    ON psc.ProductCategoryID = pc.ProductCategoryID
GROUP BY pc.Name
ORDER BY TotalSales DESC;

--- (5)  I need to analyze bicycle sales performance over time. For each product category, what are the year-over-year 
--- changes in net revenue (defined as list price minus standard cost) for the last three years available in the database? [Mine]
--  Increased Complexity

SELECT
    pc.Name AS ProductCategory,
    YEAR(soh.OrderDate) AS OrderYear,
    SUM((p.ListPrice - p.StandardCost) * sod.OrderQty) AS NetRevenue
FROM Sales.SalesOrderDetail sod
JOIN Sales.SalesOrderHeader soh
    ON sod.SalesOrderID = soh.SalesOrderID
JOIN Production.Product p
    ON sod.ProductID = p.ProductID
JOIN Production.ProductSubcategory ps
    ON p.ProductSubcategoryID = ps.ProductSubcategoryID
JOIN Production.ProductCategory pc
    ON ps.ProductCategoryID = pc.ProductCategoryID
GROUP BY
    pc.Name,
    YEAR(soh.OrderDate)
ORDER BY
    pc.Name,
    OrderYear;

--- (6) Which employees actually have the job title “Sales Representative”? [From Other student] - Marginal Complexity - Lowell Yu

select * from Person.Person;
select * from HumanResources.Employee;

select pr.FirstName, 
       pr.lastName
from HumanResources.Employee Emp

join person.Person pr 
on emp.BusinessEntityID = pr.BusinessEntityID

where emp.JobTitle = 'sales Representative'
;
--- (7) Business User question—Increased complexity: There is a group of hackers attacking credit cards with expiration dates in October 2005. 
--- We were asked to decline all the orders with those dates. Make me a list of the credit cards affected, and a list of all the team's emails to notify the company. [From other student] - Geovany Flores 
---Increased Complexity
SELECT 
    cc.CreditCardID,
    cc.CardType,
    cc.CardNumber,
    cc.ExpMonth,
    cc.ExpYear
FROM Sales.CreditCard AS cc
WHERE cc.ExpMonth = 10
  AND cc.ExpYear = 2005;

SELECT 
    p.FirstName,
    p.LastName,
    ea.EmailAddress
FROM Person.Person AS p
JOIN Person.EmailAddress AS ea
    ON p.BusinessEntityID = ea.BusinessEntityID
JOIN HumanResources.Employee AS e
    ON p.BusinessEntityID = e.BusinessEntityID;

-- (8) Which tables contain list price, standard cost, and order quantity, 
--- and how are these tables related through primary and foreign keys? [Mine] Metadata question

/** The table with the requested info is PRODUCTION.PRODUCT

- Product.product with listPrice, StandardCost
- Sales.SalesOrderDetails with OrderQty, ProductID Joined Through ProductID
   