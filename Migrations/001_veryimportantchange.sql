-- <Migration ID="a3c073f9-8e66-45ca-b5e5-43482995aa90" />
GO

PRINT N'Altering [dbo].[Categories]';
GO
ALTER TABLE [dbo].[Categories]
ADD [NewCol1] [NCHAR](10) NULL,
    [FunyName] [NCHAR](10) NULL;
GO
