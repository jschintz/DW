USE [DataMart]
GO
/****** Object:  View [dbo].[Developer_DataMart_FROpportunities]    Script Date: 8/24/2020 9:49:52 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE View [dbo].[Developer_DataMart_FROpportunities] As
SELECT [Id]
      ,[IsDeleted]
	  ,[AccountId]
	  ,[RecordTypeId]
	  ,[Amount]
      --,[Name]
      --,[Description]
      ,[CloseDate]
      ,[CreatedDate]
	  ,[Grant_Name__c] As [Grant Name]
	  ,StageName As [Stage]
	  --,(Select [Name] FROM [CDATA].[SF-FR].[Account] WHERE [Opportunity].[AccountId]=[Account].[Id]) As [Account Name]
      ,(Select [Type] FROM [CDATA].[SF-FR].[Account] WHERE [Opportunity].[AccountId]=[Account].[Id]) As [Account Type]
	  ,(Select [Fundraising_Sector__c] FROM [CDATA].[SF-FR].[Goal__c] WHERE [Opportunity].[Fundraising_Goal__c]=[Goal__c].[Id]) As [Goal Sector]

  FROM [CDATA].[SF-FR].[Opportunity]
  WHERE IsDeleted=0
GO
