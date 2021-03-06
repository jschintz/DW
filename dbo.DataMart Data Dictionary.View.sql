USE [DataMart]
GO
/****** Object:  View [dbo].[DataMart Data Dictionary]    Script Date: 8/24/2020 9:49:52 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[DataMart Data Dictionary]
AS
SELECT 
	o.name as [Table Name],
	c.object_id [Table ID],
	ta.temporal_type_desc [Change Tracking],
    c.name 'Column Name',
	c.column_id [Column ID],
    t.Name 'Data type',
    c.max_length 'Max Length',
    c.precision ,
    c.scale ,
    c.is_nullable,
    ISNULL(i.is_primary_key, 0) 'Primary Key'
FROM    
    sys.columns c
INNER JOIN   
    sys.objects o ON c.object_id=o.object_id
INNER JOIN   
    sys.tables ta ON c.object_id=ta.object_id
INNER JOIN 
    sys.types t ON c.user_type_id = t.user_type_id
LEFT OUTER JOIN 
    sys.index_columns ic ON ic.object_id = c.object_id AND ic.column_id = c.column_id
LEFT OUTER JOIN 
    sys.indexes i ON ic.object_id = i.object_id AND ic.index_id = i.index_id
WHERE temporal_type!=1
GO
