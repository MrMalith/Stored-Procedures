
--USE [DevStProt_admin]


INSERT INTO [dbo].[App]
           ([Name]
           ,[Description]
           ,[Version]
           ,[TenantId]
           ,[InternalAppId]
           ,[InternalAppData]
           ,[Swagger]
           ,[AuthenticationType]
           ,[Icon]
           ,[ThemeColor])
     VALUES
           ('Doc Gen'
           ,'Document Generator'
           ,'1'
           ,NULL
           ,'doc-gen'
           ,NULL
           ,NULL
           ,'NoAuth'
           ,NULL
           ,'#F6FBFF')

DECLARE @AppId int
SET @AppId = select ID from [dbo].[App]

INSERT INTO [dbo].[Action] 
			([AppID],
			[Name],
			[Description],
			[Path],
			[HTTPVerb],
			[JsonContent],
			[Summary],
			[Host],
			[AuthenticationData],
			[DynamicInputActionId]) 
VALUES 
		  (@AppId,
		  'Generate Document',
		  'Generate Document' ,
		  '/api/Template/generateDocument',
		  'POST',
		   NULL, 
		  'For generating document', 
		  'https://docgendev.azurewebsites.net',
		   NULL,
		   NULL) 

INSERT INTO [dbo].[AuthenticationData]
           ([AuthenticationType]
           ,[BasicUsernameKey]
           ,[BasicUsernameValue]
           ,[BasicPasswordKey]
           ,[BasicPasswordValue]
           ,[ApiKeyKey]
           ,[ApiKeyValue]
           ,[ApiKeyInHeader]
           ,[OAuth2ClientId]
           ,[OAuth2ClientSecret]
           ,[OAuth2AuthUrl]
           ,[OAuth2TokenUrl]
           ,[OAuth2RefreshUrl]
           ,[OAuth2RedirectUrl]
           ,[OAuth2Scopes]
           ,[AppId])
     VALUES
           ('NoAuth',
		   NULL,
		   NULL,
		   NULL,
		   NULL,
		   NULL,
		   NULL,
		   NULL,
		   NULL,
		   NULL,
		   NULL,
		   NULL,
		   NULL,
		   NULL,
		   NULL,
		   @AppId)
