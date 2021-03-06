USE [DataMart]
GO
/****** Object:  View [dbo].[Developer_DataMart_TXN_LoanTransactions]    Script Date: 8/24/2020 9:49:52 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



/****** Script for SelectTopNRows command from SSMS  ******/
CREATE View [dbo].[Developer_DataMart_TXN_LoanTransactions] AS

SELECT 
	[transrefno] AS [ID]
      ,[acctrefno] AS [Acct Ref No]
      ,[transaction_reference_no] AS [Transaction Reference No]
      ,[transaction_code]  AS [Transaction Code]
      ,CASE [reversal_transrefno] When 0 then Null ELSE [reversal_transrefno] END AS [Reversal Reference No]
      ,[loan_group_no] AS [Loan Group No]
      ,[transaction_date] AS [Transaction Date]
      ,[effective_date] AS [Effective Date]
	  ,[date_due] AS [Date Due]
	  ,[gl_date] AS [GL Date]
      ,CASE [batch_no]  When 0 then Null ELSE [batch_no]  END As [Batch No]
	  ,(Select [payment_method_code] from	NLS.dbo.loan_payment_method  WHERE loan_payment_method.[payment_method_no]=[loanacct_trans_history].[payment_method_no])AS [Loan Payment Method]
      ,[transaction_amount] AS [Transaction Amount]
	  ,SUBSTRING(transaction_type, 4, 2) AS [Credit-Debit]
	  ,Case WHEN SUBSTRING(transaction_type, 4, 1)='C' Then [transaction_amount] END AS [Credits]
	  ,Case WHEN SUBSTRING(transaction_type, 4, 1)='D' Then [transaction_amount] END AS [Dedits]
	  ,CASE Left([transaction_type],3)
		WHEN ' ' then '' 
		WHEN 'AIA'	THEN 'Admin Fee Amortization'
		WHEN 'AIT'	THEN 'Admin Fee Setup'
		WHEN 'F'	THEN 'Fee' 
		WHEN 'I'	THEN 'Interest'  
		WHEN 'L'	THEN 'Late Fee'  
		WHEN 'LA'	THEN 'Loan Advance' 
		WHEN 'N'	THEN 'Billing'  
		WHEN 'P'	THEN 'Principal'  
		WHEN 'S'	THEN 'Suspense' 
		WHEN 'SF'	THEN 'Servicing fee'
		WHEN 'U1'	THEN 'Process Server'
		WHEN 'U2'	THEN 'Court Costs'
		WHEN 'U3'	THEN 'Repo'
		WHEN 'U4'	THEN 'Sherrif'
		WHEN 'U5'	THEN 'Legal Costs'
		END AS [Transaction Type]
	,[transaction_type] AS [Transaction Type Details]
    ,[transaction_description] AS [Transaction Description]
	,		CASE (Select transaction_classification FROM [NLS].[dbo].[loan_transaction_codes] WHERE [loan_transaction_codes].[transaction_code]=[loanacct_trans_history].[transaction_code])
		WHEN 0 then 'None'
		WHEN 1 then 'Advance'
		WHEN 2 then 'Billing'
		WHEN 3 then 'Payment'
		WHEN 4 then 'Late Fee'
		WHEN 5 then 'Fee'
		WHEN 6 then 'Write Off'
		WHEN 7 then 'Amortized Fee'
		END
		AS [Transaction Classification]
      FROM [NLS].[dbo].[loanacct_trans_history]
GO
