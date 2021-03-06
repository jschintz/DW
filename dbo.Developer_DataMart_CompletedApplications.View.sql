USE [DataMart]
GO
/****** Object:  View [dbo].[Developer_DataMart_CompletedApplications]    Script Date: 8/24/2020 9:49:52 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO









CREATE VIEW [dbo].[Developer_DataMart_CompletedApplications] AS
Select 
task.task_refno As ApplicationID_TaskRefno
,task.NLS_refno As [CIF No]

,(Select MAX(task_routing_history.created_date) FROM NLS.dbo.task_routing_history WHERE task_routing_history.workflow_result_id = 4 AND task_routing_history.task_refno=task.task_refno) AS [Application Create Date]

,TRY_Convert(numeric(18,2), Case When task_detail.userdef01='0000000000000.00000' OR task_detail.userdef01='0.00000' THEN NULL ELSE task_detail.userdef01 END) AS [Requested Amount]
,TRY_Convert(numeric(18,2), Case When task_detail.userdef26='0000000000000.00000' OR task_detail.userdef26='0.00000' OR task_detail.userdef26='0' THEN NULL ELSE task_detail.userdef26 END) AS [Monthly Payment]
,task_detail.userdef02 AS [Primary Loan Use]
,TRY_CONVERT(numeric(18,2), Case When task_detail.userdef23='0000000000000.00000' THEN Null ELSE task_detail.userdef23 END) AS [PQ Loan Amount]
,TRY_CONVERT(numeric(18,0), Case When task_detail.userdef03='0000000000000.00000' THEN Null ELSE task_detail.userdef03 END) AS [PQ Loan Term]
,TRY_CONVERT(numeric(18,2), Case When task_detail.userdef32='0000000000000.00000' OR task_detail.userdef32='0.00000'  OR task_detail.userdef32='0'  THEN Null ELSE task_detail.userdef32 END) AS [PQ Monthly Payment]
,task_detail.userdef20 AS [Product/Service]
,task_detail.userdef04 AS [Years in Business]
,task_detail.userdef06 AS [Months in Business]
,TRY_CONVERT(numeric(18,2), Case When task_detail.userdef05='0000000000000.00000' THEN NULL ELSE task_detail.userdef05 END) AS [Monthly Revenues]
,TRY_CONVERT(numeric(18,2), Case When task_detail.userdef07='0000000000000.00000' THEN NULL ELSE task_detail.userdef07 END) AS [Monthly Net Cash Flow]
,TRY_CONVERT(numeric(18,0), Case When task_detail.userdef67='0000000000000.00000' THEN NULL ELSE task_detail.userdef67 END) AS [Biz Trades Past Due]
,TRY_CONVERT(numeric(18,0), Case When task_detail.userdef68='0000000000000.00000' THEN NULL ELSE task_detail.userdef68 END) AS [Open Tax Liens]
,task_detail.userdef45 AS [Repayment History]
,TRY_CONVERT(numeric(18,0), Case When task_detail.userdef46 ='0000000000000.00000' THEN NULL WHEN TRY_CONVERT(numeric(18,2),task_detail.userdef46)<=999.00 AND TRY_CONVERT(numeric(18,2),task_detail.userdef46)>=200.00 THEN task_detail.userdef46 ELSE NULL END)    AS [FICO Applicant]
,TRY_CONVERT(numeric(18,0), Case When task_detail.userdef93 ='0000000000000.00000' THEN NULL WHEN TRY_CONVERT(numeric(18,2),task_detail.userdef93)<=999.00 AND TRY_CONVERT(numeric(18,2),task_detail.userdef93)>=200.00 THEN task_detail.userdef93 ELSE NULL END)    AS [Pre-Qual FICO]
,TRY_CONVERT(numeric(18,0), Case When task_detail.userdef66 ='0000000000000.00000' THEN NULL WHEN TRY_CONVERT(numeric(18,2),task_detail.userdef66)<=999.00 AND TRY_CONVERT(numeric(18,2),task_detail.userdef66)>=200.00 THEN task_detail.userdef66 ELSE NULL END)    AS [Vantage Score]
,TRY_CONVERT(numeric(18,0), Case When task_detail.userdef47 ='0000000000000.00000' THEN NULL ELSE task_detail.userdef47 END) AS [Trades Past Due]
,TRY_CONVERT(numeric(18,0), Case When task_detail.userdef48 ='0000000000000.00000' THEN NULL ELSE task_detail.userdef48 END) AS [Collection Accounts]
,TRY_CONVERT(numeric(18,0), Case When task_detail.userdef56 ='0000000000000.00000' THEN NULL ELSE task_detail.userdef56 END) AS [Open Trades]
,TRY_CONVERT(numeric(18,0), Case When task_detail.userdef57 ='0000000000000.00000' THEN NULL ELSE task_detail.userdef57 END) AS [Inquiries last 6 months]
,task_detail.userdef29 AS [Denial Date]
,task_detail.userdef79 AS [Denial Reason]

,TRY_CONVERT(numeric(18,2),(SELECT TOP 1 [tmr_udf].userdef01
  FROM [NLS].[dbo].[tmr]
  JOIN  [NLS].[dbo].[tmr_udf] ON [tmr].[tmr_id]=[tmr_udf].[tmr_id] 
  WHERE [tmr].parent_refno=task.task_refno AND [tmr_code_id]=11 ORDER BY [tmr_udf].[tmr_id] DESC )) AS [HH Income AGI]


    ,TRY_CONVERT(numeric(18,0),(SELECT TOP 1 [tmr_udf].userdef02
  FROM [NLS].[dbo].[tmr]
  JOIN  [NLS].[dbo].[tmr_udf] ON [tmr].[tmr_id]=[tmr_udf].[tmr_id] 
  WHERE [tmr].parent_refno=task.task_refno AND [tmr_code_id]=11 ORDER BY [tmr_udf].[tmr_id] DESC )) AS [# people in home]

    ,(SELECT TOP 1 [tmr_udf].userdef03
  FROM [NLS].[dbo].[tmr]
  JOIN  [NLS].[dbo].[tmr_udf] ON [tmr].[tmr_id]=[tmr_udf].[tmr_id] 
  WHERE [tmr].parent_refno=task.task_refno AND [tmr_code_id]=11 ORDER BY [tmr_udf].[tmr_id] DESC ) AS [Head of Household]

    ,TRY_CONVERT(numeric(18,2),(SELECT TOP 1 [tmr_udf].userdef04
  FROM [NLS].[dbo].[tmr]
  JOIN  [NLS].[dbo].[tmr_udf] ON [tmr].[tmr_id]=[tmr_udf].[tmr_id] 
  WHERE [tmr].parent_refno=task.task_refno AND [tmr_code_id]=11 ORDER BY [tmr_udf].[tmr_id] DESC )) AS [Business Takehome HH Income]

    ,TRY_CONVERT(numeric(18,2),(SELECT TOP 1 [tmr_udf].userdef05
  FROM [NLS].[dbo].[tmr]
  JOIN  [NLS].[dbo].[tmr_udf] ON [tmr].[tmr_id]=[tmr_udf].[tmr_id] 
  WHERE [tmr].parent_refno=task.task_refno AND [tmr_code_id]=11 ORDER BY [tmr_udf].[tmr_id] DESC )) AS [Other Job HH Income]

    ,TRY_CONVERT(numeric(18,2),(SELECT TOP 1 [tmr_udf].userdef06
  FROM [NLS].[dbo].[tmr]
  JOIN  [NLS].[dbo].[tmr_udf] ON [tmr].[tmr_id]=[tmr_udf].[tmr_id] 
  WHERE [tmr].parent_refno=task.task_refno AND [tmr_code_id]=11 ORDER BY [tmr_udf].[tmr_id] DESC )) AS [Spouse HH Income]

    ,TRY_CONVERT(numeric(18,2),(SELECT TOP 1 [tmr_udf].userdef07
  FROM [NLS].[dbo].[tmr]
  JOIN  [NLS].[dbo].[tmr_udf] ON [tmr].[tmr_id]=[tmr_udf].[tmr_id] 
  WHERE [tmr].parent_refno=task.task_refno AND [tmr_code_id]=11 ORDER BY [tmr_udf].[tmr_id] DESC )) AS [Public Assistance HH Income]

    ,TRY_CONVERT(numeric(18,2),(SELECT TOP 1 [tmr_udf].userdef08
  FROM [NLS].[dbo].[tmr]
  JOIN  [NLS].[dbo].[tmr_udf] ON [tmr].[tmr_id]=[tmr_udf].[tmr_id] 
  WHERE [tmr].parent_refno=task.task_refno AND [tmr_code_id]=11 ORDER BY [tmr_udf].[tmr_id] DESC )) AS [Other HH Income]

    ,TRY_CONVERT(numeric(18,2),(SELECT TOP 1 [tmr_udf].userdef09
  FROM [NLS].[dbo].[tmr]
  JOIN  [NLS].[dbo].[tmr_udf] ON [tmr].[tmr_id]=[tmr_udf].[tmr_id] 
  WHERE [tmr].parent_refno=task.task_refno AND [tmr_code_id]=11 ORDER BY [tmr_udf].[tmr_id] DESC )) AS [Rent HH Income]

    ,(SELECT TOP 1 [tmr_udf].userdef10
  FROM [NLS].[dbo].[tmr]
  JOIN  [NLS].[dbo].[tmr_udf] ON [tmr].[tmr_id]=[tmr_udf].[tmr_id] 
  WHERE [tmr].parent_refno=task.task_refno AND [tmr_code_id]=11 ORDER BY [tmr_udf].[tmr_id] DESC ) AS [Time in Residence]

    ,TRY_CONVERT(numeric(18,2),(SELECT TOP 1 [tmr_udf].userdef11
  FROM [NLS].[dbo].[tmr]
  JOIN  [NLS].[dbo].[tmr_udf] ON [tmr].[tmr_id]=[tmr_udf].[tmr_id] 
  WHERE [tmr].parent_refno=task.task_refno AND [tmr_code_id]=11 ORDER BY [tmr_udf].[tmr_id] DESC )) AS [Car Gas/Ins/Maint HH Expenses]

    ,TRY_CONVERT(numeric(18,2),(SELECT TOP 1 [tmr_udf].userdef12
  FROM [NLS].[dbo].[tmr]
  JOIN  [NLS].[dbo].[tmr_udf] ON [tmr].[tmr_id]=[tmr_udf].[tmr_id] 
  WHERE [tmr].parent_refno=task.task_refno AND [tmr_code_id]=11 ORDER BY [tmr_udf].[tmr_id] DESC )) AS [Utilities HH Expenses]

    ,TRY_CONVERT(numeric(18,2),(SELECT TOP 1 [tmr_udf].userdef13
  FROM [NLS].[dbo].[tmr]
  JOIN  [NLS].[dbo].[tmr_udf] ON [tmr].[tmr_id]=[tmr_udf].[tmr_id] 
  WHERE [tmr].parent_refno=task.task_refno AND [tmr_code_id]=11 ORDER BY [tmr_udf].[tmr_id] DESC )) AS [Remittances HH Expenses]

    ,TRY_CONVERT(numeric(18,2),(SELECT TOP 1 [tmr_udf].userdef14
  FROM [NLS].[dbo].[tmr]
  JOIN  [NLS].[dbo].[tmr_udf] ON [tmr].[tmr_id]=[tmr_udf].[tmr_id] 
  WHERE [tmr].parent_refno=task.task_refno AND [tmr_code_id]=11 ORDER BY [tmr_udf].[tmr_id] DESC )) AS [Education/Childcare HH Expenses]

    ,TRY_CONVERT(numeric(18,2),(SELECT TOP 1 [tmr_udf].userdef15
  FROM [NLS].[dbo].[tmr]
  JOIN  [NLS].[dbo].[tmr_udf] ON [tmr].[tmr_id]=[tmr_udf].[tmr_id] 
  WHERE [tmr].parent_refno=task.task_refno AND [tmr_code_id]=11 ORDER BY [tmr_udf].[tmr_id] DESC )) AS [Child Support/Alimony HH Expenses]

    ,TRY_CONVERT(numeric(18,2),(SELECT TOP 1 [tmr_udf].userdef16
  FROM [NLS].[dbo].[tmr]
  JOIN  [NLS].[dbo].[tmr_udf] ON [tmr].[tmr_id]=[tmr_udf].[tmr_id] 
  WHERE [tmr].parent_refno=task.task_refno AND [tmr_code_id]=11 ORDER BY [tmr_udf].[tmr_id] DESC )) AS [Personal HH Expenses]

    ,TRY_CONVERT(numeric(18,2),(SELECT TOP 1 [tmr_udf].userdef17
  FROM [NLS].[dbo].[tmr]
  JOIN  [NLS].[dbo].[tmr_udf] ON [tmr].[tmr_id]=[tmr_udf].[tmr_id] 
  WHERE [tmr].parent_refno=task.task_refno AND [tmr_code_id]=11 ORDER BY [tmr_udf].[tmr_id] DESC )) AS [Other HH Expenses]

    ,TRY_CONVERT(numeric(18,2),(SELECT TOP 1 [tmr_udf].userdef18
  FROM [NLS].[dbo].[tmr]
  JOIN  [NLS].[dbo].[tmr_udf] ON [tmr].[tmr_id]=[tmr_udf].[tmr_id] 
  WHERE [tmr].parent_refno=task.task_refno AND [tmr_code_id]=11 ORDER BY [tmr_udf].[tmr_id] DESC )) AS [Total HH Income]

    ,TRY_CONVERT(numeric(18,2),(SELECT TOP 1 [tmr_udf].userdef19
  FROM [NLS].[dbo].[tmr]
  JOIN  [NLS].[dbo].[tmr_udf] ON [tmr].[tmr_id]=[tmr_udf].[tmr_id] 
  WHERE [tmr].parent_refno=task.task_refno AND [tmr_code_id]=11 ORDER BY [tmr_udf].[tmr_id] DESC )) AS [Total HH Expenses]

      ,TRY_CONVERT(numeric(18,2),(SELECT TOP 1 [tmr_udf].userdef01
  FROM [NLS].[dbo].[tmr]
  JOIN  [NLS].[dbo].[tmr_udf] ON [tmr].[tmr_id]=[tmr_udf].[tmr_id] 
  WHERE [tmr].parent_refno=task.task_refno AND [tmr_code_id]=10 ORDER BY [tmr_udf].[tmr_id] DESC )) AS [Current Monthly Biz. Sales]


        ,TRY_CONVERT(numeric(18,2),(SELECT TOP 1 [tmr_udf].userdef02
  FROM [NLS].[dbo].[tmr]
  JOIN  [NLS].[dbo].[tmr_udf] ON [tmr].[tmr_id]=[tmr_udf].[tmr_id] 
  WHERE [tmr].parent_refno=task.task_refno AND [tmr_code_id]=10 ORDER BY [tmr_udf].[tmr_id] DESC )) AS [Last Year Monthly Biz. Sales]

        ,TRY_CONVERT(numeric(18,2),(SELECT TOP 1 [tmr_udf].userdef03
  FROM [NLS].[dbo].[tmr]
  JOIN  [NLS].[dbo].[tmr_udf] ON [tmr].[tmr_id]=[tmr_udf].[tmr_id] 
  WHERE [tmr].parent_refno=task.task_refno AND [tmr_code_id]=10 ORDER BY [tmr_udf].[tmr_id] DESC )) AS [Current Monthly Biz. COGS]

        ,TRY_CONVERT(numeric(18,2),(SELECT TOP 1 [tmr_udf].userdef04
  FROM [NLS].[dbo].[tmr]
  JOIN  [NLS].[dbo].[tmr_udf] ON [tmr].[tmr_id]=[tmr_udf].[tmr_id] 
  WHERE [tmr].parent_refno=task.task_refno AND [tmr_code_id]=10 ORDER BY [tmr_udf].[tmr_id] DESC )) AS [Current Monthly Biz. Gross Margin]

        ,TRY_CONVERT(numeric(18,2),(SELECT TOP 1 [tmr_udf].userdef05
  FROM [NLS].[dbo].[tmr]
  JOIN  [NLS].[dbo].[tmr_udf] ON [tmr].[tmr_id]=[tmr_udf].[tmr_id] 
  WHERE [tmr].parent_refno=task.task_refno AND [tmr_code_id]=10 ORDER BY [tmr_udf].[tmr_id] DESC )) AS [Projected Monthly Biz. Sales]

        ,TRY_CONVERT(numeric(18,2),(SELECT TOP 1 [tmr_udf].userdef06
  FROM [NLS].[dbo].[tmr]
  JOIN  [NLS].[dbo].[tmr_udf] ON [tmr].[tmr_id]=[tmr_udf].[tmr_id] 
  WHERE [tmr].parent_refno=task.task_refno AND [tmr_code_id]=10 ORDER BY [tmr_udf].[tmr_id] DESC )) AS [Projected Biz. COGS]

        ,TRY_CONVERT(numeric(18,2),(SELECT TOP 1 [tmr_udf].userdef07
  FROM [NLS].[dbo].[tmr]
  JOIN  [NLS].[dbo].[tmr_udf] ON [tmr].[tmr_id]=[tmr_udf].[tmr_id] 
  WHERE [tmr].parent_refno=task.task_refno AND [tmr_code_id]=10 ORDER BY [tmr_udf].[tmr_id] DESC )) AS [Projected Biz. Gross Margin]

        ,TRY_CONVERT(numeric(18,2),(SELECT TOP 1 [tmr_udf].userdef08
  FROM [NLS].[dbo].[tmr]
  JOIN  [NLS].[dbo].[tmr_udf] ON [tmr].[tmr_id]=[tmr_udf].[tmr_id] 
  WHERE [tmr].parent_refno=task.task_refno AND [tmr_code_id]=10 ORDER BY [tmr_udf].[tmr_id] DESC )) AS [Biz. Net Cash Flow]

          ,TRY_CONVERT(numeric(18,2),(SELECT TOP 1 [tmr_udf].userdef17
  FROM [NLS].[dbo].[tmr]
  JOIN  [NLS].[dbo].[tmr_udf] ON [tmr].[tmr_id]=[tmr_udf].[tmr_id] 
  WHERE [tmr].parent_refno=task.task_refno AND [tmr_code_id]=10 ORDER BY [tmr_udf].[tmr_id] DESC )) AS [Projected Biz. Net Cash Flow]

              ,TRY_CONVERT(numeric(18,2),(SELECT TOP 1 [tmr_udf].userdef09
  FROM [NLS].[dbo].[tmr]
  JOIN  [NLS].[dbo].[tmr_udf] ON [tmr].[tmr_id]=[tmr_udf].[tmr_id] 
  WHERE [tmr].parent_refno=task.task_refno AND [tmr_code_id]=10 ORDER BY [tmr_udf].[tmr_id] DESC )) AS [Rent/Lease Biz. Expenses]

              ,TRY_CONVERT(numeric(18,2),(SELECT TOP 1 [tmr_udf].userdef10
  FROM [NLS].[dbo].[tmr]
  JOIN  [NLS].[dbo].[tmr_udf] ON [tmr].[tmr_id]=[tmr_udf].[tmr_id] 
  WHERE [tmr].parent_refno=task.task_refno AND [tmr_code_id]=10 ORDER BY [tmr_udf].[tmr_id] DESC )) AS [Employee Wages Biz. Expenses]

                ,TRY_CONVERT(numeric(18,2),(SELECT TOP 1 [tmr_udf].userdef26
  FROM [NLS].[dbo].[tmr]
  JOIN  [NLS].[dbo].[tmr_udf] ON [tmr].[tmr_id]=[tmr_udf].[tmr_id] 
  WHERE [tmr].parent_refno=task.task_refno AND [tmr_code_id]=10 ORDER BY [tmr_udf].[tmr_id] DESC )) AS [Owner Wages Biz. Expenses]

            ,TRY_CONVERT(numeric(18,2),(SELECT TOP 1 [tmr_udf].userdef11
  FROM [NLS].[dbo].[tmr]
  JOIN  [NLS].[dbo].[tmr_udf] ON [tmr].[tmr_id]=[tmr_udf].[tmr_id] 
  WHERE [tmr].parent_refno=task.task_refno AND [tmr_code_id]=10 ORDER BY [tmr_udf].[tmr_id] DESC )) AS [Gas/Ins/Maint Biz. Expenses]

              ,TRY_CONVERT(numeric(18,2),(SELECT TOP 1 [tmr_udf].userdef12
  FROM [NLS].[dbo].[tmr]
  JOIN  [NLS].[dbo].[tmr_udf] ON [tmr].[tmr_id]=[tmr_udf].[tmr_id] 
  WHERE [tmr].parent_refno=task.task_refno AND [tmr_code_id]=10 ORDER BY [tmr_udf].[tmr_id] DESC )) AS [Advertising Biz. Expenses]

              ,TRY_CONVERT(numeric(18,2),(SELECT TOP 1 [tmr_udf].userdef13
  FROM [NLS].[dbo].[tmr]
  JOIN  [NLS].[dbo].[tmr_udf] ON [tmr].[tmr_id]=[tmr_udf].[tmr_id] 
  WHERE [tmr].parent_refno=task.task_refno AND [tmr_code_id]=10 ORDER BY [tmr_udf].[tmr_id] DESC )) AS [Utilities/Bills Biz. Expenses]

              ,TRY_CONVERT(numeric(18,2),(SELECT TOP 1 [tmr_udf].userdef14
  FROM [NLS].[dbo].[tmr]
  JOIN  [NLS].[dbo].[tmr_udf] ON [tmr].[tmr_id]=[tmr_udf].[tmr_id] 
  WHERE [tmr].parent_refno=task.task_refno AND [tmr_code_id]=10 ORDER BY [tmr_udf].[tmr_id] DESC )) AS [Other Biz. Expenses]

              ,TRY_CONVERT(numeric(18,2),(SELECT TOP 1 [tmr_udf].userdef27
  FROM [NLS].[dbo].[tmr]
  JOIN  [NLS].[dbo].[tmr_udf] ON [tmr].[tmr_id]=[tmr_udf].[tmr_id] 
  WHERE [tmr].parent_refno=task.task_refno AND [tmr_code_id]=10 ORDER BY [tmr_udf].[tmr_id] DESC )) AS [Dep/Amort Biz. Expenses]

              ,TRY_CONVERT(numeric(18,2),(SELECT TOP 1 [tmr_udf].userdef15
  FROM [NLS].[dbo].[tmr]
  JOIN  [NLS].[dbo].[tmr_udf] ON [tmr].[tmr_id]=[tmr_udf].[tmr_id] 
  WHERE [tmr].parent_refno=task.task_refno AND [tmr_code_id]=10 ORDER BY [tmr_udf].[tmr_id] DESC )) AS [Total Monthly Biz. Expenses]

              ,TRY_CONVERT(numeric(18,2),(SELECT TOP 1 [tmr_udf].userdef16
  FROM [NLS].[dbo].[tmr]
  JOIN  [NLS].[dbo].[tmr_udf] ON [tmr].[tmr_id]=[tmr_udf].[tmr_id] 
  WHERE [tmr].parent_refno=task.task_refno AND [tmr_code_id]=10 ORDER BY [tmr_udf].[tmr_id] DESC )) AS [Projected Net Biz. Expenses]

  /* Start Exception List*/
                ,TRY_CONVERT(bit,(SELECT TOP 1 [tmr_udf].userdef01
  FROM [NLS].[dbo].[tmr]
  JOIN  [NLS].[dbo].[tmr_udf] ON [tmr].[tmr_id]=[tmr_udf].[tmr_id] 
  WHERE [tmr].parent_refno=task.task_refno AND [tmr_code_id]=27 ORDER BY [tmr_udf].[tmr_id] DESC )) AS [Time in Business Exception]
              
			    ,TRY_CONVERT(bit,(SELECT TOP 1 [tmr_udf].userdef02
  FROM [NLS].[dbo].[tmr]
  JOIN  [NLS].[dbo].[tmr_udf] ON [tmr].[tmr_id]=[tmr_udf].[tmr_id] 
  WHERE [tmr].parent_refno=task.task_refno AND [tmr_code_id]=27 ORDER BY [tmr_udf].[tmr_id] DESC )) AS [Minimum FICO Exception]

                  ,TRY_CONVERT(bit,(SELECT TOP 1 [tmr_udf].userdef03
  FROM [NLS].[dbo].[tmr]
  JOIN  [NLS].[dbo].[tmr_udf] ON [tmr].[tmr_id]=[tmr_udf].[tmr_id] 
  WHERE [tmr].parent_refno=task.task_refno AND [tmr_code_id]=27 ORDER BY [tmr_udf].[tmr_id] DESC )) AS [Industry Exception]

                  ,TRY_CONVERT(bit,(SELECT TOP 1 [tmr_udf].userdef04
  FROM [NLS].[dbo].[tmr]
  JOIN  [NLS].[dbo].[tmr_udf] ON [tmr].[tmr_id]=[tmr_udf].[tmr_id] 
  WHERE [tmr].parent_refno=task.task_refno AND [tmr_code_id]=27 ORDER BY [tmr_udf].[tmr_id] DESC )) AS [Financial Documentation Exception]

                  ,TRY_CONVERT(bit,(SELECT TOP 1 [tmr_udf].userdef05
  FROM [NLS].[dbo].[tmr]
  JOIN  [NLS].[dbo].[tmr_udf] ON [tmr].[tmr_id]=[tmr_udf].[tmr_id] 
  WHERE [tmr].parent_refno=task.task_refno AND [tmr_code_id]=27 ORDER BY [tmr_udf].[tmr_id] DESC )) AS [Ownership Issues Exception]

                  ,TRY_CONVERT(bit,(SELECT TOP 1 [tmr_udf].userdef06
  FROM [NLS].[dbo].[tmr]
  JOIN  [NLS].[dbo].[tmr_udf] ON [tmr].[tmr_id]=[tmr_udf].[tmr_id] 
  WHERE [tmr].parent_refno=task.task_refno AND [tmr_code_id]=27 ORDER BY [tmr_udf].[tmr_id] DESC )) AS [Non-financial Documentation Exception]

                  ,TRY_CONVERT(bit,(SELECT TOP 1 [tmr_udf].userdef07
  FROM [NLS].[dbo].[tmr]
  JOIN  [NLS].[dbo].[tmr_udf] ON [tmr].[tmr_id]=[tmr_udf].[tmr_id] 
  WHERE [tmr].parent_refno=task.task_refno AND [tmr_code_id]=27 ORDER BY [tmr_udf].[tmr_id] DESC )) AS [UW Guidelines Exception]

                  ,TRY_CONVERT(bit,(SELECT TOP 1 [tmr_udf].userdef08
  FROM [NLS].[dbo].[tmr]
  JOIN  [NLS].[dbo].[tmr_udf] ON [tmr].[tmr_id]=[tmr_udf].[tmr_id] 
  WHERE [tmr].parent_refno=task.task_refno AND [tmr_code_id]=27 ORDER BY [tmr_udf].[tmr_id] DESC )) AS [Credit History Guidelines Exception]

                  ,TRY_CONVERT(bit,(SELECT TOP 1 [tmr_udf].userdef09
  FROM [NLS].[dbo].[tmr]
  JOIN  [NLS].[dbo].[tmr_udf] ON [tmr].[tmr_id]=[tmr_udf].[tmr_id] 
  WHERE [tmr].parent_refno=task.task_refno AND [tmr_code_id]=27 ORDER BY [tmr_udf].[tmr_id] DESC )) AS [Collateral Gap Exception]

                  ,TRY_CONVERT(bit,(SELECT TOP 1 [tmr_udf].userdef10
  FROM [NLS].[dbo].[tmr]
  JOIN  [NLS].[dbo].[tmr_udf] ON [tmr].[tmr_id]=[tmr_udf].[tmr_id] 
  WHERE [tmr].parent_refno=task.task_refno AND [tmr_code_id]=27 ORDER BY [tmr_udf].[tmr_id] DESC )) AS [Collateral Guidelines Exception]

                  ,TRY_CONVERT(bit,(SELECT TOP 1 [tmr_udf].userdef11
  FROM [NLS].[dbo].[tmr]
  JOIN  [NLS].[dbo].[tmr_udf] ON [tmr].[tmr_id]=[tmr_udf].[tmr_id] 
  WHERE [tmr].parent_refno=task.task_refno AND [tmr_code_id]=27 ORDER BY [tmr_udf].[tmr_id] DESC )) AS [Pricing Exception]

                  ,TRY_CONVERT(bit,(SELECT TOP 1 [tmr_udf].userdef12
  FROM [NLS].[dbo].[tmr]
  JOIN  [NLS].[dbo].[tmr_udf] ON [tmr].[tmr_id]=[tmr_udf].[tmr_id] 
  WHERE [tmr].parent_refno=task.task_refno AND [tmr_code_id]=27 ORDER BY [tmr_udf].[tmr_id] DESC )) AS [Amount Exception]

                  ,TRY_CONVERT(bit,(SELECT TOP 1 [tmr_udf].userdef18
  FROM [NLS].[dbo].[tmr]
  JOIN  [NLS].[dbo].[tmr_udf] ON [tmr].[tmr_id]=[tmr_udf].[tmr_id] 
  WHERE [tmr].parent_refno=task.task_refno AND [tmr_code_id]=27 ORDER BY [tmr_udf].[tmr_id] DESC )) AS [External Data Validation Audit]

                  ,TRY_CONVERT(bit,(SELECT TOP 1 [tmr_udf].userdef19
  FROM [NLS].[dbo].[tmr]
  JOIN  [NLS].[dbo].[tmr_udf] ON [tmr].[tmr_id]=[tmr_udf].[tmr_id] 
  WHERE [tmr].parent_refno=task.task_refno AND [tmr_code_id]=27 ORDER BY [tmr_udf].[tmr_id] DESC )) AS [Soft Incomplete Audit]

                  ,TRY_CONVERT(bit,(SELECT TOP 1 [tmr_udf].userdef20
  FROM [NLS].[dbo].[tmr]
  JOIN  [NLS].[dbo].[tmr_udf] ON [tmr].[tmr_id]=[tmr_udf].[tmr_id] 
  WHERE [tmr].parent_refno=task.task_refno AND [tmr_code_id]=27 ORDER BY [tmr_udf].[tmr_id] DESC )) AS [Hard Incomplete Audit]

                  ,TRY_CONVERT(bit,(SELECT TOP 1 [tmr_udf].userdef21
  FROM [NLS].[dbo].[tmr]
  JOIN  [NLS].[dbo].[tmr_udf] ON [tmr].[tmr_id]=[tmr_udf].[tmr_id] 
  WHERE [tmr].parent_refno=task.task_refno AND [tmr_code_id]=27 ORDER BY [tmr_udf].[tmr_id] DESC )) AS [Info not transferred from app Exception]

                  ,TRY_CONVERT(bit,(SELECT TOP 1 [tmr_udf].userdef22
  FROM [NLS].[dbo].[tmr]
  JOIN  [NLS].[dbo].[tmr_udf] ON [tmr].[tmr_id]=[tmr_udf].[tmr_id] 
  WHERE [tmr].parent_refno=task.task_refno AND [tmr_code_id]=27 ORDER BY [tmr_udf].[tmr_id] DESC )) AS [Number of Employees not Entered Exception]

                    ,TRY_CONVERT(bit,(SELECT TOP 1 [tmr_udf].userdef23
  FROM [NLS].[dbo].[tmr]
  JOIN  [NLS].[dbo].[tmr_udf] ON [tmr].[tmr_id]=[tmr_udf].[tmr_id] 
  WHERE [tmr].parent_refno=task.task_refno AND [tmr_code_id]=27 ORDER BY [tmr_udf].[tmr_id] DESC )) AS [Business Name Exception]

                      ,TRY_CONVERT(bit,(SELECT TOP 1 [tmr_udf].userdef24
  FROM [NLS].[dbo].[tmr]
  JOIN  [NLS].[dbo].[tmr_udf] ON [tmr].[tmr_id]=[tmr_udf].[tmr_id] 
  WHERE [tmr].parent_refno=task.task_refno AND [tmr_code_id]=27 ORDER BY [tmr_udf].[tmr_id] DESC )) AS [Business Start Date Exception]

                      ,TRY_CONVERT(bit,(SELECT TOP 1 [tmr_udf].userdef25
  FROM [NLS].[dbo].[tmr]
  JOIN  [NLS].[dbo].[tmr_udf] ON [tmr].[tmr_id]=[tmr_udf].[tmr_id] 
  WHERE [tmr].parent_refno=task.task_refno AND [tmr_code_id]=27 ORDER BY [tmr_udf].[tmr_id] DESC )) AS [Primary Use of Funds Exception]

                      ,TRY_CONVERT(bit,(SELECT TOP 1 [tmr_udf].userdef26
  FROM [NLS].[dbo].[tmr]
  JOIN  [NLS].[dbo].[tmr_udf] ON [tmr].[tmr_id]=[tmr_udf].[tmr_id] 
  WHERE [tmr].parent_refno=task.task_refno AND [tmr_code_id]=27 ORDER BY [tmr_udf].[tmr_id] DESC )) AS [Business Entitiy Incorrect Exception]

                      ,TRY_CONVERT(bit,(SELECT TOP 1 [tmr_udf].userdef27
  FROM [NLS].[dbo].[tmr]
  JOIN  [NLS].[dbo].[tmr_udf] ON [tmr].[tmr_id]=[tmr_udf].[tmr_id] 
  WHERE [tmr].parent_refno=task.task_refno AND [tmr_code_id]=27 ORDER BY [tmr_udf].[tmr_id] DESC )) AS [Reports not pulled Exception]

                      ,TRY_CONVERT(bit,(SELECT TOP 1 [tmr_udf].userdef28
  FROM [NLS].[dbo].[tmr]
  JOIN  [NLS].[dbo].[tmr_udf] ON [tmr].[tmr_id]=[tmr_udf].[tmr_id] 
  WHERE [tmr].parent_refno=task.task_refno AND [tmr_code_id]=27 ORDER BY [tmr_udf].[tmr_id] DESC )) AS [Tax Info Exception]

                      ,TRY_CONVERT(bit,(SELECT TOP 1 [tmr_udf].userdef29
  FROM [NLS].[dbo].[tmr]
  JOIN  [NLS].[dbo].[tmr_udf] ON [tmr].[tmr_id]=[tmr_udf].[tmr_id] 
  WHERE [tmr].parent_refno=task.task_refno AND [tmr_code_id]=27 ORDER BY [tmr_udf].[tmr_id] DESC )) AS [Email Age High Risk Exception]

                      ,TRY_CONVERT(bit,(SELECT TOP 1 [tmr_udf].userdef30
  FROM [NLS].[dbo].[tmr]
  JOIN  [NLS].[dbo].[tmr_udf] ON [tmr].[tmr_id]=[tmr_udf].[tmr_id] 
  WHERE [tmr].parent_refno=task.task_refno AND [tmr_code_id]=27 ORDER BY [tmr_udf].[tmr_id] DESC )) AS [Specs Missing Exception]

    ,(select TOP 1
	CreditProfile.[CreditBureauName]
	from NLS.dbo.tmr 
	inner join NLS.dbo.CreditProfile on tmr.child_refno=CreditProfile.CreditProfileID 
	WHERE tmr_code_id = 7 AND tmr.parent_refno=task.task_refno
	ORDER BY CreditProfileID DESC) AS [Credit Bureau - Hard Pull]

	,(select TOP 1
	CreditProfile.[ReportDate]
	from NLS.dbo.tmr 
	inner join NLS.dbo.CreditProfile on tmr.child_refno=CreditProfile.CreditProfileID 
	WHERE tmr_code_id = 7 AND tmr.parent_refno=task.task_refno
	ORDER BY CreditProfileID DESC) AS [Credit Report Date - Hard Pull]

		,(select TOP 1
	CreditProfile.[CreditProfileID]
	from NLS.dbo.tmr 
	inner join NLS.dbo.CreditProfile on tmr.child_refno=CreditProfile.CreditProfileID 
	WHERE tmr_code_id = 7 AND tmr.parent_refno=task.task_refno
	ORDER BY CreditProfileID DESC) AS [Credit Report ID - Hard Pull]

  ,(select TOP 1
	CreditRiskModel.Score
	from NLS.dbo.tmr 
	inner join NLS.dbo.CreditRiskModel on tmr.child_refno=CreditRiskModel.CreditProfileID 
	WHERE ScoreType IN ('V3','V60') and tmr_code_id = 7 AND tmr.parent_refno=task.task_refno
	ORDER BY CreditProfileID DESC) AS [VS3 Credit Risk Score - Hard Pull]

	,(select TOP 1
	CreditRiskModel.Score
	from NLS.dbo.tmr 
	inner join NLS.dbo.CreditRiskModel on tmr.child_refno=CreditRiskModel.CreditProfileID 
	WHERE ScoreType='601' and tmr_code_id = 7 AND tmr.parent_refno=task.task_refno
	ORDER BY CreditProfileID DESC) AS [601 FICO Bankruptcy Risk Score - Hard Pull]

	,(select TOP 1
	CreditRiskModel.Score
	from NLS.dbo.tmr 
	inner join NLS.dbo.CreditRiskModel on tmr.child_refno=CreditRiskModel.CreditProfileID 
	WHERE ScoreType='P02' and tmr_code_id = 7 AND tmr.parent_refno=task.task_refno
	ORDER BY CreditProfileID DESC) AS [P02 FICO Credit Risk Score Classic 2004 - Hard Pull]

		,(select TOP 1
	CreditRiskModel.Score
	from NLS.dbo.tmr 
	inner join NLS.dbo.CreditRiskModel on tmr.child_refno=CreditRiskModel.CreditProfileID 
	WHERE ScoreType='AA' and tmr_code_id = 7 AND tmr.parent_refno=task.task_refno
	ORDER BY CreditProfileID DESC) AS [AA FICO3 Credit Risk Score - Hard Pull]

	  ,(select TOP 1
	CreditRiskModel.Score
	from NLS.dbo.tmr 
	inner join NLS.dbo.CreditRiskModel on tmr.child_refno=CreditRiskModel.CreditProfileID 
	WHERE ScoreType='V2' and tmr_code_id = 7 AND tmr.parent_refno=task.task_refno
	ORDER BY CreditProfileID DESC) AS [VS2 Credit Risk Score - Hard Pull]

	  ,(select TOP 1
	CreditRiskModel.Score
	from NLS.dbo.tmr 
	inner join NLS.dbo.CreditRiskModel on tmr.child_refno=CreditRiskModel.CreditProfileID 
	WHERE ScoreType='Q88' and tmr_code_id = 7 AND tmr.parent_refno=task.task_refno
	ORDER BY CreditProfileID DESC) AS [Q88 FICO8 Credit Risk Score - Hard Pull]

	,(select TOP 1
	CreditProfile.[PublicRecordsCount]
	from NLS.dbo.tmr 
	inner join NLS.dbo.CreditProfile on tmr.child_refno=CreditProfile.CreditProfileID 
	WHERE tmr_code_id = 7 AND tmr.parent_refno=task.task_refno
	ORDER BY CreditProfileID DESC) AS [Public Records Count - Hard Pull]

	,(select TOP 1
	CreditProfile.[InstallmentBalance]
	from NLS.dbo.tmr 
	inner join NLS.dbo.CreditProfile on tmr.child_refno=CreditProfile.CreditProfileID 
	WHERE tmr_code_id = 7 AND tmr.parent_refno=task.task_refno
	ORDER BY CreditProfileID DESC) AS [Installment Balance - Hard Pull]

		,(select TOP 1
	CreditProfile.[RealEstateBalance]
	from NLS.dbo.tmr 
	inner join NLS.dbo.CreditProfile on tmr.child_refno=CreditProfile.CreditProfileID 
	WHERE tmr_code_id = 7 AND tmr.parent_refno=task.task_refno
	ORDER BY CreditProfileID DESC) AS [Real Estate Balance - Hard Pull]

			,(select TOP 1
	CreditProfile.[RevolvingBalance]
	from NLS.dbo.tmr 
	inner join NLS.dbo.CreditProfile on tmr.child_refno=CreditProfile.CreditProfileID 
	WHERE tmr_code_id = 7 AND tmr.parent_refno=task.task_refno
	ORDER BY CreditProfileID DESC) AS [Revolving - Hard Pull]

				,(select TOP 1
	CreditProfile.[PastDueAmount]
	from NLS.dbo.tmr 
	inner join NLS.dbo.CreditProfile on tmr.child_refno=CreditProfile.CreditProfileID 
	WHERE tmr_code_id = 7 AND tmr.parent_refno=task.task_refno
	ORDER BY CreditProfileID DESC) AS [Past Due Amount - Hard Pull]

	
				,(select TOP 1
	CreditProfile.[MonthlyPayment]
	from NLS.dbo.tmr 
	inner join NLS.dbo.CreditProfile on tmr.child_refno=CreditProfile.CreditProfileID 
	WHERE tmr_code_id = 7 AND tmr.parent_refno=task.task_refno
	ORDER BY CreditProfileID DESC) AS [Monthly Payment - Hard Pull]

					,(select TOP 1
	CreditProfile.[RealEstatePayment]
	from NLS.dbo.tmr 
	inner join NLS.dbo.CreditProfile on tmr.child_refno=CreditProfile.CreditProfileID 
	WHERE tmr_code_id = 7 AND tmr.parent_refno=task.task_refno
	ORDER BY CreditProfileID DESC) AS [Real Estate Payment - Hard Pull]

					,(select TOP 1
	CreditProfile.[RevolvingAvailablePercent]
	from NLS.dbo.tmr 
	inner join NLS.dbo.CreditProfile on tmr.child_refno=CreditProfile.CreditProfileID 
	WHERE tmr_code_id = 7 AND tmr.parent_refno=task.task_refno
	ORDER BY CreditProfileID DESC) AS [Revolving Available Percent - Hard Pull]
					
					,(select TOP 1
	CreditProfile.[TotalInquiries]
	from NLS.dbo.tmr 
	inner join NLS.dbo.CreditProfile on tmr.child_refno=CreditProfile.CreditProfileID 
	WHERE tmr_code_id = 7 AND tmr.parent_refno=task.task_refno
	ORDER BY CreditProfileID DESC) AS [Total Inquiries - Hard Pull]

						,(select TOP 1
	CreditProfile.[InquiriesDuringLast6Months]
	from NLS.dbo.tmr 
	inner join NLS.dbo.CreditProfile on tmr.child_refno=CreditProfile.CreditProfileID 
	WHERE tmr_code_id = 7 AND tmr.parent_refno=task.task_refno
	ORDER BY CreditProfileID DESC) AS [Inquiries During Last 6 Months - Hard Pull]

							,(select TOP 1
	CreditProfile.[TotalTradeLines]
	from NLS.dbo.tmr 
	inner join NLS.dbo.CreditProfile on tmr.child_refno=CreditProfile.CreditProfileID 
	WHERE tmr_code_id = 7 AND tmr.parent_refno=task.task_refno
	ORDER BY CreditProfileID DESC) AS [Total Trade Lines - Hard Pull]

							,(select TOP 1
	CreditProfile.[PaidAccountsCount]
	from NLS.dbo.tmr 
	inner join NLS.dbo.CreditProfile on tmr.child_refno=CreditProfile.CreditProfileID 
	WHERE tmr_code_id = 7 AND tmr.parent_refno=task.task_refno
	ORDER BY CreditProfileID DESC) AS [Paid Accounts Count - Hard Pull]

							,(select TOP 1
	CreditProfile.[SatisfactoryAccounts]
	from NLS.dbo.tmr 
	inner join NLS.dbo.CreditProfile on tmr.child_refno=CreditProfile.CreditProfileID 
	WHERE tmr_code_id = 7 AND tmr.parent_refno=task.task_refno
	ORDER BY CreditProfileID DESC) AS [Satisfactory Accounts - Hard Pull]

								,(select TOP 1
	CreditProfile.[NowDelinquentDerog]
	from NLS.dbo.tmr 
	inner join NLS.dbo.CreditProfile on tmr.child_refno=CreditProfile.CreditProfileID 
	WHERE tmr_code_id = 7 AND tmr.parent_refno=task.task_refno
	ORDER BY CreditProfileID DESC) AS [Now Delinquent Derog - Hard Pull]

								,(select TOP 1
	CreditProfile.[WasDelinquentDerog]
	from NLS.dbo.tmr 
	inner join NLS.dbo.CreditProfile on tmr.child_refno=CreditProfile.CreditProfileID 
	WHERE tmr_code_id = 7 AND tmr.parent_refno=task.task_refno
	ORDER BY CreditProfileID DESC) AS [Was Delinquent Derog - Hard Pull]

								,(select TOP 1
	CreditProfile.[DelinquenciesOver30Days]
	from NLS.dbo.tmr 
	inner join NLS.dbo.CreditProfile on tmr.child_refno=CreditProfile.CreditProfileID 
	WHERE tmr_code_id = 7 AND tmr.parent_refno=task.task_refno
	ORDER BY CreditProfileID DESC) AS [Delinquencies Over 30 Days - Hard Pull]

								,(select TOP 1
	CreditProfile.[DelinquenciesOver60Days]
	from NLS.dbo.tmr 
	inner join NLS.dbo.CreditProfile on tmr.child_refno=CreditProfile.CreditProfileID 
	WHERE tmr_code_id = 7 AND tmr.parent_refno=task.task_refno
	ORDER BY CreditProfileID DESC) AS [Delinquencies Over 60 Days - Hard Pull]

									,(select TOP 1
	CreditProfile.[DelinquenciesOver90Days]
	from NLS.dbo.tmr 
	inner join NLS.dbo.CreditProfile on tmr.child_refno=CreditProfile.CreditProfileID 
	WHERE tmr_code_id = 7 AND tmr.parent_refno=task.task_refno
	ORDER BY CreditProfileID DESC) AS [Delinquencies Over 90 Days - Hard Pull]

										,(select TOP 1
	CreditProfile.[DerogCount]
	from NLS.dbo.tmr 
	inner join NLS.dbo.CreditProfile on tmr.child_refno=CreditProfile.CreditProfileID 
	WHERE tmr_code_id = 7 AND tmr.parent_refno=task.task_refno
	ORDER BY CreditProfileID DESC) AS [Derog Count - Hard Pull]

	,  (Select Count(0)
	FROM NLS.[dbo].[CreditTradeLine]
	WHERE CreditTradeLine.CreditProfileID = (select TOP 1 CreditProfile.[CreditProfileID] from NLS.dbo.tmr inner join NLS.dbo.CreditProfile on tmr.child_refno=CreditProfile.CreditProfileID WHERE tmr_code_id = 7 AND tmr.parent_refno=task.task_refno ORDER BY CreditProfileID DESC)
	AND CreditTradeLine.IsRevolving='R'
	) AS [Total Accounts Count Revolving - Hard Pull Tradelines]

	,  (Select Sum(TRY_Convert(numeric(18,2),[CreditLimitAmount]))
	FROM NLS.[dbo].[CreditTradeLine]
	WHERE CreditTradeLine.CreditProfileID = (select TOP 1 CreditProfile.[CreditProfileID] from NLS.dbo.tmr inner join NLS.dbo.CreditProfile on tmr.child_refno=CreditProfile.CreditProfileID WHERE tmr_code_id = 7 AND tmr.parent_refno=task.task_refno ORDER BY CreditProfileID DESC)
	AND CreditTradeLine.IsRevolving='R'
	) AS [Total Credit Limit Revolving - Hard Pull Tradelines]  

	,  (Select Sum(TRY_Convert(numeric(18,2),[HighCreditAmount]))
	FROM NLS.[dbo].[CreditTradeLine]
	WHERE CreditTradeLine.CreditProfileID = (select TOP 1 CreditProfile.[CreditProfileID] from NLS.dbo.tmr inner join NLS.dbo.CreditProfile on tmr.child_refno=CreditProfile.CreditProfileID WHERE tmr_code_id = 7 AND tmr.parent_refno=task.task_refno ORDER BY CreditProfileID DESC)
	AND CreditTradeLine.IsRevolving='R'
	) AS [Total High Credit Amount Revolving - Hard Pull Tradelines] 

	,  (Select Sum(TRY_Convert(numeric(18,2),[OriginalAmount]))
	FROM NLS.[dbo].[CreditTradeLine]
	WHERE CreditTradeLine.CreditProfileID = (select TOP 1 CreditProfile.[CreditProfileID] from NLS.dbo.tmr inner join NLS.dbo.CreditProfile on tmr.child_refno=CreditProfile.CreditProfileID WHERE tmr_code_id = 7 AND tmr.parent_refno=task.task_refno ORDER BY CreditProfileID DESC)
	AND CreditTradeLine.IsRevolving='R'
	) AS [Total Original Amount Revolving - Hard Pull Tradelines] 

	,  (Select Sum(TRY_Convert(numeric(18,2),[BalanceAmount]))
	FROM NLS.[dbo].[CreditTradeLine]
	WHERE CreditTradeLine.CreditProfileID = (select TOP 1 CreditProfile.[CreditProfileID] from NLS.dbo.tmr inner join NLS.dbo.CreditProfile on tmr.child_refno=CreditProfile.CreditProfileID WHERE tmr_code_id = 7 AND tmr.parent_refno=task.task_refno ORDER BY CreditProfileID DESC)
	AND CreditTradeLine.IsRevolving='R'
	) AS [Total Outstanding Balances Revolving - Hard Pull Tradelines] 

	,  (Select Sum(TRY_Convert(numeric(18,2),[AmountPastDue]))
	FROM NLS.[dbo].[CreditTradeLine]
	WHERE CreditTradeLine.CreditProfileID = (select TOP 1 CreditProfile.[CreditProfileID] from NLS.dbo.tmr inner join NLS.dbo.CreditProfile on tmr.child_refno=CreditProfile.CreditProfileID WHERE tmr_code_id = 7 AND tmr.parent_refno=task.task_refno ORDER BY CreditProfileID DESC)
	AND CreditTradeLine.IsRevolving='R'
	) AS [Total Past Due Amounts Revolving - Hard Pull Tradelines] 

			,  (Select Count(0)
	FROM NLS.[dbo].[CreditTradeLine]
	WHERE CreditTradeLine.CreditProfileID = (select TOP 1 CreditProfile.[CreditProfileID] from NLS.dbo.tmr inner join NLS.dbo.CreditProfile on tmr.child_refno=CreditProfile.CreditProfileID WHERE tmr_code_id = 7 AND tmr.parent_refno=task.task_refno ORDER BY CreditProfileID DESC)
	AND CreditTradeLine.IsRevolving='R' AND IsClosed='O'
	) AS [Open Accounts Count Revolving - Hard Pull Tradelines]

	,  (Select Sum(TRY_Convert(numeric(18,2),[CreditLimitAmount]))
	FROM NLS.[dbo].[CreditTradeLine]
	WHERE CreditTradeLine.CreditProfileID = (select TOP 1 CreditProfile.[CreditProfileID] from NLS.dbo.tmr inner join NLS.dbo.CreditProfile on tmr.child_refno=CreditProfile.CreditProfileID WHERE tmr_code_id = 7 AND tmr.parent_refno=task.task_refno ORDER BY CreditProfileID DESC)
	AND CreditTradeLine.IsRevolving='R' AND IsClosed='O'
	) AS [Open Credit Limit Revolving - Hard Pull Tradelines]  

	,  (Select Sum(TRY_Convert(numeric(18,2),[HighCreditAmount]))
	FROM NLS.[dbo].[CreditTradeLine]
	WHERE CreditTradeLine.CreditProfileID = (select TOP 1 CreditProfile.[CreditProfileID] from NLS.dbo.tmr inner join NLS.dbo.CreditProfile on tmr.child_refno=CreditProfile.CreditProfileID WHERE tmr_code_id = 7 AND tmr.parent_refno=task.task_refno ORDER BY CreditProfileID DESC)
	AND CreditTradeLine.IsRevolving='R' AND IsClosed='O'
	) AS [Open High Credit Amount Revolving - Hard Pull Tradelines] 

	,  (Select Sum(TRY_Convert(numeric(18,2),[OriginalAmount]))
	FROM NLS.[dbo].[CreditTradeLine]
	WHERE CreditTradeLine.CreditProfileID = (select TOP 1 CreditProfile.[CreditProfileID] from NLS.dbo.tmr inner join NLS.dbo.CreditProfile on tmr.child_refno=CreditProfile.CreditProfileID WHERE tmr_code_id = 7 AND tmr.parent_refno=task.task_refno ORDER BY CreditProfileID DESC)
	AND CreditTradeLine.IsRevolving='R' AND IsClosed='O'
	) AS [Open Original Amount Revolving - Hard Pull Tradelines] 

	,  (Select Sum(TRY_Convert(numeric(18,2),[BalanceAmount]))
	FROM NLS.[dbo].[CreditTradeLine]
	WHERE CreditTradeLine.CreditProfileID = (select TOP 1 CreditProfile.[CreditProfileID] from NLS.dbo.tmr inner join NLS.dbo.CreditProfile on tmr.child_refno=CreditProfile.CreditProfileID WHERE tmr_code_id = 7 AND tmr.parent_refno=task.task_refno ORDER BY CreditProfileID DESC)
	AND CreditTradeLine.IsRevolving='R' AND IsClosed='O'
	) AS [Open Outstanding Balances Revolving - Hard Pull Tradelines] 

	,  (Select Sum(TRY_Convert(numeric(18,2),[AmountPastDue]))
	FROM NLS.[dbo].[CreditTradeLine]
	WHERE CreditTradeLine.CreditProfileID = (select TOP 1 CreditProfile.[CreditProfileID] from NLS.dbo.tmr inner join NLS.dbo.CreditProfile on tmr.child_refno=CreditProfile.CreditProfileID WHERE tmr_code_id = 7 AND tmr.parent_refno=task.task_refno ORDER BY CreditProfileID DESC)
	AND CreditTradeLine.IsRevolving='R' AND IsClosed='O'
	) AS [Open Past Due Amounts Revolving - Hard Pull Tradelines] 

	,  (Select Count(0)
	FROM NLS.[dbo].[CreditTradeLine]
	WHERE CreditTradeLine.CreditProfileID = (select TOP 1 CreditProfile.[CreditProfileID] from NLS.dbo.tmr inner join NLS.dbo.CreditProfile on tmr.child_refno=CreditProfile.CreditProfileID WHERE tmr_code_id = 7 AND tmr.parent_refno=task.task_refno ORDER BY CreditProfileID DESC)
	AND CreditTradeLine.IsRevolving='I'
	) AS [Total Accounts Count Installment - Hard Pull Tradelines]

	,  (Select Sum(TRY_Convert(numeric(18,2),[CreditLimitAmount]))
	FROM NLS.[dbo].[CreditTradeLine]
	WHERE CreditTradeLine.CreditProfileID = (select TOP 1 CreditProfile.[CreditProfileID] from NLS.dbo.tmr inner join NLS.dbo.CreditProfile on tmr.child_refno=CreditProfile.CreditProfileID WHERE tmr_code_id = 7 AND tmr.parent_refno=task.task_refno ORDER BY CreditProfileID DESC)
	AND CreditTradeLine.IsRevolving='I'
	) AS [Total Credit Limit Installment - Hard Pull Tradelines]  

	,  (Select Sum(TRY_Convert(numeric(18,2),[HighCreditAmount]))
	FROM NLS.[dbo].[CreditTradeLine]
	WHERE CreditTradeLine.CreditProfileID = (select TOP 1 CreditProfile.[CreditProfileID] from NLS.dbo.tmr inner join NLS.dbo.CreditProfile on tmr.child_refno=CreditProfile.CreditProfileID WHERE tmr_code_id = 7 AND tmr.parent_refno=task.task_refno ORDER BY CreditProfileID DESC)
	AND CreditTradeLine.IsRevolving='I'
	) AS [Total High Credit Amount Installment - Hard Pull Tradelines] 

	,  (Select Sum(TRY_Convert(numeric(18,2),[OriginalAmount]))
	FROM NLS.[dbo].[CreditTradeLine]
	WHERE CreditTradeLine.CreditProfileID = (select TOP 1 CreditProfile.[CreditProfileID] from NLS.dbo.tmr inner join NLS.dbo.CreditProfile on tmr.child_refno=CreditProfile.CreditProfileID WHERE tmr_code_id = 7 AND tmr.parent_refno=task.task_refno ORDER BY CreditProfileID DESC)
	AND CreditTradeLine.IsRevolving='I'
	) AS [Total Original Amount Installment - Hard Pull Tradelines] 

	,  (Select Sum(TRY_Convert(numeric(18,2),[BalanceAmount]))
	FROM NLS.[dbo].[CreditTradeLine]
	WHERE CreditTradeLine.CreditProfileID = (select TOP 1 CreditProfile.[CreditProfileID] from NLS.dbo.tmr inner join NLS.dbo.CreditProfile on tmr.child_refno=CreditProfile.CreditProfileID WHERE tmr_code_id = 7 AND tmr.parent_refno=task.task_refno ORDER BY CreditProfileID DESC)
	AND CreditTradeLine.IsRevolving='I'
	) AS [Total Outstanding Balances Installment - Hard Pull Tradelines] 

	,  (Select Sum(TRY_Convert(numeric(18,2),[AmountPastDue]))
	FROM NLS.[dbo].[CreditTradeLine]
	WHERE CreditTradeLine.CreditProfileID = (select TOP 1 CreditProfile.[CreditProfileID] from NLS.dbo.tmr inner join NLS.dbo.CreditProfile on tmr.child_refno=CreditProfile.CreditProfileID WHERE tmr_code_id = 7 AND tmr.parent_refno=task.task_refno ORDER BY CreditProfileID DESC)
	AND CreditTradeLine.IsRevolving='I'
	) AS [Total Past Due Amounts Installment - Hard Pull Tradelines] 

			,  (Select Count(0)
	FROM NLS.[dbo].[CreditTradeLine]
	WHERE CreditTradeLine.CreditProfileID = (select TOP 1 CreditProfile.[CreditProfileID] from NLS.dbo.tmr inner join NLS.dbo.CreditProfile on tmr.child_refno=CreditProfile.CreditProfileID WHERE tmr_code_id = 7 AND tmr.parent_refno=task.task_refno ORDER BY CreditProfileID DESC)
	AND CreditTradeLine.IsRevolving='I' AND IsClosed='O'
	) AS [Open Accounts Count Installment - Hard Pull Tradelines]

	,  (Select Sum(TRY_Convert(numeric(18,2),[CreditLimitAmount]))
	FROM NLS.[dbo].[CreditTradeLine]
	WHERE CreditTradeLine.CreditProfileID = (select TOP 1 CreditProfile.[CreditProfileID] from NLS.dbo.tmr inner join NLS.dbo.CreditProfile on tmr.child_refno=CreditProfile.CreditProfileID WHERE tmr_code_id = 7 AND tmr.parent_refno=task.task_refno ORDER BY CreditProfileID DESC)
	AND CreditTradeLine.IsRevolving='I' AND IsClosed='O'
	) AS [Open Credit Limit Installment - Hard Pull Tradelines]  

	,  (Select Sum(TRY_Convert(numeric(18,2),[HighCreditAmount]))
	FROM NLS.[dbo].[CreditTradeLine]
	WHERE CreditTradeLine.CreditProfileID = (select TOP 1 CreditProfile.[CreditProfileID] from NLS.dbo.tmr inner join NLS.dbo.CreditProfile on tmr.child_refno=CreditProfile.CreditProfileID WHERE tmr_code_id = 7 AND tmr.parent_refno=task.task_refno ORDER BY CreditProfileID DESC)
	AND CreditTradeLine.IsRevolving='I' AND IsClosed='O'
	) AS [Open High Credit Amount Installment- Hard Pull Tradelines] 

	,  (Select Sum(TRY_Convert(numeric(18,2),[OriginalAmount]))
	FROM NLS.[dbo].[CreditTradeLine]
	WHERE CreditTradeLine.CreditProfileID = (select TOP 1 CreditProfile.[CreditProfileID] from NLS.dbo.tmr inner join NLS.dbo.CreditProfile on tmr.child_refno=CreditProfile.CreditProfileID WHERE tmr_code_id = 7 AND tmr.parent_refno=task.task_refno ORDER BY CreditProfileID DESC)
	AND CreditTradeLine.IsRevolving='I' AND IsClosed='O'
	) AS [Open Original Amount Installment - Hard Pull Tradelines] 

	,  (Select Sum(TRY_Convert(numeric(18,2),[BalanceAmount]))
	FROM NLS.[dbo].[CreditTradeLine]
	WHERE CreditTradeLine.CreditProfileID = (select TOP 1 CreditProfile.[CreditProfileID] from NLS.dbo.tmr inner join NLS.dbo.CreditProfile on tmr.child_refno=CreditProfile.CreditProfileID WHERE tmr_code_id = 7 AND tmr.parent_refno=task.task_refno ORDER BY CreditProfileID DESC)
	AND CreditTradeLine.IsRevolving='I' AND IsClosed='O'
	) AS [Open Outstanding Balances Installment - Hard Pull Tradelines] 

	,  (Select Sum(TRY_Convert(numeric(18,2),[AmountPastDue]))
	FROM NLS.[dbo].[CreditTradeLine]
	WHERE CreditTradeLine.CreditProfileID = (select TOP 1 CreditProfile.[CreditProfileID] from NLS.dbo.tmr inner join NLS.dbo.CreditProfile on tmr.child_refno=CreditProfile.CreditProfileID WHERE tmr_code_id = 7 AND tmr.parent_refno=task.task_refno ORDER BY CreditProfileID DESC)
	AND CreditTradeLine.IsRevolving='I' AND IsClosed='O'
	) AS [Open Past Due Amounts Installment - Hard Pull Tradelines] 

		,  (Select Count(0)
	FROM NLS.[dbo].[CreditTradeLine]
	WHERE CreditTradeLine.CreditProfileID = (select TOP 1 CreditProfile.[CreditProfileID] from NLS.dbo.tmr inner join NLS.dbo.CreditProfile on tmr.child_refno=CreditProfile.CreditProfileID WHERE tmr_code_id = 7 AND tmr.parent_refno=task.task_refno ORDER BY CreditProfileID DESC)
	AND CreditTradeLine.AccountType IN ('19','25','26','2C','5B','6B') 
	) AS [Total Accounts Count Mortgage - Hard Pull Tradelines]

	,  (Select Sum(TRY_Convert(numeric(18,2),[CreditLimitAmount]))
	FROM NLS.[dbo].[CreditTradeLine]
	WHERE CreditTradeLine.CreditProfileID = (select TOP 1 CreditProfile.[CreditProfileID] from NLS.dbo.tmr inner join NLS.dbo.CreditProfile on tmr.child_refno=CreditProfile.CreditProfileID WHERE tmr_code_id = 7 AND tmr.parent_refno=task.task_refno ORDER BY CreditProfileID DESC)
	AND CreditTradeLine.AccountType IN ('19','25','26','2C','5B','6B') 
	) AS [Total Credit Limit Mortgage - Hard Pull Tradelines]  

	,  (Select Sum(TRY_Convert(numeric(18,2),[HighCreditAmount]))
	FROM NLS.[dbo].[CreditTradeLine]
	WHERE CreditTradeLine.CreditProfileID = (select TOP 1 CreditProfile.[CreditProfileID] from NLS.dbo.tmr inner join NLS.dbo.CreditProfile on tmr.child_refno=CreditProfile.CreditProfileID WHERE tmr_code_id = 7 AND tmr.parent_refno=task.task_refno ORDER BY CreditProfileID DESC)
	AND CreditTradeLine.AccountType IN ('19','25','26','2C','5B','6B') 
	) AS [Total High Credit Amount Mortgage - Hard Pull Tradelines] 

	,  (Select Sum(TRY_Convert(numeric(18,2),[OriginalAmount]))
	FROM NLS.[dbo].[CreditTradeLine]
	WHERE CreditTradeLine.CreditProfileID = (select TOP 1 CreditProfile.[CreditProfileID] from NLS.dbo.tmr inner join NLS.dbo.CreditProfile on tmr.child_refno=CreditProfile.CreditProfileID WHERE tmr_code_id = 7 AND tmr.parent_refno=task.task_refno ORDER BY CreditProfileID DESC)
	AND CreditTradeLine.AccountType IN ('19','25','26','2C','5B','6B') 
	) AS [Total Original Amount Mortgage - Hard Pull Tradelines] 

	,  (Select Sum(TRY_Convert(numeric(18,2),[BalanceAmount]))
	FROM NLS.[dbo].[CreditTradeLine]
	WHERE CreditTradeLine.CreditProfileID = (select TOP 1 CreditProfile.[CreditProfileID] from NLS.dbo.tmr inner join NLS.dbo.CreditProfile on tmr.child_refno=CreditProfile.CreditProfileID WHERE tmr_code_id = 7 AND tmr.parent_refno=task.task_refno ORDER BY CreditProfileID DESC)
	AND CreditTradeLine.AccountType IN ('19','25','26','2C','5B','6B') 
	) AS [Total Outstanding Balances Mortgage - Hard Pull Tradelines] 

	,  (Select Sum(TRY_Convert(numeric(18,2),[AmountPastDue]))
	FROM NLS.[dbo].[CreditTradeLine]
	WHERE CreditTradeLine.CreditProfileID = (select TOP 1 CreditProfile.[CreditProfileID] from NLS.dbo.tmr inner join NLS.dbo.CreditProfile on tmr.child_refno=CreditProfile.CreditProfileID WHERE tmr_code_id = 7 AND tmr.parent_refno=task.task_refno ORDER BY CreditProfileID DESC)
	AND CreditTradeLine.AccountType IN ('19','25','26','2C','5B','6B') 
	) AS [Total Past Due Amounts Mortgage - Hard Pull Tradelines] 

			,  (Select Count(0)
	FROM NLS.[dbo].[CreditTradeLine]
	WHERE CreditTradeLine.CreditProfileID = (select TOP 1 CreditProfile.[CreditProfileID] from NLS.dbo.tmr inner join NLS.dbo.CreditProfile on tmr.child_refno=CreditProfile.CreditProfileID WHERE tmr_code_id = 7 AND tmr.parent_refno=task.task_refno ORDER BY CreditProfileID DESC)
	AND CreditTradeLine.AccountType IN ('19','25','26','2C','5B','6B')  AND IsClosed='O'
	) AS [Open Accounts Count Mortgage - Hard Pull Tradelines]

	,  (Select Sum(TRY_Convert(numeric(18,2),[CreditLimitAmount]))
	FROM NLS.[dbo].[CreditTradeLine]
	WHERE CreditTradeLine.CreditProfileID = (select TOP 1 CreditProfile.[CreditProfileID] from NLS.dbo.tmr inner join NLS.dbo.CreditProfile on tmr.child_refno=CreditProfile.CreditProfileID WHERE tmr_code_id = 7 AND tmr.parent_refno=task.task_refno ORDER BY CreditProfileID DESC)
	AND CreditTradeLine.AccountType IN ('19','25','26','2C','5B','6B')  AND IsClosed='O'
	) AS [Open Credit Limit Mortgage - Hard Pull Tradelines]  

	,  (Select Sum(TRY_Convert(numeric(18,2),[HighCreditAmount]))
	FROM NLS.[dbo].[CreditTradeLine]
	WHERE CreditTradeLine.CreditProfileID = (select TOP 1 CreditProfile.[CreditProfileID] from NLS.dbo.tmr inner join NLS.dbo.CreditProfile on tmr.child_refno=CreditProfile.CreditProfileID WHERE tmr_code_id = 7 AND tmr.parent_refno=task.task_refno ORDER BY CreditProfileID DESC)
	AND CreditTradeLine.AccountType IN ('19','25','26','2C','5B','6B')  AND IsClosed='O'
	) AS [Open High Credit Amount Mortgage - Hard Pull Tradelines] 

	,  (Select Sum(TRY_Convert(numeric(18,2),[OriginalAmount]))
	FROM NLS.[dbo].[CreditTradeLine]
	WHERE CreditTradeLine.CreditProfileID = (select TOP 1 CreditProfile.[CreditProfileID] from NLS.dbo.tmr inner join NLS.dbo.CreditProfile on tmr.child_refno=CreditProfile.CreditProfileID WHERE tmr_code_id = 7 AND tmr.parent_refno=task.task_refno ORDER BY CreditProfileID DESC)
	AND CreditTradeLine.AccountType IN ('19','25','26','2C','5B','6B')  AND IsClosed='O'
	) AS [Open Original Amount Mortgage - Hard Pull Tradelines] 

	,  (Select Sum(TRY_Convert(numeric(18,2),[BalanceAmount]))
	FROM NLS.[dbo].[CreditTradeLine]
	WHERE CreditTradeLine.CreditProfileID = (select TOP 1 CreditProfile.[CreditProfileID] from NLS.dbo.tmr inner join NLS.dbo.CreditProfile on tmr.child_refno=CreditProfile.CreditProfileID WHERE tmr_code_id = 7 AND tmr.parent_refno=task.task_refno ORDER BY CreditProfileID DESC)
	AND CreditTradeLine.AccountType IN ('19','25','26','2C','5B','6B')  AND IsClosed='O'
	) AS [Open Outstanding Balances Mortgage - Hard Pull Tradelines] 

	,  (Select Sum(TRY_Convert(numeric(18,2),[AmountPastDue]))
	FROM NLS.[dbo].[CreditTradeLine]
	WHERE CreditTradeLine.CreditProfileID = (select TOP 1 CreditProfile.[CreditProfileID] from NLS.dbo.tmr inner join NLS.dbo.CreditProfile on tmr.child_refno=CreditProfile.CreditProfileID WHERE tmr_code_id = 7 AND tmr.parent_refno=task.task_refno ORDER BY CreditProfileID DESC)
	AND CreditTradeLine.AccountType IN ('19','25','26','2C','5B','6B') AND IsClosed='O'
	) AS [Open Past Due Amounts Mortgage - Hard Pull Tradelines] 
	

											,(select TOP 1
	collateral_vehicle.[original_value]
	from NLS.dbo.tmr 
	inner join NLS.dbo.collateral_vehicle on tmr.child_refno=collateral_vehicle.collateral_id 
	WHERE tmr_code_id = 4 AND tmr.parent_refno=task.task_refno
	ORDER BY collateral_id  DESC) AS [Original Value 1 - Application Collateral]

												,(select TOP 1
	collateral_vehicle.[current_value]
	from NLS.dbo.tmr 
	inner join NLS.dbo.collateral_vehicle on tmr.child_refno=collateral_vehicle.collateral_id 
	WHERE tmr_code_id = 4 AND tmr.parent_refno=task.task_refno
	ORDER BY collateral_id  DESC) AS [Current Value 1 - Application Collateral]

													,(select TOP 1
	collateral_vehicle.[purchase_price]
	from NLS.dbo.tmr 
	inner join NLS.dbo.collateral_vehicle on tmr.child_refno=collateral_vehicle.collateral_id 
	WHERE tmr_code_id = 4 AND tmr.parent_refno=task.task_refno
	ORDER BY collateral_id  DESC) AS [Purchase Price 1 - Application Collateral]

													,(select TOP 1
				CASE when collateral_vehicle.[title_status] IS NULL then NULL
				when collateral_vehicle.[title_status] = '0' then 'Not Received'
				when collateral_vehicle.[title_status] = '1'				then 'Submitted'
				when collateral_vehicle.[title_status] = '2'				then 'Perfected'
				when collateral_vehicle.[title_status] = '3'				then 'Received Needs Attention'
				when collateral_vehicle.[title_status] = '4'				then 'Received'
				when collateral_vehicle.[title_status] = '5'				then 'Released'
				when collateral_vehicle.[title_status] = '6'				then 'Lien Posted'
				when collateral_vehicle.[title_status] = '7'				then 'Unsecured'
				when collateral_vehicle.[title_status] = '8' 				then 'Other'
				END
	from NLS.dbo.tmr 
	inner join NLS.dbo.collateral_vehicle on tmr.child_refno=collateral_vehicle.collateral_id 
	WHERE tmr_code_id = 4 AND tmr.parent_refno=task.task_refno
	ORDER BY collateral_id  DESC) AS [Title Status 1 - Application Collateral]

												,(select TOP 1
	collateral_vehicle.[title_released_date]
	from NLS.dbo.tmr 
	inner join NLS.dbo.collateral_vehicle on tmr.child_refno=collateral_vehicle.collateral_id 
	WHERE tmr_code_id = 4 AND tmr.parent_refno=task.task_refno
	ORDER BY collateral_id  DESC) AS [Title Released Date 1 - Application Collateral]

													,(select TOP 1
	collateral_vehicle.[title_perfected_date]
	from NLS.dbo.tmr 
	inner join NLS.dbo.collateral_vehicle on tmr.child_refno=collateral_vehicle.collateral_id 
	WHERE tmr_code_id = 4 AND tmr.parent_refno=task.task_refno
	ORDER BY collateral_id  DESC) AS [Title Perfected Date 1 - Application Collateral]

												,(select 
	collateral_vehicle.[original_value]
	from NLS.dbo.tmr 
	inner join NLS.dbo.collateral_vehicle on tmr.child_refno=collateral_vehicle.collateral_id 
	WHERE tmr_code_id = 4 AND tmr.parent_refno=task.task_refno
	ORDER BY collateral_id  DESC
	OFFSET 1 ROWS   -- Skips first collateral
	FETCH NEXT 1 ROW ONLY  -- Returns only 1 record
	) AS [Original Value 2 - Application Collateral]

												,(select 
	collateral_vehicle.[current_value]
	from NLS.dbo.tmr 
	inner join NLS.dbo.collateral_vehicle on tmr.child_refno=collateral_vehicle.collateral_id 
	WHERE tmr_code_id = 4 AND tmr.parent_refno=task.task_refno
	ORDER BY collateral_id  DESC
	OFFSET 1 ROWS   -- Skips first collateral
	FETCH NEXT 1 ROW ONLY  -- Returns only 1 record
	) AS [Current Value 2 - Application Collateral]

													,(select 
	collateral_vehicle.[purchase_price]
	from NLS.dbo.tmr 
	inner join NLS.dbo.collateral_vehicle on tmr.child_refno=collateral_vehicle.collateral_id 
	WHERE tmr_code_id = 4 AND tmr.parent_refno=task.task_refno
	ORDER BY collateral_id  DESC
	OFFSET 1 ROWS   -- Skips first collateral
	FETCH NEXT 1 ROW ONLY  -- Returns only 1 record
	) AS [Purchase Price 2 - Application Collateral]

													,(select 
				CASE when collateral_vehicle.[title_status] IS NULL then NULL
				when collateral_vehicle.[title_status] = '0' then 'Not Received'
				when collateral_vehicle.[title_status] = '1'				then 'Submitted'
				when collateral_vehicle.[title_status] = '2'				then 'Perfected'
				when collateral_vehicle.[title_status] = '3'				then 'Received Needs Attention'
				when collateral_vehicle.[title_status] = '4'				then 'Received'
				when collateral_vehicle.[title_status] = '5'				then 'Released'
				when collateral_vehicle.[title_status] = '6'				then 'Lien Posted'
				when collateral_vehicle.[title_status] = '7'				then 'Unsecured'
				when collateral_vehicle.[title_status] = '8' 				then 'Other'
				END
	from NLS.dbo.tmr 
	inner join NLS.dbo.collateral_vehicle on tmr.child_refno=collateral_vehicle.collateral_id 
	WHERE tmr_code_id = 4 AND tmr.parent_refno=task.task_refno
	ORDER BY collateral_id  DESC
	OFFSET 1 ROWS   -- Skips first collateral
	FETCH NEXT 1 ROW ONLY  -- Returns only 1 record
	) AS [Title Status 2 - Application Collateral]

												,(select 
	collateral_vehicle.[title_released_date]
	from NLS.dbo.tmr 
	inner join NLS.dbo.collateral_vehicle on tmr.child_refno=collateral_vehicle.collateral_id 
	WHERE tmr_code_id = 4 AND tmr.parent_refno=task.task_refno
	ORDER BY collateral_id  DESC
	OFFSET 1 ROWS   -- Skips first collateral
	FETCH NEXT 1 ROW ONLY  -- Returns only 1 record
	) AS [Title Released Date 2 - Application Collateral]

													,(select 
	collateral_vehicle.[title_perfected_date]
	from NLS.dbo.tmr 
	inner join NLS.dbo.collateral_vehicle on tmr.child_refno=collateral_vehicle.collateral_id 
	WHERE tmr_code_id = 4 AND tmr.parent_refno=task.task_refno
	ORDER BY collateral_id  DESC
	OFFSET 1 ROWS   -- Skips first collateral
	FETCH NEXT 1 ROW ONLY  -- Returns only 1 record
	) AS [Title Perfected Date 2 - Application Collateral]

	/* */

													,(select 
	collateral_vehicle.[original_value]
	from NLS.dbo.tmr 
	inner join NLS.dbo.collateral_vehicle on tmr.child_refno=collateral_vehicle.collateral_id 
	WHERE tmr_code_id = 4 AND tmr.parent_refno=task.task_refno
	ORDER BY collateral_id  DESC
	OFFSET 2 ROWS   -- Skips first 2 collateral
	FETCH NEXT 1 ROW ONLY  -- Returns only 1 record
	) AS [Original Value 3 - Application Collateral]

												,(select 
	collateral_vehicle.[current_value]
	from NLS.dbo.tmr 
	inner join NLS.dbo.collateral_vehicle on tmr.child_refno=collateral_vehicle.collateral_id 
	WHERE tmr_code_id = 4 AND tmr.parent_refno=task.task_refno
	ORDER BY collateral_id  DESC
	OFFSET 2 ROWS   -- Skips first 2 collateral
	FETCH NEXT 1 ROW ONLY  -- Returns only 1 record
	) AS [Current Value 3 - Application Collateral]

													,(select 
	collateral_vehicle.[purchase_price]
	from NLS.dbo.tmr 
	inner join NLS.dbo.collateral_vehicle on tmr.child_refno=collateral_vehicle.collateral_id 
	WHERE tmr_code_id = 4 AND tmr.parent_refno=task.task_refno
	ORDER BY collateral_id  DESC
	OFFSET 2 ROWS   -- Skips first 2 collateral
	FETCH NEXT 1 ROW ONLY  -- Returns only 1 record
	) AS [Purchase Price 3 - Application Collateral]

													,(select 
				CASE when collateral_vehicle.[title_status] IS NULL then NULL
				when collateral_vehicle.[title_status] = '0' then 'Not Received'
				when collateral_vehicle.[title_status] = '1'				then 'Submitted'
				when collateral_vehicle.[title_status] = '2'				then 'Perfected'
				when collateral_vehicle.[title_status] = '3'				then 'Received Needs Attention'
				when collateral_vehicle.[title_status] = '4'				then 'Received'
				when collateral_vehicle.[title_status] = '5'				then 'Released'
				when collateral_vehicle.[title_status] = '6'				then 'Lien Posted'
				when collateral_vehicle.[title_status] = '7'				then 'Unsecured'
				when collateral_vehicle.[title_status] = '8' 				then 'Other'
				END
	from NLS.dbo.tmr 
	inner join NLS.dbo.collateral_vehicle on tmr.child_refno=collateral_vehicle.collateral_id 
	WHERE tmr_code_id = 4 AND tmr.parent_refno=task.task_refno
	ORDER BY collateral_id  DESC
	OFFSET 2 ROWS   -- Skips first 2 collateral
	FETCH NEXT 1 ROW ONLY  -- Returns only 1 record
	) AS [Title Status 3 - Application Collateral]

												,(select 
	collateral_vehicle.[title_released_date]
	from NLS.dbo.tmr 
	inner join NLS.dbo.collateral_vehicle on tmr.child_refno=collateral_vehicle.collateral_id 
	WHERE tmr_code_id = 4 AND tmr.parent_refno=task.task_refno
	ORDER BY collateral_id  DESC
	OFFSET 2 ROWS   -- Skips first 2 collateral
	FETCH NEXT 1 ROW ONLY  -- Returns only 1 record
	) AS [Title Released Date 3- Application Collateral]

													,(select 
	collateral_vehicle.[title_perfected_date]
	from NLS.dbo.tmr 
	inner join NLS.dbo.collateral_vehicle on tmr.child_refno=collateral_vehicle.collateral_id 
	WHERE tmr_code_id = 4 AND tmr.parent_refno=task.task_refno
	ORDER BY collateral_id  DESC
	OFFSET 2 ROWS   -- Skips first 2 collateral
	FETCH NEXT 1 ROW ONLY  -- Returns only 1 record
	) AS [Title Perfected Date 3 - Application Collateral]
,TRY_CONVERT(numeric(18,0), Case When task_detail.userdef35 ='0000000000000.00000' THEN NULL ELSE  task_detail.userdef35 END ) AS [Approval Amount]
,TRY_CONVERT(numeric(18,0), Case When task_detail.userdef36 ='0000000000000.00000' THEN NULL ELSE  task_detail.userdef36 END ) AS [Term (payments)]
,TRY_CONVERT(numeric(18,0), Case When task_detail.userdef37 ='0000000000000.00000' THEN NULL ELSE  task_detail.userdef37 END ) AS [Interest Rate]
,TRY_CONVERT(numeric(18,0), Case When task_detail.userdef38 ='0000000000000.00000' THEN NULL ELSE  task_detail.userdef38 END ) AS [Loan Fee]
,task_detail.userdef39 AS [Payment Frequency]
,TRY_CONVERT(numeric(18,0), Case When task_detail.userdef40 ='0000000000000.00000' THEN NULL ELSE  task_detail.userdef40 END ) AS [Payment]
,TRY_CONVERT(numeric(18,0), Case When task_detail.userdef41 ='0000000000000.00000' THEN NULL ELSE  task_detail.userdef41 END ) AS [Payment Coverage]

,TRY_CONVERT(numeric(18,0), Case When task_detail.userdef11 ='0000000000000.00000' THEN NULL ELSE  task_detail.userdef11 END ) AS [UW DSCR Global]
,task_detail.userdef12 AS [PQ Personal Risk]
,task_detail.userdef13 AS [PQ Business Risk]
,TRY_CONVERT(numeric(18,0), Case When task_detail.userdef14 ='0000000000000.00000' THEN NULL ELSE  task_detail.userdef14 END ) AS [Counteroffer Amount]
,task_detail.userdef15 AS [Counteroffer Reason]
,TRY_CONVERT(numeric(18,0), Case When task_detail.userdef16 ='0000000000000.00000' THEN NULL ELSE  task_detail.userdef16 END ) AS [Counteroffer Term]
,task_detail.userdef17 AS [Counteroffer Selected Term]
,TRY_CONVERT(numeric(18,0), Case When task_detail.userdef18 ='0000000000000.00000' THEN NULL ELSE  task_detail.userdef18 END ) AS [Counteroffer Payment]
,TRY_CONVERT(numeric(18,0), Case When task_detail.userdef19 ='0000000000000.00000' THEN NULL ELSE  task_detail.userdef19 END ) AS [Counteroffer Fee $]
,(SELECT Max([mod_datestamp])
  FROM [NLS].[dbo].[task_modification_history]
  WHERE [item_changed]='Status'
  AND [new_value]='6 LOAN DECISION'
  AND [task_modification_history].task_refno = task.task_refno) AS [Most Recent Loan Decision Date]

,(SELECT Min([mod_datestamp])
  FROM [NLS].[dbo].[task_modification_history]
  WHERE [item_changed]='Status'
  AND [new_value]='4 UNDERWRITING'
  AND [task_modification_history].task_refno = task.task_refno) AS [First Date Entered UW]

,(SELECT Min([mod_datestamp])
  FROM [NLS].[dbo].[task_modification_history]
  WHERE [item_changed]='Status'
  AND [old_value]='4 UNDERWRITING'
  AND [task_modification_history].task_refno = task.task_refno) AS [Most Recent Left UW]

 ,(SELECT Max([mod_datestamp])
  FROM [NLS].[dbo].[task_modification_history]
  WHERE [item_changed]='Status'
  AND [old_value]='7A FUNDING REVIEW'
  AND [task_modification_history].task_refno =task.task_refno) AS [Most Recent Date Left Funding Review]

    ,task_detail.userdef58 AS [Funds to Borrower]
	,task_detail.userdef59 AS [Funds to OF]
	,task_detail.userdef85 AS [Funds to Third Party]
	,task_detail.userdef86 AS [Third Party Chk 4]
	,task_detail.userdef87 AS [Third Party Chk 5]

from	NLS.dbo.task 
Inner JOIN NLS.dbo.task_detail  ON task_detail.task_refno=task.task_refno
WHERE	task.task_refno IN (Select task_routing_history.task_refno FROM NLS.dbo.task_routing_history WHERE task_routing_history.workflow_result_id = 4)


GO
