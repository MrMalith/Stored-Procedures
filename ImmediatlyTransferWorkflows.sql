/****** Object:  StoredProcedure [dbo].[ImmediatlyTransferWorkflows]    Script Date: 9/8/2020 4:09:14 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:      <Author, , Malith>
-- Create Date: <Create Date, 19/08/2020 >********************
-- Description: <Description, Immediatly assign workflows >
-- =============================================
CREATE PROCEDURE [dbo].[ImmediatlyTransferWorkflows]
(
    @UserReferenceId NVARCHAR(MAX),
	@CoveringPerson NVARCHAR(MAX),
	--@Result NVARCHAR(MAX),
	--@Result2 NVARCHAR(MAX),
	@WorkflowId BIGINT
)
AS
IF @WorkflowId=0
BEGIN
    SET NOCOUNT ON
    --SET @Result = (SELECT * FROM InboxItem WHERE UserReferenceId=@UserReferenceId AND 
		--FilterType = 'Pending' order by Id desc)

	Update InboxItem set FilterType = 'Removed',
	                     TransferedTo = @CoveringPerson 
						 WHERE UserReferenceId=@UserReferenceId AND 
						 FilterType = 'Pending'
END

ELSE
BEGIN
    SET NOCOUNT ON
	--SELECT * FROM InboxItem WHERE UserReferenceId = @UserReferenceId AND 
	--WorkflowId = @WorkflowId AND FilterType = 'Pending' order by Id desc
	Update InboxItem set FilterType = 'Removed',
	                     TransferedTo=@CoveringPerson 
						 WHERE UserReferenceId = @UserReferenceId AND 
						 WorkflowId = @WorkflowId AND FilterType = 'Pending'
END
BEGIN
    SELECT * FROM InboxItem WHERE UserReferenceId=@UserReferenceId AND 
		FilterType = 'Pending'
END
	

GO

