IF OBJECT_ID('[dbo].[Alphabetical list of products]') IS NOT NULL
	DROP VIEW [dbo].[Alphabetical list of products];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

create view [dbo].[Alphabetical list of products] AS
SELECT Products.*, Categories.CategoryName
FROM Categories INNER JOIN Products ON Categories.CategoryID = Products.CategoryID
WHERE (((Products.Discontinued)=0))
GO
