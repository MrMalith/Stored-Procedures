/****** Object:  Table [dbo].[WorkflowEndVertexContextItems]    Script Date: 5/10/2021 2:12:09 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[WorkflowEndVertexContextItems](
	[WorkflowId] [bigint] NOT NULL,
	[Version] [bigint] NOT NULL,
	[VertexId] [bigint] NOT NULL,
	[ContextItemKey] [nvarchar](max) NOT NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO

