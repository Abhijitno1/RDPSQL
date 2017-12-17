select DISTINCT ShipCountry  from[dbo].[Invoices]
select *, (UnitPrice * Quantity)*(1- Discount) + Freight as OrderTotal  from [dbo].[Invoices]
go

--Static Pivot
SELECT * FROM 
(
select ProductName, ShipCountry, (UnitPrice * Quantity)*(1- Discount) + Freight as OrderTotal  from[dbo].[Invoices]
) Src
PIVOT
(
	SUM(OrderTotal)
	FOR ShipCountry IN ([USA], [Canada], [UK], [Germany], [France], [Denmark])
) Pvt
GO

--Dynamic Pivot
DECLARE @SqlQuery NVarchar(MAX), @ColumnName NVarchar(MAX)

SELECT @ColumnName = ISNULL(@ColumnName + ', ', '') + QUOTENAME(ShipCountry)
FROM (SELECT DISTINCT ShipCountry  from [dbo].[Invoices]) as Countries

SELECT @SqlQuery = 'SELECT * FROM (
	select ProductName, ShipCountry, (UnitPrice * Quantity)*(1- Discount) + Freight as OrderTotal  from[dbo].[Invoices]
) src PIVOT (Sum(OrderTotal) FOR ShipCountry IN (' + @ColumnName + ')) pvt'

EXEC sp_executesql @SqlQuery
GO