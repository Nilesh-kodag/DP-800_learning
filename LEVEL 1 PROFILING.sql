--1. Count rows, nulls, blanks, and distinct values for every important column.
--2. Find values containing leading/trailing spaces, tabs, and non-breaking spaces.
--3. Identify duplicate customer, product, order, and payment records.
--4. Find IDs that differ only by case or whitespace.
--5. Profile all raw date patterns before converting them.
--CREATE TABLE dirty_lab.raw_suppliers
--(
--    supplier_id         VARCHAR(50),
--    supplier_name       VARCHAR(150),
--    contact_person      VARCHAR(100),
--    email_raw           VARCHAR(200),
--    phone_raw           VARCHAR(100),
--    country_raw         VARCHAR(100),
--    city_raw            VARCHAR(100),
--    postal_code_raw     VARCHAR(50),
--    rating_raw          VARCHAR(50),
--    contract_start_raw  VARCHAR(100),
--    contract_end_raw    VARCHAR(100),
--    is_active_raw       VARCHAR(30)
--);
--GO

--INSERT INTO dirty_lab.raw_suppliers VALUES
--('S001','ABC Electronics','Rajesh Kumar','sales@abc.com','9876543210','India','Hyderabad','500081','4.8','2024-01-01','2028-12-31','Yes'),
--('S002','XYZ Imports',NULL,'contact@xyz.com',NULL,'India','Mumbai','400001',NULL,'01/02/2024',NULL,'1'),
--('S003','Global Tech','John Smith','john@@global.com','+1-222-333-4444','USA','New York',NULL,'Five','2024/05/01','',NULL),
--('S004',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL),
--('S005','Office Supplies','Sneha Patil','sneha@office.com','98765abc210','India','Pune','411001','3.9','2025-01-15','2030-01-15','TRUE'),
--('S006','Furniture Hub','Amit Sharma','',NULL,'India','Delhi',NULL,'','not available','2029-12-31','No'),
--('S007','Tech World','Rahul Verma','rahul@tech.com','9988776655','India',NULL,NULL,'4','2026-01-01',NULL,'Y'),
--('S008','Dummy Supplier',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL);
--GO

--CREATE TABLE dirty_lab.raw_employees
--(
--    employee_id         VARCHAR(50),
--    first_name          VARCHAR(100),
--    last_name           VARCHAR(100),
--    email_raw           VARCHAR(200),
--    phone_raw           VARCHAR(100),
--    manager_id_raw      VARCHAR(50),
--    department_raw      VARCHAR(100),
--    designation_raw     VARCHAR(100),
--    salary_raw          VARCHAR(100),
--    hire_date_raw       VARCHAR(100),
--    termination_date_raw VARCHAR(100),
--    is_active_raw       VARCHAR(30)
--);
--GO

--INSERT INTO dirty_lab.raw_employees VALUES
--('E001','Nilesh','Kodag','nilesh@company.com','9876543210',NULL,'Engineering','Data Engineer','1500000','2024-01-15',NULL,'Yes'),
--('E002','Rahul','Verma','rahul@company.com',NULL,'E001','Engineering','Senior Data Engineer','1800000','15/02/2024',NULL,'TRUE'),
--('E003','Sneha','Patil','sneha@@company.com','9988776655','E001','HR','HR Manager','900000','2024/03/01','',NULL),
--('E004',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL),
--('E005','Amit','Sharma','','98765abc210','E010','Finance','Analyst','₹950000','2025-01-01',NULL,'1'),
--('E006','Priya','Nair','priya@company.com',NULL,NULL,'Sales','Executive','NULL','not available',NULL,'No'),
--('E007','John','Doe','john@company.com','12345','E002','Sales','Manager','-50000','2050-01-01',NULL,'Y'),
--('E008','Test','User',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL);
--GO



SELECT * FROM 
INFORMATION_SCHEMA.TABLES
where TABLE_CATALOG='learning';

--How to Count rows, nulls, blanks, and distinct values for every important column.
SELECT * FROm [dirty_lab].[raw_payments];

-- row count 
--Core DifferenceCOUNT(*) counts every row in the table, including duplicate rows and rows containing NULL values.COUNT(column_name) counts 
--only the rows where the specified column is not NULL.

--| Feature            | COUNT(*)                         | COUNT(column_name)                    |
--|--------------------|----------------------------------|---------------------------------------|
--| Counts NULLs?      | Yes                              | No                                    |
--| Counts duplicates? | Yes                              | Yes (unless DISTINCT is used)         |
--| Performance        | Optimized by modern databases    | May be slower if column is not indexed|
--| Result             | Total row count                  | Total populated rows for that column  |

select count(*),count(refund_amount_raw), count(distinct refund_amount_raw)  from [dirty_lab].[raw_payments];

Select sum(case when postal_code_raw is null then 1 else 0 end) count_nulls
     , count(postal_code_raw) count_not_nulls 
  from dirty_lab.raw_suppliers;

--  count_nulls	count_not_nulls
--5	3

SELECT 
trim("supplier_id"),
trim("supplier_name"),
trim("contact_person"),
trim("email_raw"),
trim("phone_raw"),
trim("country_raw"),
trim("city_raw"),
trim("postal_code_raw"),
trim("rating_raw"),
trim("contract_start_raw"),
trim("contract_end_raw"),
trim("is_active_raw")
FROM dirty_lab.raw_suppliers

--Find values containing leading/trailing spaces, tabs, and non-breaking spaces.
SELECT
    supplier_name AS Original,
    TRIM(supplier_name) AS AfterTrim
FROM dirty_lab.raw_suppliers
WHERE supplier_name <> TRIM(supplier_name);

SELECT *
FROM dirty_lab.raw_suppliers
WHERE supplier_name <> LTRIM(RTRIM(supplier_name));

SELECT *
FROM dirty_lab.raw_suppliers
WHERE supplier_name LIKE '%' + CHAR(9) + '%';

SELECT *
FROM dirty_lab.raw_customers
WHERE CHARINDEX(CHAR(160), full_name) > 0;


SELECT *
FROM dirty_lab.raw_customers
WHERE
      full_name <> LTRIM(RTRIM(full_name))
   OR CHARINDEX(CHAR(9), full_name) > 0
   OR CHARINDEX(CHAR(160), full_name) > 0;




   SELECT *
FROM dirty_lab.raw_customers
WHERE
      full_name      <> LTRIM(RTRIM(full_name))
   OR email_address  <> LTRIM(RTRIM(email_address))
   OR phone_number   <> LTRIM(RTRIM(phone_number))

   OR CHARINDEX(CHAR(9), full_name) > 0
   OR CHARINDEX(CHAR(9), email_address) > 0
   OR CHARINDEX(CHAR(9), phone_number) > 0

   OR CHARINDEX(CHAR(160), full_name) > 0
   OR CHARINDEX(CHAR(160), email_address) > 0
   OR CHARINDEX(CHAR(160), phone_number) > 0;