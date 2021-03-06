USE [DataMart]
GO
/****** Object:  View [dbo].[Developer_DataMart_ParentLoans]    Script Date: 8/24/2020 9:49:52 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



CREATE VIEW [dbo].[Developer_DataMart_ParentLoans] AS

WITH Hierarchy(ChildId, ParentId, Parents, ImmediateParent, OriginalParent, NumParents)
AS
(
    SELECT 
	restructured_acctrefno 
	,acctrefno
	,CAST('' AS VARCHAR(MAX)) 
	,CAST('' AS VARCHAR(MAX))  
	,CAST('' AS VARCHAR(MAX)) 
	,0
        FROM NLS.dbo.loanacct 
        WHERE acctrefno NOT IN (SELECT COALESCE(restructured_acctrefno, 0) FROM NLS.dbo.loanacct )     
    UNION ALL
    SELECT 
	PrevGeneration.restructured_acctrefno 
	,PrevGeneration.acctrefno
        ,CAST(CASE WHEN Parents.Parents = '' 
        THEN(CAST(Parents.ParentId AS VARCHAR(MAX)))
        ELSE(Parents.Parents + ' -> ' + CAST(Parents.ParentId AS VARCHAR(MAX)))
		END AS VARCHAR(MAX))
	, CAST(Parents.ParentId AS VARCHAR(MAX))
	,CASE WHEN Parents.Parents = '' THEN (CAST(Parents.ParentId AS VARCHAR(MAX)))
		ELSE Parents.OriginalParent
	END

    , case when Parents.ParentId = PrevGeneration.acctrefno then 0 else Parents.NumParents + 1 end
        FROM NLS.dbo.loanacct  AS PrevGeneration
        INNER JOIN Hierarchy AS Parents ON PrevGeneration.acctrefno = Parents.ChildId
)
SELECT ParentId As [Acct Ref No]
	,NumParents
	,Parents As [Parent List]
	,ImmediateParent  As [Immediate Parent]
	,OriginalParent AS [Original Parent]
    FROM Hierarchy
	WHERE Parents!=''
GO
