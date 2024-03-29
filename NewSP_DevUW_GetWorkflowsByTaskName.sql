/****** Object:  StoredProcedure [dbo].[GetWorkflowsByTaskName]    Script Date: 8/28/2021 2:40:25 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:      <Author, , Malith>
-- Create Date: <Create Date, 27/08/2020, >
-- Description: <Description,Get workflows >
-- =============================================
CREATE PROCEDURE [dbo].[GetWorkflowsByTaskName](@FilterType NVARCHAR(25),@TaskName NVARCHAR(MAX), @USERREFERENCEID NVARCHAR(MAX),@WorkflowId BIGINT)
AS
BEGIN
  
--    SET NOCOUNT ON

--    SELECT [WorkflowName],WorkflowId, count([WorkflowName]) AS ItemCount , (select * from InboxItem WHERE [FilterType] = @FILTERTYPE AND UserReferenceId = @USERREFERENCEID AND WorkflowInstaceId = @ReferenceId for Json auto) as InboxItem FROM InboxItem
--	 WHERE [FilterType] = @FILTERTYPE AND UserReferenceId = @USERREFERENCEID AND WorkflowInstaceId = @ReferenceId
--GROUP BY [WorkflowName],WorkflowId

SET NOCOUNT ON

    SELECT [WorkflowName],WorkflowId, count([WorkflowName]) AS ItemCount , (select * from InboxItem WHERE [FilterType] = @FILTERTYPE AND UserReferenceId = @USERREFERENCEID AND TaskName = @TaskName AND WorkflowId = @WorkflowId
	for Json auto) as InboxItem FROM InboxItem
	 WHERE [FilterType] = @FILTERTYPE AND UserReferenceId = @USERREFERENCEID AND UserReferenceId = @USERREFERENCEID AND WorkflowId = @WorkflowId
GROUP BY [WorkflowName],WorkflowId

END