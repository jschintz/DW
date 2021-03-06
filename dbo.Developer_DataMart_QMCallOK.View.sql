USE [DataMart]
GO
/****** Object:  View [dbo].[Developer_DataMart_QMCallOK]    Script Date: 8/24/2020 9:49:52 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

  CREATE View [dbo].[Developer_DataMart_QMCallOK]
  AS
  SELECT 
   CALLOK_callid
 ,CALLOK_from
 ,CALLOK_tstEnd
 ,CALLOK_waitLen
 ,CALLOK_callLen
 ,CALLOK_reason
 ,CALLOK_agent
 ,CALLOK_transfer
 ,CALLOK_queue
 ,CALLOK_tstEnter
 ,CALLOK_attempts
 ,CALLOK_url
,CALLOK_stcode
 ,CALLOK_stints
 ,CALLOK_oPos
 ,CALLOK_dnis
 ,CALLOK_ivr
 ,CALLOK_server
 ,CALLOK_lastAtt
 ,CALLOK_haveAtt
 ,CALLOK_attAA
 ,CALLOK_bridged
,CALLOK_mohEvts
 ,CALLOK_mohDur
 ,CALLOK_ivrWait
 ,CALLOK_tstStart
 ,CALLOK_ivrTime
 ,CALLOK_calltag
 ,CALLOK_features
 ,CALLOK_variables
 ,CALLOK_events
-- ,CALLOK_features
-- ,CALLOK_variables
FROM [CDATA].[Queue-Metrics].[CallsOKRaw]
CROSS APPLY OPENJSON([DetailsDO.CallsOkRaw])
 WITH (
 CALLOK_callid VARCHAR(250) '$[0]',
 CALLOK_from VARCHAR(250) '$[1]',
 CALLOK_tstEnd VARCHAR(250) '$[2]',
 CALLOK_waitLen VARCHAR(250) '$[3]',
 CALLOK_callLen VARCHAR(250) '$[4]',
 CALLOK_reason VARCHAR(250) '$[5]',
 CALLOK_agent VARCHAR(250) '$[6]',
 CALLOK_transfer VARCHAR(250) '$[7]',
 CALLOK_queue VARCHAR(250) '$[8]',
 CALLOK_tstEnter VARCHAR(250) '$[9]',
 CALLOK_attempts  VARCHAR(250) '$[10]',
 CALLOK_url VARCHAR(250) '$[11]',
 CALLOK_server VARCHAR(250) '$[12]',
 CALLOK_stints VARCHAR(250) '$[13]',
 CALLOK_oPos VARCHAR(250) '$[14]',
 CALLOK_dnis VARCHAR(250) '$[15]',
 CALLOK_ivr VARCHAR(250) '$[16]',
 CALLOK_stcode VARCHAR(250) '$[17]',
 CALLOK_lastAtt VARCHAR(250) '$[18]',
 CALLOK_haveAtt VARCHAR(250) '$[19]',
 CALLOK_attAA VARCHAR(250) '$[20]',
 CALLOK_bridged VARCHAR(250) '$[21]',
CALLOK_mohEvts VARCHAR(250) '$[22]',
 CALLOK_mohDur VARCHAR(250) '$[23]',
 CALLOK_ivrWait VARCHAR(250) '$[24]',
 CALLOK_tstStart VARCHAR(250) '$[25]',
 CALLOK_ivrTime VARCHAR(250) '$[26]',
 CALLOK_calltag VARCHAR(250) '$[27]',
 CALLOK_features VARCHAR(250) '$[28]',
 CALLOK_variables VARCHAR(250) '$[29]',
 CALLOK_events VARCHAR(250) '$[30]',
 CALLOK_features  VARCHAR(250) '$[31]',
 CALLOK_variables VARCHAR(250) '$[32]'


  )
WHERE CALLOK_callid!='CALLOK_callid'
  ;
GO
