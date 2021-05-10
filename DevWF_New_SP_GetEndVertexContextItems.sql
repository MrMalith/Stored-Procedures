/****** Object:  StoredProcedure [dbo].[GetEndVertexContextItems]    Script Date: 5/10/2021 5:22:47 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:      <Author, , Malith>
-- Create Date: <Create Date, , 2021 May 10>
-- Description: <Description, , [GetEndVertexContextItems]>
-- =============================================
CREATE PROCEDURE  [dbo].[GetEndVertexContextItems]
(
	@WorkflowId bigint,
	@Version bigint
)
AS
BEGIN
    -- SET NOCOUNT ON added to prevent extra result sets from
    -- interfering with SELECT statements.
    SET NOCOUNT ON

    -- Insert statements for procedure here
    SELECT * from WorkflowEndVertexContextItems 
	where WorkflowId = @WorkflowId AND Version = @Version
END
GO

