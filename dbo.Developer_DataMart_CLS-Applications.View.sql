USE [DataMart]
GO
/****** Object:  View [dbo].[Developer_DataMart_CLS-Applications]    Script Date: 8/24/2020 9:49:52 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [dbo].[Developer_DataMart_CLS-Applications] AS
Select 
[genesis__Applications__c].[Id] AS [Application Id]
,[genesis__Applications__c].[Name] AS [Application Name]
,[genesis__Applications__c].[CreatedDate] AS [Created Date]
,[genesis__Applications__c].genesis__Account__c As [Borrower Account ID]
,[genesis__Applications__c].Merchant_Account__c As [Business Account ID]
,[genesis__Applications__c].genesis__Status__c  AS [Status]
,[genesis__Applications__c].genesis__Loan_Amount__c AS [Loan Amount]
,[genesis__Applications__c].genesis__Asset_Class__c AS [Asset Class]
,[genesis__Applications__c].genesis__Term__c As Term
,(Select [clcommon__Product_Name__c] FROM [CDATA].[SF-CLS-Prod].[clcommon__CL_Product__c] WHERE [genesis__Applications__c].genesis__CL_Product__c = [clcommon__CL_Product__c].[Id]  ) AS [Product Name]
,[genesis__Applications__c].Requested_Loan_Amount__c AS [Requested Loan Amount]
,(SELECT [Name] FROM [CDATA].[SF-CLS-Prod].[User] WHERE [genesis__Applications__c].[OwnerId] =[User].[Id] ) AS [Owner]
,[genesis__Applications__c].genesis__CL_Purpose__c
,[genesis__Applications__c].Repeat_Borrower__c AS [Repeat Borrower]
,[genesis__Applications__c].Receive_Text_Info__c AS [Receive Text Info]
,[genesis__Applications__c].Is_Phone_Verified__c AS [Is Phone Verified]
,[genesis__Applications__c].genesis__Product_Type__c AS [Product Type]
,[genesis__Applications__c].genesis__Interest_Rate__c As [Interest Rate]
,CASE WHEN [genesis__Applications__c].Total_Repayment_Amount__c =0 THEN Null ELSE [genesis__Applications__c].Total_Repayment_Amount__c END AS [Total Repayment Amount]
,[genesis__Applications__c].Require_Collateral__c AS [Require Collateral]
,[genesis__Applications__c].Require_Coborrower__c AS [Require Coborrower]
,[genesis__Applications__c].Relationship_Type__c AS [Relationship Type]
,[genesis__Applications__c].Referred_By_Broker__c AS [Referred by Broker]
,[genesis__Applications__c].Referred_By__c AS [Referred By]
,[genesis__Applications__c].portal_stage__c AS [Portal Stage]
,(SELECT [Name] FROM [CDATA].[SF-CLS-Prod].[User] WHERE [genesis__Applications__c].Loan_Officer__c =[User].[Id] ) AS [Loan Officer]
,[genesis__Applications__c].How_Did_You_Hear_About__c AS [How did you hear About Us]
,[genesis__Applications__c].genesis__Product_Sub_Type__c AS [Sub Type]
,[genesis__Applications__c].genesis__Payment_Frequency__c As [Payment Frequency]
,[genesis__Applications__c].genesis__Overall_Status__c AS [Overall Status]
,[genesis__Applications__c].genesis__Fees_Amount__c AS [Fees Amount]
,[genesis__Applications__c].genesis__Days_Convention__c AS [Days Convention]
--,[genesis__Applications__c].genesis__CL_Product_Name__c AS [Product Name]
,[genesis__Applications__c].CLS_CalCap_Check_Eligibility__c AS [CalCap Eligibility]
,[genesis__Applications__c].Applicant_applicable_for_business__c AS [Applicant Applicable for Business]
,[genesis__Applications__c].Special_Notes_to_Accounting__c AS [Special Notes to Accounting]
,CASE WHEN [genesis__Applications__c].Soft_Pull_Experian_Report__c IS NULL Then 0 ELse 1 END as [Softpull?]
,[genesis__Applications__c].Is_Override__c AS [Is Override]
,CASE WHEN [genesis__Applications__c].genesis__Total_Score__c=0 Then Null ELSE [genesis__Applications__c].genesis__Total_Score__c END AS [Total Score]
,CASE WHEN [genesis__Applications__c].genesis__Payment_Amount__c=0 Then Null Else [genesis__Applications__c].genesis__Payment_Amount__c END As [Payment Amount]
,[genesis__Applications__c].genesis__Maturity_Date__c AS [Maturity Date]
,[genesis__Applications__c].genesis__Interest_Calculation_Method__c AS [Interest Calculation Method]
,[genesis__Applications__c].genesis__Expected_Start_Date__c AS [Expected Start Date]
,[genesis__Applications__c].genesis__Expected_First_Payment_Date__c AS [Expected First Payment Date]
,[genesis__Applications__c].genesis__Expected_Close_Date__c AS [Expected Close Date]
,[genesis__Applications__c].genesis__Disbursement_Date__c AS [Disbursement Date]
,[genesis__Applications__c].genesis__Credit_Limit__c AS [Credit Limit]
,[genesis__Applications__c].genesis__APR__c AS [APR]
,[genesis__Applications__c].Created_From_Skuid__c AS [Created from SKUID]
,CASE WHEN  [genesis__Applications__c].Collateral_Coverage__c = 0 Then Null Else [genesis__Applications__c].Collateral_Coverage__c END AS [Collateral Coverage]
,[genesis__Applications__c].CLS_Affirm__c AS Affirm
,[genesis__Applications__c].Calculated_Offer_Amount__c AS [Calculated Offer Amount]
,Isnull((SELECT 1
  FROM [CDATA].[SF-CLS-Prod].[Task]
  WHERE [Task].[genesis__Application__c]=[genesis__Applications__c].[Id]
AND [genesis__Completion_Mandatory__c]=1
  AND [Subject] ='Application Info'),0) AS [Application Info Req?]
,Isnull((SELECT 1
  FROM [CDATA].[SF-CLS-Prod].[Task]
  WHERE [Task].[genesis__Application__c]=[genesis__Applications__c].[Id]
AND [genesis__Completion_Mandatory__c]=1
  AND [Subject] ='Audit ACH Bank Account/Funding Account'),0) AS [Audit ACH Bank Account/Funding Account Req?]
,Isnull((SELECT 1
  FROM [CDATA].[SF-CLS-Prod].[Task]
  WHERE [Task].[genesis__Application__c]=[genesis__Applications__c].[Id]
AND [genesis__Completion_Mandatory__c]=1
  AND [Subject] ='Audit Liabilities/Payoff Accounts'),0) AS [Audit Liabilities/Payoff Accounts Req?]
,Isnull((SELECT 1
  FROM [CDATA].[SF-CLS-Prod].[Task]
  WHERE [Task].[genesis__Application__c]=[genesis__Applications__c].[Id]
AND [genesis__Completion_Mandatory__c]=1
  AND [Subject] ='Audit References'),0) AS [Audit References Req?]
,Isnull((SELECT 1
  FROM [CDATA].[SF-CLS-Prod].[Task]
  WHERE [Task].[genesis__Application__c]=[genesis__Applications__c].[Id]
AND [genesis__Completion_Mandatory__c]=1
  AND [Subject] ='Check ACH Bank Account/Funding Account'),0) AS [Check ACH Bank Account/Funding Account Req?]
,Isnull((SELECT 1
  FROM [CDATA].[SF-CLS-Prod].[Task]
  WHERE [Task].[genesis__Application__c]=[genesis__Applications__c].[Id]
AND [genesis__Completion_Mandatory__c]=1
  AND [Subject] ='Check Liabilities/Payoff Accounts'),0) AS [Check Liabilities/Payoff Accounts Req?]
,Isnull((SELECT 1
  FROM [CDATA].[SF-CLS-Prod].[Task]
  WHERE [Task].[genesis__Application__c]=[genesis__Applications__c].[Id]
AND [genesis__Completion_Mandatory__c]=1
  AND [Subject] ='Check Requested'),0) AS [Check Requested Req?]
,Isnull((SELECT 1
  FROM [CDATA].[SF-CLS-Prod].[Task]
  WHERE [Task].[genesis__Application__c]=[genesis__Applications__c].[Id]
AND [genesis__Completion_Mandatory__c]=1
  AND [Subject] ='Credit check'),0) AS [Credit check Req?]
,Isnull((SELECT 1
  FROM [CDATA].[SF-CLS-Prod].[Task]
  WHERE [Task].[genesis__Application__c]=[genesis__Applications__c].[Id]
AND [genesis__Completion_Mandatory__c]=1
  AND [Subject] ='Document Upload'),0) AS [Document Upload Req?]
,Isnull((SELECT 1
  FROM [CDATA].[SF-CLS-Prod].[Task]
  WHERE [Task].[genesis__Application__c]=[genesis__Applications__c].[Id]
AND [genesis__Completion_Mandatory__c]=1
  AND [Subject] ='Enter financials'),0) AS [Enter financials Req?]
,Isnull((SELECT 1
  FROM [CDATA].[SF-CLS-Prod].[Task]
  WHERE [Task].[genesis__Application__c]=[genesis__Applications__c].[Id]
AND [genesis__Completion_Mandatory__c]=1
  AND [Subject] ='Evaluate Collateral'),0) AS [Evaluate Collateral Req?]
,Isnull((SELECT 1
  FROM [CDATA].[SF-CLS-Prod].[Task]
  WHERE [Task].[genesis__Application__c]=[genesis__Applications__c].[Id]
AND [genesis__Completion_Mandatory__c]=1
  AND [Subject] ='Fraud Verification Accounts'),0) AS [Fraud Verification Accounts Req?]
,Isnull((SELECT 1
  FROM [CDATA].[SF-CLS-Prod].[Task]
  WHERE [Task].[genesis__Application__c]=[genesis__Applications__c].[Id]
AND [genesis__Completion_Mandatory__c]=1
  AND [Subject] ='Fraud Verification Individuals'),0) AS [Fraud Verification Individuals Req?]
,Isnull((SELECT 1
  FROM [CDATA].[SF-CLS-Prod].[Task]
  WHERE [Task].[genesis__Application__c]=[genesis__Applications__c].[Id]
AND [genesis__Completion_Mandatory__c]=1
  AND [Subject] ='Funding Review'),0) AS [Funding Review Req?]
,Isnull((SELECT 1
  FROM [CDATA].[SF-CLS-Prod].[Task]
  WHERE [Task].[genesis__Application__c]=[genesis__Applications__c].[Id]
AND [genesis__Completion_Mandatory__c]=1
  AND [Subject] ='Hard Pull'),0) AS [Hard Pull Req?]
,Isnull((SELECT 1
  FROM [CDATA].[SF-CLS-Prod].[Task]
  WHERE [Task].[genesis__Application__c]=[genesis__Applications__c].[Id]
AND [genesis__Completion_Mandatory__c]=1
  AND [Subject] ='Loan Approval'),0) AS [Loan Approval Req?]
,Isnull((SELECT 1
  FROM [CDATA].[SF-CLS-Prod].[Task]
  WHERE [Task].[genesis__Application__c]=[genesis__Applications__c].[Id]
AND [genesis__Completion_Mandatory__c]=1
  AND [Subject] ='Loan Funded'),0) AS [Loan Funded Req?]
,Isnull((SELECT 1
  FROM [CDATA].[SF-CLS-Prod].[Task]
  WHERE [Task].[genesis__Application__c]=[genesis__Applications__c].[Id]
AND [genesis__Completion_Mandatory__c]=1
  AND [Subject] ='Perform Cash Flow Analysis'),0) AS [Perform Cash Flow Analysis Req?]
,Isnull((SELECT 1
  FROM [CDATA].[SF-CLS-Prod].[Task]
  WHERE [Task].[genesis__Application__c]=[genesis__Applications__c].[Id]
AND [genesis__Completion_Mandatory__c]=1
  AND [Subject] ='Pull Reports'),0) AS [Pull Reports Req?]
,Isnull((SELECT 1
  FROM [CDATA].[SF-CLS-Prod].[Task]
  WHERE [Task].[genesis__Application__c]=[genesis__Applications__c].[Id]
AND [genesis__Completion_Mandatory__c]=1
  AND [Subject] ='Re-run the scorecard'),0) AS [Re-run the scorecard Req?]
,Isnull((SELECT 1
  FROM [CDATA].[SF-CLS-Prod].[Task]
  WHERE [Task].[genesis__Application__c]=[genesis__Applications__c].[Id]
AND [genesis__Completion_Mandatory__c]=1
  AND [Subject] ='Select initial offer'),0) AS [Select initial offer Req?]
,Isnull((SELECT 1
  FROM [CDATA].[SF-CLS-Prod].[Task]
  WHERE [Task].[genesis__Application__c]=[genesis__Applications__c].[Id]
AND [genesis__Completion_Mandatory__c]=1
  AND [Subject] ='Update Financials'),0) AS [Update Financials Req?]
,Isnull((SELECT 1
  FROM [CDATA].[SF-CLS-Prod].[Task]
  WHERE [Task].[genesis__Application__c]=[genesis__Applications__c].[Id]
AND [genesis__Completion_Mandatory__c]=1
  AND [Subject] ='Verify Documents'),0) AS [Verify Documents Req?]
,Isnull((SELECT 1
  FROM [CDATA].[SF-CLS-Prod].[Task]
  WHERE [Task].[genesis__Application__c]=[genesis__Applications__c].[Id]
AND [genesis__Completion_Mandatory__c]=1
  AND [Subject] ='Verify loan details'),0) AS [Verify loan details Req?]

,(SELECT Status
  FROM [CDATA].[SF-CLS-Prod].[Task]
  WHERE [Task].[genesis__Application__c]=[genesis__Applications__c].[Id]
  AND [Subject] ='Application Info') AS [Application Info Status]
,(SELECT Status
  FROM [CDATA].[SF-CLS-Prod].[Task]
  WHERE [Task].[genesis__Application__c]=[genesis__Applications__c].[Id]
  AND [Subject] ='Audit ACH Bank Account/Funding Account') AS [Audit ACH Bank Account/Funding Account Status]
,(SELECT Status
  FROM [CDATA].[SF-CLS-Prod].[Task]
  WHERE [Task].[genesis__Application__c]=[genesis__Applications__c].[Id]
  AND [Subject] ='Audit Liabilities/Payoff Accounts') AS [Audit Liabilities/Payoff Accounts Status]
,(SELECT Status
  FROM [CDATA].[SF-CLS-Prod].[Task]
  WHERE [Task].[genesis__Application__c]=[genesis__Applications__c].[Id]
  AND [Subject] ='Audit References') AS [Audit References Status]
,(SELECT Status
  FROM [CDATA].[SF-CLS-Prod].[Task]
  WHERE [Task].[genesis__Application__c]=[genesis__Applications__c].[Id]
  AND [Subject] ='Check ACH Bank Account/Funding Account') AS [Check ACH Bank Account/Funding Account Status]
,(SELECT Status
  FROM [CDATA].[SF-CLS-Prod].[Task]
  WHERE [Task].[genesis__Application__c]=[genesis__Applications__c].[Id]
  AND [Subject] ='Check Liabilities/Payoff Accounts') AS [Check Liabilities/Payoff Accounts Status]
,(SELECT Status
  FROM [CDATA].[SF-CLS-Prod].[Task]
  WHERE [Task].[genesis__Application__c]=[genesis__Applications__c].[Id]
  AND [Subject] ='Check Requested') AS [Check Requested Status]
,(SELECT Status
  FROM [CDATA].[SF-CLS-Prod].[Task]
  WHERE [Task].[genesis__Application__c]=[genesis__Applications__c].[Id]
  AND [Subject] ='Credit check') AS [Credit check Status]
,(SELECT Status
  FROM [CDATA].[SF-CLS-Prod].[Task]
  WHERE [Task].[genesis__Application__c]=[genesis__Applications__c].[Id]
  AND [Subject] ='Document Upload') AS [Document Upload Status]
,(SELECT Status
  FROM [CDATA].[SF-CLS-Prod].[Task]
  WHERE [Task].[genesis__Application__c]=[genesis__Applications__c].[Id]
  AND [Subject] ='Enter financials') AS [Enter financials Status]
,(SELECT Status
  FROM [CDATA].[SF-CLS-Prod].[Task]
  WHERE [Task].[genesis__Application__c]=[genesis__Applications__c].[Id]
  AND [Subject] ='Evaluate Collateral') AS [Evaluate Collateral Status]
,(SELECT Status
  FROM [CDATA].[SF-CLS-Prod].[Task]
  WHERE [Task].[genesis__Application__c]=[genesis__Applications__c].[Id]
  AND [Subject] ='Fraud Verification Accounts') AS [Fraud Verification Accounts Status]
,(SELECT Status
  FROM [CDATA].[SF-CLS-Prod].[Task]
  WHERE [Task].[genesis__Application__c]=[genesis__Applications__c].[Id]
  AND [Subject] ='Fraud Verification Individuals') AS [Fraud Verification Individuals Status]
,(SELECT Status
  FROM [CDATA].[SF-CLS-Prod].[Task]
  WHERE [Task].[genesis__Application__c]=[genesis__Applications__c].[Id]
  AND [Subject] ='Funding Review') AS [Funding Review Status]
,(SELECT Status
  FROM [CDATA].[SF-CLS-Prod].[Task]
  WHERE [Task].[genesis__Application__c]=[genesis__Applications__c].[Id]
  AND [Subject] ='Hard Pull') AS [Hard Pull Status]
,(SELECT Status
  FROM [CDATA].[SF-CLS-Prod].[Task]
  WHERE [Task].[genesis__Application__c]=[genesis__Applications__c].[Id]
  AND [Subject] ='Loan Approval') AS [Loan Approval Status]
,(SELECT Status
  FROM [CDATA].[SF-CLS-Prod].[Task]
  WHERE [Task].[genesis__Application__c]=[genesis__Applications__c].[Id]
  AND [Subject] ='Loan Funded') AS [Loan Funded Status]
,(SELECT Status
  FROM [CDATA].[SF-CLS-Prod].[Task]
  WHERE [Task].[genesis__Application__c]=[genesis__Applications__c].[Id]
  AND [Subject] ='Perform Cash Flow Analysis') AS [Perform Cash Flow Analysis Status]
,(SELECT Status
  FROM [CDATA].[SF-CLS-Prod].[Task]
  WHERE [Task].[genesis__Application__c]=[genesis__Applications__c].[Id]
  AND [Subject] ='Pull Reports') AS [Pull Reports Status]
,(SELECT Status
  FROM [CDATA].[SF-CLS-Prod].[Task]
  WHERE [Task].[genesis__Application__c]=[genesis__Applications__c].[Id]
  AND [Subject] ='Re-run the scorecard') AS [Re-run the scorecard Status]
,(SELECT Status
  FROM [CDATA].[SF-CLS-Prod].[Task]
  WHERE [Task].[genesis__Application__c]=[genesis__Applications__c].[Id]
  AND [Subject] ='Select initial offer') AS [Select initial offer Status]
,(SELECT Status
  FROM [CDATA].[SF-CLS-Prod].[Task]
  WHERE [Task].[genesis__Application__c]=[genesis__Applications__c].[Id]
  AND [Subject] ='Update Financials') AS [Update Financials Status]
,(SELECT Status
  FROM [CDATA].[SF-CLS-Prod].[Task]
  WHERE [Task].[genesis__Application__c]=[genesis__Applications__c].[Id]
  AND [Subject] ='Verify Documents') AS [Verify Documents Status]
,(SELECT Status
  FROM [CDATA].[SF-CLS-Prod].[Task]
  WHERE [Task].[genesis__Application__c]=[genesis__Applications__c].[Id]
  AND [Subject] ='Verify loan details') AS [Verify loan details Status]


FROM [CDATA].[SF-CLS-Prod].[genesis__Applications__c]
WHERE [genesis__Applications__c].[IsDeleted] = 0
GO
