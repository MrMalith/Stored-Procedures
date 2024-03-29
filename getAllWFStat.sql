/****** Object:  StoredProcedure [dbo].[GetWorkflowsListWithStatusCount]    Script Date: 11/1/2021 10:02:51 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:      <Author, , Malith>
-- Create Date: <Create Date, , 10.31.2021>
-- Description: <Description, ,GetWorkflowsListWithStatusCount >
-- =============================================
ALTER PROCEDURE [dbo].[GetWorkflowsListWithStatusCount]
(
    @tenantId BIGINT
)
AS
BEGIN
	declare @result NVarchar(max);
    SET NOCOUNT ON
	

--Create Table #WorkflowResultListTempTable (
--    WorkflowId bigint, WorkflowName nvarchar(max), PendingCount bigint, CompletedCount bigint, FailedCount bigint, ExecutionTime bigint
--);

--Create Table #WorkflowStatusTempTable (
--    WorkflowID bigint, WorkflowName nvarchar(max), CurrentStatus nvarchar(MAX), ExecutionTime bigint
--);

----insert into #WorkflowResultListTempTable
----select w.ID,w.WorkflowName from Workflow w
----	WHERE w.TenantId = @tenantId
----	AND w.ID IN (
----		SELECT WorkflowID FROM WorkflowVersion v WHERE v.Validity = 1
----	)

--insert into #WorkflowStatusTempTable
----SET @result = 
--select top 100 wv.WorkflowID, w.WorkflowName, wi.CurrentStatus, wi.ExecutionTime from Workflow w
--	inner join WorkflowVersion wv on wv.WorkflowID = w.ID
--	inner join WorkflowInstance wi on wv.ID = wi.WorkflowVersionID
--	WHERE 
--		w.TenantId = 1 AND 
--		w.ID IN (
--			SELECT WorkflowID FROM WorkflowVersion v WHERE v.Validity = 1
--		)
--	order by wv.WorkflowID desc

--SELECT
--	* from #WorkflowStatusTempTable for json auto
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

SET @result = (SELECT * FROM #WorkflowResultListTempTable res order by res.WorkflowId desc FOR JSON AUTO)

DROP TABLE #WorkflowsWithExecTimeTempTable
drop table #WorkflowsWithStatusCountTempTable
DROP TABLE #WorkflowResultListTempTable

SELECT
	@result
END
