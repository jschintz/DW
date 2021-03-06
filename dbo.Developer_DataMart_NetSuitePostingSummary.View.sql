USE [DataMart]
GO
/****** Object:  View [dbo].[Developer_DataMart_NetSuitePostingSummary]    Script Date: 8/24/2020 9:49:52 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
Create VIEW [dbo].[Developer_DataMart_NetSuitePostingSummary] AS
SELECT 
		(Select [PeriodName] from [CDATA].[NetSuite].[AccountingPeriod] WHERE [InternalId]=[Period_InternalId]) As [Month-Year]
	  ,(Select [AcctType] from [CDATA].[NetSuite].[Account] WHERE [InternalId]=[Account_InternalId]) AS [Account Type]
	  ,(Select [AcctName] from [CDATA].[NetSuite].[Account] WHERE [InternalId]=[Account_InternalId]) AS [Account Name]
      ,[Entity_InternalId]
	  ,(SELECT Name FROM [CDATA].[NetSuite].[Department] WHERE [Department_InternalId]=[InternalId]) As Department 
      ,(Select [Name] from [CDATA].[NetSuite].[Classification] WHERE [InternalId]=[Class_InternalId]) As [Class]
      --,(Select [PostingTransactionSummary].[Location_InternalId] ) As [Location]
      ,[OriginalAmount]
  FROM [CDATA].[NetSuite].[PostingTransactionSummary]
GO
