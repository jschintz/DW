USE [DataMart]
GO
/****** Object:  View [dbo].[Developer_DataMart_Report_TB-EOM-Chargeoff]    Script Date: 8/24/2020 9:49:52 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE VIEW [dbo].[Developer_DataMart_Report_TB-EOM-Chargeoff] AS
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
  WHERE   Developer_DataMart_LoanDailyTrialBalance.[Date of Trial Balance] IN (
    SELECT   MAX(Developer_DataMart_LoanDailyTrialBalance.[Date of Trial Balance])
    FROM     [Developer_DataMart_LoanDailyTrialBalance]
	WHERE Developer_DataMart_LoanDailyTrialBalance.[Date of Trial Balance]<dateadd(d,-(day(getdate())),getdate())  -- Remove any date efore the end of last month
    GROUP BY MONTH(Developer_DataMart_LoanDailyTrialBalance.[Date of Trial Balance]), YEAR(Developer_DataMart_LoanDailyTrialBalance.[Date of Trial Balance]) -- Get the max date within each month/year combo
  ) AND Developer_DataMart_LoanDailyTrialBalance.[Date of Trial Balance]>='2014-1-1'  --Only query loans since 2014
  --ORDER BY DataMart_LoanDailyTrialBalance.[Date of Trial Balance] ASC
GO
