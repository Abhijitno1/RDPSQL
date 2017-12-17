-- Inline table valued function
CREATE FUNCTION dbo.AnnualProductSales(
	@Year int
)
RETURNS TABLE
AS
	RETURN SELECT dbo.Categories.CategoryName, dbo.Products.ProductName, SUM(CONVERT(money, (dbo.[Order Details].UnitPrice * dbo.[Order Details].Quantity) 
        * (1 - dbo.[Order Details].Discount) / 100) * 100) AS ProductSales
	FROM dbo.Categories INNER JOIN
		dbo.Products ON dbo.Categories.CategoryID = dbo.Products.CategoryID INNER JOIN
		dbo.Orders INNER JOIN
		dbo.[Order Details] ON dbo.Orders.OrderID = dbo.[Order Details].OrderID ON dbo.Products.ProductID = dbo.[Order Details].ProductID
	WHERE Year(dbo.Orders.ShippedDate) = @Year
	GROUP BY dbo.Categories.CategoryName, dbo.Products.ProductName
GO
select * into #MyTempTable from AnnualProductSales(1997)
SELECT * from #MyTempTable
Drop table #MYTempTable
GO

-- Scalar function
CREATE FUNCTION MostExpensiveProd4Category (
	@CategoryID int
)
RETURNS NVarchar(40)
AS
BEGIN
	DECLARE @ProdName NVarchar(40)

	SELECT @ProdName = ProductName
	FROM dbo.Products OP
	WHERE (OP.CategoryID = @CategoryID)
	AND UnitPrice = (SELECT MAX(UnitPrice) FROM Products IP WHERE IP.CategoryID = OP.CategoryID)

	RETURN @ProdName
END
GO
SELECT dbo.MostExpensiveProd4Category(1)
GO

-- Multistatement table valued function
CREATE FUNCTION CustomerOrders (
	@CustomerID NChar(5)
)
RETURNS @CustOrders TABLE (
	CustomerID NCHar(5),
	CompanyName NVarchar(40),
	OrderID int,
	OrderDate DateTime
)
AS
BEGIN
	INSERT INTO @CustOrders
	SELECT dbo.Customers.CustomerID, dbo.Customers.CompanyName, dbo.Orders.OrderID, dbo.Orders.OrderDate
	FROM dbo.Customers INNER JOIN
		dbo.Orders ON dbo.Customers.CustomerID = dbo.Orders.CustomerID
	WHERE dbo.Customers.CustomerID = @CustomerID

	IF (@@ROWCOUNT = 0 )
		INSERT INTO @CustOrders
		VALUES ('', 'No orders found', 0, GetDate())
	RETURN
END
GO
SELECT * FROM dbo.CustomerOrders('ALFKI')
GO