/****** Object:  StoredProcedure [dbo].[GetWorkflowsListWithStatusCount_v2]    Script Date: 11/4/2021 10:29:08 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:      <Author, , Malith>
-- Create Date: <Create Date, , 2.11.2021>
-- Description: <Description, ,GetWorkflowsListWithStatusCountv2 >
-- =============================================
ALTER PROCEDURE [dbo].[GetWorkflowsListWithStatusCount_v2]
(
    @tenantId BIGINT,
	@PageNumber BIGINT,
	@RowsOfPage BIGINT
)
AS
BEGIN
	declare @result NVarchar(max);
	declare @count BIGINT;
    SET NOCOUNT ON
Create Table #WorkflowsWithExecTimeTempTable (
    WorkflowId bigint, WorkflowName nvarchar(max), ExecutionTime bigint, CategoryID bigint
);
Create Table #WorkflowsWithStatusCountTempTable (
    WorkflowId bigint, CurrentStatus nvarchar(max), ItemCount bigint
);
Create Table #WorkflowResultListTempTable (
    WorkflowId bigint, WorkflowName nvarchar(max), PendingCount bigint, CompletedCount bigint, FailedCount bigint, ExecutionTime bigint, Category nvarchar(max)
);

insert into #WorkflowsWithExecTimeTempTable
select Distinct wv.WorkflowID, w.WorkflowName, AVG(wi.ExecutionTime) AS AverageExecutionTime, w.CategoryId
from Workflow w
inner join WorkflowVersion wv on wv.WorkflowID = w.ID
inner join WorkflowInstance wi on wv.ID = wi.WorkflowVersionID
WHERE w.TenantId = 1 AND w.ID IN (SELECT WorkflowID FROM WorkflowVersion v WHERE v.Validity = 1)
group by wv.WorkflowID, w.WorkflowName, w.CategoryId
order by wv.WorkflowID desc

insert into #WorkflowsWithStatusCountTempTable
select wv.WorkflowID, wi.CurrentStatus, count(*) as itemCount
from Workflow w
inner join WorkflowVersion wv on wv.WorkflowID = w.ID
inner join WorkflowInstance wi on wv.ID = wi.WorkflowVersionID
WHERE w.TenantId = 1 AND w.ID IN (SELECT WorkflowID FROM WorkflowVersion v WHERE v.Validity = 1)
group by wi.CurrentStatus, wv.WorkflowID
order by wv.WorkflowID desc

insert into #WorkflowResultListTempTable
select wfex.WorkflowId, 
wfex.WorkflowName,
(select wfst.ItemCount from #WorkflowsWithStatusCountTempTable wfst where wfst.CurrentStatus = 'Halt' and wfst.WorkflowId = wfex.WorkflowId),
(select wfst.ItemCount from #WorkflowsWithStatusCountTempTable wfst where wfst.CurrentStatus = 'Completed' and wfst.WorkflowId = wfex.WorkflowId),
(select wfst.ItemCount from #WorkflowsWithStatusCountTempTable wfst where wfst.CurrentStatus = 'Failed' and wfst.WorkflowId = wfex.WorkflowId),
wfex.ExecutionTime,
(select wfcat.Icon from WorkflowCategory wfcat where wfcat.Id = wfex.CategoryID)
from #WorkflowsWithExecTimeTempTable wfex

SET @count = (SELECT COUNT(DISTINCT WorkflowId) + MAX(CASE WHEN WorkflowId IS NULL THEN 1 ELSE 0 END)
FROM #WorkflowResultListTempTable);

SET @result = (SELECT * FROM #WorkflowResultListTempTable res order by res.WorkflowId desc
OFFSET(@PageNumber-1)*@RowsOfPage ROWS
FETCH NEXT @RowsOfPage ROWS ONLY FOR JSON AUTO)

DROP TABLE #WorkflowsWithExecTimeTempTable
DROP TABLE #WorkflowsWithStatusCountTempTable
DROP TABLE #WorkflowResultListTempTable

SELECT
	@result,@count as total
	return;
END
