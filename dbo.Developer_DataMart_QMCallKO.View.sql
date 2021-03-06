USE [DataMart]
GO
/****** Object:  View [dbo].[Developer_DataMart_QMCallKO]    Script Date: 8/24/2020 9:49:52 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/****** Script for SelectTopNRows command from SSMS  ******/
  Create View [dbo].[Developer_DataMart_QMCallKO]  AS
  SELECT CALLKO_callid 
 ,CASE CALLKO_agentOut WHEN '&nbsp;' THEN NULL ELSE CALLKO_agentOut END AS CALLKO_agentOut
 ,CALLKO_from
 ,CALLKO_tstEnd
 ,CALLKO_reason
 ,CALLKO_quePos
 ,CALLKO_waitLen
 ,CALLKO_queue
 ,CALLKO_tstEnter
 ,CALLKO_attempts
 ,CASE CALLKO_url  WHEN '&nbsp;' THEN NULL ELSE CALLKO_url END AS CALLKO_url 
 ,CASE CALLKO_key  WHEN '&nbsp;' THEN NULL ELSE CALLKO_key END AS CALLKO_key
 ,CASE CALLKO_server  WHEN '&nbsp;' THEN NULL ELSE CALLKO_server END AS CALLKO_server
 ,CALLKO_stints
 ,CALLKO_oPos
 ,CASE CALLKO_dnis  WHEN '&nbsp;' THEN NULL ELSE CALLKO_dnis END AS CALLKO_dnis
 ,CASE CALLKO_ivr  WHEN '&nbsp;' THEN NULL ELSE CALLKO_ivr END AS CALLKO_ivr
 ,CASE CALLKO_stcode  WHEN '&nbsp;' THEN NULL ELSE CALLKO_stcode END AS CALLKO_stcode
 --,CALLKO_stints
 ,CASE CALLKO_lastAtt WHEN '&nbsp;' THEN NULL ELSE CALLKO_lastAtt END AS CALLKO_lastAtt
 ,CALLKO_haveAtt
 ,CALLKO_attAA
 ,CALLKO_ivrWait
 ,CALLKO_tstStart
 ,CALLKO_ivrTime
  ,CASE CALLKO_calltag WHEN '&nbsp;' THEN NULL ELSE CALLKO_calltag END AS CALLKO_calltag
 ,CALLKO_featuresnum
 ,CALLKO_variablesnum
 ,CALLKO_events
 ,CALLKO_features
 ,CALLKO_variables
FROM [CDATA].[Queue-Metrics].[CallsKoRaw]
CROSS APPLY OPENJSON([DetailsDO.CallsKoRaw])
 WITH (
 CALLKO_callid VARCHAR(250) '$[0]',
 CALLKO_agentOut VARCHAR(250) '$[1]',
 CALLKO_from VARCHAR(250) '$[2]',
 CALLKO_tstEnd VARCHAR(250) '$[3]',
 CALLKO_reason VARCHAR(250) '$[4]',
 CALLKO_quePos VARCHAR(250) '$[5]',
 CALLKO_waitLen VARCHAR(250) '$[6]',
 CALLKO_queue VARCHAR(250) '$[7]',
 CALLKO_tstEnter VARCHAR(250) '$[8]',
 CALLKO_attempts VARCHAR(250) '$[9]',
 CALLKO_url VARCHAR(250) '$[10]',
 CALLKO_key  VARCHAR(250) '$[11]',
 CALLKO_server VARCHAR(250) '$[12]',
 CALLKO_stints VARCHAR(250) '$[13]',
 CALLKO_oPos VARCHAR(250) '$[14]',
 CALLKO_dnis VARCHAR(250) '$[15]',
 CALLKO_ivr VARCHAR(250) '$[16]',
 CALLKO_stcode VARCHAR(250) '$[17]',
 CALLKO_stints VARCHAR(250) '$[18]',
 CALLKO_lastAtt VARCHAR(250) '$[19]',
 CALLKO_haveAtt VARCHAR(250) '$[20]',
 CALLKO_attAA VARCHAR(250) '$[21]',
 CALLKO_ivrWait VARCHAR(250) '$[22]',
 CALLKO_tstStart VARCHAR(250) '$[23]',
 CALLKO_ivrTime VARCHAR(250) '$[24]',
 CALLKO_calltag VARCHAR(250) '$[25]',
 CALLKO_featuresnum VARCHAR(250) '$[26]',
 CALLKO_variablesnum VARCHAR(250) '$[27]',
 CALLKO_events VARCHAR(250) '$[28]',
 CALLKO_features VARCHAR(250) '$[29]',
 CALLKO_variables VARCHAR(250) '$[30]'

  )
WHERE CALLKO_callid!='CALLKO_callid'
  ;
GO
