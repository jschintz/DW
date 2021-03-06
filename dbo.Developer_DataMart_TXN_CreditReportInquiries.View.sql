USE [DataMart]
GO
/****** Object:  View [dbo].[Developer_DataMart_TXN_CreditReportInquiries]    Script Date: 8/24/2020 9:49:52 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/****** Script for SelectTopNRows command from SSMS  ******/
CREATE VIEW [dbo].[Developer_DataMart_TXN_CreditReportInquiries] AS
SELECT 
	[CreditProfile].[CreditProfileID]
      ,[CreditProfile].[cifno]
      ,[CreditProfile].[CreditBureauName]
      ,[CreditProfile].[ReportDate]
      ,[CreditProfile].[ReferenceNumber]
      ,[CreditInquiry].[CreditInquiryID]
      ,[CreditInquiry].[InquiryDate]
      ,[CreditInquiry].[Amount]
      ,[CreditInquiry].[TypeCode]
      ,[CreditInquiry].[Terms]
      ,[CreditInquiry].[AccountNumber]
      ,[CreditInquiry].[SubCode]
      ,[CreditInquiry].[KOB]
      ,[CreditInquiry].[SubscriberDisplayName]
  FROM [NLS].[dbo].[CreditInquiry]
  JOIN [NLS].[dbo].[CreditProfile] ON [CreditInquiry].[CreditProfileID]=[CreditProfile].[CreditProfileID]
GO
