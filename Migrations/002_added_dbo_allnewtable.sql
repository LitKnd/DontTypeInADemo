-- <Migration ID="c7eaa61a-e191-4ac0-a46f-7d94a389fc54" />
GO

PRINT N'Creating [dbo].[AllNewTable]'
GO
CREATE TABLE [dbo].[AllNewTable]
(
[i] [int] NOT NULL IDENTITY(1, 1)
)
GO
PRINT N'Creating primary key [PK_AllNewTable_i] on [dbo].[AllNewTable]'
GO
ALTER TABLE [dbo].[AllNewTable] ADD CONSTRAINT [PK_AllNewTable_i] PRIMARY KEY CLUSTERED  ([i])
GO
