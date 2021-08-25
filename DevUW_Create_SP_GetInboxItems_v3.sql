/****** Object:  StoredProcedure [dbo].[GetInboxItems_v2]    Script Date: 8/23/2021 11:33:07 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:      <Author, , Nadun>
-- Create Date: <Create Date, 25/10/2019, >
-- Description: <Description,Get Inbox Items >
-- =============================================

-- [GetInboxItems_v2] 1,7,'Pending',600,'eyJ0ZW5hbnRJZCI6MSwidXNlcklkIjoxM30='

CREATE PROCEDURE [dbo].[GetInboxItems_v3] (@from BIGINT, @to BIGINT, @FILTERTYPE NVARCHAR(25), @WORKFLOWID BIGINT, @USERREFERENCEID NVARCHAR(MAX))
AS
BEGIN 
	SET NOCOUNT ON 
	--IF @STARTROWINDEX = 0
	--BEGIN
		IF @FILTERTYPE = 'All'
		BEGIN
			-- Insert statements for procedure here 

	 WITH Events_CTE ([Id], [UserReferenceId],
	  [Type], [Data], [FilterType], [Date], [WorkflowInstaceId],
	   [TaskId], [CompletedBy], [IdentityValues], [WorkflowEntityInvolvementsJsonString], [WorkflowName], [WorkflowId],
	    [WorkflowInitiatedDataJsonString], [IsDelegated], [DelegationRequestId], [WorkflowCategory], [IsApprovalTask], [ApprovalReferenceId], 
		[IsOutboxItem], [WorkflowCategoryIcon] ,rw)
		 as(
		 		SELECT [Id], [UserReferenceId],
	  [Type], [Data], [FilterType], [Date], [WorkflowInstaceId],
	   [TaskId], [CompletedBy], [IdentityValues], [WorkflowEntityInvolvementsJsonString], [WorkflowName], [WorkflowId],
	    [WorkflowInitiatedDataJsonString], [IsDelegated], [DelegationRequestId], [WorkflowCategory], [IsApprovalTask], [ApprovalReferenceId], 
		[IsOutboxItem], [WorkflowCategoryIcon] ,rw 
				FROM(
					SELECT *,ROW_NUMBER() over(ORDER BY Id DESC)rw
					FROM [dbo].[InboxItem]
					WHERE WorkflowId = @WORKFLOWID
					AND UserReferenceId = @USERREFERENCEID 
					AND [FilterType] != 'Removed' )x WHERE x.rw BETWEEN @from AND @to )
					
SELECT * FROM Events_CTE O
 
		END
		ELSE
		BEGIN
			-- Insert statements for procedure here
		 
		 
			
	 WITH Events_CTE ([Id], [UserReferenceId], [Type], [Data],
	  [FilterType], [Date], [WorkflowInstaceId], [TaskId], [CompletedBy],
	   [IdentityValues], [WorkflowEntityInvolvementsJsonString], [WorkflowName],
		[WorkflowId], [WorkflowInitiatedDataJsonString], [IsDelegated], 
		[DelegationRequestId], [WorkflowCategory], [IsApprovalTask],
		 [ApprovalReferenceId], [IsOutboxItem],[WorkflowCategoryIcon] ,rw)
		 as(
		 		SELECT [Id], [UserReferenceId],
	  [Type], [Data], [FilterType], [Date], [WorkflowInstaceId],
	   [TaskId], [CompletedBy], [IdentityValues], [WorkflowEntityInvolvementsJsonString], [WorkflowName], [WorkflowId],
	    [WorkflowInitiatedDataJsonString], [IsDelegated], [DelegationRequestId], [WorkflowCategory], [IsApprovalTask], [ApprovalReferenceId], 
		[IsOutboxItem], [WorkflowCategoryIcon] ,rw 
				FROM(
					SELECT *,ROW_NUMBER() over(ORDER BY Id DESC)rw
					FROM [dbo].[InboxItem]
					WHERE 
					 FilterType = @FILTERTYPE 
					And WorkflowId = @WORKFLOWID
					AND UserReferenceId = @USERREFERENCEID 
					AND [FilterType] != 'Removed'
			
					)x WHERE x.rw BETWEEN @from AND @to )
					
SELECT * FROM Events_CTE O 
 
		END
	--END

	--ELSE
	--BEGIN
	--	IF @FILTERTYPE = 'All'
	--	BEGIN
	--		-- Insert statements for procedure here
	--		SELECT TOP (@MAXIMUMROWS)
	--			*
	--	 	FROM [dbo].[InboxItem]
	--		WHERE Id < @STARTROWINDEX
	--		AND WorkflowId = @WORKFLOWID
	--		AND UserReferenceId = @USERREFERENCEID
	--	    AND [FilterType] != 'Removed'
	--		ORDER BY Id DESC
	--	END
	--	ELSE
	--	BEGIN
	--		-- Insert statements for procedure here
	--		SELECT TOP (@MAXIMUMROWS)
	--			*
	--		FROM [dbo].[InboxItem]
	--		WHERE FilterType = @FILTERTYPE
	--		AND Id < @STARTROWINDEX
	--		AND WorkflowId = @WORKFLOWID
	--		AND UserReferenceId = @USERREFERENCEID
	--		AND [FilterType] != 'Removed'
	--		ORDER BY Id DESC
	--	END
	--END


END
