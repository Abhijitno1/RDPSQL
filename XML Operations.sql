/*USE [Northwind]
GO*/
--Output XML data
SELECT [CustomerID]
      ,[CompanyName]
      ,[ContactName]
      ,[ContactTitle]
      ,[Address]
      ,[City]
      ,[Region]
      ,[PostalCode]
      ,[Country]
      ,[Phone]
      ,[Fax]
  FROM [dbo].[Customers]
  FOR XML RAW ('Customer'), elements, ROOT('Customers')
GO

--Input XML data
DECLARE @strXML XML, @docHandle int

SET @strXML = '<Customers>
  <Customer>
    <CustomerID>ALFKI</CustomerID>
    <CompanyName>Alfreds Futterkiste</CompanyName>
    <ContactName>Maria Anders</ContactName>
    <ContactTitle>Sales Representative</ContactTitle>
    <Address>Obere Str. 57</Address>
    <City>Berlin</City>
    <PostalCode>12209</PostalCode>
    <Country>Germany</Country>
    <Phone>030-0074321</Phone>
    <Fax>030-0076545</Fax>
  </Customer>
  <Customer>
    <CustomerID>ANATR</CustomerID>
    <CompanyName>Ana Trujillo Emparedados y helados</CompanyName>
    <ContactName>Ana Trujillo</ContactName>
    <ContactTitle>Owner</ContactTitle>
    <Address>Avda. de la Constitución 2222</Address>
    <City>México D.F.</City>
    <PostalCode>05021</PostalCode>
    <Country>Mexico</Country>
    <Phone>(5) 555-4729</Phone>
    <Fax>(5) 555-3745</Fax>
  </Customer>
  <Customer>
    <CustomerID>ANTON</CustomerID>
    <CompanyName>Antonio Moreno Taquería</CompanyName>
    <ContactName>Antonio Moreno</ContactName>
    <ContactTitle>Owner</ContactTitle>
    <Address>Mataderos  2312</Address>
    <City>México D.F.</City>
    <PostalCode>05023</PostalCode>
    <Country>Mexico</Country>
    <Phone>(5) 555-3932</Phone>
  </Customer>
  <Customer>
    <CustomerID>AROUT</CustomerID>
    <CompanyName>Around the Horn</CompanyName>
    <ContactName>Thomas Hardy</ContactName>
    <ContactTitle>Sales Representative</ContactTitle>
    <Address>120 Hanover Sq.</Address>
    <City>London</City>
    <PostalCode>WA1 1DP</PostalCode>
    <Country>UK</Country>
    <Phone>(171) 555-7788</Phone>
    <Fax>(171) 555-6750</Fax>
  </Customer>
</Customers>'

EXEC sp_xml_preparedocument @docHandle OUTPUT, @strXML
SELECT * FROM OpenXML(@docHandle, N'/Customers/Customer', 2)
WITH (
	[CustomerID] [nchar](5),
	[CompanyName] [nvarchar](40),
	[ContactName] [nvarchar](30),
	[ContactTitle] [nvarchar](30),
	[Address] [nvarchar](60),
	[City] [nvarchar](15),
	[Region] [nvarchar](15),
	[PostalCode] [nvarchar](10),
	[Country] [nvarchar](15),
	[Phone] [nvarchar](24),
	[Fax] [nvarchar](24)
)
EXEC sp_xml_removedocument @docHandle

--SELECT @strXml.query('Customer[1]') -- XML datatype functions .query .value, .update, .exists
