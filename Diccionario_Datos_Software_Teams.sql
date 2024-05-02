SELECT 
    'DATADICTIONARY' AS `REPORT`,
    @@hostname AS `ServerName`,
    DATABASE() AS `DatabaseName`,
    t.TABLE_NAME AS `TableName`, 
    t.TABLE_SCHEMA AS `SchemaName`, 
    c.COLUMN_NAME AS `ColumnName`, 
    c.COLUMN_TYPE AS `DataType`, 
    c.CHARACTER_MAXIMUM_LENGTH AS `MaxLength`, 
    CASE 
        WHEN c.IS_NULLABLE = 'NO' THEN 'NO'
        ELSE 'YES'
    END AS `IsNull`,
    CASE 
        WHEN c.EXTRA = 'auto_increment' THEN 'YES'
        ELSE 'NO'
    END AS `IsIdentity`, 
    IFNULL(c.COLUMN_COMMENT, '-- add description here') AS `Description`
FROM information_schema.TABLES t
JOIN information_schema.COLUMNS c
    ON t.TABLE_SCHEMA = c.TABLE_SCHEMA AND t.TABLE_NAME = c.TABLE_NAME
WHERE t.TABLE_SCHEMA = 'softwareteam'
ORDER BY 
    t.TABLE_NAME,
    c.ORDINAL_POSITION;
