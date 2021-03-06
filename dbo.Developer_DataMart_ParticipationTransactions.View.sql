USE [DataMart]
GO
/****** Object:  View [dbo].[Developer_DataMart_ParticipationTransactions]    Script Date: 8/24/2020 9:49:52 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [dbo].[Developer_DataMart_ParticipationTransactions] AS
SELECT [acctrefno]
      ,[loanNumber]
      ,[participationDate]
	  	  ,CASE WHEN (Select Count(0) FROM [NLS].[dbo].[OF_Participations] maxdate where maxdate.[acctrefno]=[OF_Participations].[acctrefno] AND  maxdate.[participationDate]<[OF_Participations].[participationDate] ) =0 THEN [participationPercent]
	  ELSE [participationPercent] -  (Select Top 1  [participationPercent] FROM [NLS].[dbo].[OF_Participations] maxdate where maxdate.[acctrefno]=[OF_Participations].[acctrefno] AND  maxdate.[participationDate]<[OF_Participations].[participationDate] ORDER BY [participationDate])
	  END AS [Current Participation %]
	  , (Select CAST(ROUND([daily_trial_balance].gl_principal_balance, 2)as decimal(15,2)) FROM [NLS].[dbo].[daily_trial_balance] WHERE [daily_trial_balance].[acctrefno] = [OF_Participations].[acctrefno] AND [daily_trial_balance].[trial_balance_date] = [OF_Participations].[origLastDay] )
	  AS [GL Princpial Balance] 
	   ,(CASE WHEN (Select Count(0) FROM [NLS].[dbo].[OF_Participations] maxdate where maxdate.[acctrefno]=[OF_Participations].[acctrefno] AND  maxdate.[participationDate]<[OF_Participations].[participationDate] ) =0 THEN [participationPercent]
	  ELSE [participationPercent] -  (Select Top 1  [participationPercent] FROM [NLS].[dbo].[OF_Participations] maxdate where maxdate.[acctrefno]=[OF_Participations].[acctrefno] AND  maxdate.[participationDate]<[OF_Participations].[participationDate] ORDER BY [participationDate])
	  END * .01) *
	 (Select CAST(ROUND([daily_trial_balance].gl_principal_balance, 2)as decimal(15,2)) FROM [NLS].[dbo].[daily_trial_balance] WHERE [daily_trial_balance].[acctrefno] = [OF_Participations].[acctrefno] AND [daily_trial_balance].[trial_balance_date] = [OF_Participations].[origLastDay] )
	  AS [GL Participated Principal] 
	   ,[participationPercent] As TotalparticipationPercent
      ,[origGroup]
      ,[origLastDay]
      ,[newGroup] 
	  ,(Select Count(0) FROM [NLS].[dbo].[OF_Participations] maxdate where maxdate.[acctrefno]=[OF_Participations].[acctrefno] AND  maxdate.[participationDate]<[OF_Participations].[participationDate] ) As [# of prior participations]
	  ,(Select Top 1 [participationDate] FROM [NLS].[dbo].[OF_Participations] maxdate where maxdate.[acctrefno]=[OF_Participations].[acctrefno] AND  maxdate.[participationDate]<[OF_Participations].[participationDate] ORDER BY [participationDate]) As[ Most recent participation date]
  FROM  [NLS].[dbo].[OF_Participations]
GO
