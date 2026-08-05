-- Check columnstore health
SELECT 
    object_name(object_id) AS TableName,
    state_desc,
    total_rows,
    deleted_rows,
    size_in_bytes / 1024 / 1024 AS SizeMB
FROM sys.dm_db_column_store_row_group_physical_stats
WHERE object_id = OBJECT_ID('dirty_lab.customer_orders');

SELECT
    OBJECT_NAME(object_id) AS TableName,
    state_desc,
    total_rows,
    deleted_rows,
    size_in_bytes / 1024.0 / 1024.0 AS SizeMB
FROM sys.dm_db_column_store_row_group_physical_stats
WHERE object_id = OBJECT_ID('dbo.customer_orders');


SELECT
    i.name AS IndexName,
    i.type_desc AS IndexType
FROM sys.indexes AS i
WHERE i.object_id = OBJECT_ID('dirty_lab.customer_orders');


DROP TABLE IF EXISTS dbo.SalesHistory;
GO

CREATE TABLE dbo.SalesHistory
(
    SaleID INT,
    CustomerID INT,
    ProductID INT,
    Quantity INT,
    Price DECIMAL(10,2),
    SaleDate DATE
);
GO


INSERT INTO dbo.SalesHistory
VALUES
(1,101,10,2,100.50,'2024-01-01'),
(2,102,11,1,200.00,'2024-01-02'),
(3,103,12,5,150.25,'2024-01-03'),
(4,104,13,3,120.75,'2024-01-04'),
(5,105,14,2,300.00,'2024-01-05'),
(6,106,15,1,450.00,'2024-01-06'),
(7,107,16,4,175.00,'2024-01-07'),
(8,108,17,2,220.00,'2024-01-08');
GO


SELECT * FROM dbo.SalesHistory;


CREATE CLUSTERED COLUMNSTORE INDEX CCI_SalesHistory
ON dbo.SalesHistory;
GO


SELECT
    name,
    type_desc
FROM sys.indexes
WHERE object_id = OBJECT_ID('dbo.SalesHistory');


SELECT
    OBJECT_NAME(object_id) AS TableName,
    state_desc,
    total_rows,
    deleted_rows,
    size_in_bytes / 1024.0 / 1024.0 AS SizeMB
FROM sys.dm_db_column_store_row_group_physical_stats
WHERE object_id = OBJECT_ID('dbo.SalesHistory');



ALTER INDEX CCI_SalesHistory
ON dbo.SalesHistory
REBUILD;
GO


SELECT
    OBJECT_NAME(object_id) AS TableName,
    state_desc,
    total_rows,
    deleted_rows,
    size_in_bytes / 1024.0 / 1024.0 AS SizeMB
FROM sys.dm_db_column_store_row_group_physical_stats
WHERE object_id = OBJECT_ID('dbo.SalesHistory');


EXEC sp_spaceused 'dbo.SalesHistory';