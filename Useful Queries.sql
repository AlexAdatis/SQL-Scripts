--Checking for schema name, table name and row count
SELECT SCHEMA_NAME(t.[schema_id]) AS [table_schema]
,OBJECT_NAME(p.[object_id]) AS [table_name]
,SUM(p.[rows]) AS [row_count]
FROM [sys].[partitions] p
JOIN [sys].[tables] t ON p.[object_id] = t.[object_id]
WHERE p.[index_id] < 2
GROUP BY p.[object_id]
,t.[schema_id]
ORDER BY 1, 2 ASC

--Checking for the presence of all tables and columns with their data types:
SELECT
schema_name = schema_name(tab.schema_id)
,table_name = tab.name
,column_name = col.name
,data_type = t.name
FROM
sys.tables AS tab
JOIN sys.columns AS col
ON tab.object_id = col.object_id left
JOIN sys.types AS t
ON col.user_type_id = t.user_type_id
ORDER BY
schema_name,
table_name,
column_id;

--Checking for the presence of foreign keys, parent and reference tables:
SELECT
[FK Name] = fk.name
,[Parent table] = tp.name
,[Parent column name] = cp.name
,[Refrenced table] = tr.name
,[Parent column name] = cr.name
FROM
sys.foreign_keys AS fk
JOIN sys.tables AS tp
ON fk.parent_object_id = tp.object_id
JOIN sys.tables AS tr
ON fk.referenced_object_id = tr.object_id
JOIN sys.foreign_key_columns AS fkc
ON fkc.constraint_object_id = fk.object_id
JOIN sys.columns AS cp
ON fkc.parent_column_id = cp.column_id
AND fkc.parent_object_id = cp.object_id
JOIN sys.columns AS cr
ON fkc.referenced_column_id = cr.column_id
AND fkc.referenced_object_id = cr.object_id
ORDER BY
tp.name
,cp.column_id