USE [DataMart]
GO
/****** Object:  View [dbo].[Developer_DataMart_Contacts]    Script Date: 8/24/2020 9:49:52 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO








CREATE VIEW [dbo].[Developer_DataMart_Contacts] AS
SELECT 
[cif_demographics].[cifno]
,cif_demographics.userdef01 As [Legal Status - Current]
,cif_demographics.userdef09 As [Ethnicity - Current]
,cif_demographics.userdef11 As [Minority Owned - Current]
,cif_demographics.userdef12 As [Woman Owned - Current]
,cif_demographics.userdef15 As [NAICS Code - Current]
,cif_demographics.userdef02 As [NAICS Description - Current]
,cif_detail.userdef15 As [Business Location - Current]
,cif_detail.userdef16 As [Legal Structure - Current]
,cif_detail.userdef36 As [Primary Language - Current]
,cif_detail.userdef35 As [Referral Source - Current]
,cif_detail.userdef18 As [Product Service Description - Current]
,(SELECT TOP (1) 
  [cif_modification_history].[new_value]
  FROM [NLS].[dbo].[cif_modification_history]
  WHERE [cif_modification_history].item_changed='CIF Detail #35' AND [cif_modification_history].[new_value] IS NOT NULL AND [cif_modification_history].[new_value]!=''
  AND [cif_modification_history].[cifno]=[cif].[cifno]
  Order BY [cif_modification_history].mod_datestamp ASC) As [Referral Source - First]
,cif_detail.userdef30 As [How did you hear about us - Current]
,(SELECT TOP (1) 
  [cif_modification_history].[new_value]
  FROM [NLS].[dbo].[cif_modification_history]
  WHERE [cif_modification_history].item_changed='CIF Detail #30' AND [cif_modification_history].[new_value] IS NOT NULL AND [cif_modification_history].[new_value]!=''
  AND [cif_modification_history].[cifno]=[cif].[cifno]
  Order BY [cif_modification_history].mod_datestamp ASC) As [How did you hear about us - First]
,(SELECT TOP (1) 
  [cif_modification_history].[new_value]
  FROM [NLS].[dbo].[cif_modification_history]
  WHERE [cif_modification_history].item_changed='CIF Detail #18' AND [cif_modification_history].[new_value] IS NOT NULL AND [cif_modification_history].[new_value]!=''
  AND [cif_modification_history].[cifno]=[cif].[cifno]
  Order BY [cif_modification_history].mod_datestamp ASC) As [Product Service Description - First]
,(SELECT TOP (1) 
  cif_addressbook.[state]
  FROM [NLS].[dbo].[cif_addressbook]
  WHERE (cif_addressbook.entity='BUSINESS ADDRESS' OR address_desc='BUSINESS ADDRESS : A' OR relationship_code_id = 7)
  AND cif_addressbook.[cifno]=[cif].[cifno]
  Order BY [cif_addressbook].row_id DESC ) AS [Business State - Current]
  ,(SELECT TOP (1) 
  cif_addressbook.[county]
  FROM [NLS].[dbo].[cif_addressbook]
  WHERE (cif_addressbook.entity='BUSINESS ADDRESS' OR address_desc='BUSINESS ADDRESS : A' OR relationship_code_id = 7)
  AND cif_addressbook.[cifno]=[cif].[cifno]
  Order BY [cif_addressbook].row_id DESC ) AS [Business County - Current]
  ,(SELECT TOP (1) 
  cif_addressbook.[FIPSCode]
  FROM [NLS].[dbo].[cif_addressbook]
  WHERE (cif_addressbook.entity='BUSINESS ADDRESS' OR address_desc='BUSINESS ADDRESS : A' OR relationship_code_id = 7)
  AND cif_addressbook.[cifno]=[cif].[cifno]
  Order BY [cif_addressbook].row_id DESC ) AS [Business FIPS - Current]
  ,(SELECT TOP (1) 
  cif_addressbook.[DPLatitude]
  FROM [NLS].[dbo].[cif_addressbook]
  WHERE (cif_addressbook.entity='BUSINESS ADDRESS' OR address_desc='BUSINESS ADDRESS : A' OR relationship_code_id = 7)
  AND cif_addressbook.[cifno]=[cif].[cifno]
  Order BY [cif_addressbook].row_id DESC ) AS [Business Latitude - Current]
    ,(SELECT TOP (1) 
  cif_addressbook.[DPLongitude]
  FROM [NLS].[dbo].[cif_addressbook]
  WHERE (cif_addressbook.entity='BUSINESS ADDRESS' OR address_desc='BUSINESS ADDRESS : A' OR relationship_code_id = 7)
  AND cif_addressbook.[cifno]=[cif].[cifno]
  Order BY [cif_addressbook].row_id DESC ) AS [Business Longitude - Current]
 ,( SELECT [ET_Ethnicity] FROM [Development].[dbo].[ET_ReportData] WHERE cif.[cifno]=[ET_ReportData].[cifno]) AS [Ethnicty - Ethnic Tech]
 ,( SELECT [ET_Gender] FROM [Development].[dbo].[ET_ReportData] WHERE cif.[cifno]=[ET_ReportData].[cifno]) AS [Gender - Ethnic Tech]
  ,(SELECT TOP (1) 
  cif_addressbook.[zip]
  FROM [NLS].[dbo].[cif_addressbook]
  WHERE (cif_addressbook.entity='BUSINESS ADDRESS' OR address_desc='BUSINESS ADDRESS : A' OR relationship_code_id = 7)
  AND cif_addressbook.[cifno]=[cif].[cifno]
  Order BY [cif_addressbook].row_id DESC ) AS [Business Zip - Current]
, [cif_demographics].Userdef09 AS [Race]
, [cif_demographics].Userdef10 AS [Gender]
,cif_demographics.userdef03	as [Business Census Tract]
,cif_demographics.userdef04	as [Census Tract #]
,TRY_Convert(numeric(18,0), Case When cif_demographics.userdef05='0000000000000.00000' OR cif_demographics.userdef05='0.00000' THEN NULL ELSE cif_demographics.userdef05 END) AS [Jobs Retained]
,TRY_Convert(numeric(18,0), Case When cif_demographics.userdef06='0000000000000.00000' OR cif_demographics.userdef06='0.00000' THEN NULL ELSE cif_demographics.userdef06 END) AS [Jobs Created]
,cif_demographics.userdef13	as [Head of Household]
,cif_demographics.userdef14	as [Borrower Income Level]
,TRY_Convert(numeric(18,0), Case When cif_demographics.userdef16='0000000000000.00000' OR cif_demographics.userdef16='0.00000' THEN NULL ELSE cif_demographics.userdef16 END) AS [AGI]
,TRY_Convert(numeric(18,0), Case When cif_demographics.userdef17='0000000000000.00000' OR cif_demographics.userdef17='0.00000' THEN NULL ELSE cif_demographics.userdef17 END) AS [# of People in Home]
,cif_demographics.userdef18	as [IDA Client]
,cif_demographics.userdef19	as [Veteran Owned]
,LEFT(cif_detail.userdef01,250)	as [Referral Source Detail]
,cif_detail.userdef02	as [Lead Officer]
,cif_detail.userdef08	as [Date Business Established]
,cif_detail.userdef09	as [Business License?]
,TRY_Convert(numeric(18,0), Case When cif_detail.userdef10='0000000000000.00000' OR cif_detail.userdef10='0.00000' THEN NULL ELSE cif_detail.userdef10 END) AS [Years in Current Location]
,cif_detail.userdef11	as [Do you have a lease?]
,TRY_Convert(numeric(18,0), Case When cif_detail.userdef12='0000000000000.00000' OR cif_detail.userdef12='0.00000' THEN NULL ELSE cif_detail.userdef12 END) AS [Years Left in lease/option]
,cif_detail.userdef17	as [Industry]
,cif_detail.userdef19	as [Business Owner 1]
,TRY_Convert(numeric(18,0), Case When cif_detail.userdef20='0000000000000.00000' OR cif_detail.userdef20='0.00000' THEN NULL ELSE cif_detail.userdef20 END) AS [Owner 1 % of Company]
,cif_detail.userdef21	as [Owner 1 Status]
,cif_detail.userdef22	as [Business Owner 2]
,TRY_Convert(numeric(18,0), Case When cif_detail.userdef23='0000000000000.00000' OR cif_detail.userdef23='0.00000' THEN NULL ELSE cif_detail.userdef23 END) AS [Owner 2 % of Company]
,cif_detail.userdef24	as [Owner 2 Status]
,cif_detail.userdef25	as [Business Owner 3]
,TRY_Convert(numeric(18,0), Case When cif_detail.userdef26='0000000000000.00000' OR cif_detail.userdef26='0.00000' THEN NULL ELSE cif_detail.userdef26 END) AS [Owner 3 % of Company]
,cif_detail.userdef27	as [Owner 3 Status]
,TRY_Convert(numeric(18,0), Case When cif_detail.userdef28='0000000000000.00000' OR cif_detail.userdef28='0.00000' THEN NULL ELSE cif_detail.userdef28 END) AS [Full Time Employees]
,TRY_Convert(numeric(18,0), Case When cif_detail.userdef29='0000000000000.00000' OR cif_detail.userdef29='0.00000' THEN NULL ELSE cif_detail.userdef29 END) AS [Part Time Employees]
,cif_detail.userdef30	as [How did you hear about us?]
,cif_detail.userdef31	as [# of Locations]
,cif_detail.userdef32	as [Days Open]
,cif_detail.userdef37	as [Referred To]
,cif_detail.userdef49	as [Source Campaign]
,[cif].[cifnumber] AS [Contact Number]
				,(SELECT [u].[username]
				  FROM	[NLS].[dbo].[nlsusers] u (nolock)
				  WHERE	[u].[userno] = [cif].[officer_number]) AS [Contact Officer]
				,[cif].[company] AS Company
				,(SELECT TOP(1)	[cc].[comment_description] +	CASE
																					WHEN [cc].[comments] IS NULL
																					THEN ''
																					ELSE ' ' + [cc].[comments]
																				END
							FROM	[NLS].[dbo].[cif_comments] cc (nolock)
							WHERE	[cc].[cifno] = [cif].[cifno]
									AND [cc].[category_id] = 16
									AND [cc].[created] IN (SELECT MAX([cc2].[created])
														FROM	[NLS].[dbo].[cif_comments] cc2 (NOLOCK)
														WHERE	cc2.cifno = [cif].cifno
																AND category_id = 16)) AS [Approval Comment - Current] 
				,(SELECT TOP(1) CONVERT(VARCHAR(10), MAX([cc2].[created]), 101)
						FROM	[NLS].[dbo].[cif_comments] cc2 (NOLOCK)
						WHERE	[cc2].[cifno] = [cif].[cifno]
									and category_id = 16) AS [Approval Comment Date - Current] 
				,(SELECT TOP(1)	[cc].comment_description +	CASE
																					WHEN cc.comments is null
																					THEN ''
																					ELSE ' ' + cc.comments
																				END
							FROM	[NLS].[dbo].[cif_comments] cc (NOLOCK)
							WHERE	[cc].[cifno] = [cif].[cifno]
									AND [cc].[category_id] != 16
									AND [cc].[created] IN (SELECT	MAX(created)
														FROM	[NLS].[dbo].[cif_comments] cc2 (nolock)
														WHERE   [cc2].[cifno] = [cif].[cifno]
														AND     [cc2].[category_id] != 16)) as [Comment - Current]
				,(	SELECT TOP(1)	CONVERT(varchar(10), MAX([cc2].[created]), 101)
							FROM	[NLS].[dbo].[cif_comments] cc2 (NOLOCK)
							WHERE   [cc2].[cifno] = [cif].[cifno]
							AND [cc2].[category_id] != 16) AS [Comment Date - Current]
FROM [NLS].[dbo].[cif]
INNER JOIN [NLS].[dbo].[cif_demographics] ON cif.[cifno]=cif_demographics.[cifno]
INNER JOIN [NLS].[dbo].[cif_detail] ON cif.[cifno]=cif_detail.[cifno]
GO
