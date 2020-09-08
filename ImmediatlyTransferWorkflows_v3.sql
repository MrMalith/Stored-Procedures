/****** Object:  StoredProcedure [dbo].[ImmediatlyTransferWorkflows_v3]    Script Date: 9/8/2020 4:08:39 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:      <Author, Malith>
-- Create Date: <Create Date, , >
-- Description: <Description, , >
-- =============================================
CREATE PROCEDURE [dbo].[ImmediatlyTransferWorkflows_v3]
(
    @ReferenceId NVARCHAR(MAX),
	@CoveringPerson NVARCHAR(MAX),
	@workflowId BIGINT,
	@DelegationRequestId BIGINT
)
AS
IF @WorkflowId=0
BEGIN
	
	DECLARE @isDelegated as bit
	SET @isDelegated = 1
	--set @isDelegated = 1
	DECLARE @filterType as nvarchar(20)
	SET @filterType = 'Pending'
	--SET @filterType = 'Pending'
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

			SELECT @CoveringPerson,
			[Type],
			[Data],
			@filterType,
			[Date],
			WorkflowInstaceId,
			TaskId,
			CompletedBy,
			IdentityValues,
			WorkflowEntityInvolvementsJsonString,
			WorkflowName,
			WorkflowId,
			WorkflowInitiatedDataJsonString,
			@isDelegated,
			@DelegationRequestId,
			WorkflowCategory,
			IsApprovalTask,
			ApprovalReferenceId,
			IsOutboxItem,
			WorkflowCategoryIcon,
			@CoveringPerson
			FROM InboxItem
			WHERE FilterType='Pending' AND UserReferenceId = @ReferenceId
	END
	BEGIN
		Update InboxItem set FilterType = 'Removed',
										 TransferedTo = @coveringPerson 
										 WHERE UserReferenceId=@ReferenceId AND 
										 FilterType = 'Pending'
	END
		BEGIN
			SELECT * FROM InboxItem WHERE UserReferenceId=@ReferenceId AND 
				FilterType = 'Removed'
		END
END
ELSE
	DECLARE @isDelegated2 as bit
	SET @isDelegated2 = 1
	DECLARE @filterType2 as nvarchar(20)
	SET @filterType2 = 'Pending'
	BEGIN
			INSERT INTO #tempUserPending(
			UserReferenceId,
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

			SELECT *
			FROM InboxItem
			WHERE FilterType ='Pending' AND UserReferenceId = @ReferenceId AND WorkflowId=@workflowId
	END
	
	BEGIN
			INSERT INTO #tempCoveringPersonPending(
			UserReferenceId,
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

			SELECT *
			FROM InboxItem
			WHERE FilterType ='Pending' AND UserReferenceId = @CoveringPerson AND WorkflowId=@workflowId	
	END
	BEGIN
			INSERT INTO #tempFinalPending(
			UserReferenceId,
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
				u.*
				FROM #tempUserPending u
			WHERE NOT EXISTS(SELECT NULL
							FROM #tempCoveringPersonPending c
							WHERE u.TaskId = c.TaskId AND u.WorkflowInstaceId = c.WorkflowInstaceId)

		END
			--SELECT 
			--	UserReferenceId,
			--	[Type],
			--	[Data],
			--	FilterType,
			--	[Date],
			--	WorkflowInstaceId,
			--	TaskId,
			--	CompletedBy,
			--	IdentityValues,
			--	WorkflowEntityInvolvementsJsonString,
			--	WorkflowName,
			--	WorkflowId,
			--	WorkflowInitiatedDataJsonString,
			--	IsDelegated,
			--	DelegationRequestId,
			--	WorkflowCategory,
			--	IsApprovalTask,
			--	ApprovalReferenceId,
			--	IsOutboxItem,
			--	WorkflowCategoryIcon,
			--	TransferedTo
			--FROM #tempUserPending, #tempCoveringPersonPending
			--WHERE #tempUserPending.WorkflowId = #tempCoveringPersonPending.WorkflowId
			--AND #tempUserPending.WorkflowInstaceId != #tempCoveringPersonPending.WorkflowInstaceId

			--ALTER TABLE #tempFinalPending
			--DROP COLUMN Id

	--BEGIN
	--		INSERT INTO InboxItem(UserReferenceId,
	--		[Type],
	--		[Data],
	--		FilterType,
	--		[Date],
	--		WorkflowInstaceId,
	--		TaskId,
	--		CompletedBy,
	--		IdentityValues,
	--		WorkflowEntityInvolvementsJsonString,
	--		WorkflowName,
	--		WorkflowId,
	--		WorkflowInitiatedDataJsonString,
	--		IsDelegated,
	--		DelegationRequestId,
	--		WorkflowCategory,
	--		IsApprovalTask,
	--		ApprovalReferenceId,
	--		IsOutboxItem,
	--		WorkflowCategoryIcon,
	--		TransferedTo)

	--		SELECT @CoveringPerson,
	--		[Type],
	--		[Data],
	--		@filterType2,
	--		[Date],
	--		WorkflowInstaceId,
	--		TaskId,
	--		CompletedBy,
	--		IdentityValues,
	--		WorkflowEntityInvolvementsJsonString,
	--		WorkflowName,
	--		WorkflowId,
	--		WorkflowInitiatedDataJsonString,
	--		@isDelegated2,
	--		@DelegationRequestId,
	--		WorkflowCategory,
	--		IsApprovalTask,
	--		ApprovalReferenceId,
	--		IsOutboxItem,
	--		WorkflowCategoryIcon,
	--		@CoveringPerson
	--		FROM #tempFinalPending
	--		WHERE FilterType='Pending' AND UserReferenceId = @ReferenceId AND WorkflowId=@workflowId
	--END
	--BEGIN
	--	Update InboxItem set FilterType = 'Removed',
	--									 TransferedTo = @coveringPerson 
	--									 WHERE UserReferenceId=@ReferenceId AND 
	--									 FilterType = 'Pending' AND
	--									 WorkflowId= @workflowId
	--END
	--BEGIN
	--	SELECT * FROM InboxItem WHERE UserReferenceId=@ReferenceId AND 
	--		FilterType = 'Removed' AND
	--		WorkflowId = @workflowId
	--END

	--  exec [ImmediatlyTransferWorkflows_v3] 'eyJ0ZW5hbnRJZCI6MSwidXNlcklkIjoyMjB9',999,'eyJ0ZW5hbnRJZCI6MSwidXNlcklkIjoyMjl9',425
GO

