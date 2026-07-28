--LEVEL 2: STANDARDIZATION
--6. Standardize IDs to uppercase and remove surrounding whitespace.
--7. Standardize names while preserving accents and apostrophes.
--8. Normalize email addresses and identify invalid emails.
--9. Normalize phone numbers into digits-only or E.164-like format.
--10. Standardize country and state names.
--11. Standardize gender and active-status values.
--12. Convert income, prices, tax, discount, shipping, refund, and fees to decimals.
--13. Convert weights into kilograms.
--14. Convert stock and quantity into integers.


CREATE TABLE dirty_lab.raw_inventory_sales
(
    transaction_id_raw      VARCHAR(50),
    customer_id_raw         VARCHAR(50),
    product_id_raw          VARCHAR(50),

    customer_name_raw       VARCHAR(150),
    product_name_raw        VARCHAR(200),

    email_raw               VARCHAR(200),
    phone_raw               VARCHAR(100),

    country_raw             VARCHAR(100),
    state_raw               VARCHAR(100),

    gender_raw              VARCHAR(50),
    active_status_raw       VARCHAR(50),

    annual_income_raw       VARCHAR(100),
    unit_price_raw          VARCHAR(100),
    tax_raw                 VARCHAR(100),
    discount_raw            VARCHAR(100),
    shipping_amount_raw     VARCHAR(100),
    refund_amount_raw       VARCHAR(100),
    gateway_fee_raw         VARCHAR(100),

    weight_raw              VARCHAR(100),
    stock_quantity_raw      VARCHAR(100),
    order_quantity_raw      VARCHAR(100)
);
GO
INSERT INTO dirty_lab.raw_inventory_sales
(
    transaction_id_raw,
    customer_id_raw,
    product_id_raw,
    customer_name_raw,
    product_name_raw,
    email_raw,
    phone_raw,
    country_raw,
    state_raw,
    gender_raw,
    active_status_raw,
    annual_income_raw,
    unit_price_raw,
    tax_raw,
    discount_raw,
    shipping_amount_raw,
    refund_amount_raw,
    gateway_fee_raw,
    weight_raw,
    stock_quantity_raw,
    order_quantity_raw
)
VALUES

-- 1. Mostly clean row
(
    'TXN001',
    'C001',
    'P001',
    'Nilesh Kodag',
    'Wireless Mouse',
    'nilesh.kodag@gmail.com',
    '+91 84338 53793',
    'India',
    'Maharashtra',
    'Male',
    'Active',
    '1200000',
    '799.00',
    '143.82',
    '0',
    '50',
    '0',
    '15.50',
    '150 g',
    '120',
    '2'
),

-- 2. IDs with spaces and lowercase
(
    ' txn002 ',
    ' c002 ',
    ' p002 ',
    '  Aastika Sharma  ',
    'Mechanical Keyboard ',
    ' AASTIKA.SHARMA@GMAIL.COM ',
    '09876543211',
    ' india ',
    ' maharashtra ',
    'F',
    'YES',
    '12,00,000',
    '3,499.99',
    '18%',
    '10%',
    '₹100',
    '0.00',
    '1.8%',
    '1.2 KG',
    '45 units',
    '01'
),

-- 3. Accent in name and international number
(
    'Txn003',
    'c003',
    'p003',
    'José da Silva',
    'Café Grinder',
    'JOSE.SILVA@EXAMPLE.COM',
    '+55 (11) 99876-5432',
    'Brasil',
    'São Paulo',
    'male',
    'true',
    'BRL 180000',
    'R$ 499.90',
    'R$ 89.98',
    '5 percent',
    'R$ 25',
    'NULL',
    'R$ 12.50',
    '850 grams',
    'twenty',
    '3'
),

-- 4. Apostrophe in name and UK values
(
    ' TXN004',
    'C004 ',
    'P004',
    'John O''Connor',
    '27" Monitor',
    'john.oconnor@example.com',
    '0044 7700 900123',
    'United Kingdom',
    'London',
    'Man',
    'Enabled',
    '£72,000',
    '£299.99',
    '£60',
    '0.15',
    'FREE',
    '£25',
    '£4.99',
    '5.6kg',
    '18',
    '2 units'
),

-- 5. Invalid email and phone
(
    'txn005',
    'c005',
    'p005',
    'Priya Nair',
    'Laptop Stand',
    'priya.nair@@email.com',
    '98765abc210',
    'IND',
    'Kerala',
    'Woman',
    'Y',
    '₹1,050,000',
    '₹1,299',
    '18 %',
    '₹200',
    '₹0',
    '',
    '20',
    '1,500 g',
    '-5',
    'one'
),

-- 6. Missing email and phone
(
    'TXN006',
    'C006',
    'P006',
    'Fatima Al-Zahra',
    'Office Chair',
    NULL,
    NULL,
    'UAE',
    'Dubai',
    'FEMALE',
    '1',
    'AED 240,000',
    'AED 12500',
    'AED 625',
    '0',
    'AED 250',
    '0',
    'AED 75',
    '18 kg',
    '15.5',
    '1'
),

-- 7. Invalid email structure and India aliases
(
    'TXN007',
    'C007',
    'P007',
    'Arjun Reddy',
    'Standing Desk',
    'arjun.reddy@gmail',
    '91-9988776655',
    'Bharat',
    'Telengana',
    'M',
    'T',
    '8.5L',
    '$399.99',
    '$32.40',
    '$40',
    '$25',
    '$0',
    '$12.49',
    '35 KG',
    '8',
    '1'
),

-- 8. Extra internal spaces
(
    ' TXN008 ',
    ' c008 ',
    ' p008 ',
    'Priya    Nair',
    'Noise   Cancelling   Headset',
    ' priya.nair@example.com ',
    '(+91) 91234-56789',
    'INDIA',
    'Tamilnadu',
    'f',
    'ACTIVE',
    '950000.50',
    '8999.5',
    '1376.92',
    '15 percent',
    '0',
    '0',
    '162.51',
    '280g',
    '0',
    '1'
),

-- 9. Non-breaking space and tab characters
(
    CHAR(160) + 'TXN009' + CHAR(9),
    CHAR(9) + 'C009',
    'P009' + CHAR(160),
    CHAR(160) + 'Ravi Kumar' + CHAR(9),
    'USB-C' + CHAR(9) + 'Cable',
    CHAR(32) + 'ravi@example.com',
    CHAR(160) + '9876540000',
    ' india ',
    ' Uttar Pradesh ',
    'm',
    'Yes',
    '1.2e6',
    '499',
    '89.82',
    '5 %',
    '50.00',
    '0',
    '10',
    '80grams',
    '100',
    '10'
),

-- 10. Empty and NULL values
(
    'TXN010',
    NULL,
    'P010',
    '',
    'Notebook',
    '',
    '',
    NULL,
    NULL,
    NULL,
    NULL,
    NULL,
    '',
    NULL,
    '',
    NULL,
    '',
    NULL,
    NULL,
    NULL,
    NULL
),

-- 11. Invalid numeric values
(
    'TXN011',
    'C011',
    'P011',
    'Meera Iyer',
    'Pen Pack',
    'meera.iyer@example.com',
    '8888888888',
    'India',
    'Tamil Nadu',
    'Female',
    'No',
    'not available',
    'fifty',
    'eighteen percent',
    'ten',
    'FREE',
    'none',
    'unknown',
    '0.05 kg',
    'five hundred',
    'ten'
),

-- 12. Negative and logically invalid values
(
    'TXN012',
    'C012',
    'P012',
    'Sneha Patil',
    'Office Desk',
    'sneha.patil@example.com',
    '9876543210',
    'IN',
    'MH',
    'Woman',
    'N',
    '-50000',
    '-1200',
    '-216',
    '-10%',
    '-100',
    '-500',
    '-25',
    '-15kg',
    '-10',
    '-2'
),

-- 13. Unicode name and foreign formats
(
    'TXN013',
    'C013',
    'P013',
    '李 明',
    '无线鼠标',
    'li.ming@example.cn',
    '+86 138 0013 8000',
    'China',
    'Beijing',
    'M',
    'TRUE',
    'CNY 320000',
    'CNY 189',
    'CNY 34.02',
    '0',
    'CNY 20',
    'CNY 0',
    'CNY 2.50',
    '0.25kg',
    '250',
    '5'
),

-- 14. European decimal formatting
(
    'TXN014',
    'C014',
    'P014',
    'François D''Arcy',
    'Ergonomic Chair',
    'francois.darcy@example.fr',
    '+33 6 12 34 56 78',
    'France',
    'Île-de-France',
    'Homme',
    'Oui',
    '72.000,50',
    '1.299,99',
    '233,99',
    '10,5%',
    '49,99',
    '0,00',
    '15,25',
    '12,5 kg',
    '30,0',
    '2,0'
),

-- 15. Duplicate-style identifiers with inconsistent casing
(
    'txn001',
    ' c001 ',
    'p001',
    'NILESH KODAG',
    'WIRELESS MOUSE',
    'NILESH.KODAG@GMAIL.COM',
    '8433853793',
    'INDIA',
    'maharashtra',
    'MALE',
    '1',
    '₹12,00,000',
    '₹799',
    '18%',
    '0%',
    'FREE',
    '₹0',
    '₹15.50',
    '0.150 kg',
    '120 units',
    '02'
);
GO

SELECT * FROM 
INFORMATION_SCHEMA.TABLES
--LEVEL 2: STANDARDIZATION
--6. Standardize IDs to uppercase and remove surrounding whitespace.

SELECT replace(UPper(ltrim(RTRIM(transaction_id_raw))),char(160),'') as clearn_transaction_id_raw,* FROM dirty_lab.raw_inventory_sales;
SELECT replace(replace(UPper(ltrim(RTRIM(transaction_id_raw))),char(160),''),'TXN','TXN_') as clearn_transaction_id_raw,* FROM dirty_lab.raw_inventory_sales;


--7. Standardize names while preserving accents and apostrophes.
SELECT LEFT('SQL Tutorial', 3) AS ExtractString;

SELECT 
case when   CHARINDEX('?', customer_name_raw)>0 or CHARINDEX(null, customer_name_raw)>0
then Replace(CASE
    WHEN CHARINDEX('@', email_raw) > 0
        THEN LEFT(email_raw, CHARINDEX('@', email_raw) - 1)
    ELSE NULL      -- or email_raw, depending on your requirement
END,'.',' ') else  replace(UPper(ltrim(RTRIM(customer_name_raw))),char(160),'') end as clearn_customer_name_raw,* FROM dirty_lab.raw_inventory_sales;

--8. Normalize email addresses and identify invalid emails.
SELECT 
nullif(replace(replace(UPper(ltrim(RTRIM(email_raw))),char(160),''),CHAR(90),''),'') as clearn_email_raw,* FROM dirty_lab.raw_inventory_sales;



--9. Normalize phone numbers into digits-only or E.164-like format.
SELECT 
nullif(TRANSLATE(replace(replace(replace(UPper(ltrim(RTRIM(phone_raw))),char(160),''),CHAR(90),''),char(32),'') ,'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ',
REPLICATE(' ',52)),'') as clearn_phone_raw,
NULLIF(
    REPLACE(
    REPLACE(
    REPLACE(
    REPLACE(
    REPLACE(
    REPLACE(
    REPLACE(
        TRANSLATE(UPPER(LTRIM(RTRIM(phone_raw))),'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ',REPLICATE(' ',52)),
        CHAR(160),''),
        CHAR(9),''),
        ' ',''),
        '(',''),
        ')',''),
        '-',''),
        '+',''
),
'') AS clean_phone_raw2,* FROM dirty_lab.raw_inventory_sales;


--10. Standardize country and state names.
--11. Standardize gender and active-status values.
--12. Convert income, prices, tax, discount, shipping, refund, and fees to decimals.
--13. Convert weights into kilograms.
--14. Convert stock and quantity into integers.

SELECT * FROM dirty_lab.raw_inventory_sales
