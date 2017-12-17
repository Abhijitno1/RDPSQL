/*
create view [dbo].[Alphabetical list of products] AS
SELECT Products.*, Categories.CategoryName
FROM Categories INNER JOIN Products ON Categories.CategoryID = Products.CategoryID
WHERE (((Products.Discontinued)=0))
GO
*/

With ProductsList_CTE ([ProductID], [ProductName], [CompanyName], [CategoryName], [QuantityPerUnit], [UnitPrice], [UnitsInStock])
AS
(
	SELECT        dbo.Products.ProductID, dbo.Products.ProductName, dbo.Suppliers.CompanyName, dbo.Categories.CategoryName, dbo.Products.QuantityPerUnit, 
							 dbo.Products.UnitPrice, dbo.Products.UnitsInStock
	FROM            dbo.Products INNER JOIN
							 dbo.Categories ON dbo.Products.CategoryID = dbo.Categories.CategoryID INNER JOIN
							 dbo.Suppliers ON dbo.Products.SupplierID = dbo.Suppliers.SupplierID
	WHERE        (dbo.Products.Discontinued = 0)
),
OrderDetails_CTE (OrderID, CustomerID, OrderDate, ProductID, UnitPrice, Quantity, Discount)
AS
(
SELECT        dbo.Orders.OrderID, dbo.Orders.CustomerID, dbo.Orders.OrderDate, dbo.[Order Details].ProductID, dbo.[Order Details].UnitPrice, dbo.[Order Details].Quantity, 
                         dbo.[Order Details].Discount
FROM            dbo.Orders INNER JOIN
                         dbo.[Order Details] ON dbo.Orders.OrderID = dbo.[Order Details].OrderID
)

SELECT * FROM ProductsList_CTE PL
JOIN OrderDetails_CTE OD ON PL.ProductID = OD.ProductID 
WHERE LOWER(CompanyName) LIKE 'exotic%'
GO

WITH EmployeeManagers (EmployeeId, EmployeeName, [Level], ManagerId, ManagerName)
AS
(
	SELECT EmployeeId, Convert(Varchar(255), FirstName + ' ' + LastName) AS ManagerName, 1, null, ''
	FROM dbo.Employees
	WHERE ReportsTo IS Null
	UNION ALL
	SELECT E.EmployeeID, Convert(Varchar(255), E.FirstName + ' ' + E.LastName) AS ManagerName, em.[Level] + 1, EM.EmployeeId, EM.EmployeeName
	FROM dbo.Employees E INNER JOIN EmployeeManagers EM
	ON E.ReportsTo = EM.EmployeeId
)

SELECT * FROM EmployeeManagers
GO