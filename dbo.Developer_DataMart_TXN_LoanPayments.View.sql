USE [DataMart]
GO
/****** Object:  View [dbo].[Developer_DataMart_TXN_LoanPayments]    Script Date: 8/24/2020 9:49:52 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



CREATE VIEW [dbo].[Developer_DataMart_TXN_LoanPayments] AS
SELECT			
[row_id]
      ,[acctrefno] AS [Acct Ref No] 
      ,[payment_reference_no] AS [Payment Reference No] 
      ,[transaction_reference_no] AS [Transaction Reference No] 
      ,[date_due] AS [Date Due] 
      ,[date_paid] AS [Date Paid] 
	  ,[gl_date] AS [GL Date] 
      ,[payment_number] AS [Payment Number] 
      ,[payment_type] AS [Payment Type]
      ,[payment_amount] AS [Payment Amount] 
      ,[payment_description] AS [Payment Description] 
      ,[transaction_code] AS [Transaction Code] 
      ,[memoentry] AS [Memo Entry] 
	  ,(Select [payment_method_code] from	NLS.dbo.loan_payment_method  WHERE loan_payment_method.[payment_method_no]=[loanacct_payment_history].[payment_method_no]) As [Loan Payment Method]
      ,[late_fee_code] AS [Late Fee Code] 
      ,[batch_no] AS [Bacth No] 
      ,[nsf_flag] AS [NSF Flag] 
      ,[nsf_date] AS [NSF Date] 
      ,[bulk_payment_id] AS [Bulk Payment Id] 
	  ,[userdef02] AS Repo 
  FROM [NLS].[dbo].[loanacct_payment_history]
GO
