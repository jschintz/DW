USE [DataMart]
GO
/****** Object:  View [dbo].[Developer_DataMart_Report_TB-AllTime-Chargeoff]    Script Date: 8/24/2020 9:49:52 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE VIEW [dbo].[Developer_DataMart_Report_TB-AllTime-Chargeoff] AS
SELECT  
	Developer_DataMart_LoanDailyTrialBalance.[Date of Trial Balance]
	  ,[Developer_DataMart_LoanDailyTrialBalance].[Acct Ref No]
	  ,Developer_DataMart_AllAccounts_LoansRestructures.[CIF No]
	  ,Developer_DataMart_AllAccounts_LoansRestructures.[Restructured Acct Ref No]
      ,Developer_DataMart_AllAccounts_LoansRestructures.[ChargeOff Date]
      ,Developer_DataMart_AllAccounts_LoansRestructures.[ChargeOff Amount]
      ,Developer_DataMart_LoanDailyTrialBalance.[Eff Days Past Due]
      ,Developer_DataMart_LoanDailyTrialBalance.[Eff  Days Past Due Grouped]
      ,Developer_DataMart_LoanDailyTrialBalance.[Eff Outstanding $ Balance]
      ,Developer_DataMart_LoanDailyTrialBalance.[Eff  Outstanding $ Principal]
      ,Developer_DataMart_LoanDailyTrialBalance.[Eff Active Loan]
      ,Developer_DataMart_LoanDailyTrialBalance.[GL Days Past Due]
      ,Developer_DataMart_LoanDailyTrialBalance.[GL  Days Past Due Grouped]
      ,Developer_DataMart_LoanDailyTrialBalance.[GL Outstanding $ Balance]
      ,Developer_DataMart_LoanDailyTrialBalance.[GL  Outstanding $ Principal]
      ,Developer_DataMart_LoanDailyTrialBalance.[GL Active Loan]
	  ,Developer_DataMart_ParentLoans.[NumParents] AS [Restructure Num of Parents]
      ,Developer_DataMart_ParentLoans.[Parent List] AS [Restructure Acctrefno Parent List]
      ,Developer_DataMart_ParentLoans.[Immediate Parent] AS [Restructure Immediate Acctrefno Parent] 
      ,Developer_DataMart_ParentLoans.[Original Parent] AS [Restructure Original Acctrefno Parent]
  FROM [Developer_DataMart_LoanDailyTrialBalance]
JOIN [Developer_DataMart_AllAccounts_LoansRestructures] ON Developer_DataMart_AllAccounts_LoansRestructures.[Acct Ref No]= Developer_DataMart_LoanDailyTrialBalance.[Acct Ref No]
LEFT JOIN [Developer_DataMart_ParentLoans] ON Developer_DataMart_LoanDailyTrialBalance.[Acct Ref No]=Developer_DataMart_ParentLoans.[Acct Ref No]
GO
