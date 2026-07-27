use learning;

select * from INFORMATION_SCHEMA.TABLES;
-- UNDERSTAND COLUMNS 
-- Table catalog : Explain about database where table exist 
-- Table schema : Explain who owns schema of that table in this case its dirty_lab schema is like folder which group related table 
-- table name:actual name of tables 
-- tabletype:The type of object. Usually BASE TABLE or VIEW
/*
SQL Server
│
└── Database (learning)
      │
      ├── Schema (dbo)
      │      └── sysdiagrams
      │
      └── Schema (dirty_lab)
             ├── raw_customers
             ├── raw_products
             ├── raw_orders
             └── raw_payments */


             a
SELECT* From INFORMATION_SCHEMA.COLUMNS
where TABLE_NAME='raw_customers';

/*
===============================================================================
PRACTICE TASKS
===============================================================================

LEVEL 1: PROFILING
1. Count rows, nulls, blanks, and distinct values for every important column.
2. Find values containing leading/trailing spaces, tabs, and non-breaking spaces.
3. Identify duplicate customer, product, order, and payment records.
4. Find IDs that differ only by case or whitespace.
5. Profile all raw date patterns before converting them.*/

-- information about table 
SELECT * FROM INFORMATION_SCHEMA.TABLES
where TABLE_NAME in ('raw_customers','raw_orders','raw_payments','raw_products');

-- information about columns 
SELECT* From INFORMATION_SCHEMA.COLUMNS
where TABLE_NAME  in ('raw_customers','raw_orders','raw_payments','raw_products');



DECLARE @TableName SYSNAME  = N'raw_customers'; 
DECLARE @DynamicSQL NVARCHAR(MAX) = '';

-- Construct a unified query by fetching all column names from the metadata
SELECT @DynamicSQL += 'SELECT ''' + COLUMN_NAME + ''' AS [ColumnName], COUNT(DISTINCT [' + COLUMN_NAME + ']) AS [DistinctCount] FROM [' + TABLE_SCHEMA + '].[' + TABLE_NAME + '] UNION ALL '
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = @TableName;

-- Clean up the trailing 'UNION ALL ' from the generated string
IF LEN(@DynamicSQL) > 0
BEGIN
    SET @DynamicSQL = LEFT(@DynamicSQL, LEN(@DynamicSQL) - 11);
    
    -- Execute the generated code
    EXEC sp_executesql @DynamicSQL;
END
ELSE
BEGIN
    PRINT 'Table not found or has no columns.';
END
