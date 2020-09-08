/****** Object:  StoredProcedure [dbo].[ImmediatlyTransferWorkflows_v4]    Script Date: 9/8/2020 4:08:22 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:      <Author, Malith>
-- Create Date: <Create Date, 09,07 >
-- Description: <Description, ImmediatlyTransferWorkflows_v4 >
-- =============================================
CREATE PROCEDURE [dbo].[ImmediatlyTransferWorkflows_v4]
(
    @ReferenceId NVARCHAR(MAX),
	@CoveringPerson NVARCHAR(MAX),
	@workflowId BIGINT,
	@DelegationRequestId BIGINT
)
AS
BEGIN
    SET NOCOUNT ON
	DECLARE @isDelegated2 as bit
	SET @isDelegated2 = 1
	DECLARE @filterType2 as nvarchar(20)
	SET @filterType2 = 'Pending'

	select * 
	into #tempUserPending
	from InboxItem
			WHERE FilterType ='Pending' AND UserReferenceId = @ReferenceId AND WorkflowId=@workflowId

			--Select * from #tempUserPending
	
	select * 
	into #tempCoveringPersonPending
	from InboxItem
			WHERE FilterType ='Pending' AND UserReferenceId = @CoveringPerson AND WorkflowId=@workflowId
	
	--Select * from #tempCoveringPersonPending
	BEGIN
			INSERT INTO InboxItem(UserReferenceId,
			[Type],
			[Data],
			FilterType,
			[Date],
			WorkflowInstaceId,
			TaskId,
			CompletedBy,
			IdentityValues,
			WorkflowEntityInvolvementsJsonString,
			WorkflowName,
			WorkflowId,
			WorkflowInitiatedDataJsonString,
			IsDelegated,
			DelegationRequestId,
			WorkflowCategory,
			IsApprovalTask,
			ApprovalReferenceId,
			IsOutboxItem,
			WorkflowCategoryIcon,
			TransferedTo)

		SELECT
			@CoveringPerson,
			u.[Type],
			u.[Data],
			@filterType2,
			u.[Date],
			u.WorkflowInstaceId,
			u.TaskId,
			u.CompletedBy,
			u.IdentityValues,
			u.WorkflowEntityInvolvementsJsonString,
			u.WorkflowName,
			u.WorkflowId,
			u.WorkflowInitiatedDataJsonString,
			@isDelegated2,
			@DelegationRequestId,
			u.WorkflowCategory,
			u.IsApprovalTask,
			u.ApprovalReferenceId,
			u.IsOutboxItem,
			u.WorkflowCategoryIcon,
			@CoveringPerson
			FROM #tempUserPending u
		WHERE NOT EXISTS(SELECT NULL
						FROM #tempCoveringPersonPending c
						WHERE u.TaskId = c.TaskId AND u.WorkflowInstaceId = c.WorkflowInstaceId)
	END
	BEGIN
		Update InboxItem set FilterType = 'Removed',
										 TransferedTo = @coveringPerson 
										 WHERE UserReferenceId=@ReferenceId AND 
										 FilterType = 'Pending' AND
										 WorkflowId= @workflowId
	END
	BEGIN
		SELECT * FROM InboxItem WHERE UserReferenceId=@ReferenceId AND 
			FilterType = 'Removed' AND
			WorkflowId = @workflowId
	END
END
GO

