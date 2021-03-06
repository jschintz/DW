USE [DataMart]
GO
/****** Object:  View [dbo].[Developer_DataMart_QMCallCenterCalls]    Script Date: 8/24/2020 9:49:52 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [dbo].[Developer_DataMart_QMCallCenterCalls] AS

WITH cte AS
 (
 select 
*
		,ROW_NUMBER() OVER (PARTITION BY [CALLOK_callid] ORDER BY [CALLOK_tstEnter] DESC) AS rn
  FROM [DataMart].[dbo].[Developer_DataMart_QMCallOK]
  WHERE [CALLOK_from]!='*'
  )
SELECT 
		'Answered' As [Call Status]
		,[CALLOK_callid] AS [Asterisk_UID]
		,dateadd(HOUR,-8,
		dateadd(SECOND, try_cast([CALLOK_tstEnter] as numeric), '1970-01-01')) AS [Date Call Enter]
	  ,Isnull(
			  (Select [nome_coda] FROM [CDATA].[Queue-Metrics].[Queue] WHERE [CALLOK_queue] =[Queue].[composizione_coda] )
			  ,(Select Min([nome_coda]) FROM [CDATA].[Queue-Metrics].[Queue] WHERE [Queue].[composizione_coda] LIKE CONCAT('%', [CALLOK_queue], '%') ) 
	  )AS [Queue]
	  ,TRY_CAST( [CALLOK_ivrTime] AS INT) as [IVR - Seconds]
	   ,TRY_CAST([CALLOK_waitLen] AS INT)  as [Wait - Seconds]
	   ,TRY_CAST([CALLOK_callLen] AS INT)  As [Duration - Seconds]
	   ,(SELECT [descr_agente] FROM  [CDATA].[Queue-Metrics].[Agent] WHERE [nome_agente]=replace([CALLOK_Agent],'\','')) AS [Handled_by]
	   ,(SELECT [loc_name] FROM [CDATA].[Queue-Metrics].[Agent] WHERE [nome_agente]=replace([CALLOK_Agent],'\','')) AS [Handled_by Location]
	   ,(SELECT [real_name] FROM [CDATA].[Queue-Metrics].[Agent] WHERE [nome_agente]=replace([CALLOK_Agent],'\','')) AS [Handled_by Group]
	  
	  ,(SELECT [status_descr] FROM [CDATA].[Queue-Metrics].[Outcome] WHERE [CALLOK_stcode]=[status_code]) AS [Outcome]
	  ,ISnull(  --Select most recent CIF NO.  Implicit asusmption highets # is most recent.
				--Lookup # in 2 places
				(Select MAx([cifno]) AS COunt FROM [NLS].[dbo].[cif_phone_nums] WHERE [CALLOK_from] =[phone_raw])
				,
				(Select MAx([cifno]) AS COunt FROM [NLS].[dbo].[cif_addressbook_phone_nums] JOIN [NLS].[dbo].[cif_addressbook] ON [addressbook_row_id]=[cif_addressbook].[row_id]	  WHERE [CALLOK_from] =[phone_raw])
		) AS [NLS CIF Lookup]
FROM cte
WHERE rn = 1


  UNION ALL SELECT DISTINCT
		'Unanswered' As [Call Status]
		,[DataMart].[dbo].[Developer_DataMart_QMCallKO].[CALLKO_callid] AS [Asterisk_UID]
		,dateadd(HOUR,-8,
			dateadd(SECOND, try_cast([CALLKO_tstEnter] as numeric), '1970-01-01')) AS [Date Call Enter]
      	  ,Isnull(
			  (Select [nome_coda] FROM [CDATA].[Queue-Metrics].[Queue] WHERE [CALLKO_queue] =[Queue].[composizione_coda] )
			  ,(Select Min([nome_coda]) FROM [CDATA].[Queue-Metrics].[Queue] WHERE [Queue].[composizione_coda] LIKE CONCAT('%', [CALLKO_queue], '%') ) 
	  )AS [Queue]
	   ,CAST( [CALLKO_ivrTime] AS INT) as [IVR - Seconds]
	    ,CAST( [CALLKO_waitLen] AS INT) as [Wait - Seconds]
	   ,NULL As [Duration - Seconds]
	   ,(SELECT [descr_agente] FROM [CDATA].[Queue-Metrics].[Agent] WHERE [nome_agente]=replace([CALLKO_agentOut],'\','')) AS [Handled_by]
	   ,(SELECT [loc_name] FROM [CDATA].[Queue-Metrics].[Agent] WHERE [nome_agente]=replace([CALLKO_agentOut],'\','')) AS [Handled_by Location]
	   ,(SELECT [real_name] FROM [CDATA].[Queue-Metrics].[Agent] WHERE [nome_agente]=replace([CALLKO_agentOut],'\','')) AS [Handled_by Group]
	   ,(SELECT [status_descr] FROM [CDATA].[Queue-Metrics].[Outcome] WHERE [CALLKO_stcode]=[status_code]) AS [Outcome]
	  ,ISnull(  --Select most recent CIF NO.  Implicit asusmption highets # is most recent.
				--Lookup # in 2 places
				(Select MAx([cifno]) AS COunt FROM [NLS].[dbo].[cif_phone_nums] WHERE [CALLKO_from] =[phone_raw])
				,
				(Select MAx([cifno]) AS COunt FROM [NLS].[dbo].[cif_addressbook_phone_nums] JOIN [NLS].[dbo].[cif_addressbook] ON [addressbook_row_id]=[cif_addressbook].[row_id]	  WHERE [CALLKO_from] =[phone_raw])
		) AS [NLS CIF Lookup]

  FROM [DataMart].[dbo].[Developer_DataMart_QMCallKO]
  --Exclude Duplicates
    JOIN (SELECT t.[CALLKO_callid],
               MAX(t.[CALLKO_tstEnter]) AS max_date
          FROM [DataMart].[dbo].[Developer_DataMart_QMCallKO] t
      GROUP BY t.[CALLKO_callid]) x ON x.[CALLKO_callid] = [Developer_DataMart_QMCallKO].[CALLKO_callid]
                            AND x.max_date = [Developer_DataMart_QMCallKO].[CALLKO_tstEnter]
  --Exclude IDs in Answered table
  WHERE [DataMart].[dbo].[Developer_DataMart_QMCallKO].CALLKO_callid NOT IN(SELECT [CALLOK_callid] FROM [DataMart].[dbo].[Developer_DataMart_QMCallOK])
GO
