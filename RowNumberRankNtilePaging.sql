--RowNumber, rank and Ntile functions
SELECT ROW_NUMBER() OVER (ORDER BY CompanyName) as SrNo, *  from [Customers] ORDER BY City
GO
SELECT DENSE_RANK() OVER (ORDER BY UnitPrice DESC) as [Rank], * FROM [dbo].[Products Above Average Price]
GO
SELECT NTILE(4) OVER (ORDER BY OrderDate) AS Groups4, * FROM [dbo].[Orders] WHERE YEAR(Orderdate)=1997
GO
-- Get third page data for customers table when page size is 10 rows
SELECT * FROM Customers
ORDER BY CustomerID
OFFSET 10*2 ROWS
FETCH NEXT 10 ROWS ONLY
