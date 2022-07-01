-- Day 2 Assignment
-- NORTHWIND SECTION

-- 14. List all Products that has been sold at least once in last 25 years.

select Pr.ProductName, ord.OrderID, ord.OrderDate, ODet.ProductID
from dbo.Orders as [Ord]
join dbo.[Order Details] as [ODet]
on Ord.OrderID = ODet.OrderID
join dbo.Products as [Pr]
on Odet.ProductID = Pr.ProductID
where OrderDate > DATEADD(YEAR, -25, GETDATE())
order by OrderID

-- 15. List top 5 locations (Zip Code) where the products sold most.
select Top 5 O.ShipPostalCode, sum(OD.Quantity) as [Sum of quantity of items ordered]
from dbo.Orders as [O]
join dbo.[Order Details] as [OD]
on O.OrderID = od.OrderID
where o.ShipPostalCode is not null
group by O.ShipPostalCode
ORDER BY sum(OD.Quantity) desc

select Top 5 count(ODet.ProductID) [Products per OrderID], Cst.PostalCode, Cst.CustomerID, sum(Odet.quantity) [Total Quantity per PostalCode]
from dbo.Orders as [Ord]
join dbo.[Order Details] as [ODet]
on Ord.OrderID = ODet.OrderID
join dbo.Customers as [Cst]
on Ord.CustomerID = Cst.CustomerID
group by Cst.PostalCode, Cst.CustomerID
order by sum(Odet.Quantity) desc

-- 16. List top 5 locations (Zip Code) where the products sold most in last 25 years.
select Top 5 O.ShipPostalCode, sum(OD.Quantity) as [Sum of quantity of items ordered]
from dbo.Orders as [O]
join dbo.[Order Details] as [OD]
on O.OrderID = od.OrderID
where o.ShipPostalCode is not null and O.OrderDate > DATEADD(Year, -25, GETDATE())
group by O.ShipPostalCode
ORDER BY sum(OD.Quantity) desc


select Top 5 count(ODet.ProductID) [Products per OrderID], Cst.PostalCode, Cst.CustomerID, sum(Odet.Quantity) [Total Quantity per PostalCode]
from dbo.Orders as [Ord]
join dbo.[Order Details] as [ODet]
on Ord.OrderID = ODet.OrderID
join dbo.Customers as [Cst]
on Ord.CustomerID = Cst.CustomerID
where Ord.OrderDate > DATEADD(YEAR, -25, GETDATE())
group by Cst.PostalCode, Cst.CustomerID
order by sum(Odet.Quantity) desc

-- 17. List all city names and number of customers in that city.     
-- Using Customers db
select City, count(CustomerID) from dbo.Customers
group by City

-- Using Orders db
select ShipCity, count(distinct(CustomerID)) from dbo.Orders
group by ShipCity

-- 18. List city names which have more than 2 customers, and number of customers in that city

-- Using Customers db
select City, count(CustomerID) from dbo.Customers
group by City
having count(CustomerID)>=2

-- Using Orders db
select ShipCity, count(distinct(CustomerID)) from dbo.Orders
group by ShipCity
having count(distinct(CustomerID))>=2

-- 19. List the names of customers who placed orders after 1/1/98 with order date.
select distinct(C.CompanyName)
from dbo.[Orders] as [O]
join dbo.Customers as [C]
on O.CustomerID = C.CustomerID
where O.OrderDate>'1998-01-01'

-- 20. List the names of all customers with most recent order dates
select C.CompanyName, Max(O.OrderDate) as [Most Recent order Date]
from dbo.Customers as [C]
left join dbo.Orders as [O]
on C.CustomerID = O.CustomerID
group BY C.CustomerID

-- 21. Display the names of all customers  along with the  count of products they bought

-- Count of ProductIDs they bought (as in the count of distinct types of products bought)
select C.CompanyName, count(OD.ProductID) [Count of distinct types of products bought]
from dbo.Customers as [C]
left join dbo.Orders as [O] on C.CustomerID = O.CustomerID -- left join in case there are orderids without a customerid
join dbo.[Order Details] as [OD] on O.OrderID = OD.OrderID
group by C.CompanyName

-- Count of Quantity of products they bought (as in the sum of all individual items purchased across all productIDs)
select C.CompanyName, sum(OD.Quantity) [Sum of quantity]
from dbo.Customers as [C]
left join dbo.Orders as [O] on C.CustomerID = O.CustomerID -- left join in case there are orderids without a customerid
join dbo.[Order Details] as [OD] on O.OrderID = OD.OrderID
group by C.CompanyName

-- 22. Display the customer ids who bought more than 100 Products with count of products.

-- Customer IDs who bought more than 100 types of different productids

select C.CompanyName, count(OD.ProductID) [Count of different product types purchased]
from dbo.Customers as [C]
left join dbo.Orders as [O] on C.CustomerID = O.CustomerID -- left join in case there are orderids without a customerid
join dbo.[Order Details] as [OD] on O.OrderID = OD.OrderID
group by C.CompanyName
having count(OD.ProductID)>100

-- Customer IDs who bought more than 100 in quantity of product regardless of productid/product type

select C.CompanyName, sum(OD.Quantity) [Quantity of products purchased across all product types]
from dbo.Customers as [C]
left join dbo.Orders as [O] on C.CustomerID = O.CustomerID -- left join in case there are orderids without a customerid
join dbo.[Order Details] as [OD] on O.OrderID = OD.OrderID
group by C.CompanyName
having sum(OD.Quantity)>100

-- 23. List all of the possible ways that suppliers can ship their products. Display the results as below
select Sup.CompanyName [Suppliers], Ship.CompanyName [Shipping Companies]
from dbo.Suppliers as [Sup]
cross join dbo.Shippers as [Ship]

-- 24. Display the products order each day. Show Order date and Product Name.
select O.OrderDate, P.ProductName
from dbo.Orders as [O]
join dbo.[Order Details] as [OD] on O.OrderID = OD.OrderID
join dbo.[Products] as [P] on OD.ProductID = P.ProductID
order By o.OrderDate

-- 25. Displays pairs of employees who have the same job title.
select FirstName + ' '+ LastName [Full Name], Title FROM dbo.Employees
group by FirstName + ' '+ LastName, Title
order by Title

-- 26. Display all the Managers who have more than 2 employees reporting to them.
select t2.FirstName + ' ' + t2.LastName [Supervisor], count(t1.FirstName + ' ' + t1.LastName) [Supervisee count] from dbo.Employees as t1
join dbo.Employees as t2 on t1.ReportsTo = t2.EmployeeID
group by t2.FirstName + ' ' + t2.LastName

-- 27. 
SELECT City, CompanyName, 'Customer' as Type
from dbo.Customers
Union
Select City, CompanyName, 'Supplier' as Type
from dbo.Suppliers
order by city