USE [DataMart]
GO
/****** Object:  View [dbo].[Developer_DataMart_QualifiedLeads]    Script Date: 8/24/2020 9:49:52 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO










CREATE VIEW [dbo].[Developer_DataMart_QualifiedLeads] AS
Select 
task_routing_history.task_refno As LeadID_TaskRefno
,task.NLS_refno As [CIF No]
,task.[creation_date] AS [Task Creation Date]
,task.[completion_date] AS [Task Completion Date]
, (SELECT [status_code] FROM [NLS].[dbo].[task_status_codes] WHERE task.[status_code_id]=[task_status_codes].[status_code_id]) AS [Status]
,task_routing_history.created_date [Lead Create Date]
,task_detail.userdef02 AS [Primary Loan Use]
,TRY_Convert(numeric(18,2), Case When task_detail.userdef01='0000000000000.00000' OR task_detail.userdef01='0.00000' THEN NULL ELSE task_detail.userdef01 END) AS [Requested Amount]
, (Select TOP 1 [action]  from NLS.dbo.task_routing_history MostRecentTask JOIN [NLS].[dbo].[workflow_action] ON MostRecentTask.[workflow_action_id]=[workflow_action].[workflow_action_id] WHERE task_routing_history.task_refno=MostRecentTask.task_refno ORDER BY MostRecentTask.[created_date] DESC) AS [Most Recent Workflow Action]
, (Select TOP 1 [result]  from NLS.dbo.task_routing_history MostRecentTask JOIN [NLS].[dbo].[workflow_result] ON MostRecentTask.[workflow_result_id]=[workflow_result].[workflow_result_id] WHERE task_routing_history.task_refno=MostRecentTask.task_refno ORDER BY MostRecentTask.[created_date] DESC) AS [Most Recent Workflow Result]
, CASE WHEN  task_detail.userdef02 IN ('TRUCK & TRAILER PURCHASE', 'TRUCK PURCHASE', 'TRUCK REPAIR/RETROFIT', 'TRUCK/RETROFIT PURCHASE', 'TRUCKPURCHASE') Then 'Trucking'
				WHEN /*Current Contact Referral Source*/(Select cif_detail.userdef30 As [Referral Source - Current] from [NLS].[dbo].[cif_detail] WHERE [cif_detail].[cifno]=task.NLS_refno )= 'LENDINGCLUB' THEN 'Lending Club'
				WHEN /*Current Contact Referral Source*/(Select cif_detail.userdef30 As [Referral Source - Current] from [NLS].[dbo].[cif_detail] WHERE [cif_detail].[cifno]=task.NLS_refno )= 'LENDING CLUB' THEN 'Lending Club'
	WHEN task_detail.userdef20 = 'FOOD MOBILE' THEN 'Mobile Food'
	WHEN task_detail.userdef02 = 'MOBILE FOOD' THEN 'Mobile Food'
	WHEN TRY_Convert(numeric(18,2), Case When task_detail.userdef01='0000000000000.00000' OR task_detail.userdef01='0.00000' THEN NULL ELSE task_detail.userdef01 END) >= 30000 Then 'Small Business' 
	WHEN TRY_Convert(numeric(18,2), Case When task_detail.userdef01='0000000000000.00000' OR task_detail.userdef01='0.00000' THEN NULL ELSE task_detail.userdef01 END) < 30000 Then 'Micro Business' 
END AS [Segment 2019]
		,(	select	nlsusers.username
					from	NLS.dbo.nlsusers 
					where	nlsusers.userno = task.owner_uid  /* Join on clause between subquery and parent */
					) as [Lead Owner]
		,(	select	nlsusers.office
					from	NLS.dbo.nlsusers 
					where	nlsusers.userno = task.owner_uid /* Join on clause between subquery and parent */
					) as [Lead Owner Office]
		,(	select	nlsusers.department
					from	NLS.dbo.nlsusers 
					where	nlsusers.userno = task.owner_uid  /* Join on clause between subquery and parent */
					) as [Lead Owner Department]
, CASE WHEN  task_detail.userdef02 IN ('TRUCK & TRAILER PURCHASE', 'TRUCK PURCHASE', 'TRUCK REPAIR/RETROFIT', 'TRUCK/RETROFIT PURCHASE', 'TRUCKPURCHASE')   AND (SELECT TOP (1) cif_addressbook.[state] FROM [NLS].[dbo].[cif_addressbook] WHERE (cif_addressbook.entity='BUSINESS ADDRESS' OR address_desc='BUSINESS ADDRESS : A') AND cif_addressbook.[cifno]=task.NLS_refno Order BY [cif_addressbook].row_id DESC ) ='CA'  THEN 'Trucking - CA'
 WHEN  task_detail.userdef02 IN ('TRUCK & TRAILER PURCHASE', 'TRUCK PURCHASE', 'TRUCK REPAIR/RETROFIT', 'TRUCK/RETROFIT PURCHASE', 'TRUCKPURCHASE')  AND isnull((SELECT TOP (1) cif_addressbook.[state] FROM [NLS].[dbo].[cif_addressbook] WHERE (cif_addressbook.entity='BUSINESS ADDRESS' OR address_desc='BUSINESS ADDRESS : A') AND cif_addressbook.[cifno]=task.NLS_refno Order BY [cif_addressbook].row_id DESC ),'') !='CA'  THEN 'Trucking - Non-CA'
				WHEN /*Current Contact Referral Source*/(Select cif_detail.userdef30 As [Referral Source - Current] from [NLS].[dbo].[cif_detail] WHERE [cif_detail].[cifno]=task.NLS_refno )= 'LENDINGCLUB' AND ((SELECT  priority_code FROM [NLS].[dbo].task_priority_codes WHERE task_priority_codes.[priority_code_id]=[task].[priority_code_id]) = 'NEAR PRIME' ) THEN 'Lending Club Near Prime'
				WHEN /*Current Contact Referral Source*/(Select cif_detail.userdef30 As [Referral Source - Current] from [NLS].[dbo].[cif_detail] WHERE [cif_detail].[cifno]=task.NLS_refno )= 'LENDING CLUB' AND ((SELECT  priority_code FROM [NLS].[dbo].task_priority_codes WHERE task_priority_codes.[priority_code_id]=[task].[priority_code_id]) = 'NEAR PRIME' ) THEN 'Lending Club Near Prime'
					WHEN /*Current Contact Referral Source*/(Select cif_detail.userdef30 As [Referral Source - Current] from [NLS].[dbo].[cif_detail] WHERE [cif_detail].[cifno]=task.NLS_refno )= 'LENDINGCLUB' AND ( Isnull((SELECT  priority_code FROM [NLS].[dbo].task_priority_codes WHERE task_priority_codes.[priority_code_id]=[task].[priority_code_id]),'') != 'NEAR PRIME' ) THEN 'Lending Club 2nd Look'
				WHEN /*Current Contact Referral Source*/(Select cif_detail.userdef30 As [Referral Source - Current] from [NLS].[dbo].[cif_detail] WHERE [cif_detail].[cifno]=task.NLS_refno )= 'LENDING CLUB' AND ( Isnull((SELECT  priority_code FROM [NLS].[dbo].task_priority_codes WHERE task_priority_codes.[priority_code_id]=[task].[priority_code_id]),'') != 'NEAR PRIME' ) THEN 'Lending Club 2nd Look'
	
	WHEN task_detail.userdef20 = 'FOOD MOBILE' AND (SELECT TOP (1) cif_addressbook.[state] FROM [NLS].[dbo].[cif_addressbook] WHERE (cif_addressbook.entity='BUSINESS ADDRESS' OR address_desc='BUSINESS ADDRESS : A') AND cif_addressbook.[cifno]=task.NLS_refno Order BY [cif_addressbook].row_id DESC ) ='CA' THEN 'Mobile Food - CA'
	WHEN task_detail.userdef02 = 'MOBILE FOOD' AND (SELECT TOP (1) cif_addressbook.[state] FROM [NLS].[dbo].[cif_addressbook] WHERE (cif_addressbook.entity='BUSINESS ADDRESS' OR address_desc='BUSINESS ADDRESS : A') AND cif_addressbook.[cifno]=task.NLS_refno Order BY [cif_addressbook].row_id DESC ) ='CA' THEN 'Mobile Food - CA'
		WHEN task_detail.userdef20 = 'FOOD MOBILE' AND Isnull((SELECT TOP (1) cif_addressbook.[state] FROM [NLS].[dbo].[cif_addressbook] WHERE (cif_addressbook.entity='BUSINESS ADDRESS' OR address_desc='BUSINESS ADDRESS : A') AND cif_addressbook.[cifno]=task.NLS_refno Order BY [cif_addressbook].row_id DESC ),'') !='CA' THEN 'Mobile Food - Non-CA'
	WHEN task_detail.userdef02 = 'MOBILE FOOD' AND Isnull((SELECT TOP (1) cif_addressbook.[state] FROM [NLS].[dbo].[cif_addressbook] WHERE (cif_addressbook.entity='BUSINESS ADDRESS' OR address_desc='BUSINESS ADDRESS : A') AND cif_addressbook.[cifno]=task.NLS_refno Order BY [cif_addressbook].row_id DESC ),'') !='CA' THEN 'Mobile Food - Non-CA'
	WHEN (Select cif_detail.userdef30 FROM [NLS].[dbo].[cif_detail] WHERE cif_detail.cifno=task.NLS_refno )='PARTNERS' Then 'Community Partners'
	WHEN TRY_Convert(numeric(18,2), Case When task_detail.userdef01='0000000000000.00000' OR task_detail.userdef01='0.00000' THEN NULL ELSE task_detail.userdef01 END) >= 30000 Then 'D2C Small Business'  
	WHEN TRY_Convert(numeric(18,2), Case When task_detail.userdef01='0000000000000.00000' OR task_detail.userdef01='0.00000' THEN NULL ELSE task_detail.userdef01 END) < 30000 Then 'D2C Micro' 
END AS [Segment 2020]
,TRY_CONVERT(numeric(18,0), Case When task_detail.userdef46 ='0000000000000.00000' THEN NULL WHEN TRY_CONVERT(numeric(18,2),task_detail.userdef46)<=999.00 AND TRY_CONVERT(numeric(18,2),task_detail.userdef46)>=200.00 THEN task_detail.userdef46 ELSE NULL END)    AS [FICO Applicant]
,TRY_CONVERT(numeric(18,0), Case When task_detail.userdef93 ='0000000000000.00000' THEN NULL WHEN TRY_CONVERT(numeric(18,2),task_detail.userdef93)<=999.00 AND TRY_CONVERT(numeric(18,2),task_detail.userdef93)>=200.00 THEN task_detail.userdef93 ELSE NULL END)    AS [Pre-Qual FICO]
,ROW_NUMBER() OVER (PARTITION BY task.NLS_refno ORDER BY task.[creation_date]) As [Running Total # Leads for CIF]
,(Select Count([loanacct].[cifno]) FROM [NLS].[dbo].[loanacct] WHERE [loanacct].[cifno]=task.NLS_refno AND [open_date]<= [creation_date]) As [Running Total # Loans for CIF]
,ROW_NUMBER() OVER (PARTITION BY task.NLS_refno, (Select Count([loanacct].[cifno]) FROM [NLS].[dbo].[loanacct] WHERE [loanacct].[cifno]=task.NLS_refno AND [open_date]<= [creation_date]) ORDER BY task.[creation_date]) As [Running Total # Leads for CIF & Loan]

,(SELECT  [LoanRequests].loan_id AS [LC Loan ID]
  FROM [WebLoanRequests].[dbo].[LoanRequests]
  JOIN  [Opportunityfund_MSCRM].dbo.OpportunityBase ON OpportunityBase.[OpportunityId]=[LoanRequests].[OpportunityId]
  WHERE  OpportunityBase.oppfund_NLSTaskRef=task_routing_history.task_refno) AS [LC Loan ID]

		,(	SELECT	[u2].[username]
			FROM	[NLS].[dbo].[nlsusers] u2 
			WHERE	[u2].[userno] = [task].[creator_uid]) AS [Task Created By]
,Isnull((SELECT MAX([mh].[mod_datestamp]) FROM	[NLS].[dbo].[task_modification_history] mh 
					WHERE	[mh].[task_refno] = [task].[task_refno]
							and [mh].[item_changed] = 'Status'),task.[creation_date])  AS [Status Date]
,TRY_Convert(date, [task_detail].[userdef100]) as [Scheduled Book Date]
,Isnull((SELECT MAX([mh].[mod_datestamp]) FROM	[NLS].[dbo].[task_modification_history] mh ,
							[NLS].[dbo].[nlsusers] u2
					WHERE	[mh].[task_refno] = [task].[task_refno]
							AND [task].[owner_uid] = [u2].[userno]
							AND [u2].[username] = [mh].[new_value]
							AND [mh].[item_changed] = 'OWNER'),task.[creation_date])  AS [Assigned Date]

from	NLS.dbo.task_routing_history 
Inner JOIN NLS.dbo.task ON task_routing_history.task_refno=task.task_refno
Inner JOIN NLS.dbo.task_detail ON task_detail.task_refno=task.task_refno
where	workflow_result_id = 19 



GO
