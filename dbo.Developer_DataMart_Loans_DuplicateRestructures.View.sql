USE [DataMart]
GO
/****** Object:  View [dbo].[Developer_DataMart_Loans_DuplicateRestructures]    Script Date: 8/24/2020 9:49:52 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



CREATE VIEW [dbo].[Developer_DataMart_Loans_DuplicateRestructures] AS
SELECT 
		TRY_CONVERT(numeric(10,0),loanacct.[cifno]) AS [CIF No]
		,FirstAccounts.[First Acct Ref No]
		,FirstAccounts.[First Task Ref No]
		,IsNull((Select original_loan.original_note_amount
		from	NLS.dbo.loanacct original_loan   
		where	FirstAccounts.[First Acct Ref No] = original_loan.acctrefno /* Join on clause between subquery and parent */
		),loanacct.original_note_amount) AS [First Note Loan Amount]
		,IsNull((Select original_loan.open_date
		from	NLS.dbo.loanacct original_loan   
		where	FirstAccounts.[First Acct Ref No] = original_loan.acctrefno /* Join on clause between subquery and parent */
		),loanacct.open_date) AS [First Note Loan Open Date]

		,IsNull((Select original_loan.input_gl_date
		from	NLS.dbo.loanacct original_loan   
		where	FirstAccounts.[First Acct Ref No] = original_loan.acctrefno /* Join on clause between subquery and parent */
		),loanacct.input_gl_date) AS [First Note Input GL Date]

		,loanacct.acctrefno As [Current Acct Ref No]
		,loanacct.loan_number as [Current Loan Number]
		,TRY_CONVERT(decimal, Left(loanacct_detail.userdef09,13)) AS [Current Task Ref No]
		,loanacct.original_note_amount  AS [Current Note Loan Amount]
		,loanacct.open_date  AS [Current Note Loan Open Date]
		,loanacct.input_gl_date As [Current Input GL Date]

		,(Select [Developer_DataMart_ParentLoans].[NumParents]
		from	[DataMart].[dbo].[Developer_DataMart_ParentLoans] 
		where	[Developer_DataMart_ParentLoans].[Acct Ref No] = loanacct.acctrefno /* Join on clause between subquery and parent */
		) AS [Number Parent Restructures]

		,(Select [Developer_DataMart_ParentLoans].[Parent List]
		from	[DataMart].[dbo].[Developer_DataMart_ParentLoans] 
		where	[Developer_DataMart_ParentLoans].[Acct Ref No] = loanacct.acctrefno /* Join on clause between subquery and parent */
		) AS [List Parent Restructures]

		,(Select shortname from [NLS].[dbo].cif WHERE [cifno]=(select Max(cifno)/*Select most recent CifNo for duplicates */ FROM [NLS].[dbo].[cif_loan_relationship]  where relationship_code_id=13 AND [cif_loan_relationship].[acctrefno]=loanacct.acctrefno )) AS [Referral Source Loan]
		, CASE	
				WHEN (select	loan_port_codes.portfolio_code
				from	NLS.dbo.loan_port_codes 
				where	loan_port_codes.portfolio_code_id = loanacct.portfolio_code_id  /* Join on clauses between subquery and parent */
				)='PPP' Then 'PPP'
				WHEN (select	loan_port_codes.portfolio_code
				from	NLS.dbo.loan_port_codes 
				where	loan_port_codes.portfolio_code_id = loanacct.portfolio_code_id  /* Join on clauses between subquery and parent */
				)='CA RELIEF' Then 'CA RELIEF'
				WHEN (select	task_detail.userdef02
					from	NLS.dbo.task_detail 
					INNER JOIN NLS.dbo.task ON task.task_refno=task_detail.task_refno
					AND task.task_refno=FirstAccounts.[First Task Ref No]
					)
					IN ('TRUCK & TRAILER PURCHASE', 'TRUCK PURCHASE', 'TRUCK REPAIR/RETROFIT', 'TRUCK/RETROFIT PURCHASE', 'TRUCKPURCHASE') THEN 'Trucking'
				WHEN (select	loan_port_codes.portfolio_code
				from	NLS.dbo.loan_port_codes 
				where	loan_port_codes.portfolio_code_id = loanacct.portfolio_code_id  /* Join on clauses between subquery and parent */
				)='TRUCKING' Then 'Trucking'
				WHEN /*Current Contact Referral Source*/(Select cif_detail.userdef30 As [Referral Source - Current] from [NLS].[dbo].[cif_detail] WHERE [cif_detail].[cifno]=loanacct.[cifno] )= 'LENDINGCLUB' THEN 'Lending Club'
				WHEN /*Current Contact Referral Source*/(Select cif_detail.userdef30 As [Referral Source - Current] from [NLS].[dbo].[cif_detail] WHERE [cif_detail].[cifno]=loanacct.[cifno] )= 'LENDING CLUB' THEN 'Lending Club'
				WHEN (select	task_detail.userdef20
					from	NLS.dbo.task_detail 
					INNER JOIN NLS.dbo.task ON task.task_refno=task_detail.task_refno
					AND task.task_refno=FirstAccounts.[First Task Ref No]
					)
					= 'FOOD MOBILE' THEN 'Mobile Food'
				WHEN (select	task_detail.userdef02
					from	NLS.dbo.task_detail 
					INNER JOIN NLS.dbo.task ON task.task_refno=task_detail.task_refno
					AND task.task_refno=FirstAccounts.[First Task Ref No]
					)
					= 'MOBILE FOOD' THEN 'Mobile Food'
				WHEN IsNull((Select original_loan.original_note_amount
					from	NLS.dbo.loanacct original_loan   
					where	original_loan.acctrefno = FirstAccounts.[First Acct Ref No] /* Join on clause between subquery and parent */					),loanacct.original_note_amount) 
					>= 30000 Then 'Small Business' 
				WHEN IsNull((Select original_loan.original_note_amount
					from	NLS.dbo.loanacct original_loan   
					where	original_loan.acctrefno  = FirstAccounts.[First Acct Ref No] /* Join on clause between subquery and parent */
					),loanacct.original_note_amount) 
					< 30000 Then 'Micro Business' 
			ELSE 'Error?'
			END AS [Segment 2019]
		,CAST(ROUND(loanacct.current_payoff_balance, 2) as decimal(15,2)) /* Remove leading and trailing 0s*/  as [Payoff Balance]
		,loanacct_payment.amortized_payment_amount as [Payment Amount]
		,loanacct.current_suspense as LoanCurrentSuspense
		,loanacct.current_principal_balance As [Current Principal Balance]
		,loanacct.current_interest_balance  As [Current Interest Balance]
		,loanacct.current_fees_balance  As [Current Fees Balance]
		,loanacct.current_late_charge_balance  As [Current Late Charge Balance]
		/* Loan Information */

		,loanacct.payoff_date as [Loan Closed Date]
		,(	select	loan_status_codes.status_code 
			from	NLS.dbo.loan_status_codes  
			where	loanacct.status_code_no = loan_status_codes.status_code_no /* Join on clause between subquery and parent */ 
			) as [Loan Status]
		,case
			when loanacct.loan_type = 0
			then '
			'
			else 'OTHER'
			end as [Loan Type]
		,(	select	loan_group.loan_group
					from	NLS.dbo.loan_group 
					where	loanacct.loan_group_no = loan_group.loan_group_no /* Join on clause between subquery and parent */
					) as [Loan Group]
		,(	select	loan_class.code
					from	NLS.dbo.loan_class 
					where	loanacct.loan_class1_no = loan_class.codenum /* Join on clause between subquery and parent */
					) as [Loan Class 1]
		,(	select	loan_class.code
					from	NLS.dbo.loan_class  
					where	loanacct.loan_class2_no = loan_class.codenum /* Join on clause between subquery and parent */
					) as [Loan Class 2]
		,(select	loan_port_codes.portfolio_code
				from	NLS.dbo.loan_port_codes 
				where	loan_port_codes.portfolio_code_id = loanacct.portfolio_code_id  /* Join on clauses between subquery and parent */
				) as [Loan Portfolio]
		,(	select case
								when loanacct_setup.term_char = 'M'
								then 'MONTHS'
								when loanacct_setup.term_char = 'D'
								then 'DAYS'
								when loanacct_setup.term_char = 'P'
								then 'PAYMENTS'
								else 'OTHER'
							end
					from	NLS.dbo.loanacct_setup 
					where	loanacct.acctrefno = loanacct_setup.acctrefno /* Join on clause between subquery and parent */
					) as [Term Type]
		,(	select	CAST(loanacct_setup.term as varchar(10)) + '/' + CAST(loanacct_setup.term_due as varchar(10)) /* Convert numeric fields to text and concatenate together */
					from	NLS.dbo.loanacct_setup 
					where	loanacct.acctrefno = loanacct_setup.acctrefno /* Join on clause between subquery and parent */
					)as [Term]
		,loanacct_detail.userdef05 as [Rating]
		,loanacct_detail.userdef06 as [Rating Last Refreshed]
		,(	select	nlsusers.username
					from	NLS.dbo.nlsusers 
					where	nlsusers.userno = loanacct.loan_officer_no  /* Join on clause between subquery and parent */
					) as [Loan Officer]
		,(	select	nlsusers.office
					from	NLS.dbo.nlsusers 
					where	nlsusers.userno = loanacct.loan_officer_no  /* Join on clause between subquery and parent */
					) as [Loan Officer Office]
		,(	select	nlsusers.department
					from	NLS.dbo.nlsusers 
					where	nlsusers.userno = loanacct.loan_officer_no  /* Join on clause between subquery and parent */
					) as [Loan Officer Department]
		,(	select	nlsusers.username
					from	NLS.dbo.nlsusers  
					where	nlsusers.userno = loanacct.collection_officer_no /* Join on clause between subquery and parent */
					) as [Loan Collection Officer] 
		,loanacct_detail.userdef42 as LoanOrigOfficer
		,(	select	case
								when loanacct_setup.interest_method = 'SI'
								then 'SIMPLE INTEREST'
								else 'OTHER'
							end
					from	NLS.dbo.loanacct_setup 
					where	loanacct.acctrefno = loanacct_setup.acctrefno /* Join on clause between subquery and parent */
					) as [Interest Type]
		/* END Loan Information */

		/* Business Information */ 
		,loanacct_detail.userdef10 as [County]
		,TRY_CONVERT(numeric, loanacct_detail.userdef11) as [Ownership Percent]
		,TRY_CONVERT(numeric, loanacct_detail.userdef12) as [People In Home]
		,TRY_CONVERT(numeric, loanacct_detail.userdef13) as [Full-Time Employees]
		,TRY_CONVERT(numeric, loanacct_detail.userdef14) as [Part-Time Employees]
		,TRY_CONVERT(numeric, loanacct_detail.userdef15) as [Jobs Created]
		,TRY_CONVERT(numeric, loanacct_detail.userdef16) as [Jobs Retained]
		,loanacct_detail.userdef17 as [Resident Status]
		,loanacct_detail.userdef18 as [Census Tract Num]
		,loanacct_detail.userdef19 as [Census Tract Income Level]
		,loanacct_detail.userdef20 as [Individual Income Level]
		,TRY_CONVERT(datetime, loanacct_detail.userdef21) as [Old Loan Credit Score Date]
		, case when loanacct_detail.userdef22='' then NULL
		when  PARSE(loanacct_detail.userdef22 AS INT)	>= 200.0 AND PARSE(loanacct_detail.userdef22 AS INT) <= 850.0 then  PARSE(loanacct_detail.userdef22 AS INT) /* validate credit score ranges.  Parse converts strings to numeric*/
		END as [Old Loan Credit Score]
		,loanacct_detail.userdef23 as [AGI Loan]
		,TRY_CONVERT(numeric, loanacct_detail.userdef24) as [Avg Monthly Revenue]
		,TRY_CONVERT(numeric, loanacct_detail.userdef38) as [Pre TA Hours 1]
		,TRY_CONVERT(numeric, loanacct_detail.userdef39) as [Pre TA Hours 2]
		,TRY_CONVERT(numeric, loanacct_detail.userdef40) as [Post TA Hours 1]
		,TRY_CONVERT(numeric, loanacct_detail.userdef41) as [Post TA Hours 2]
		/* END Business Information */  

		/* Loan Details */
		,case
			when loanacct_detail_2.userdef35 is null
			then NULL
			when loanacct_detail_2.userdef35 = 1
			then 'YES'
			else 'NO'
		end as [Image Release]
		,case
			when loanacct_detail_2.userdef36 is null
			then NULL
			when loanacct_detail_2.userdef36 = 1
			then 'YES'
			else 'NO'
		end as [Kiva]
		,case
			when loanacct_detail_2.userdef37 is null
			then NULL
			when loanacct_detail_2.userdef37 = 1
			then 'YES'
			else 'NO'
		end as [Green Loan]
		,case
			when loanacct_detail_2.userdef39 is null
			then NULL
			when loanacct_detail_2.userdef39 = 1
			then 'YES'
			else 'NO'
		end as [CDBGSJ]
		,case
			when loanacct_detail_2.userdef40 is null
			then NULL
			when loanacct_detail_2.userdef40 = 1
			then 'YES'
			else 'NO'
		end as [CDBGSF]
		,case
			when loanacct_detail_2.userdef45 is null
			then NULL
			when loanacct_detail_2.userdef45 = 1
			then 'YES'
			else 'NO'
		end as [Cal Cap LLR]
		,case
			when loanacct_detail_2.userdef44 is null
			then NULL
			when loanacct_detail_2.userdef44 = 1
			then 'YES'
			else 'NO'
		end as [Cal Cap ARB]
		,case
			when loanacct_detail_2.userdef46 is null
			then NULL
			when loanacct_detail_2.userdef46 = 1
			then 'YES'
			else 'NO'
		end as [Nor Cal]
		,loanacct_detail_2.userdef41 as [DUNS num]
		,loanacct_detail_2.userdef42 as [Cal Cap num]
		,TRY_CONVERT(numeric, loanacct_detail_2.userdef43) as [Cal Cap Percent]
		,TRY_CONVERT(numeric, loanacct_detail_2.userdef47) as [Nor Cal Percent]
		/*END Loan Details */

		/* Loan Product Information */ 
		,loanacct.current_interest_rate as [Current Interest Rate]
		,(select 	SUM(loanacct_trans_history.transaction_amount)
			from	NLS.dbo.loanacct_trans_history 
			where	loanacct.acctrefno = loanacct_trans_history.acctrefno /* Join on clauses between subquery and parent */
			and loanacct_trans_history.transaction_code = 600 /* Filter to origination fees */
			) as [Loan Fees Code 600]
		/* END Loan Product Information */ 

		/* Loan Payment History*/
		,loanacct_detail.userdef46 AS [PayNearMe Enrollment]
		,[principal_payment_dayvalue] as [Principal Payment Day]
		,loanacct_payment.[total_payments] as [Total Payments]
		,loanacct_payment.[total_payments_made] As [Total Payments Made]
		,(SELECT Count( payment_reference_no)
		FROM [NLS].[dbo].[loanacct_payments_due]
		WHERE loanacct_payments_due.acctrefno = loanacct.acctrefno
		AND payment_type='ZZ' AND past_due_indicator!='0')  AS [# Payments Due]
		,loanacct_payment.[next_payment_total_amount] As [Next Payment Total Amount]
		,loanacct_payment.last_payment_date AS [Last Payment Date]
		,loanacct_payment.last_payment_amount AS [Last Payment Amount]
		,loanacct.[interest_paid_thru_date] As [Interest Paid Thru Date]
		,loanacct.[principal_paid_thru_date] As [Principal Paid Thru Date]
		,CASE WHEN loanacct_payment.balloon_payment_date IS NOT NULL then 'TRUE' ELSE 'FALSE' END AS [Balloon Payment Flag]
		,loanacct_payment.balloon_payment_date AS [Balloon Payment Date]
		,loanacct_payment.balloon_payment_amount AS [Balloon Payment Amount]
		,Case When (SELECT Count(loanacct_ach.acctrefno)
		  FROM [NLS].[dbo].[loanacct_ach]
		  WHERE [loanacct_ach].acctrefno = loanacct.acctrefno
		  AND loanacct_ach.status=0 AND loanacct_ach.billing_type=2
		)>0 then 'True' ELSE 'False' END As [Current Recurring ACH Setup]
		,Case When (SELECT Count(loanacct_ach.acctrefno)
		  FROM [NLS].[dbo].[loanacct_ach]
		  WHERE [loanacct_ach].acctrefno = loanacct.acctrefno
		  AND loanacct_ach.num_of_draws>0 AND loanacct_ach.billing_type=2
		)>0 then 'True' ELSE 'False' END As [Ever Recurring ACH Setup]
		,[loanacct_setup].[amort_repayment_method] As [Repayment Hierarchy]
		/* END Loan Payment History*/

		/* Loan Delinquency History */
		,loanacct.days_past_due as [Days Past Due]
		,Case When loanacct.days_past_due =0 then 'On-time'
		When loanacct.days_past_due <15 then '1-14' 
		When loanacct.days_past_due <30 then '15-29' 
		When loanacct.days_past_due <60 then '30-59' 
		When loanacct.days_past_due <90 then '60-89' 
		When loanacct.days_past_due <150 then '90-149' 
		When loanacct.days_past_due >=150 then '150+' 
			END as [Days Past Due Groups]
	,loanacct.[total_past_due_balance] AS [Total Past Due Balance]
	,loanacct.[total_current_due_balance] AS [Total Current Due Balance]
		,(select	loanacct_statistics.days_late_10
				from	NLS.dbo.loanacct_statistics 
				where	loanacct_statistics.master_record = 0
						and loanacct_statistics.acctrefno = loanacct.acctrefno /* Join on clauses between subquery and parent */
						) as [# Occurences 10 Days Past Due]
		,(select	MAX(loanacct_statistics.days_late_30)
				from	NLS.dbo.loanacct_statistics 
				where	loanacct_statistics.master_record = 0
						and loanacct_statistics.acctrefno = loanacct.acctrefno /* Join on clauses between subquery and parent */
						) as [# Occurences 30 Days Past Due]
		,(select	MAX(loanacct_statistics.days_late_60)
				from	NLS.dbo.loanacct_statistics 
				where	loanacct_statistics.master_record = 0
						and loanacct_statistics.acctrefno = loanacct.acctrefno /* Join on clauses between subquery and parent */
						) as [# Occurences 60 Days Past Due]
		,(select	MAX(loanacct_statistics.days_late_90)
				from	NLS.dbo.loanacct_statistics 
				where	loanacct_statistics.master_record = 0
						and loanacct_statistics.acctrefno = loanacct.acctrefno /* Join on clauses between subquery and parent */
						) as [# Occurences 90 Days Past Due]
		,loanacct.principal_paid_thru_date As [Principal Paid Through Date]
		,(SELECT max([daily_trial_balance].[trial_balance_date])
			  FROM [NLS].[dbo].[daily_trial_balance]
			  WHERE [daily_trial_balance].acctrefno = loanacct.acctrefno 
			  AND [daily_trial_balance].eff_days_past_due=0
			) as [Last Date 0 DPD]
		,(CASE WHEN (	select	case
								when l1.payoff_date < '04/01/2012'
								then ISNULL(ld1.userdef37,'')
								else (	SELECT	ISNULL(TRY_CONVERT(varchar(10), MAX(gl_date), 101),'')
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
							)> '01/01/1900' THEN 'TRUE' ELSE 'FALSE' END )as [ChargeOff Flag]
				,TRY_CONVERT(datetime,nullif((	select	case
								when l1.payoff_date < '04/01/2012'
								then ISNULL(ld1.userdef37,'')
								else (	SELECT	ISNULL(TRY_CONVERT(varchar(10), MAX(gl_date), 101),'')
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
							),'')) as [ChargeOff Date]
		,TRY_CONVERT(numeric, (	select	case
								when l1.payoff_date < '04/01/2012'
								then ISNULL(ld1.userdef36,'')
								else (	SELECT	ISNULL(CAST(SUM(	CASE	
																		WHEN CAST(loanacct_trans_history.transaction_code AS INT) % 2 > 0 
																		THEN -loanacct_trans_history.transaction_amount 
																		ELSE loanacct_trans_history.transaction_amount 
																	END) as varchar(25)), '')
										FROM	NLS.dbo.loanacct_trans_history 
										WHERE	acctrefno = l1.acctrefno /* Join on clauses between subquery and parent */
												AND CAST(TRY_CONVERT(varchar(10), gl_date, 101) as datetime) in (	select	MAX(gl_date)
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
					)) as [ChargeOff Amount]
		,loanacct_payment.last_nsf_date AS [Last NSF Date]
		,loanacct_payment.last_nsf_amount AS [Last NSF Amount]
		/* END Delinquency*/

		/*NorCal & Cal Cap Recoveries*/													
		,TRY_CONVERT(datetime, loanacct_detail_2.userdef02) as [Cal Cap Claim Date]
		,TRY_CONVERT(numeric, loanacct_detail_2.userdef03) as [Cal Cap Claim Total]
		,TRY_CONVERT(numeric, loanacct_detail_2.userdef04) as [Cal Cap Claim Principal]
		,TRY_CONVERT(numeric, loanacct_detail_2.userdef05) as  [Cal Cap Claim Interest]
		,TRY_CONVERT(numeric, loanacct_detail_2.userdef06) as  [Cal Cap Claim Fees]
		,TRY_CONVERT(numeric, loanacct_detail_2.userdef07) as  [Cal Cap Claim Percent]
		,TRY_CONVERT(datetime,loanacct_detail_2.userdef19) as  [Cal Cap Recover Date]
		,TRY_CONVERT(numeric, loanacct_detail_2.userdef20) as  [Cal Cap Recover Total]
		,TRY_CONVERT(numeric, loanacct_detail_2.userdef21) as  [Cal Cap Recover Principal]
		,TRY_CONVERT(numeric, loanacct_detail_2.userdef22) as  [Cal Cap Recover Interest]
		,TRY_CONVERT(numeric, loanacct_detail_2.userdef23) as  [Cal Cap Recover Fees]
		,TRY_CONVERT(datetime,loanacct_detail_2.userdef08) as  [Nor Cal Claim Date]
		,TRY_CONVERT(numeric, loanacct_detail_2.userdef09) as  [Nor Cal Claim Total]
		,TRY_CONVERT(numeric, loanacct_detail_2.userdef10) as  [Nor Cal Claim Principal]
		,TRY_CONVERT(numeric, loanacct_detail_2.userdef11) as  [Nor Cal Claim Interest]
		,TRY_CONVERT(numeric, loanacct_detail_2.userdef12) as  [Nor Cal Claim Fees]
		,TRY_CONVERT(numeric, loanacct_detail_2.userdef13) as  [Nor Cal Claim Percent]
		,TRY_CONVERT(datetime,loanacct_detail_2.userdef25) as  [Nor Cal Recover Date]
		,TRY_CONVERT(numeric, loanacct_detail_2.userdef26) as  [Nor Cal Recover Total]
		,TRY_CONVERT(numeric, loanacct_detail_2.userdef27) as  [Nor Cal Recover Principal]
		,TRY_CONVERT(numeric, loanacct_detail_2.userdef28) as  [Nor Cal Recover Interest]
		,TRY_CONVERT(numeric, loanacct_detail_2.userdef29) as  [Nor Cal Recover Fees]
		/*END NorCal & Cal Cap Recoveries */	

		/* Restructure  */
				,(	select	case
						when l1.open_date < '04/01/2012'
						then ld1.userdef25
						else (	select	case
											when l1.acctrefno in (	select distinct
																			restructured_acctrefno
																	from	NLS.dbo.loanacct l2  )
											then 'YES'
											else 'NO'
										end)
					end
			from	NLS.dbo.loanacct l1 ,
					NLS.dbo.loanacct_detail ld1 
			where	l1.acctrefno = ld1.acctrefno and loanacct.acctrefno = l1.acctrefno /* Join on clause between subquery and parent */
			) as [Restructured 1]
		,TRY_CONVERT(datetime,(	select	case
								when l1.open_date < '04/01/2012' AND ld1.userdef26>'01/01/1900' /*remove 0-filled dates*/
								then ld1.userdef26
								else (	select	 l1.open_date
										where	l1.acctrefno in (	select distinct
																			restructured_acctrefno
																	from	NLS.dbo.loanacct l2 ))
							end
					from	NLS.dbo.loanacct l1 ,
							NLS.dbo.loanacct_detail ld1 
					where	l1.acctrefno = ld1.acctrefno and loanacct.acctrefno = l1.acctrefno /* Join on clause between subquery and parent */
					)) as [Restructured 1 Date]
		,(	select	case
								when l1.open_date < '04/01/2012' AND ld1.userdef27!='' AND parse(ld1.userdef27 as decimal)>0 /*remove 0-filled*/
								then parse(ld1.userdef27 as decimal)
								else (	select	l1.original_note_amount
										where	l1.acctrefno in (	select distinct
																			restructured_acctrefno
																	from	NLS.dbo.loanacct l2 ))
							end
					from	NLS.dbo.loanacct l1 ,
							NLS.dbo.loanacct_detail ld1 
					where	l1.acctrefno = ld1.acctrefno and loanacct.acctrefno = l1.acctrefno /* Join on clause between subquery and parent */
					) as [Restructured 1 Amount]
		,(	select	case
								when l1.open_date < '04/01/2012'   AND ld1.userdef28>'01/01/1900' /*remove 0-filled dates*/
								then ld1.userdef28
								else (	select	l1.curr_maturity_date
										where	l1.acctrefno in (	select distinct
																			restructured_acctrefno
																	from	NLS.dbo.loanacct l2 ))
							end
					from	NLS.dbo.loanacct l1 ,
							NLS.dbo.loanacct_detail ld1 
					where	l1.acctrefno = ld1.acctrefno and loanacct.acctrefno = l1.acctrefno /* Join on clauses between subquery and parent */
					) as [Restructured 1 Maturity Date]
		,loanacct_detail.userdef32 as [Restructured 2]
		,TRY_CONVERT(datetime,loanacct_detail.userdef33) as [Restructured 2 Date]
		,TRY_CONVERT(numeric, loanacct_detail.userdef34) as [Restructured 2 Amount]
		,TRY_CONVERT(datetime,loanacct_detail.userdef35) as [Restructured 2 Maturity Date]
		/*END Restructure */

		/* Collection */
		,loanacct_detail.userdef01 as [Collection Legal Status]
		,TRY_CONVERT(datetime,loanacct_detail.userdef02) as [Collection Court Date]
		,TRY_CONVERT(datetime,loanacct_detail.userdef03) as [Collection Date Served]
		,TRY_CONVERT(datetime,loanacct_detail.userdef04) as [Collection Date Repo Req]
		/* END Collection */
		
		,loanacct.restructured_acctrefno As [RestructuredAcct Ref No]
		,(select	max(result_date)
			from	NLS.dbo.task_routing_history 
			INNER JOIN NLS.dbo.task ON task.task_refno=task_routing_history.task_refno
			where	workflow_result_id = 12 /* Filter to loan approval workflow results */
			AND task.nls_refno=TRY_CONVERT(decimal, Left(loanacct_detail.userdef09,13)) /* Join on clauses between subquery and parent */  
			)	As [Approval Date]
		,(select	max(task_routing_history.result_date)
			from	NLS.dbo.task_routing_history 
			INNER JOIN NLS.dbo.task ON task.task_refno=task_routing_history.task_refno
			where	workflow_result_id = 4 /* Filter to loan approval workflow results */
			AND task.nls_refno=TRY_CONVERT(decimal, Left(loanacct_detail.userdef09,13))  /* Join on clauses between subquery and parent */  
			)	As AppCompletedDate
			
		,case
			when NLS.dbo.StripLeadingZero(loanacct_detail_2.userdef17) = '0.00'
			then ''
			else NLS.dbo.StripLeadingZero(loanacct_detail_2.userdef17)
		end as [First Data Split]
		,case
			when NLS.dbo.StripLeadingZero(loanacct_detail_2.userdef33) = '0.00'
			then ''
			else NLS.dbo.StripLeadingZero(loanacct_detail_2.userdef33)
		end as [App Star Split]
				, CASE	
				WHEN (select	loan_port_codes.portfolio_code
				from	NLS.dbo.loan_port_codes 
				where	loan_port_codes.portfolio_code_id = loanacct.portfolio_code_id  /* Join on clauses between subquery and parent */
				)='PPP' Then 'PPP'
				WHEN (select	loan_port_codes.portfolio_code
				from	NLS.dbo.loan_port_codes 
				where	loan_port_codes.portfolio_code_id = loanacct.portfolio_code_id  /* Join on clauses between subquery and parent */
				)='CA RELIEF' Then 'CA RELIEF'
				WHEN (select	task_detail.userdef02
					from	NLS.dbo.task_detail 
					INNER JOIN NLS.dbo.task ON task.task_refno=task_detail.task_refno
					AND task.task_refno=FirstAccounts.[First Task Ref No]
					)
					IN ('TRUCK & TRAILER PURCHASE', 'TRUCK PURCHASE', 'TRUCK REPAIR/RETROFIT', 'TRUCK/RETROFIT PURCHASE', 'TRUCKPURCHASE')  AND (SELECT TOP (1) cif_addressbook.[state] FROM [NLS].[dbo].[cif_addressbook] WHERE (cif_addressbook.entity='BUSINESS ADDRESS' OR address_desc='BUSINESS ADDRESS : A') AND cif_addressbook.[cifno]=loanacct.cifno Order BY [cif_addressbook].row_id DESC ) ='CA'  THEN 'Trucking - CA'
				WHEN (select	loan_port_codes.portfolio_code
				from	NLS.dbo.loan_port_codes 
				where	loan_port_codes.portfolio_code_id = loanacct.portfolio_code_id  /* Join on clauses between subquery and parent */
				)='TRUCKING'  AND isnull((SELECT TOP (1) cif_addressbook.[state] FROM [NLS].[dbo].[cif_addressbook] WHERE (cif_addressbook.entity='BUSINESS ADDRESS' OR address_desc='BUSINESS ADDRESS : A') AND cif_addressbook.[cifno]=loanacct.cifno Order BY [cif_addressbook].row_id DESC ),'')   ='CA' Then 'Trucking - CA'
								WHEN (select	task_detail.userdef02
					from	NLS.dbo.task_detail 
					INNER JOIN NLS.dbo.task ON task.task_refno=task_detail.task_refno
					AND task.task_refno=FirstAccounts.[First Task Ref No]
					)
					IN ('TRUCK & TRAILER PURCHASE', 'TRUCK PURCHASE', 'TRUCK REPAIR/RETROFIT', 'TRUCK/RETROFIT PURCHASE', 'TRUCKPURCHASE')  AND isnull((SELECT TOP (1) cif_addressbook.[state] FROM [NLS].[dbo].[cif_addressbook] WHERE (cif_addressbook.entity='BUSINESS ADDRESS' OR address_desc='BUSINESS ADDRESS : A') AND cif_addressbook.[cifno]=loanacct.cifno Order BY [cif_addressbook].row_id DESC ),'') !='CA'  THEN 'Trucking - Non-CA'
				WHEN (select	loan_port_codes.portfolio_code
				from	NLS.dbo.loan_port_codes 
				where	loan_port_codes.portfolio_code_id = loanacct.portfolio_code_id  /* Join on clauses between subquery and parent */
				)='TRUCKING'  AND isnull((SELECT TOP (1) cif_addressbook.[state] FROM [NLS].[dbo].[cif_addressbook] WHERE (cif_addressbook.entity='BUSINESS ADDRESS' OR address_desc='BUSINESS ADDRESS : A') AND cif_addressbook.[cifno]=loanacct.cifno Order BY [cif_addressbook].row_id DESC ),'')   !='CA' Then 'Trucking - Non-CA'
				WHEN /*Current Contact Referral Source*/(Select cif_detail.userdef30 As [Referral Source - Current] from [NLS].[dbo].[cif_detail] WHERE [cif_detail].[cifno]=loanacct.[cifno] ) IN( 'LENDINGCLUB','LENDING CLUB') AND (select	loan_class.code from	NLS.dbo.loan_class 	where	loanacct.loan_class1_no = loan_class.codenum /* Join on clause between subquery and parent */)='NEAR PRIME' THEN 'Lending Club Near Prime'
				WHEN /*Current Contact Referral Source*/(Select cif_detail.userdef30 As [Referral Source - Current] from [NLS].[dbo].[cif_detail] WHERE [cif_detail].[cifno]=loanacct.[cifno] ) IN( 'LENDINGCLUB','LENDING CLUB') AND Isnull((select	loan_class.code from	NLS.dbo.loan_class 	where	loanacct.loan_class1_no = loan_class.codenum /* Join on clause between subquery and parent */),'')!='NEAR PRIME' THEN 'Lending Club 2nd Look'
				WHEN (select	task_detail.userdef20
					from	NLS.dbo.task_detail 
					INNER JOIN NLS.dbo.task ON task.task_refno=task_detail.task_refno
					AND task.task_refno=FirstAccounts.[First Task Ref No]
					)
					= 'FOOD MOBILE' AND (SELECT TOP (1) cif_addressbook.[state] FROM [NLS].[dbo].[cif_addressbook] WHERE (cif_addressbook.entity='BUSINESS ADDRESS' OR address_desc='BUSINESS ADDRESS : A') AND cif_addressbook.[cifno]=loanacct.cifno Order BY [cif_addressbook].row_id DESC ) ='CA' THEN 'Mobile Food - CA'
				WHEN (select	task_detail.userdef02
					from	NLS.dbo.task_detail 
					INNER JOIN NLS.dbo.task ON task.task_refno=task_detail.task_refno
					AND task.task_refno=FirstAccounts.[First Task Ref No]
					)
					= 'MOBILE FOOD' AND (SELECT TOP (1) cif_addressbook.[state] FROM [NLS].[dbo].[cif_addressbook] WHERE (cif_addressbook.entity='BUSINESS ADDRESS' OR address_desc='BUSINESS ADDRESS : A') AND cif_addressbook.[cifno]=loanacct.cifno Order BY [cif_addressbook].row_id DESC ) ='CA' THEN 'Mobile Food - CA'
				WHEN (select	task_detail.userdef20
					from	NLS.dbo.task_detail 
					INNER JOIN NLS.dbo.task ON task.task_refno=task_detail.task_refno
					AND task.task_refno=FirstAccounts.[First Task Ref No]
					)
					= 'FOOD MOBILE' AND Isnull((SELECT TOP (1) cif_addressbook.[state] FROM [NLS].[dbo].[cif_addressbook] WHERE (cif_addressbook.entity='BUSINESS ADDRESS' OR address_desc='BUSINESS ADDRESS : A') AND cif_addressbook.[cifno]=loanacct.cifno Order BY [cif_addressbook].row_id DESC ),'') !='CA' THEN 'Mobile Food - Non-CA'
				WHEN (select	task_detail.userdef02
					from	NLS.dbo.task_detail 
					INNER JOIN NLS.dbo.task ON task.task_refno=task_detail.task_refno
					AND task.task_refno=FirstAccounts.[First Task Ref No]
					)
					= 'MOBILE FOOD' AND Isnull((SELECT TOP (1) cif_addressbook.[state] FROM [NLS].[dbo].[cif_addressbook] WHERE (cif_addressbook.entity='BUSINESS ADDRESS' OR address_desc='BUSINESS ADDRESS : A') AND cif_addressbook.[cifno]=loanacct.cifno Order BY [cif_addressbook].row_id DESC ),'') !='CA' THEN 'Mobile Food - Non-CA'				
				WHEN (Select cif_detail.userdef30 FROM [NLS].[dbo].[cif_detail] WHERE cif_detail.cifno=loanacct.cifno )='PARTNERS' Then 'Community Partners'
				WHEN IsNull((Select original_loan.original_note_amount
					from	NLS.dbo.loanacct original_loan   
					where	original_loan.acctrefno = FirstAccounts.[First Acct Ref No] /* Join on clause between subquery and parent */					),loanacct.original_note_amount) 
					>= 30000 Then 'D2C Small Business' 
				WHEN IsNull((Select original_loan.original_note_amount
					from	NLS.dbo.loanacct original_loan   
					where	original_loan.acctrefno  = FirstAccounts.[First Acct Ref No] /* Join on clause between subquery and parent */
					),loanacct.original_note_amount) 
					< 30000 Then 'D2C Micro' 
			ELSE 'Error?'
			END AS [Segment 2020]

,(select TOP 1
	participationDate 
	FROM [NLS].[dbo].[OF_Participations]
	WHERE loanacct.[acctrefno]= [OF_Participations].[acctrefno]
	ORDER BY participationDate DESC) AS [Current Particpation Start Date]

,(select TOP 1
	participationPercent
	FROM [NLS].[dbo].[OF_Participations]
	WHERE loanacct.[acctrefno]= [OF_Participations].[acctrefno]
	ORDER BY participationDate DESC) AS [Current Particpation Percent]

,(select TOP 1
	newGroup
	FROM [NLS].[dbo].[OF_Participations]
	WHERE loanacct.[acctrefno]= [OF_Participations].[acctrefno]
	ORDER BY participationDate DESC) AS [Current Participation Group]

      ,loanacct.[open_maturity_date] AS [Open Maturity Date]
      ,loanacct.[curr_maturity_date] AS [Current Maturity Date]
      ,loanacct.[payoff_date] AS [Payoff Date]
      ,loanacct.[last_activity_date] AS [Last Activity Date]

, STUFF((SELECT ', ' + [status_code]
                         FROM [NLS].[dbo].[loan_status_codes]
						JOIN  [NLS].[dbo].[loanacct_statuses] on [loanacct_statuses].status_code_no=[loan_status_codes].status_code_no
						WHERE  [loanacct_statuses].acctrefno=loanacct.acctrefno
                               ORDER BY [loan_status_codes].[status_code_no]
                               FOR XML PATH(''), TYPE).value('.[1]', 'varchar(max)'), 1, 2, '') AS [Status Detail]

, (Select
	[status_code]
	FROM [NLS].[dbo].[loan_status_codes]
	JOIN  [NLS].[dbo].[loanacct_statuses] on [loanacct_statuses].status_code_no=[loan_status_codes].status_code_no
	WHERE [loan_status_codes].[status_code_no]=10
	AND [loanacct_statuses].acctrefno=loanacct.acctrefno) AS [Status Code 10]

, (Select
	[status_code]
	FROM [NLS].[dbo].[loan_status_codes]
	JOIN  [NLS].[dbo].[loanacct_statuses] on [loanacct_statuses].status_code_no=[loan_status_codes].status_code_no
	WHERE [loan_status_codes].[status_code_no]=11
	AND [loanacct_statuses].acctrefno=loanacct.acctrefno) AS [Status Code 11]

, (Select
	[status_code]
	FROM [NLS].[dbo].[loan_status_codes]
	JOIN  [NLS].[dbo].[loanacct_statuses] on [loanacct_statuses].status_code_no=[loan_status_codes].status_code_no
	WHERE [loan_status_codes].[status_code_no]=12
	AND [loanacct_statuses].acctrefno=loanacct.acctrefno) AS [Status Code 12]

, (Select
	[status_code]
	FROM [NLS].[dbo].[loan_status_codes]
	JOIN  [NLS].[dbo].[loanacct_statuses] on [loanacct_statuses].status_code_no=[loan_status_codes].status_code_no
	WHERE [loan_status_codes].[status_code_no]=13
	AND [loanacct_statuses].acctrefno=loanacct.acctrefno) AS [Status Code 13]

, (Select
	[status_code]
	FROM [NLS].[dbo].[loan_status_codes]
	JOIN  [NLS].[dbo].[loanacct_statuses] on [loanacct_statuses].status_code_no=[loan_status_codes].status_code_no
	WHERE [loan_status_codes].[status_code_no]=14
	AND [loanacct_statuses].acctrefno=loanacct.acctrefno) AS [Status Code 14]

, (Select
	[status_code]
	FROM [NLS].[dbo].[loan_status_codes]
	JOIN  [NLS].[dbo].[loanacct_statuses] on [loanacct_statuses].status_code_no=[loan_status_codes].status_code_no
	WHERE [loan_status_codes].[status_code_no]=15
	AND [loanacct_statuses].acctrefno=loanacct.acctrefno) AS [Status Code 15]

, (Select
	[status_code]
	FROM [NLS].[dbo].[loan_status_codes]
	JOIN  [NLS].[dbo].[loanacct_statuses] on [loanacct_statuses].status_code_no=[loan_status_codes].status_code_no
	WHERE [loan_status_codes].[status_code_no]=16
	AND [loanacct_statuses].acctrefno=loanacct.acctrefno) AS [Status Code 16]

, (Select
	[status_code]
	FROM [NLS].[dbo].[loan_status_codes]
	JOIN  [NLS].[dbo].[loanacct_statuses] on [loanacct_statuses].status_code_no=[loan_status_codes].status_code_no
	WHERE [loan_status_codes].[status_code_no]=17
	AND [loanacct_statuses].acctrefno=loanacct.acctrefno) AS [Status Code 17]

, (Select
	[status_code]
	FROM [NLS].[dbo].[loan_status_codes]
	JOIN  [NLS].[dbo].[loanacct_statuses] on [loanacct_statuses].status_code_no=[loan_status_codes].status_code_no
	WHERE [loan_status_codes].[status_code_no]=18
	AND [loanacct_statuses].acctrefno=loanacct.acctrefno) AS [Status Code 18]

, (Select
	[status_code]
	FROM [NLS].[dbo].[loan_status_codes]
	JOIN  [NLS].[dbo].[loanacct_statuses] on [loanacct_statuses].status_code_no=[loan_status_codes].status_code_no
	WHERE [loan_status_codes].[status_code_no]=19
	AND [loanacct_statuses].acctrefno=loanacct.acctrefno) AS [Status Code 19]

, (Select
	[status_code]
	FROM [NLS].[dbo].[loan_status_codes]
	JOIN  [NLS].[dbo].[loanacct_statuses] on [loanacct_statuses].status_code_no=[loan_status_codes].status_code_no
	WHERE [loan_status_codes].[status_code_no]=20
	AND [loanacct_statuses].acctrefno=loanacct.acctrefno) AS [Status Code 20]

, (Select
	[status_code]
	FROM [NLS].[dbo].[loan_status_codes]
	JOIN  [NLS].[dbo].[loanacct_statuses] on [loanacct_statuses].status_code_no=[loan_status_codes].status_code_no
	WHERE [loan_status_codes].[status_code_no]=21
	AND [loanacct_statuses].acctrefno=loanacct.acctrefno) AS [Status Code 21]

, (Select
	[status_code]
	FROM [NLS].[dbo].[loan_status_codes]
	JOIN  [NLS].[dbo].[loanacct_statuses] on [loanacct_statuses].status_code_no=[loan_status_codes].status_code_no
	WHERE [loan_status_codes].[status_code_no]=22
	AND [loanacct_statuses].acctrefno=loanacct.acctrefno) AS [Status Code 22]

, (Select
	[status_code]
	FROM [NLS].[dbo].[loan_status_codes]
	JOIN  [NLS].[dbo].[loanacct_statuses] on [loanacct_statuses].status_code_no=[loan_status_codes].status_code_no
	WHERE [loan_status_codes].[status_code_no]=23
	AND [loanacct_statuses].acctrefno=loanacct.acctrefno) AS [Status Code 23]

, (Select
	[status_code]
	FROM [NLS].[dbo].[loan_status_codes]
	JOIN  [NLS].[dbo].[loanacct_statuses] on [loanacct_statuses].status_code_no=[loan_status_codes].status_code_no
	WHERE [loan_status_codes].[status_code_no]=24
	AND [loanacct_statuses].acctrefno=loanacct.acctrefno) AS [Status Code 24]

, (Select
	[status_code]
	FROM [NLS].[dbo].[loan_status_codes]
	JOIN  [NLS].[dbo].[loanacct_statuses] on [loanacct_statuses].status_code_no=[loan_status_codes].status_code_no
	WHERE [loan_status_codes].[status_code_no]=25
	AND [loanacct_statuses].acctrefno=loanacct.acctrefno) AS [Status Code 25]

, (Select
	[status_code]
	FROM [NLS].[dbo].[loan_status_codes]
	JOIN  [NLS].[dbo].[loanacct_statuses] on [loanacct_statuses].status_code_no=[loan_status_codes].status_code_no
	WHERE [loan_status_codes].[status_code_no]=26
	AND [loanacct_statuses].acctrefno=loanacct.acctrefno) AS [Status Code 26]

, (Select
	[status_code]
	FROM [NLS].[dbo].[loan_status_codes]
	JOIN  [NLS].[dbo].[loanacct_statuses] on [loanacct_statuses].status_code_no=[loan_status_codes].status_code_no
	WHERE [loan_status_codes].[status_code_no]=27
	AND [loanacct_statuses].acctrefno=loanacct.acctrefno) AS [Status Code 27]

, (Select
	[status_code]
	FROM [NLS].[dbo].[loan_status_codes]
	JOIN  [NLS].[dbo].[loanacct_statuses] on [loanacct_statuses].status_code_no=[loan_status_codes].status_code_no
	WHERE [loan_status_codes].[status_code_no]=28
	AND [loanacct_statuses].acctrefno=loanacct.acctrefno) AS [Status Code 28]

, (Select
	[status_code]
	FROM [NLS].[dbo].[loan_status_codes]
	JOIN  [NLS].[dbo].[loanacct_statuses] on [loanacct_statuses].status_code_no=[loan_status_codes].status_code_no
	WHERE [loan_status_codes].[status_code_no]=29
	AND [loanacct_statuses].acctrefno=loanacct.acctrefno) AS [Status Code 29]

, (Select
	[status_code]
	FROM [NLS].[dbo].[loan_status_codes]
	JOIN  [NLS].[dbo].[loanacct_statuses] on [loanacct_statuses].status_code_no=[loan_status_codes].status_code_no
	WHERE [loan_status_codes].[status_code_no]=30
	AND [loanacct_statuses].acctrefno=loanacct.acctrefno) AS [Status Code 30]

FROM NLS.dbo.loanacct 
INNER JOIN NLS.dbo.loanacct_detail  ON loanacct.acctrefno = loanacct_detail.acctrefno
INNER JOIN NLS.dbo.loanacct_detail_2  ON loanacct.acctrefno = loanacct_detail_2.acctrefno
INNER JOIN NLS.dbo.loanacct_payment  ON loanacct.acctrefno = loanacct_payment.acctrefno
INNER JOIN NLS.dbo.loanacct_setup  ON loanacct.acctrefno = loanacct_setup.acctrefno
INNER JOIN (/*Subquery Make Original Loan AcctRefNO available for other lookups */
		/* MUST RUN PARENT TABLE BEFORE*/
		Select loanacct.acctrefno
		,TRY_CONVERT(numeric(10,0),IsNull((Select [Parent Loans].[Original Parent]
		from	[DataMart].[dbo].[Parent Loans] 
		where	[Parent Loans].[Acct Ref No] = loanacct.acctrefno /* Join on clause between subquery and parent */
		),loanacct.acctrefno)) as [First Acct Ref No]
		,TRY_CONVERT(numeric(10,0), Left(	IsNull((Select original_loan_detail.userdef09
		from	[DataMart].[dbo].[Parent Loans] 
		JOIN  NLS.dbo.loanacct original_loan   ON [Parent Loans].[Original Parent]=original_loan.acctrefno
		JOIN  NLS.dbo.loanacct_detail original_loan_detail on original_loan_detail.acctrefno=original_loan.acctrefno
		where	[Parent Loans].[Acct Ref No] = loanacct.acctrefno /* Join on clause between subquery and parent */
		),loanacct_detail.userdef09),13))  AS [First Task Ref No]
		FROM NLS.dbo.loanacct 
		INNER JOIN NLS.dbo.loanacct_detail  ON loanacct.acctrefno = loanacct_detail.acctrefno
		Where loanacct.restructured_acctrefno='0'
		) FirstAccounts ON FirstAccounts.acctrefno=loanacct.acctrefno
--Where loanacct.restructured_acctrefno='0' 
--Keep all restructures


GO
