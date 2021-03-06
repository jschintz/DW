USE [DataMart]
GO
/****** Object:  View [dbo].[Developer_DataMart_Complaints]    Script Date: 8/24/2020 9:49:52 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

Create View [dbo].[Developer_DataMart_Complaints] AS

SELECT
[IncidentId] AS [Incident Id]
--  ,[Title] AS [Case Title]
--  ,[CustomerIdName] AS [Customer]
,[TicketNumber] AS [Case Number]
,  (SELECT [Value] FROM [Opportunityfund_MSCRM].[dbo].[StringMapBase] WHERE AttributeName = 'oppfund_Category' AND AttributeValue=[oppfund_Category]) AS [Category]
, (SELECT [Value] FROM [Opportunityfund_MSCRM].[dbo].[StringMapBase] WHERE AttributeName = 'oppfund_Subcategory' AND AttributeValue=[oppfund_Subcategory])  AS [Subcategory]
 ,[CreatedOn] AS [Created On]
, (SELECT [Value] FROM [Opportunityfund_MSCRM].[dbo].[StringMapBase] WHERE AttributeName = 'oppfund_FirstContactAttemp' AND AttributeValue=[oppfund_FirstContactAttemp])  AS [First Contact Attemp]
,[oppfund_FirstContacton] AS [First Contact on]
, (SELECT [Value] FROM [Opportunityfund_MSCRM].[dbo].[StringMapBase] WHERE AttributeName = 'oppfund_FirstSuccessfulContact' AND AttributeValue=[oppfund_FirstSuccessfulContact])  AS [First Succesfull Contact]
,FollowUpTaskCreated AS [Follow up Task Created]
,[ModifiedOn] AS [Modified On]
,(SELECT [Value] FROM [Opportunityfund_MSCRM].[dbo].[StringMapBase] WHERE AttributeName = 'SeverityCode' AND AttributeValue=[SeverityCode]) AS [Severity]
,[EscalatedOn] AS [Escalated On]
, (SELECT [FullName] FROM [Opportunityfund_MSCRM].[dbo].[SystemUserBase] WHERE SystemUserId=[IncidentBase].[OwnerId]) AS [Owner]
, (SELECT l.Label
			FROM [Opportunityfund_MSCRM].MetadataSchema.Attribute a
			INNER JOIN [Opportunityfund_MSCRM].MetadataSchema.Entity e
			ON a.EntityId = e.EntityId
			AND YEAR(e.OverwriteTime) = 1900
			INNER JOIN [Opportunityfund_MSCRM].MetadataSchema.AttributePicklistValue pl
			ON a.OptionSetId = pl.OptionSetId
			INNER JOIN [Opportunityfund_MSCRM].MetadataSchema.LocalizedLabel l
			ON pl.AttributePicklistValueId = l.ObjectId
			WHERE a.Name = 'StatusCode' AND e.Name='Incident' AND pl.Value=[StatusCode]
	) AS [Status]
-- AS [Status Reason]
	,[CustomerIdType] As [Customer Id Type]
  FROM [Opportunityfund_MSCRM].[dbo].[IncidentBase]
GO
