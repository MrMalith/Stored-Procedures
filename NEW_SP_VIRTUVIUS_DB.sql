/****** Object:  StoredProcedure [dbo].[GetUserGroupsByIds]    Script Date: 22/03/04 8:35:02 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:      <Malith>
-- Create Date: <2022.3.3>
-- =============================================
CREATE PROCEDURE [dbo].[GetUserGroupsByIds](@JSON NVARCHAR(MAX))
AS
BEGIN

	DECLARE @RESULT NVARCHAR(MAX)

	SET @RESULT = (
	SELECT UG.Id,UG.[Name],UG.TenentId,
	ISNULL((SELECT UserReferenceId FROM UserGroupUser WHERE UserGroupId = X.Id FOR JSON AUTO),'[]') AS 'Users'
	FROM [dbo].[UserGroup] UG
	INNER JOIN
			(SELECT Id
			FROM OPENJSON(@JSON)
			WITH(
				Id NVARCHAR(MAX) '$'
			))X
	ON UG.Id = X.Id
	FOR JSON AUTO
	)

	SELECT @RESULT
END
GO

