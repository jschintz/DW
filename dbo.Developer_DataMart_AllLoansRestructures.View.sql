USE [DataMart]
GO
/****** Object:  View [dbo].[Developer_DataMart_AllLoansRestructures]    Script Date: 8/24/2020 9:49:52 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO




CREATE VIEW [dbo].[Developer_DataMart_AllLoansRestructures] AS
SELECT  
		loanacct.acctrefno As [Acct Ref No]
		,loanacct.loan_number as [Loan Number]
		,loanacct.[cifno] AS [CIF No]
		,CASE WHEN restructured_acctrefno = 0 THEN NULL ELSE restructured_acctrefno  END AS [Restructured Acct Ref No]
		,NULLIF((	select	case
								when l1.payoff_date < '04/01/2012'
								then ISNULL(ld1.userdef37,'')
								else (	SELECT	ISNULL(CONVERT(varchar(10), MAX(gl_date), 101),'')
										FROM	NLS.dbo.loanacct_trans_history 
										WHERE	acctrefno = l1.acctrefno 
												AND acctrefno in (	select	acctrefno
																	from NLS.dbo.loanacct_statuses 
																	where status_code_no = 12)
												AND transaction_code IN (440, 441, 444, 445, 448, 449, 452, 453, 470, 471, 472, 473, 474, 475, 476, 477, 478, 479, 480, 481, 482, 483, 484, 485, 486, 487, 488, 489))
							end
					from	NLS.dbo.loanacct l1 ,
							NLS.dbo.loanacct_detail ld1 
					where	l1.acctrefno = ld1.acctrefno and loanacct.acctrefno = l1.acctrefno /* Join on clauses between subquery and parent */
							),'') as [ChargeOff Date]
		,NULLIF(CAST(ROUND((	select	case
								when l1.payoff_date < '04/01/2012'
								then ISNULL(ld1.userdef36,'')
								else (	SELECT	ISNULL(CAST(SUM(	CASE	
																		WHEN CAST(loanacct_trans_history.transaction_code AS INT) % 2 > 0 
																		THEN -loanacct_trans_history.transaction_amount 
																		ELSE loanacct_trans_history.transaction_amount 
																	END) as varchar(25)), '')
										FROM	NLS.dbo.loanacct_trans_history 
										WHERE	acctrefno = l1.acctrefno /* Join on clauses between subquery and parent */
												AND CAST(CONVERT(varchar(10), gl_date, 101) as datetime) in (	select	MAX(gl_date)
																												from	NLS.dbo.loanacct_trans_history 
																												where	acctrefno = l1.acctrefno )
												AND acctrefno in (	select	acctrefno
																	from NLS.dbo.loanacct_statuses 
																	where status_code_no = 12)
												AND transaction_code IN (440, 441, 444, 445, 448, 449, 452, 453, 470, 471, 472, 473, 474, 475, 476, 477, 478, 479, 480, 481, 482, 483, 484, 485, 486, 487, 488, 489))
							end
					from	NLS.dbo.loanacct l1 ,
							NLS.dbo.loanacct_detail ld1 
					where	l1.acctrefno = ld1.acctrefno and loanacct.acctrefno = l1.acctrefno /* Join on clauses between subquery and parent */
					), 2) as decimal(15,2)),0) as [ChargeOff Amount]
FROM NLS.dbo.loanacct 
GO
