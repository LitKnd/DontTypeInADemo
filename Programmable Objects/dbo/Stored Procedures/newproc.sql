IF OBJECT_ID('[dbo].[newproc]') IS NOT NULL
	DROP PROCEDURE [dbo].[newproc];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROC [dbo].[newproc]
AS
SELECT 1;
GO
