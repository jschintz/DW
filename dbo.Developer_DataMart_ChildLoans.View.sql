USE [DataMart]
GO
/****** Object:  View [dbo].[Developer_DataMart_ChildLoans]    Script Date: 8/24/2020 9:49:52 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE VIEW [dbo].[Developer_DataMart_ChildLoans] 
AS

WITH Hierarchy( ParentId, ChildId, Children, LowestChild, NumChildren)
AS
(
    SELECT 
	acctrefno
	,restructured_acctrefno 
	,CAST('' AS VARCHAR(MAX))   
	,CAST('' AS VARCHAR(MAX)) 
	,0
        FROM NLS.dbo.loanacct 
		WHERE restructured_acctrefno ='0'
        --WHERE acctrefno IN (SELECT COALESCE(restructured_acctrefno, 0) FROM NLS.dbo.loanacct )     
    UNION ALL
    SELECT 
	PrevGeneration.acctrefno 
	,PrevGeneration.restructured_acctrefno 
    ,CAST(CASE WHEN Children.Children = '' 
        THEN(CAST(PrevGeneration.restructured_acctrefno AS VARCHAR(MAX)))
        ELSE( CAST(PrevGeneration.restructured_acctrefno  AS VARCHAR(MAX)) + ' -> ' + Children.Children )
		END AS VARCHAR(MAX))

	,CASE WHEN Children.ChildId = '0' THEN (CAST(Children.ParentId AS VARCHAR(MAX)))
		ELSE Children.LowestChild
	END

    , case when Children.ChildId = PrevGeneration.acctrefno then 0 else Children.NumChildren + 1 end
        FROM NLS.dbo.loanacct  AS PrevGeneration
        INNER JOIN Hierarchy AS Children ON PrevGeneration.restructured_acctrefno  = Children.ParentId
		
)
SELECT 
*
    FROM Hierarchy
	WHERE NumChildren>0
GO
