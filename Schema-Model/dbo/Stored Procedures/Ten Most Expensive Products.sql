IF OBJECT_ID('[dbo].[Ten Most Expensive Products]') IS NOT NULL
	DROP PROCEDURE [dbo].[Ten Most Expensive Products];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

create procedure [dbo].[Ten Most Expensive Products] AS
SET ROWCOUNT 10
SELECT Products.ProductName AS TenMostExpensiveProducts, Products.UnitPrice
FROM Products
ORDER BY Products.UnitPrice DESC
GO
