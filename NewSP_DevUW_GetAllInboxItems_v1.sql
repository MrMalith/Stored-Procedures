/****** Object:  StoredProcedure [dbo].[GetAllInboxItems_v1]    Script Date: 8/28/2021 2:31:30 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:      <Author, , Malith>
-- Create Date: <Create Date, 27/08/2021 >
-- Description: <Description,Get Inbox Items >
-- =============================================


CREATE PROCEDURE [dbo].[GetAllInboxItems_v1] (@FILTERTYPE NVARCHAR(25), @WORKFLOWID BIGINT, @USERREFERENCEID NVARCHAR(MAX))
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
		[IsOutboxItem], [WorkflowCategoryIcon],[TransferedTo],[TaskName] ,rw)
		 as(
		 		SELECT *
				FROM(
					SELECT *,ROW_NUMBER() over(ORDER BY Id DESC)rw
					FROM [dbo].[InboxItem]
					WHERE WorkflowId = @WORKFLOWID
					AND UserReferenceId = @USERREFERENCEID 
					AND [FilterType] != 'Removed' )x)
					
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
		 [ApprovalReferenceId], [IsOutboxItem],[WorkflowCategoryIcon],[TransferedTo],[TaskName] ,rw)
		 as(
		 		SELECT * 
				FROM(
					SELECT *,ROW_NUMBER() over(ORDER BY Id DESC)rw
					FROM [dbo].[InboxItem]
					WHERE 
					 FilterType = @FILTERTYPE 
					And WorkflowId = @WORKFLOWID
					AND UserReferenceId = @USERREFERENCEID 
					AND [FilterType] != 'Removed'
			
					)x)
					
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