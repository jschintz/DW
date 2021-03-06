USE [DataMart]
GO
/****** Object:  View [dbo].[Developer_DataMart_TXN_LoanPaymentDue]    Script Date: 8/24/2020 9:49:52 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



CREATE VIEW [dbo].[Developer_DataMart_TXN_LoanPaymentDue] AS

SELECT [row_id] As [Row Id]
      ,[acctrefno] AS [Acct Ref No]
      ,[payment_reference_no] AS [Payment Reference No]
      ,[late_fee_code] AS [Late Fee Code]
      --,[participant_reference_no] AS 
      --,[impound_id]
      ,[past_due_indicator] AS [Past Due Indicator]
      ,[date_due] As [Date Due]
      ,[payment_number] AS [Payment Number] 
      ,[payment_type] AS [Payment Type]
      ,[payment_amount] AS [Payment amount] 
      ,[payment_description] AS [Payment Description]
      ,[payment_paid] AS [Payment Paid]
      ,[payment_remaining] AS [Payment Remaining]
      ,[transaction_code] AS [Transaction Code]
  FROM [NLS].[dbo].[loanacct_payments_due]
GO
