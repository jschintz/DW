USE [DataMart]
GO
/****** Object:  View [dbo].[Developer_DataMart_LoanDailyTrialBalance]    Script Date: 8/24/2020 9:49:52 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO









CREATE VIEW [dbo].[Developer_DataMart_LoanDailyTrialBalance] AS

SELECT
	[daily_trial_balance].[row_id] AS [Row ID],
	[daily_trial_balance].[acctrefno] AS [Acct Ref No]
	,[daily_trial_balance].[trial_balance_date] As [Date of Trial Balance]
	,[daily_trial_balance].[eff_days_past_due] As [Eff Days Past Due]
	,case 
					when [daily_trial_balance].eff_days_past_due < 1
					then '0 DPD'
					when [daily_trial_balance].eff_days_past_due between 1 and 30
					then '1-30 DPD'
					when [daily_trial_balance].eff_days_past_due between 31 and 60
					then '31-60 DPD'
					when [daily_trial_balance].eff_days_past_due between 61 and 90
					then '61-90 DPD'
					when [daily_trial_balance].eff_days_past_due >= 91
					then '91+ DPD'
					else 'NA'
				end AS [Eff  Days Past Due Grouped]
	,CAST(ROUND([daily_trial_balance].eff_principal_balance + [daily_trial_balance].eff_interest_balance + [daily_trial_balance].eff_fees_balance 
	+ [daily_trial_balance].eff_late_charges_balance + [daily_trial_balance].eff_udf1_balance + [daily_trial_balance].eff_udf2_balance
	+ [daily_trial_balance].eff_udf3_balance + [daily_trial_balance].eff_udf4_balance + [daily_trial_balance].eff_udf5_balance
	+ [daily_trial_balance].eff_udf6_balance + [daily_trial_balance].eff_udf7_balance + [daily_trial_balance].eff_udf8_balance
	+ [daily_trial_balance].eff_udf9_balance + [daily_trial_balance].eff_udf10_balance , 2)as decimal(15,2)) AS [Eff Outstanding $ Balance]
	,CAST(ROUND([daily_trial_balance].eff_principal_balance, 2)as decimal(15,2)) AS [Eff  Outstanding $ Principal]
	,case
					when ([daily_trial_balance].eff_principal_balance + [daily_trial_balance].eff_interest_balance + [daily_trial_balance].eff_fees_balance 
										+ [daily_trial_balance].eff_late_charges_balance + [daily_trial_balance].eff_udf1_balance + [daily_trial_balance].eff_udf2_balance
										+ [daily_trial_balance].eff_udf3_balance + [daily_trial_balance].eff_udf4_balance + [daily_trial_balance].eff_udf5_balance
										+ [daily_trial_balance].eff_udf6_balance + [daily_trial_balance].eff_udf7_balance + [daily_trial_balance].eff_udf8_balance
										+ [daily_trial_balance].eff_udf9_balance + [daily_trial_balance].eff_udf10_balance) > 0.50
					then 1
					else 0
				end AS [Eff Active Loan]

	,[daily_trial_balance].[gl_days_past_due] As [GL Days Past Due]
	,case 
					when [daily_trial_balance].gl_days_past_due < 1
					then '0 DPD'
					when [daily_trial_balance].gl_days_past_due between 1 and 30
					then '1-30 DPD'
					when [daily_trial_balance].gl_days_past_due between 31 and 60
					then '31-60 DPD'
					when [daily_trial_balance].gl_days_past_due between 61 and 90
					then '61-90 DPD'
					when [daily_trial_balance].gl_days_past_due >= 91
					then '91+ DPD'
					else 'NA'
				end AS [GL  Days Past Due Grouped]
	,CAST(ROUND([daily_trial_balance].gl_principal_balance + [daily_trial_balance].gl_interest_balance + [daily_trial_balance].gl_fees_balance 
	+ [daily_trial_balance].gl_late_charges_balance + [daily_trial_balance].gl_udf1_balance + [daily_trial_balance].gl_udf2_balance
	+ [daily_trial_balance].gl_udf3_balance + [daily_trial_balance].gl_udf4_balance + [daily_trial_balance].gl_udf5_balance
	+ [daily_trial_balance].gl_udf6_balance + [daily_trial_balance].gl_udf7_balance + [daily_trial_balance].gl_udf8_balance
	+ [daily_trial_balance].gl_udf9_balance + [daily_trial_balance].gl_udf10_balance, 2)as decimal(15,2))  AS [GL Outstanding $ Balance]
	,CAST(ROUND([daily_trial_balance].gl_principal_balance, 2)as decimal(15,2))  AS [GL  Outstanding $ Principal]

	,case
					when ([daily_trial_balance].gl_principal_balance + [daily_trial_balance].gl_interest_balance + [daily_trial_balance].gl_fees_balance 
										+ [daily_trial_balance].gl_late_charges_balance + [daily_trial_balance].gl_udf1_balance + [daily_trial_balance].gl_udf2_balance
										+ [daily_trial_balance].gl_udf3_balance + [daily_trial_balance].gl_udf4_balance + [daily_trial_balance].gl_udf5_balance
										+ [daily_trial_balance].gl_udf6_balance + [daily_trial_balance].gl_udf7_balance + [daily_trial_balance].gl_udf8_balance
										+ [daily_trial_balance].gl_udf9_balance + [daily_trial_balance].gl_udf10_balance) > 0.50
					then 1
					else 0
				end AS [GL Active Loan]
	,(Select Min([participationDate]) FROM [NLS].[dbo].[OF_Participations] WHERE [OF_Participations].[acctrefno]=[daily_trial_balance].[acctrefno] ) As [First Participation Start Date]

	,(Select StartDate
		FROM
		(Select acctrefno
		,participationDate As StartDate
		,(Select Min(endDate.participationDate) 
			FROM [NLS].[dbo].[OF_Participations] endDate 
			Where endDate.participationDate > [OF_Participations].participationDate 
			AND endDate.[acctrefno]= [OF_Participations].[acctrefno]) AS EndDate
			FROM [NLS].[dbo].[OF_Participations]) StartEnd
			WHERE StartEnd.acctrefno=[daily_trial_balance].acctrefno 
			AND StartEnd.StartDate<=[daily_trial_balance].[trial_balance_date]
			AND (StartEnd.endDate>[daily_trial_balance].[trial_balance_date] OR endDate IS NULL)) AS [Current Particpation Start Date]

	,(Select participationPercent
		FROM
		(Select acctrefno
		,[participationPercent]
		,participationDate As StartDate
		,(Select Min(endDate.participationDate) 
			FROM [NLS].[dbo].[OF_Participations] endDate 
			Where endDate.participationDate > [OF_Participations].participationDate 
			AND endDate.[acctrefno]= [OF_Participations].[acctrefno]) AS EndDate
			FROM [NLS].[dbo].[OF_Participations]) StartEnd
			WHERE StartEnd.acctrefno=[daily_trial_balance].acctrefno 
			AND StartEnd.StartDate<=[daily_trial_balance].[trial_balance_date]
			AND (StartEnd.endDate>[daily_trial_balance].[trial_balance_date] OR endDate IS NULL)) AS [Current Particpation Percent]

	,(Select newGroup 
		FROM
		(Select acctrefno
		,(Select	loan_group.loan_group
					from	NLS.dbo.loan_group 
					where	newGroup = loan_group.loan_group_no) AS newGroup 
		,participationDate As StartDate
		,(Select Min(endDate.participationDate) 
			FROM [NLS].[dbo].[OF_Participations] endDate 
			Where endDate.participationDate > [OF_Participations].participationDate 
			AND endDate.[acctrefno]= [OF_Participations].[acctrefno]) AS EndDate
			FROM [NLS].[dbo].[OF_Participations]) StartEnd
			WHERE StartEnd.acctrefno=[daily_trial_balance].acctrefno 
			AND StartEnd.StartDate<=[daily_trial_balance].[trial_balance_date]
			AND (StartEnd.endDate>[daily_trial_balance].[trial_balance_date] OR endDate IS NULL)) AS [Current Participation Group]

,(Select TOP 1 [new_value]
		FROM
		(Select  acctrefno
		,[new_value]
		,[mod_datestamp] As StartDate
		,(Select Min(endDate.[mod_datestamp]) 
			FROM [NLS].[dbo].[loanacct_mod_history] endDate 
			WHERE[item_changed]='Status' AND endDate.[mod_datestamp] > [loanacct_mod_history].[mod_datestamp] 
			AND endDate.[acctrefno]= [loanacct_mod_history].[acctrefno]) AS EndDate
			FROM [NLS].[dbo].[loanacct_mod_history]
			WHERE [item_changed]='Status' 
			) StartEnd
			WHERE StartEnd.acctrefno=[daily_trial_balance].acctrefno 
			AND StartEnd.StartDate<=[daily_trial_balance].[trial_balance_date]
			AND (StartEnd.endDate>[daily_trial_balance].[trial_balance_date] OR endDate IS NULL
			 )
			 ORDER BY StartDate DESC
			 ) AS [Status Detail]
,(Select	loan_group.loan_group
					from	NLS.dbo.loan_group 
					where	[daily_trial_balance].[loan_group_no] = loan_group.loan_group_no ) AS [Loan Group]
	, [daily_trial_balance].gl_interest_balance AS [GL  Outstanding $ Interest]
	, [daily_trial_balance].gl_fees_balance AS [GL  Outstanding $ Fees]
	,[daily_trial_balance].gl_late_charges_balance + [daily_trial_balance].gl_udf1_balance + [daily_trial_balance].gl_udf2_balance
										+ [daily_trial_balance].gl_udf3_balance + [daily_trial_balance].gl_udf4_balance + [daily_trial_balance].gl_udf5_balance
										+ [daily_trial_balance].gl_udf6_balance + [daily_trial_balance].gl_udf7_balance + [daily_trial_balance].gl_udf8_balance
										+ [daily_trial_balance].gl_udf9_balance + [daily_trial_balance].gl_udf10_balance AS [GL  Outstanding $ Late Fees]

	,(Select TOP 1 [participationPercent] FROM [NLS].[dbo].[OF_Participations] WHERE [OF_Participations].[acctrefno]=[daily_trial_balance].[acctrefno] Order BY [participationDate] ASC) As [First Participation Percent]
  FROM [NLS].[dbo].[daily_trial_balance]
  WHERE [daily_trial_balance].[trial_balance_date] < CAST(GETDATE() as date)
  AND row_id /*Exclude Rows with mulitple acct/date combos*/ NOT In(188250,
1083340,
1083350,
1109563,
1130442,
1147535,
1147540,
1161021,
1161029,
1170684,
1170685,
1186492,
1206230,
1212137,
1284099,
1339723,
1399809,
1444093,
1503807,
1519121,
1563537,
1612597,
1676589,
1690546,
1725869,
1728274)
GO
