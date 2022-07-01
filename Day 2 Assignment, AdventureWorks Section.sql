-- Day 2 Assignment
-- 1. How many products can you find in the Production.Product table?
select count(*)
from Production.Product
where ProductId is not Null
go
-- 2. Write a query that retrieves the number of products in the Production.Product table that are included in a subcategory. The rows that have NULL in column ProductSubcategoryID are considered to not be a part of any subcategory.

select count(*)
from Production.Product
where ProductId is not null and ProductSubcategoryID is not null
go

-- 3. How many Products reside in each SubCategory? Write a query to display the results with the following titles. ProductSubcategoryID CountedProducts

SELECT ProductSubcategoryID, count(ProductID) as [CountedProducts]
from Production.Product
where ProductId is not Null and ProductSubcategoryID is not null
group BY ProductSubcategoryID
go

-- 4. How many products that do not have a product subcategory.

select count(*)
from Production.Product
where ProductSubcategoryID is null and ProductID is not Null
go
-- 5. Write a query to list the sum of products quantity in the Production.ProductInventory table.
-- Query to calculate the total sum of all products (duplicates allowed, that is, we're not summing just the number of different types of products available)
select sum(Quantity)
from Production.ProductInventory
go
-- Query to calculate total sum of available quantity per productID
select ProductID, sum(Quantity) [Quantity available]
from Production.ProductInventory
where ProductID is not NULL
group by ProductID
go

select ProductID, Quantity
from Production.ProductInventory

-- 6. Write a query to list the sum of products in the Production.ProductInventory table and LocationID set to 40 and limit the result to include just summarized quantities less than 100.
-- Quantity per ProductID given location ID =40 and quantity <100 per productID
select ProductID, sum(Quantity) [Quantity available]
from Production.ProductInventory
where ProductID is not NULL and LocationID = 40 and Quantity < 100
group by ProductID
go

-- 7. Write a query to list the sum of products with the shelf information in the Production.ProductInventory table and LocationID set to 40 and limit the result to include just summarized quantities less than 100

select Shelf, ProductID, sum(Quantity) [Quantity available]
from Production.ProductInventory
where ProductID is not NULL and LocationID = 40 and Quantity < 100
group by Shelf, ProductID
go

-- 8. Write the query to list the average quantity for products where column LocationID has the value of 10 from the table Production.ProductInventory table.

select ProductID, AVG(Quantity) [Average Quantity]
from Production.ProductInventory
where ProductID is not NULL and LocationID = 10
group by ProductID
go

-- curiously no difference between the average quantity available per productid and the sum of quantity available per productid.
select ProductID, sum(quantity) [Available Quantity]
from Production.ProductInventory
where ProductID is not Null and LocationID = 10
group by ProductID
go
-- Probably has to do with the fact that each product id at locationid 10 is unique. 
select count(distinct(ProductID)) [Number of Unique ProductIDs], (select count(ProductID)
from Production.ProductInventory
where LocationID = 10 and ProductID is not null) [Number of ProductIDs]
from Production.ProductInventory
where LocationID = 10 and ProductID is not null
go
-- 9. Write query  to see the average quantity  of  products by shelf  from the table Production.ProductInventory
SELECT ProductID, Shelf, avg(quantity) [Average quantity]
From Production.ProductInventory
where ProductID is not null and Shelf is not NULL
group by ProductID, Shelf

-- 10.Write query  to see the average quantity  of  products by shelf excluding rows that has the value of N/A in the column Shelf from the table Production.ProductInventory
SELECT ProductID, Shelf, avg(quantity) [Average quantity]
From Production.ProductInventory
where ProductID is not null and Shelf is not NULL and Shelf != 'N/A'
group by ProductID, Shelf

-- 11. List the members (rows) and average list price in the Production.Product table. This should be grouped independently over the Color and the Class column. Exclude the rows where Color or Class are null.
SELECT Color, Class, count(*) [TheCount] , avg(ListPrice) [AvgPrice]
from Production.Product
where Color is not null and Class is not Null and ProductID is not Null
Group by color, Class

-- JOINS

-- 12. Write a query that lists the country and province names from person. CountryRegion and person. StateProvince tables. Join them and produce a result set similar to the following.

select cr.Name [Country], sp.Name [Province]
From Person.CountryRegion as cr
join Person.StateProvince as sp on cr.CountryRegionCode = sp.CountryRegionCode

-- 13. Write a query that lists the country and province names from person. CountryRegion and person. StateProvince tables and list the countries filter them by Germany and Canada. Join them and produce a result set similar to the following.
select cr.Name [Country], sp.Name [Province]
From Person.CountryRegion as cr
join Person.StateProvince as sp on cr.CountryRegionCode = sp.CountryRegionCode
where cr.Name in ('Germany', 'Canada')
