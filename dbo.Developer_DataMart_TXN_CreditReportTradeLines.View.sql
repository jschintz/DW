USE [DataMart]
GO
/****** Object:  View [dbo].[Developer_DataMart_TXN_CreditReportTradeLines]    Script Date: 8/24/2020 9:49:52 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/****** Script for SelectTopNRows command from SSMS  ******/
CREATE VIEW [dbo].[Developer_DataMart_TXN_CreditReportTradeLines] AS
SELECT 
	[CreditProfile].[CreditProfileID]
      ,[CreditProfile].[cifno]
      ,[CreditProfile].[CreditBureauName]
      ,[CreditProfile].[ReportDate]
      ,[CreditProfile].[ReferenceNumber]
	  ,[CreditTradeLine].[CreditTradeLineID]
      ,[CreditTradeLine].[SpecialComment]
      ,[CreditTradeLine].[Evaluation]
      ,[CreditTradeLine].[OpenDate]
      ,[CreditTradeLine].[StatusDate]
      ,[CreditTradeLine].[MaxDelinquencyDate]
      ,[CreditTradeLine].[AccountType]
      ,[CreditTradeLine].[TermsDuration]
      ,[CreditTradeLine].[ECOA]
      ,[CreditTradeLine].[BalanceDate]
      ,[CreditTradeLine].[BalanceAmount]
      ,[CreditTradeLine].[Status]
      ,[CreditTradeLine].[AmountPastDue]
      ,[CreditTradeLine].[IsClosed]
      ,[CreditTradeLine].[IsRevolving]
      ,[CreditTradeLine].[ConsumerComment]
      ,[CreditTradeLine].[AccountNumber]
      ,[CreditTradeLine].[MonthsHistory]
      ,[CreditTradeLine].[DeliquenciesOver30Days]
      ,[CreditTradeLine].[DeliquenciesOver60Days]
      ,[CreditTradeLine].[DeliquenciesOver90Days]
      ,[CreditTradeLine].[DerogCounter]
      ,[CreditTradeLine].[Collateral]
      ,[CreditTradeLine].[PaymentProfile]
      ,[CreditTradeLine].[MonthlyPaymentAmount]
      ,[CreditTradeLine].[MonthlyPaymentIsEstimated]
      ,[CreditTradeLine].[LastPaymentDate]
      ,[CreditTradeLine].[Subcode]
      ,[CreditTradeLine].[KOB]
      ,[CreditTradeLine].[SubscriberDisplayName]
      ,[CreditTradeLine].[OriginalCreditorName]
      ,[CreditTradeLine].[SoldToName]
      ,[CreditTradeLine].[IsDisputedByConsumer]
      ,[CreditTradeLine].[MaxPaymentCode]
      ,[CreditTradeLine].[FirstDelinquencyDate]
      ,[CreditTradeLine].[SecondDelinquencyDate]
      ,[CreditTradeLine].[InitialPaymentLevelDate]
      ,[CreditTradeLine].[AccountCondition]
      ,[CreditTradeLine].[PaymentStatus]
      ,[CreditTradeLine].[PaymentFrequency]
      ,[CreditTradeLine].[OriginalAmount]
      ,[CreditTradeLine].[HighCreditAmount]
      ,[CreditTradeLine].[CreditLimitAmount]
      ,[CreditTradeLine].[ChargeOffAmount]
      ,[CreditTradeLine].[ClosedDate]
      ,[CreditTradeLine].[DateReported]
      ,[CreditTradeLine].[CreditorNumber]
      ,[CreditTradeLine].[CreditorIndustryCode]
      ,[CreditTradeLine].[CreditorIndustryDescription]
      ,[CreditTradeLine].[ManuallyAddedFlag]
      ,[CreditTradeLine].[ExcludeFlag]
      ,[CreditTradeLine].[UserDefinedComment]
  FROM [NLS].[dbo].[CreditTradeLine]
  JOIN [NLS].[dbo].[CreditProfile] ON [CreditTradeLine].[CreditProfileID]=[CreditProfile].[CreditProfileID]
GO
