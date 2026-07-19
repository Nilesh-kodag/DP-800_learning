/*
    DIRTY DATA CLEANING PRACTICE DATASET
    Target: Microsoft SQL Server

    Scenario:
    An e-commerce company combined customer, order, payment, and product data
    from several legacy systems. The data contains duplicates, invalid values,
    mixed date formats, inconsistent casing, hidden spaces, malformed numbers,
    and referential-integrity problems.

    IMPORTANT:
    Most dirty fields are intentionally stored as VARCHAR so you must clean and
    convert them safely using TRY_CONVERT, TRY_CAST, NULLIF, TRIM, REPLACE, etc.
*/
use learning;

SET NOCOUNT ON;

IF SCHEMA_ID('dirty_lab') IS NULL
    EXEC('CREATE SCHEMA dirty_lab');
GO

DROP TABLE IF EXISTS dirty_lab.raw_payments;
DROP TABLE IF EXISTS dirty_lab.raw_orders;
DROP TABLE IF EXISTS dirty_lab.raw_products;
DROP TABLE IF EXISTS dirty_lab.raw_customers;
GO

CREATE TABLE dirty_lab.raw_customers
(
    source_system       VARCHAR(30),
    customer_id         VARCHAR(50),
    full_name           VARCHAR(150),
    email_address       VARCHAR(200),
    phone_number        VARCHAR(100),
    date_of_birth_raw   VARCHAR(100),
    signup_datetime_raw VARCHAR(100),
    gender_raw          VARCHAR(50),
    country_raw         VARCHAR(100),
    state_raw           VARCHAR(100),
    postal_code_raw     VARCHAR(50),
    annual_income_raw   VARCHAR(100),
    is_active_raw       VARCHAR(30),
    last_updated_raw    VARCHAR(100)
);
GO

INSERT INTO dirty_lab.raw_customers VALUES
('CRM',       'C001',     'Nilesh Kodag',          'nilesh.kodag@gmail.com',       '+91 98765 43210',      '1997-05-23',             '2026-01-05 10:30:00',       'Male',    'India',          'Maharashtra',      '410206',     '1200000',        '1',       '2026-06-10 09:15:00'),
('crm',       ' c001 ',   'NILESH  KODAG ',        'NILESH.KODAG@GMAIL.COM ',      '9876543210',           '23/05/1997',             '05/01/2026 10:30 AM',       'M',       'INDIA ',         'maharashtra ',     '410 206',    '12,00,000',      'Yes',     '10-Jun-2026 09:15'),
('Legacy',    'C002',     'Aastika Sharma',        'aastika.sharma@gmail.com',     '09876543211',          '1998/11/14',             'Jan 13 2026 08:45PM',       'Female',  'IN',             'Delhi',            '110001',     '950000.50',      'TRUE',    '2026/06/11'),
('Legacy',    'C003',     ' Rahul Verma',          'rahul.verma@gmail',            '91-9988776655',         '31-02-1994',             '2026-13-01 25:61:00',       'MALE ',   'India',          'Karnataka',        '560001',     '8.5L',           'Y',       'not available'),
('Web',       'C004',     'Priya    Nair',         'priya.nair@@email.com',        '(+91) 91234-56789',     '07-12-1995',             '2026-02-29T14:20:00Z',      'F',       'india',          'Kerala',           '682 001',    '₹1,050,000',     'Active',  '2026-06-12T05:15:30Z'),
('Web',       'C005',     '',                      'noemail',                      'NA',                    '',                       'NULL',                       'Unknown', 'United States',  'California',       '94105-1234',  '$85,500',        '0',       ''),
('Mobile',    'C006',     'José da Silva',         'jose.silva@example.com',       '+55 (11) 99876-5432',   '1989-09-15',             '15/03/2026 18:10:22',       'male',    'Brazil',         'São Paulo',        '01310-100',  'BRL 180000',      'true',    '2026-06-13 11:00'),
('Mobile',    'C007',     '李 明',                  'li.ming@example.cn',           '+86 138 0013 8000',     '1992年04月03日',           '2026/04/01 09:00:00',       'M',       'China',          'Beijing',          '100000',     'CNY 320000',      'Yes',     '13/06/2026'),
('Partner',   '0008',     'Fatima Al-Zahra',       'fatima@example.ae ',           '00971-50-123-4567',     '1990.06.20',             '20-Jun-2026 07:30:00 PM',   'FEMALE',  'UAE',            'Dubai',            NULL,         'AED 240,000',     '1',       '06/20/2026 21:00'),
('Partner',   'C009',     'John O''Connor',        'john.oconnor@example.com',     '0044 7700 900123',      '05/08/1988',             '08-05-2026 13:05',          'Man',     'UK',             'London',           'SW1A 1AA',   '£72,000',         'Enabled', '2026-06-14'),
('ERP',       'C010',     '  Sneha Patil  ',       'sneha.patil@example.com',      '98765abc210',           '1996-02-28',             '2026-05-10',                'Woman',   'Bharat',         'MH',               '400001',     '-50000',          'No',      '2026-06-15 08:30:00'),
('ERP',       'C011',     'Arjun Reddy',           'arjun.reddy@example.com',      '9999999999',            '2009-01-01',             '2025-12-31 23:59:59',       'M',       'India',          'Telengana',        '500081',     '999999999999',    '1',       '2026-06-15'),
('ERP',       'C012',     'Meera Iyer',            'meera.iyer@example.com',       '8888888888',            '1890-01-01',             '2026-06-31',                'F',       'India',          'Tamilnadu',         '600001',     'NULL',            'N',       '2026-06-16'),
('CRM',       NULL,       'Unknown Customer',      NULL,                            NULL,                    NULL,                     NULL,                        NULL,      NULL,             NULL,               NULL,         NULL,              NULL,      NULL),
('CRM',       'C013',     'Test User 123',         'test.user@example.com',        '12345',                 '01-01-2050',             '2026-07-01 12:00:00',       'Other',   'India',          'Goa',              '403001',     '0',               'Inactive','2026-07-01 12:00:00'),
('CRM',       'C014',     'Ravi Kumar' + CHAR(9),  CHAR(32) + 'ravi@example.com',  CHAR(160)+'9876540000',  '1991-10-10 00:00:00',    '2026-07-02T15:30:00+05:30', 'm',       ' india ',        ' Uttar Pradesh ',  '226001 ',    '1.2e6',           'T',       '2026-07-02T15:30:00+05:30');
GO

CREATE TABLE dirty_lab.raw_products
(
    product_id          VARCHAR(50),
    sku_raw             VARCHAR(100),
    product_name        VARCHAR(200),
    category_raw        VARCHAR(100),
    unit_price_raw      VARCHAR(100),
    cost_price_raw      VARCHAR(100),
    stock_quantity_raw  VARCHAR(100),
    weight_raw          VARCHAR(100),
    launch_date_raw     VARCHAR(100),
    discontinued_raw    VARCHAR(30),
    supplier_id_raw     VARCHAR(50)
);
GO

INSERT INTO dirty_lab.raw_products VALUES
('P001', 'SKU-1001',  'Wireless Mouse',          'Electronics',        '799.00',       '450',         '120',       '150 g',       '2025-01-15',       '0',       'S001'),
('p001', ' sku-1001 ','WIRELESS MOUSE ',         'electronics ',       '₹799',         '450.00',      '120 units', '0.15kg',      '15/01/2025',       'No',      's001'),
('P002', 'SKU1002',   'Mechanical Keyboard',     'Electronic',         '3,499.99',     '2100',        '45',        '1.2 KG',      '2025/02/28',       'FALSE',   'S002'),
('P003', 'SKU-1003',  'USB-C Cable',             'Accessories',        '499',          '125',         '-5',        '80grams',     '31-11-2025',       'N',       'S001'),
('P004', 'SKU-1004',  'Laptop Stand',            'accessory',          '1.299,00',     '850',         'NULL',      '1,500 g',     'Nov 05, 2025',     '0',       'S003'),
('P005', 'SKU-1005',  'Office Chair',            'Furniture',          '12500',        '9000',        '15.5',      '18kg',        '2026-01-01',       'No',      'S004'),
('P006', 'SKU-1006',  'Standing Desk',           'FURNITURE ',         '$399.99',      '$250',        '8',         '35 kg',       '01/15/2026',       'false',   'S004'),
('P007', 'SKU-1007',  'Monitor 27"',             'Electronics',        '18999',        '15000',       'twenty',    '5.6kg',       '2026-02-29',       '0',       'S002'),
('P008', 'SKU-1008',  'Noise Cancelling Headset','Audio',              '8999.5',       '6000',        '0',         '280g',        '2026-03-10T00:00Z','Yes',     'S005'),
('P009', 'SKU-1009',  'Webcam',                  'Electronics',        '',             '1800',        '60',        NULL,          '',                 'N',       'S999'),
('P010', 'SKU-1010',  'Notebook',                'Stationery',         '₹99',          '40',          '1000',      '200 g',       '10-04-26',          'No',      'S006'),
('P011', 'SKU-1011',  'Pen Pack',                'stationary',         '50.00',        '65.00',       '500',       '0.05 kg',     '2026-04-11',       '0',       'S006'),
(NULL,   'SKU-NULL',  'Missing Product ID',      'Other',              '100',          '50',          '10',        '1kg',         '2026-05-01',       '0',       'S007');
GO

CREATE TABLE dirty_lab.raw_orders
(
    order_id                VARCHAR(50),
    customer_id_raw         VARCHAR(50),
    product_id_raw          VARCHAR(50),
    order_datetime_raw      VARCHAR(100),
    promised_delivery_raw   VARCHAR(100),
    actual_delivery_raw     VARCHAR(100),
    quantity_raw            VARCHAR(50),
    unit_price_raw          VARCHAR(100),
    discount_raw            VARCHAR(100),
    tax_raw                 VARCHAR(100),
    shipping_amount_raw     VARCHAR(100),
    order_status_raw        VARCHAR(100),
    shipping_city_raw       VARCHAR(100),
    shipping_country_raw    VARCHAR(100),
    sales_channel_raw       VARCHAR(100),
    sales_rep_raw           VARCHAR(100)
);
GO

INSERT INTO dirty_lab.raw_orders VALUES
('O1001', 'C001',   'P001', '2026-06-01 09:15:10',       '2026-06-05',          '2026-06-04 17:20',       '2',      '799',       '10%',        '18%',       '0',          'Delivered',          'Hyderabad',      'India',          'Web',         'SR01'),
('O1001', ' c001 ', 'p001', '01/06/2026 09:15 AM',       '05-Jun-2026',         '04/06/2026 5:20 PM',     '2 units','₹799.00',    '0.10',       '0.18',      'FREE',       'delivered ',         'hyderabad ',     'INDIA',          'website',     'sr01'),
('O1002', 'C002',   'P002', 'Jun 02 2026 11:45PM',       '2026/06/07',          '08-06-2026',             '1',      '3499.99',   '₹200',       '630',       '99',         'Delivered Late',     'New Delhi',      'IN',             'Mobile App',  'SR02'),
('O1003', 'C003',   'P003', '2026-06-03T14:30:00Z',      '2026-06-06T18:00Z',   NULL,                     'three',  '499',       '5 %',        '18 %',      '50.00',      'Shipped',            'Bengaluru',      'India',          'App',         'SR03'),
('O1004', 'C004',   'P004', '03-06-2026 04:45 PM',       '07-06-2026',          '06-06-2026',             '-1',     '1299',      '0',          '233.82',    '0',          'Return Completed',   'Kochi',          'IND',            'WEB',         'SR01'),
('O1005', 'C005',   'P999', '2026/06/04 08:00',          '2026/06/10',          '',                       '1',      '9999',      'NULL',       '18%',       '100',        'Processing',         'San Francisco',  'USA',            'Partner',     ''),
('O1006', 'C006',   'P006', '06/05/2026 12:00:00',      '06/15/2026',          '06/14/2026',             '1',      '$399.99',   '$40',        '$32.40',    '$25',        'complete',           'São Paulo',      'Brazil',         'Marketplace', 'SR04'),
('O1007', 'C007',   'P007', '20260606130530',            '20260610',             '20260611120000',         '2',      '18,999',    '5',          '6840',      '500',        'Delivered',          'Beijing',        'China',          'Web',         'SR05'),
('O1008', '0008',   'P008', '07-Jun-26 7:30 PM',         '12-Jun-26',            '11-Jun-26 23:10',        '1',      '8999.50',   '15 percent', '1376.92',   '0',          'DELIVERED',          'Dubai',          'UAE',            'web ',        'SR06'),
('O1009', 'C009',   'P009', '2026-06-08 25:10:00',       '2026-06-15',          NULL,                     '1',      '',          '0',          '0',         '0',          'Cancelled',          'London',         'UK',             'Call Center', 'SR07'),
('O1010', 'C010',   'P010', '08/06/26',                  '09/06/26',             '08/06/26',               '10',     '99',        '10',         '160.38',    '49',         'delivered',          'Mumbai',         'Bharat',         'Retail',      'SR08'),
('O1011', 'C011',   'P011', '2026.06.09 10:10:10',       '2026.06.12',           '2026.06.12',             '100',    '50',        '-20',        '900',       '0',          'Delivered',          'Hyderabad',      'India',          'B2B',         'SR02'),
('O1012', 'C012',   'P005', '09-06-2026',                '08-06-2026',           '07-06-2026',             '0',      '12500',     '0',          '2250',      '500',        'Delivered',          'Chennai',        'India',          'Web',         'SR09'),
('O1013', 'C013',   'P001', '2050-01-01 00:00:00',       '2050-01-02',           NULL,                     '1',      '799',       '0',          '143.82',    '0',          'Pending',            'Goa',            'India',          'Web',         'SR01'),
('O1014', NULL,     'P002', NULL,                        NULL,                   NULL,                     NULL,     NULL,        NULL,         NULL,        NULL,         NULL,                 NULL,             NULL,             NULL,          NULL),
('O1015', 'C014',   'P002', '2026-07-02T15:30:00+05:30', '2026-07-07T18:00:00', '2026-07-07T20:00:00+05:30','01',   '3.499,99',  '7.5%',        '18%',       '₹150',       'Delivered',          CHAR(9)+'Lucknow',' india ',        'Online',      'SR10'),
('O1016', 'C404',   'P001', '2026-07-03',                '2026-07-05',           NULL,                     '1',      '799',       '0',          '143.82',    '0',          'Pending',            'Pune',           'India',          'Web',         'SR01');
GO

CREATE TABLE dirty_lab.raw_payments
(
    payment_id             VARCHAR(50),
    order_id_raw           VARCHAR(50),
    payment_datetime_raw   VARCHAR(100),
    payment_method_raw     VARCHAR(100),
    amount_raw             VARCHAR(100),
    currency_raw           VARCHAR(30),
    payment_status_raw     VARCHAR(100),
    transaction_reference  VARCHAR(150),
    refund_amount_raw      VARCHAR(100),
    gateway_fee_raw        VARCHAR(100)
);
GO

INSERT INTO dirty_lab.raw_payments VALUES
('PAY001', 'O1001',  '2026-06-01 09:16:00',      'Credit Card', '1885.64',     'INR', 'Success',    'TXN-ABC-001',       '0',       '35.40'),
('pay001', ' o1001 ','01/06/2026 09:16 AM',      'creditcard ', '₹1,885.64',   'Rs',  'SUCCESS ',   'txn-abc-001 ',      '0.00',    '1.8%'),
('PAY002', 'O1002',  '06-03-2026 00:05',         'UPI',         '4029.99',     'INR', 'Completed',  'UPI/2026/0002',     NULL,      '0'),
('PAY003', 'O1003',  '2026-06-03T14:31:10Z',     'Debit Card',  '1577.82',     'INR', 'Pending',    'DC-0003',            '',        '25'),
('PAY004', 'O1004',  '03/06/2026 16:46',         'COD',         '-1065.18',    'INR', 'Refunded',   'COD-0004',           '1065.18', '0'),
('PAY005', 'O1005',  'not paid',                 'PayPal',      '0',           'USD', 'Failed',     'PP-0005',            '0',       '0'),
('PAY006', 'O1006',  '06/05/2026 12:01 PM',      'paypal',      '$416.39',     'usd', 'success',    'PP-0006',            '$0',      '$12.49'),
('PAY007', 'O1007',  '20260606130615',           'WeChat Pay',  '43338',       'CNY', 'PAID',       'WX-0007',            '0',       '65'),
('PAY008', 'O1008',  '07-Jun-26 19:31',          'Card',        '9028.42',     'AED', 'Captured',   'AE-0008',            '0',       '162.51'),
('PAY009', 'O1009',  '',                         '',            '',            '',    '',           '',                   '',        ''),
('PAY010', 'O1010',  '2026-06-08',               'Cash',        '1189.38',     'INR', 'Success',    'CASH 1010',          '0',       '0'),
('PAY011', 'O1011',  '2026.06.09 10:11:00',      'Bank Transfer','5880',       'INR', 'Completed',  'BT-1011',            '-100',    '15'),
('PAY012', 'O1012',  '09-06-2026',               'UPI',         '15250',       'INR', 'SUCCESS',    'UPI-1012',           '0',       '0'),
('PAY013', 'O1013',  '2050-01-01 00:01:00',      'Card',        '942.82',      'INR', 'Success',    'FUTURE-1013',        '0',       '20'),
('PAY014', 'O4040',  '2026-06-10',               'UPI',         '500',         'INR', 'Success',    'ORPHAN-PAYMENT',     '0',       '0'),
('PAY015', 'O1015',  '2026-07-02T15:31:00+05:30','UPI ',        '4,228.99',    '₹',   'successful', ' UPI-1015 ',         '0',       '0'),
('PAY016', 'O1001',  '2026-06-01 09:17:00',      'Credit Card', '1885.64',     'INR', 'Success',    'TXN-ABC-001-DUP',   '0',       '35.40');
GO

/*
===============================================================================
PRACTICE TASKS
===============================================================================

LEVEL 1: PROFILING
1. Count rows, nulls, blanks, and distinct values for every important column.
2. Find values containing leading/trailing spaces, tabs, and non-breaking spaces.
3. Identify duplicate customer, product, order, and payment records.
4. Find IDs that differ only by case or whitespace.
5. Profile all raw date patterns before converting them.

LEVEL 2: STANDARDIZATION
6. Standardize IDs to uppercase and remove surrounding whitespace.
7. Standardize names while preserving accents and apostrophes.
8. Normalize email addresses and identify invalid emails.
9. Normalize phone numbers into digits-only or E.164-like format.
10. Standardize country and state names.
11. Standardize gender and active-status values.
12. Convert income, prices, tax, discount, shipping, refund, and fees to decimals.
13. Convert weights into kilograms.
14. Convert stock and quantity into integers.

LEVEL 3: DATETIME CLEANING
15. Convert all valid date-of-birth values to DATE.
16. Convert all valid signup, order, payment, and delivery timestamps.
17. Handle ISO 8601 timestamps with UTC or timezone offsets.
18. Detect ambiguous DD/MM/YYYY versus MM/DD/YYYY values.
19. Flag impossible dates, future birth dates, future orders, and invalid leap days.
20. Calculate customer age safely.
21. Calculate promised-versus-actual delivery delay.
22. Identify deliveries occurring before order dates.
23. Identify payments occurring before orders.

LEVEL 4: BUSINESS-RULE VALIDATION
24. Find negative, zero, fractional, or nonnumeric quantities.
25. Find products where cost exceeds selling price.
26. Find invalid or negative stock values.
27. Identify orders referencing missing customers or products.
28. Identify payments referencing missing orders.
29. Recalculate gross amount:
       quantity * unit_price
30. Recalculate discount, tax, shipping, and expected final order amount.
31. Compare expected order amount with payment amount.
32. Detect possible duplicate payments.
33. Validate refund amount against payment amount and status.
34. Detect inconsistent currencies.

LEVEL 5: DEDUPLICATION AND SURVIVORSHIP
35. Build a canonical customer key.
36. Rank duplicate records using ROW_NUMBER.
37. Keep the most complete and most recently updated customer record.
38. Merge useful non-null fields from duplicate records.
39. Deduplicate products, orders, and payments.
40. Document why each discarded row was removed.

LEVEL 6: FINAL MODEL
41. Create clean_customer, clean_product, clean_order, and clean_payment tables.
42. Add proper data types, primary keys, foreign keys, and CHECK constraints.
43. Create a rejected_records table with rejection reasons.
44. Create a data_quality_issue table with severity and issue category.
45. Produce a before-versus-after quality scorecard.
46. Make the cleaning process idempotent.
47. Wrap loading logic in a transaction with error handling.
48. Create views for valid records and quarantined records.

BONUS CHALLENGES
49. Write the solution without using FORMAT().
50. Use TRY_CONVERT instead of allowing the query to fail.
51. Build reusable parsing logic with CROSS APPLY.
52. Use STRING_AGG to combine multiple quality issues per row.
53. Generate a SHA2_256 hash to detect unchanged records.
54. Create an incremental MERGE or safer UPDATE/INSERT pattern.
55. Create a stored procedure that reloads the clean layer.
*/

SELECT 'raw_customers' AS table_name, COUNT(*) AS row_count
FROM dirty_lab.raw_customers
UNION ALL
SELECT 'raw_products', COUNT(*) FROM dirty_lab.raw_products
UNION ALL
SELECT 'raw_orders', COUNT(*) FROM dirty_lab.raw_orders
UNION ALL
SELECT 'raw_payments', COUNT(*) FROM dirty_lab.raw_payments;
GO