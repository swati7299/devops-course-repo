
USE Batch1


SELECT * FROM Fact$

SELECT * FROM Customer$

SELECT * FROM Product$

SELECT * FROM [Location$]

SELECT * FROM ['Regional head$']

SELECT * FROM [Returns$]




-- Q) Category wise sales

SELECT P.Category, SUM(F.Sales) 'Total sales'
FROM Fact$ F LEFT JOIN Product$ P ON F.[Product ID] = P.[Product ID]
GROUP BY P.Category

--solve by me
SELECT P.Category, SUM(F.Sales) 'Total sales'
FROM Fact$ F LEFT JOIN Product$ P ON F.[Product ID]=P.[Product ID]
GROUP BY P.Category



-- Q) Sub-category wise profit
SELECT P.[Sub-Category], SUM(F.Profit) 'Total profit'
FROM Fact$ F LEFT JOIN Product$ P ON F.[Product ID] = P.[Product ID]
GROUP BY P.[Sub-Category]
ORDER BY [Total profit] DESC


--solve by me
SELECT P.[Sub-Category], SUM(F.Profit) 'Total Profit'
FROM Fact$ F LEFT JOIN Product$ P ON F.[Product ID]=P.[Product ID]
GROUP BY P.[Sub-Category]
ORDER BY [Total Profit] DESC




-- Q) Category and Segment wise sales
SELECT P.Category, C.Segment, SUM(F.Sales) 'Total sales'
FROM Fact$ F LEFT JOIN Product$ P ON F.[Product ID] = P.[Product ID]
			LEFT JOIN Customer$ C ON F.[Customer ID] = C.[Customer ID] 
GROUP BY P.Category, C.Segment


--SOLVE BY ME
SELECT P.Category, C.Segment, SUM(F.Sales) 'Total sales'
FROM Fact$ F LEFT JOIN Product$ P ON F.[Product ID] = P.[Product ID]
			 LEFT JOIN Customer$ C ON F.[Customer ID] = C.[Customer ID]
GROUP BY P.Category, C.Segment




-- Q) Show Phones sub-category sales in Indian cities

SELECT L.City, SUM(F.Sales) 'Total sales'
FROM Fact$ F LEFT JOIN Product$ P ON F.[Product ID] = P.[Product ID]
			LEFT JOIN [Location$] L ON F.[Location ID] = L.[Location ID]
WHERE L.Country = 'India' AND P.[Sub-Category] = 'Phones'
GROUP BY L.City
ORDER BY [Total sales] DESC



--solve by me
SELECT L.City, sum(F.Sales) 'Total sales'
FROM Fact$ F LEFT JOIN Product$ P ON F.[Product ID] = P.[Product ID]
			 LEFT JOIN Location$ L ON F.[Location ID] = L.[Location ID]
WHERE L.Country = 'INDIA' AND P.[Sub-Category] = 'Phones'
GROUP BY L.City
ORDER BY [Total SALES] DESC



-- Q) Find the list of cities facing overall loss in Technology category

SELECT L.City, SUM(Profit) 'Overall profit'
FROM Fact$ F LEFT JOIN Product$ P ON F.[Product ID] = P.[Product ID]
			LEFT JOIN [Location$] L ON F.[Location ID] = L.[Location ID]
WHERE P.Category = 'Technology'
GROUP BY L.City
HAVING SUM(Profit) < 0
ORDER BY [Overall profit] 

--solve by me

SELECT L.City, SUM(Profit) 'Total Profit'
FROM Fact$ F LEFT JOIN Product$ P ON F.[Product ID] = P.[Product ID]
			 LEFT JOIN Location$ L ON F.[Location ID] = L.[Location ID]
WHERE P.Category = 'Technology'
GROUP BY L.City
HAVING SUM(Profit) < 0
ORDER BY [Total Profit] 





-- Q) Find profit generated under each Regional head

SELECT RH.[Regional Head], SUM(Profit) 'Total Profit'
FROM Fact$ F LEFT JOIN [Location$] L ON F.[Location ID] = L.[Location ID]
			LEFT JOIN ['Regional head$'] RH ON L.Region = RH.Region
GROUP BY RH.[Regional Head]
ORDER BY [Total Profit] DESC 

--SOLVE BY ME

SELECT RH.[Regional Head], SUM(Profit) 'Total Profit'
FROM Fact$ F LEFT JOIN Location$ L ON F.[Location ID] = L.[Location ID]
			 LEFT JOIN ['Regional head$'] RH ON L.Region = RH.Region
GROUP BY RH.[Regional Head]
ORDER BY [Total Profit] desc


-- Q) Find the names of those Regional heads who have generated at least 15% profit

SELECT RH.[Regional Head], ROUND(100.0*SUM(Profit)/SUM(Sales), 2) '% Profit'
FROM Fact$ F LEFT JOIN [Location$] L ON F.[Location ID] = L.[Location ID]
			LEFT JOIN ['Regional head$'] RH ON L.Region = RH.Region
GROUP BY RH.[Regional Head]
HAVING ROUND(100.0*SUM(Profit)/SUM(Sales), 2) >= 15  --- It's use for at least 15% profit
ORDER BY [% Profit] DESC

--solve by me

SELECT RH.[Regional Head], ROUND(100.0*SUM(Profit)/ SUM(Sales), 2) '% Profit'
FROM Fact$ F LEFT JOIN Location$ L ON F.[Location ID] = L.[Location ID]
			 LEFT JOIN ['Regional head$'] RH ON L.Region = RH.Region
GROUP BY RH.[Regional Head]
HAVING ROUND(100.0*SUM(Profit)/ SUM(Sales), 2) > = 15
ORDER BY [% Profit] DESC



-- Q) Find sales amount for Returned orders

SELECT SUM(F.Sales) 'sum of sales'
FROM Fact$ F LEFT JOIN [Returns$] R ON F.[Order ID] = R.[Order ID]
WHERE R.[Order ID] IS NOT NULL
--
SELECT SUM(F.Sales) 'sum of sales'
FROM Fact$ F LEFT JOIN [Returns$] R ON F.[Order ID] = R.[Order ID]
WHERE R.Returned = 'Yes'

--SOLVE BY ME
 SELECT SUM(Sales) 'sum of sales'
 FROM Fact$ F LEFT JOIN [Returns$] R ON F.[Order ID] = R.[Order ID]
 WHERE R.Returned = 'Yes'





-- Q) Find sub-category wise returned sales amount

SELECT P.[Sub-Category], ROUND(SUM(F.Sales), 2) 'Returned sales' 
FROM Fact$ F LEFT JOIN [Returns$] R ON F.[Order ID] = R.[Order ID]
			LEFT JOIN Product$ P ON F.[Product ID] = P.[Product ID]
WHERE R.Returned = 'Yes'
GROUP BY P.[Sub-Category]
ORDER BY [Returned sales] DESC

--SOLVE BY ME

SELECT p.[Sub-Category], ROUND(SUM (F.Sales), 2) 'Returned Sales'
FROM Fact$ F LEFT JOIN Product$ P ON F.[Product ID] = P.[Product ID]
			 LEFT JOIN Returns$ R ON F.[Order ID] = R.[Order ID]
WHERE R.Returned = 'Yes'
GROUP BY P.[Sub-Category]
ORDER BY [Returned Sales] DESC

 

-- Find returned sales amount for every regional head

SELECT RH.[Regional Head], SUM(F.Sales) 'Returned sales'
FROM Fact$ F LEFT JOIN [Location$] L ON F.[Location ID] = L.[Location ID]
			LEFT JOIN ['Regional head$'] RH ON L.Region = RH.Region 
			LEFT JOIN [Returns$] R ON F.[Order ID] = R.[Order ID] 
WHERE R.Returned = 'Yes'
GROUP BY RH.[Regional Head]
ORDER BY [Returned sales] DESC
 
 --SOLVE BY ME
SELECT RH.[Regional Head], SUM(F.Sales) 'Returned sales'
FROM Fact$ F LEFT JOIN [Location$] L ON F.[Location ID] = L.[Location ID]
			 LEFT JOIN ['Regional head$'] RH ON L.Region = RH.Region
			 LEFT JOIN Returns$ R ON F.[Order ID] = R.[Order ID]
WHERE R.Returned = 'Yes'
GROUP BY RH.[Regional Head]
ORDER BY [Returned sales] DESC

-- Better output  

SELECT RH.[Regional Head], SUM(CASE WHEN R.Returned = 'Yes' THEN F.Sales ELSE 0 END) 'Returned sales'
FROM Fact$ F LEFT JOIN [Location$] L ON F.[Location ID] = L.[Location ID]
			LEFT JOIN ['Regional head$'] RH ON L.Region = RH.Region 
			LEFT JOIN [Returns$] R ON F.[Order ID] = R.[Order ID] 
GROUP BY RH.[Regional Head]
ORDER BY [Returned sales] DESC




-- Q) Find the customer who have placed the order of maximum value

SELECT TOP 1 C.[Customer ID], C.[Customer Name], F.[Order ID], SUM(Sales) 'Sales amount'
FROM Fact$ F LEFT JOIN Customer$ C ON F.[Customer ID] = C.[Customer ID] 
GROUP BY C.[Customer ID], C.[Customer Name], F.[Order ID]
ORDER BY [Sales amount] DESC




-- Q) Find year wise sales for each category

SELECT P.Category, YEAR(F.[Order Date]) 'Year', SUM(Sales) 'Total sales'
FROM Fact$ F LEFT JOIN Product$ P ON F.[Product ID] = P.[Product ID]
GROUP BY P.Category, YEAR(F.[Order Date])
ORDER BY P.Category, YEAR(F.[Order Date]) 

--SOLVE BY ME
SELECT P.Category, YEAR(F.[Order Date]) 'YEAR', SUM(Sales) 'Total Sales'
FROM Fact$ F LEFT JOIN Product$ P ON F.[Product ID] = P.[Product ID]
GROUP BY P.Category, YEAR(F.[Order Date])
ORDER BY P.Category, YEAR(F.[Order Date])


-- Q) Find category and segment wise profit of 2024 in India

SELECT P.Category, C.Segment, SUM(F.Profit) 'Total profit' 
FROM Fact$ F LEFT JOIN Product$ P ON F.[Product ID] = P.[Product ID]
			LEFT JOIN Customer$ C ON F.[Customer ID] = C.[Customer ID]
			LEFT JOIN [Location$] L ON F.[Location ID] = L.[Location ID]
WHERE L.Country = 'India' AND YEAR([Order Date]) = 2024 
GROUP BY P.Category, C.Segment 
ORDER BY P.Category, C.Segment

--SOLVE BY ME

SELECT P.Category, C.Segment , SUM(Profit) 'Total profit'
FROM Fact$ F LEFT JOIN Product$ P ON F.[Product ID] = P.[Product ID]
			 LEFT JOIN Customer$ C ON F.[Customer ID] = C.[Customer ID]
			 LEFT JOIN Location$ L ON F.[Location ID] = L.[Location ID]
WHERE L.Country = 'India' and YEAR([Order Date]) = 2024
GROUP BY P.Category, C.Segment
ORDER BY P.Category, C.Segment


--fact join customer join product join location join regional head join returns , selective columns

SELECT F.*, C.[Customer ID], C.Segment, P.[Product Name], P.[Sub-Category], P.Category,
			L.City, L.State, L.Country, L.Region, L.Market, RH.[Regional Head],
			IIF(R.Returned IS NULL, 'No', 'Yes') [Return Status]
FROM Fact$ F LEFT JOIN Customer$ C ON F.[Customer ID] = C.[Customer ID]
		     LEFT JOIN Product$ P ON F.[Product ID] = P.[Product ID]
			 LEFT JOIN Location$ L ON F.[Location ID] = L.[Location ID]
			 LEFT JOIN ['Regional head$'] RH ON L.Region = RH.Region
			 LEFT JOIN Returns$ R ON F.[Order ID] =R.[Order ID]
ORDER BY P.Category