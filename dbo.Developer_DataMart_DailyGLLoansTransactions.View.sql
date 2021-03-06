USE [DataMart]
GO
/****** Object:  View [dbo].[Developer_DataMart_DailyGLLoansTransactions]    Script Date: 8/24/2020 9:49:52 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO







CREATE VIEW [dbo].[Developer_DataMart_DailyGLLoansTransactions] AS
Select 			
acctrefno
, gl_date				
,	(-1.00) *
				(
				ISNULL((	select	SUM(gl.transaction_amount)
							from NLS.dbo.loanacct_gl_trans gl 
							where	gl.gl_debit in (76, 81, 85, 106)
									and gl.gl_date = loanacct_gl_trans.gl_date	
									and gl.acctrefno = loanacct_gl_trans.acctrefno), 0.00)
				-
				ISNULL((	select	SUM(gl.transaction_amount)
							from NLS.dbo.loanacct_gl_trans gl 
							where	gl.gl_credit in (76, 81, 85, 106)
									and gl.gl_date = loanacct_gl_trans.gl_date	
									and gl.acctrefno = loanacct_gl_trans.acctrefno), 0.00)) as ChecksIssued
				-------------------------------------------------------------------------------------
,				(-1.00) *
				(
				ISNULL((	select	SUM(gl.transaction_amount)
							from NLS.dbo.loanacct_gl_trans gl 
							where	gl.gl_debit in (76, 81, 85, 106)
									and gl.gl_date = loanacct_gl_trans.gl_date	
									and gl.acctrefno = loanacct_gl_trans.acctrefno
									and gl.transcode not in (	select	transaction_code
																from	NLS.dbo.loan_transaction_codes 
																where	transaction_classification = 3
																		or transaction_code in (460, 461, 464, 465, 612, 613, 680)
																		or	(
																				transaction_code between 600 and 699
																				and transaction_description like '%Payment%'
																			)
																)), 0.00)
				-
				ISNULL((	select	SUM(gl.transaction_amount)
							from NLS.dbo.loanacct_gl_trans gl 
							where	gl.gl_credit in (76, 81, 85, 106)
									and gl.gl_date = loanacct_gl_trans.gl_date	
									and gl.acctrefno = loanacct_gl_trans.acctrefno
									and gl.transcode not in	(	select	transaction_code
																from	NLS.dbo.loan_transaction_codes 
																where	transaction_classification = 3
																		or transaction_code in (460, 461, 464, 465, 612, 613, 680)
																		or	(
																				transaction_code between 600 and 699
																				and transaction_description like '%Payment%'
																			)
															)), 0.00))  as LoanChecksIssued
																			/*	LoanChecksIssued	*/
				-------------------------------------------------------------------------------------
,				(-1.00) *
				(
				ISNULL((	select	SUM(gl.transaction_amount)
							from NLS.dbo.loanacct_gl_trans gl 
							where	gl.gl_debit in (76, 81, 85, 106)
									and gl.gl_date = loanacct_gl_trans.gl_date 
									and gl.acctrefno = loanacct_gl_trans.acctrefno
									and gl.transcode in (464, 465, 612, 613)), 0.00)
				-
				ISNULL((	select	SUM(gl.transaction_amount)
							from NLS.dbo.loanacct_gl_trans gl 
							where	gl.gl_credit in (76, 81, 85, 106)
									and gl.gl_date = loanacct_gl_trans.gl_date 
									and gl.acctrefno = loanacct_gl_trans.acctrefno
									and gl.transcode in (464, 465, 612, 613)), 0.00)) as RefundChecksIssued
																			/*	RefundChecksIssued	*/
				-------------------------------------------------------------------------------------
,				ISNULL((	select	SUM(gl.transaction_amount)
							from NLS.dbo.loanacct_gl_trans gl 
							where	gl.gl_debit in (76, 81, 85, 106)
									and gl.gl_date = loanacct_gl_trans.gl_date 
									and gl.acctrefno = loanacct_gl_trans.acctrefno
									and gl.transcode in	(	select	transaction_code
															from	NLS.dbo.loan_transaction_codes 
															where	transaction_classification = 3
																	or transaction_code in (460, 461)
																	or	(
																			transaction_code between 600 and 699
																			and transaction_description like '%Payment%'
																		)
														)), 0.00)
				-
				ISNULL((	select	SUM(gl.transaction_amount)
							from NLS.dbo.loanacct_gl_trans gl 
							where	gl.gl_credit in (76, 81, 85, 106)
									and gl.gl_date = loanacct_gl_trans.gl_date 
									and gl.acctrefno = loanacct_gl_trans.acctrefno
									and gl.transcode in (	select	transaction_code
															from	NLS.dbo.loan_transaction_codes 
															where	transaction_classification = 3
																	or transaction_code in (460, 461)
																	or	(
																			transaction_code between 600 and 699
																			and transaction_description like '%Payment%'
																		)
														)), 0.00) as PaymentsDepositedToDisbursmentAcct
																			/*	PaymentsDepositedToDisbursmentAcct	*/
,				ISNULL((	select	SUM(gl.transaction_amount)
							from NLS.dbo.loanacct_gl_trans gl 
							where	gl.gl_debit in (99)
									and gl.gl_date  = loanacct_gl_trans.gl_date
									and gl.acctrefno =  loanacct_gl_trans.acctrefno
									and gl.transcode in (	440, 441, 444, 445, 448, 449, 452, 
															453, 470, 471, 472, 473, 474, 475, 
															476, 477, 478, 479, 480, 481, 482, 
															483, 484, 485, 486, 487, 488, 489)), 0.00)
				-
				ISNULL((	select	SUM(gl.transaction_amount)
							from NLS.dbo.loanacct_gl_trans gl 
							where	gl.gl_credit in (99)
									and gl.gl_date  = loanacct_gl_trans.gl_date
									and gl.acctrefno =  loanacct_gl_trans.acctrefno
									and gl.transcode in (	440, 441, 444, 445, 448, 449, 452, 
															453, 470, 471, 472, 473, 474, 475, 
															476, 477, 478, 479, 480, 481, 482, 
															483, 484, 485, 486, 487, 488, 489)), 0.00) as WriteOffPaidTotal,
																			/*	WriteOffPaidTotal	*/
				-------------------------------------------------------------------------------------
				ISNULL((	select	SUM(gl.transaction_amount)
							from NLS.dbo.loanacct_gl_trans gl 
							where	gl.gl_debit in (99)
									and gl.gl_date  = loanacct_gl_trans.gl_date
									and gl.acctrefno =  loanacct_gl_trans.acctrefno
									and gl.transcode in (	440, 441)), 0.00)
				-
				ISNULL((	select	SUM(gl.transaction_amount)
							from NLS.dbo.loanacct_gl_trans gl 
							where	gl.gl_credit in (99)
									and gl.gl_date  = loanacct_gl_trans.gl_date
									and gl.acctrefno =  loanacct_gl_trans.acctrefno
									and gl.transcode in (	440, 441)), 0.00) as WriteOffPrincipleTotal,
																			/*	WriteOffPrincipleTotal	*/
				-------------------------------------------------------------------------------------
				ISNULL((	select	SUM(gl.transaction_amount)
							from NLS.dbo.loanacct_gl_trans gl 
							where	gl.gl_debit in (99)
									and gl.gl_date  = loanacct_gl_trans.gl_date
									and gl.acctrefno =  loanacct_gl_trans.acctrefno
									and gl.transcode in (	444, 445)), 0.00)
				-
				ISNULL((	select	SUM(gl.transaction_amount)
							from NLS.dbo.loanacct_gl_trans gl 
							where	gl.gl_credit in (99)
									and gl.gl_date  = loanacct_gl_trans.gl_date
									and gl.acctrefno =  loanacct_gl_trans.acctrefno
									and gl.transcode in (	444, 445)), 0.00) 	as WriteOffInterestTotal,
																			/*	WriteOffInterestTotal	*/
				-------------------------------------------------------------------------------------
				ISNULL((	select	SUM(gl.transaction_amount)
							from NLS.dbo.loanacct_gl_trans gl 
							where	gl.gl_debit in (99)
									and gl.gl_date  = loanacct_gl_trans.gl_date
									and gl.acctrefno =  loanacct_gl_trans.acctrefno
									and gl.transcode in (	448, 449, 452, 453, 470, 471, 472,
															473, 474, 475, 476, 477, 478, 479,
															480, 481, 482, 483, 484, 485, 486,
															487, 488, 489)), 0.00)
				-
				ISNULL((	select	SUM(gl.transaction_amount)
							from NLS.dbo.loanacct_gl_trans gl 
							where	gl.gl_credit in (99)
									and gl.gl_date  = loanacct_gl_trans.gl_date
									and gl.acctrefno =  loanacct_gl_trans.acctrefno
									and gl.transcode in (	448, 449, 452, 453, 470, 471, 472,
															473, 474, 475, 476, 477, 478, 479,
															480, 481, 482, 483, 484, 485, 486,
															487, 488, 489)), 0.00) as WriteOffFeesTotal,
																			/*	WriteOffFeesTotal	*/
				-------------------------------------------------------------------------------------
				ISNULL((	select	SUM(gl.transaction_amount)
							from NLS.dbo.loanacct_gl_trans gl 
							where	gl.gl_debit in (86, 87, 88, 103, 107, 110, 112)
									and gl.gl_date  = loanacct_gl_trans.gl_date
									and gl.acctrefno =  loanacct_gl_trans.acctrefno
									and gl.transcode in (	360, 361)), 0.00)
				-
				ISNULL((	select	SUM(gl.transaction_amount)
							from NLS.dbo.loanacct_gl_trans gl 
							where	gl.gl_credit in (86, 87, 88, 103, 107, 110, 112)
									and gl.gl_date  = loanacct_gl_trans.gl_date
									and gl.acctrefno =  loanacct_gl_trans.acctrefno
									and gl.transcode in (	360, 361)), 0.00) as RestructuredPrincipalPaidTotal,
																			/*	RestructuredPrincipalPaidTotal	*/
				-------------------------------------------------------------------------------------
				ISNULL((	select	CAST(SUM(transaction_amount_float) as decimal(10,2))
							from NLS.dbo.loanacct_gl_trans gl 
							where	gl.gl_debit in (89, 104, 108, 113)
									and gl.transcode in (	362, 363, 364, 365)
									and gl.gl_date  = loanacct_gl_trans.gl_date
									and gl.acctrefno =  loanacct_gl_trans.acctrefno), 0.00)
				+
				ISNULL((	select	SUM(transaction_amount)
							from NLS.dbo.loanacct_gl_trans gl 
							where	gl.gl_debit in (89, 104, 108, 113)
									and gl.transcode in (	362, 363, 364, 365)
									and gl.gl_date  = loanacct_gl_trans.gl_date
									and gl.acctrefno =  loanacct_gl_trans.acctrefno), 0.00)
				-
				ISNULL((	select	SUM(gl.transaction_amount)
							from NLS.dbo.loanacct_gl_trans gl 
							where	gl.gl_credit in (89, 104, 108, 113)
									and gl.transcode in (	362, 363, 364, 365)
									and gl.gl_date  = loanacct_gl_trans.gl_date
									and gl.acctrefno =  loanacct_gl_trans.acctrefno), 0.00)
				-
				ISNULL((	select	CAST(SUM(transaction_amount_float) as decimal(10,2))
							from NLS.dbo.loanacct_gl_trans gl 
							where	gl.gl_credit in (89, 104, 108, 113)
									and gl.transcode in (	362, 363, 364, 365)
									and gl.gl_date  = loanacct_gl_trans.gl_date
									and gl.acctrefno =  loanacct_gl_trans.acctrefno), 0.00) as RestructuredInterestPaidTotal,
																			/*	RestructuredInterestPaidTotal	*/
				-------------------------------------------------------------------------------------
				ISNULL((	select	SUM(gl.transaction_amount)
							from NLS.dbo.loanacct_gl_trans gl 
							where	gl.gl_debit in (90, 105, 109)
									and gl.gl_date  = loanacct_gl_trans.gl_date
									and gl.acctrefno =  loanacct_gl_trans.acctrefno
									and gl.transcode in (	366, 367, 368, 369, 370, 371, 372, 373, 374,
															375, 376, 377, 378, 379, 380, 381, 382, 383,
															384, 385, 386, 387, 388, 389)), 0.00)
				-
				ISNULL((	select	SUM(gl.transaction_amount)
							from NLS.dbo.loanacct_gl_trans gl 
							where	gl.gl_credit in (90, 105, 109)
									and gl.gl_date  = loanacct_gl_trans.gl_date
									and gl.acctrefno =  loanacct_gl_trans.acctrefno
									and gl.transcode in (	366, 367, 368, 369, 370, 371, 372, 373, 374,
															375, 376, 377, 378, 379, 380, 381, 382, 383,
															384, 385, 386, 387, 388, 389)), 0.00) as RestructuredFeesPaidTotal,
																			/*	RestructuredFeesPaidTotal	*/
				-------------------------------------------------------------------------------------
				ISNULL((	select	SUM(gl.transaction_amount)
							from NLS.dbo.loanacct_gl_trans gl 
							where	gl.gl_debit in (89, 104, 108, 113)
									and gl.gl_date  = loanacct_gl_trans.gl_date
									and gl.acctrefno =  loanacct_gl_trans.acctrefno
									and gl.transcode in (	306, 307)), 0.00)
				-
				ISNULL((	select	SUM(gl.transaction_amount)
							from NLS.dbo.loanacct_gl_trans gl 
							where	gl.gl_credit in (89, 104, 108, 113)
									and gl.gl_date  = loanacct_gl_trans.gl_date
									and gl.acctrefno =  loanacct_gl_trans.acctrefno
									and gl.transcode in (	306, 307)), 0.00)as CapitalizedOverpaidInterest,
																			/*	CapitalizedOverpaidInterest	*/
				-------------------------------------------------------------------------------------
				ISNULL((	select	SUM(gl.transaction_amount)
							from NLS.dbo.loanacct_gl_trans gl 
							where	gl.gl_debit in (90, 105, 109)
									and gl.gl_date  = loanacct_gl_trans.gl_date
									and gl.acctrefno =  loanacct_gl_trans.acctrefno
									and gl.transcode in (	620, 621, 624, 625, 628, 629,
															632, 633, 636, 637)), 0.00)
				-
				ISNULL((	select	SUM(gl.transaction_amount)
							from NLS.dbo.loanacct_gl_trans gl 
							where	gl.gl_credit in (90, 105, 109)
									and gl.gl_date  = loanacct_gl_trans.gl_date
									and gl.acctrefno =  loanacct_gl_trans.acctrefno
									and gl.transcode in (	620, 621, 624, 625, 628, 629,
															632, 633, 636, 637)), 0.00) as UDBsAdded,
																			/*	UDBsAdded	*/
				-------------------------------------------------------------------------------------
				(-1.00) * (ISNULL((	select	SUM(gl.transaction_amount)
									from NLS.dbo.loanacct_gl_trans gl 
									where	gl.gl_debit in (93)
											and gl.gl_date  = loanacct_gl_trans.gl_date 
											and gl.acctrefno =  loanacct_gl_trans.acctrefno
											and gl.transcode in (600, 601)), 0.00)
						-
						ISNULL((	select	SUM(gl.transaction_amount)
									from NLS.dbo.loanacct_gl_trans gl 
									where	gl.gl_credit in (93)
											and gl.gl_date  = loanacct_gl_trans.gl_date 
											and gl.acctrefno =  loanacct_gl_trans.acctrefno
											and gl.transcode in (600, 601)), 0.00)) as AdminFees,
																			/*	AdminFees	*/
				-------------------------------------------------------------------------------------
				ISNULL((	select	SUM(gl.transaction_amount)
							from NLS.dbo.loanacct_gl_trans gl 
							where	gl.gl_date  = loanacct_gl_trans.gl_date 
									and gl.acctrefno =  loanacct_gl_trans.acctrefno
									and (	( gl.gl_debit in (	select	gl_account_no
																from	NLS.dbo.general_ledger_accounts 
																where	gl_account in ('0908', '0910',  '1099', '1093','1003'))
											 and gl.transcode in (	select	transaction_code
																	from	NLS.dbo.loan_transaction_codes 
																	where	transaction_classification = 3
																			or transaction_code in (460, 461)
																			or (
																					transaction_code between 600 and 699
																					and transaction_description like '%Payment%')))
											or
											(gl.gl_debit in (	select	gl_account_no
																from	NLS.dbo.general_ledger_accounts 
																where	gl_account in (	'0904', '0905', '0906', '0907', '0909',
																					'0911', '0912', '0913', '0914', '0915'))))), 0.00)
				-
				ISNULL((	select	SUM(gl.transaction_amount)
							from NLS.dbo.loanacct_gl_trans gl 
							where	gl.gl_date  = loanacct_gl_trans.gl_date 
									and gl.acctrefno =  loanacct_gl_trans.acctrefno
									and (	( gl.gl_credit in (	select	gl_account_no
																from	NLS.dbo.general_ledger_accounts 
																where	gl_account in ('0908', '0910',  '1099', '1093','1003'))
												and gl.transcode in (	select	transaction_code
																		from	NLS.dbo.loan_transaction_codes 
																		where	transaction_classification = 3
																				or transaction_code in (460, 461)
																				or (
																						transaction_code between 600 and 699
																						and transaction_description like '%Payment%')))
												or
												(gl.gl_credit in (	select	gl_account_no
																	from	NLS.dbo.general_ledger_accounts 
																	where	gl_account in (	'0904', '0905', '0906', '0907', '0909',
																					'0911', '0912', '0913', '0914', '0915'))))), 0.00) as Payments,
																			/*	Payments	*/
				-------------------------------------------------------------------------------------	
				ISNULL((	select	SUM(gl.transaction_amount)
							from NLS.dbo.loanacct_gl_trans gl 
							where	gl.gl_date  = loanacct_gl_trans.gl_date 
									and gl.acctrefno =  loanacct_gl_trans.acctrefno
									and	(
										(	gl.gl_debit in	(	select	gl_account_no
																from	NLS.dbo.general_ledger_accounts 
																where	gl_account in ('0908', '0910',  '1099', '1093','1003')
															)
											and gl.transcode in (204, 205, 208, 209, 220, 221)
										)
										or
										(	gl.gl_debit in	(	select	gl_account_no
																from	NLS.dbo.general_ledger_accounts 
																where	gl_account in (	'0904', '0905', '0906', '0907', '0909',
																					'0911', '0912', '0913', '0914', '0915')
															)
											and gl.transcode in (100, 101, 204, 205, 208, 209, 220, 221)
										)
										)), 0.00)
				-
				ISNULL((	select	SUM(gl.transaction_amount)
							from NLS.dbo.loanacct_gl_trans gl 
							where	gl.gl_date  = loanacct_gl_trans.gl_date 
									and gl.acctrefno =  loanacct_gl_trans.acctrefno
									and	(
										(	gl.gl_credit in	(	select	gl_account_no
																from	NLS.dbo.general_ledger_accounts 
																where	gl_account in ('0908', '0910',  '1099', '1093','1003')
															)
											and gl.transcode in (204, 205, 208, 209, 220, 221)
										)
										or
										(	gl.gl_credit in	(	select	gl_account_no
																from	NLS.dbo.general_ledger_accounts 
																where	gl_account in (	'0904', '0905', '0906', '0907', '0909',
																					'0911', '0912', '0913', '0914', '0915')
															)
											and gl.transcode in (100, 101, 204, 205, 208, 209, 220, 221)
										)
										)), 0.00) as PrincipalPaidTotal,
																			/*	PrincipalPaidTotal	*/
				-------------------------------------------------------------------------------------	
				ISNULL((	select	SUM(gl.transaction_amount)
							from NLS.dbo.loanacct_gl_trans gl 
							where	gl.gl_date  = loanacct_gl_trans.gl_date 
									and gl.acctrefno =  loanacct_gl_trans.acctrefno
									and gl.gl_debit in (select	gl_account_no
														from	NLS.dbo.general_ledger_accounts 
														where	gl_account in (	'0908', '0910', '1099', '0904', '1093','1003',
																				'0906', '0907', '0905', '0909',
																				'0913',	'0911', '0912', '0914',
																				'0915'))
									and gl.transcode in (206, 207, 210, 211, 212, 213, 222, 223, 248, 249)), 0.00)
				-
				ISNULL((	select	SUM(gl.transaction_amount)
							from NLS.dbo.loanacct_gl_trans gl 
							where	gl.gl_date  = loanacct_gl_trans.gl_date 
									and gl.acctrefno =  loanacct_gl_trans.acctrefno
									and gl.gl_credit in (select	gl_account_no
														from	NLS.dbo.general_ledger_accounts 
														where	gl_account in (	'0908', '0910', '1099', '0904', '1093',
																				'0906', '0907', '0905', '0909',
																				'0913',	'0911', '0912', '0914',
																				'0915'))
									and gl.transcode in (206, 207, 210, 211, 212, 213, 222, 223, 248, 249)), 0.00) as InterestPaidTotal,
																			/*	InterestPaidTotal	*/
				-------------------------------------------------------------------------------------

				ISNULL((	select	SUM(gl.transaction_amount)
							from NLS.dbo.loanacct_gl_trans gl 
							where	gl.gl_date  = loanacct_gl_trans.gl_date 
									and gl.acctrefno =  loanacct_gl_trans.acctrefno
									and ((gl.gl_debit in (select	gl_account_no
														from	NLS.dbo.general_ledger_accounts 
														where	gl_account in ('0908', '0910',  '1099', '1093','1003'))
									and gl.transcode in (460, 461))
									or
										(gl.gl_debit in (select	gl_account_no
														from	NLS.dbo.general_ledger_accounts 
														where	gl_account in (	'0904', '0905', '0906', '0907', '0909',
																					'0911', '0912', '0913', '0914', '0915'))
									and gl.transcode in (460, 461, 464, 465, 612, 613)))), 0.00)
				-
				ISNULL((	select	SUM(gl.transaction_amount)
							from NLS.dbo.loanacct_gl_trans gl 
							where	gl.gl_date  = loanacct_gl_trans.gl_date 
									and gl.acctrefno =  loanacct_gl_trans.acctrefno
									and ((gl.gl_credit in (select	gl_account_no
														from	NLS.dbo.general_ledger_accounts 
														where	gl_account in ('0908', '0910',  '1099', '1093','1003'))
									and gl.transcode in (460, 461))
									or
										(gl.gl_credit in (select	gl_account_no
														from	NLS.dbo.general_ledger_accounts 
														where	gl_account in (	'0904', '0905', '0906', '0907', '0909',
																					'0911', '0912', '0913', '0914', '0915'))
									and gl.transcode in (460, 461, 464, 465, 612, 613)))), 0.00) as SuspensePaymentTotal,
																			/*	SuspensePaymentTotal	*/

				-------------------------------------------------------------------------------------	
				/*				*/
				(	select	ISNULL(SUM(transaction_amount_float), 0) 
					from NLS.dbo.loanacct_gl_trans gl 
					where	 gl.acctrefno = loanacct_gl_trans.acctrefno 
							AND gl.gl_date  = loanacct_gl_trans.gl_date 
							AND gl.gl_credit = 94) 
				-
				(	select	ISNULL(SUM(transaction_amount_float), 0) 
					from NLS.dbo.loanacct_gl_trans gl 
					where	 gl.acctrefno = loanacct_gl_trans.acctrefno 
							AND gl.gl_date  = loanacct_gl_trans.gl_date 
							AND gl.gl_debit = 94) as PeriodInterestAccrued,
																			/*	PeriodInterestAccrued	*/

																			
				-------------------------------------------------------------------------------------	
				(	select	ISNULL(SUM(transaction_amount), 0) 
					from NLS.dbo.loanacct_gl_trans gl 
					where	 gl.acctrefno = loanacct_gl_trans.acctrefno 
							AND gl.gl_date  = loanacct_gl_trans.gl_date 
							AND gl.gl_credit = 96
							and gl.transcode in (150, 151)) 
				-
				(	select	ISNULL(SUM(transaction_amount), 0) 
					from NLS.dbo.loanacct_gl_trans gl 
					where	 gl.acctrefno = loanacct_gl_trans.acctrefno 
							AND gl.gl_date  = loanacct_gl_trans.gl_date 
							AND gl.gl_debit = 96
						and gl.transcode in (150, 151)) as AccruedLateFees,
																			/*	AccruedLateFees	*/
				-------------------------------------------------------------------------------------			
				(	select	ISNULL(SUM(gl.transaction_amount), 0) 
					from NLS.dbo.loanacct_gl_trans gl 
					where	 loanacct_gl_trans.acctrefno = gl.acctrefno 
							AND gl.gl_date  = loanacct_gl_trans.gl_date 
							AND gl.gl_credit = 96
							and gl.transcode in (180, 181)) 
				-
				(	select	ISNULL(SUM(gl.transaction_amount), 0) 
					from NLS.dbo.loanacct_gl_trans gl 
					where	 loanacct_gl_trans.acctrefno = gl.acctrefno 
							AND gl.gl_date  = loanacct_gl_trans.gl_date 
							AND gl.gl_debit = 96
							and gl.transcode in (180, 181))	as AccruedNSFFees,
																			/*	AccruedNSFFees	*/
				-------------------------------------------------------------------------------------	
				(	select	ISNULL(SUM(gl.transaction_amount), 0) 
					from NLS.dbo.loanacct_gl_trans gl 
					where	 loanacct_gl_trans.acctrefno = gl.acctrefno 
							AND gl.gl_date  = loanacct_gl_trans.gl_date 
							AND gl.gl_credit = 95
							and gl.transcode in (602, 603)) 
				-
				(	select	ISNULL(SUM(gl.transaction_amount), 0) 
					from NLS.dbo.loanacct_gl_trans gl 
					where	 loanacct_gl_trans.acctrefno = gl.acctrefno 
							AND gl.gl_date  = loanacct_gl_trans.gl_date 
							AND gl.gl_debit = 95
							and gl.transcode in (602, 603))	as AmortizedFees
																			/*	AmortizedFees	*/
				-------------------------------------------------------------------------------------	

FROM NLS.dbo.loanacct_gl_trans 
GROUP BY acctrefno
, gl_date
GO
