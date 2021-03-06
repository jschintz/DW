USE [DataMart]
GO
/****** Object:  View [dbo].[Developer_DataMart_RestructuresLoan]    Script Date: 8/24/2020 9:49:52 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO




CREATE VIEW [dbo].[Developer_DataMart_RestructuresLoan] AS
Select 
	loanacct.acctrefno As [Acct Ref No]
		,loanacct.loan_number as [Loan Number]
		,loanacct.[cifno] AS [cifno]
		,loanacct.restructured_acctrefno AS [Restructured Loan Number]
		,loanacct.original_note_amount  as [Original Loan Amount]
		,CAST(ROUND(loanacct.current_payoff_balance, 2) as decimal(15,2)) /* Remove leading and trailing 0s*/  as [Payoff Balance]
		,loanacct_payment.amortized_payment_amount as [Payment Amount]
		,loanacct.current_suspense as LoanCurrentSuspense
		/* Loan Information */
		,loanacct.open_date as [Loan Open Date]
		,loanacct.curr_maturity_date as [Loan Maturity Date]
		,loanacct.payoff_date as [Loan Closed Date]
FROM NLS.dbo.loanacct 
INNER JOIN NLS.dbo.loanacct_detail  ON loanacct.acctrefno = loanacct_detail.acctrefno
INNER JOIN NLS.dbo.loanacct_detail_2  ON loanacct.acctrefno = loanacct_detail_2.acctrefno
INNER JOIN NLS.dbo.loanacct_payment  ON loanacct.acctrefno = loanacct_payment.acctrefno
INNER JOIN NLS.dbo.loanacct_setup  ON loanacct.acctrefno = loanacct_setup.acctrefno
Where loanacct.acctrefno in (	select	l2.restructured_acctrefno	from	NLS.dbo.loanacct l2 )
GO
