USE [DataMart]
GO
/****** Object:  View [dbo].[Developer_DataMart_Loans]    Script Date: 8/24/2020 9:49:52 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE VIEW [dbo].[Developer_DataMart_Loans] AS

--All Logic maintained in View Developer_DataMart_Loans_DuplicateRestructures
SELECT * 
  FROM [DataMart].[dbo].[Developer_DataMart_Loans_DuplicateRestructures]
  WHERE [RestructuredAcct Ref No]='0'
GO
