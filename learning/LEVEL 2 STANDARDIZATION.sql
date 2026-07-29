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

SELECT 
case when lower(gender_raw) ='male' or  lower(gender_raw) ='man' or  lower(gender_raw) ='m' then 'm'
when lower(gender_raw) ='female' or  lower(gender_raw) ='woman' or lower(gender_raw) ='f'  then 'f' end as Gender_clean,gender_raw,

* FROM dirty_lab.raw_inventory_sales

--12. Convert income, prices, tax, discount, shipping, refund, and fees to decimals.
--13. Convert weights into kilograms.
--14. Convert stock and quantity into integers.

SELECT 
case when lower(gender_raw) ='male' or  lower(gender_raw) ='man' or  lower(gender_raw) ='m' then 'm'
when lower(gender_raw) ='female' or  lower(gender_raw) ='woman' or lower(gender_raw) ='f'  then 'f' end as Gender_clean,gender_raw,

* FROM dirty_lab.raw_inventory_sales
/*==============================================================
  Q12. Convert income, prices, tax, discount, shipping,
       refund and gateway fees to decimal values.

  Q13. Convert weights into kilograms.

  Q14. Convert stock and order quantities into integers.
==============================================================*/

WITH cleaned_text AS
(
    SELECT
        r.*,

        /*------------------------------------------------------
          Remove leading/trailing spaces, tabs and NBSP.
        ------------------------------------------------------*/
        NULLIF(
            LTRIM(RTRIM(
                REPLACE(
                    REPLACE(annual_income_raw, CHAR(160), ''),
                    CHAR(9), ''
                )
            )),
            ''
        ) AS income_text,

        NULLIF(
            LTRIM(RTRIM(
                REPLACE(
                    REPLACE(unit_price_raw, CHAR(160), ''),
                    CHAR(9), ''
                )
            )),
            ''
        ) AS price_text,

        NULLIF(
            LTRIM(RTRIM(
                REPLACE(
                    REPLACE(tax_raw, CHAR(160), ''),
                    CHAR(9), ''
                )
            )),
            ''
        ) AS tax_text,

        NULLIF(
            LTRIM(RTRIM(
                REPLACE(
                    REPLACE(discount_raw, CHAR(160), ''),
                    CHAR(9), ''
                )
            )),
            ''
        ) AS discount_text,

        NULLIF(
            LTRIM(RTRIM(
                REPLACE(
                    REPLACE(shipping_amount_raw, CHAR(160), ''),
                    CHAR(9), ''
                )
            )),
            ''
        ) AS shipping_text,

        NULLIF(
            LTRIM(RTRIM(
                REPLACE(
                    REPLACE(refund_amount_raw, CHAR(160), ''),
                    CHAR(9), ''
                )
            )),
            ''
        ) AS refund_text,

        NULLIF(
            LTRIM(RTRIM(
                REPLACE(
                    REPLACE(gateway_fee_raw, CHAR(160), ''),
                    CHAR(9), ''
                )
            )),
            ''
        ) AS fee_text,

        NULLIF(
            LOWER(
                LTRIM(RTRIM(
                    REPLACE(
                        REPLACE(weight_raw, CHAR(160), ''),
                        CHAR(9), ''
                    )
                ))
            ),
            ''
        ) AS weight_text,

        NULLIF(
            LOWER(
                LTRIM(RTRIM(
                    REPLACE(
                        REPLACE(stock_quantity_raw, CHAR(160), ''),
                        CHAR(9), ''
                    )
                ))
            ),
            ''
        ) AS stock_text,

        NULLIF(
            LOWER(
                LTRIM(RTRIM(
                    REPLACE(
                        REPLACE(order_quantity_raw, CHAR(160), ''),
                        CHAR(9), ''
                    )
                ))
            ),
            ''
        ) AS order_quantity_text

    FROM dirty_lab.raw_inventory_sales AS r
),

/*==============================================================
  Remove currency codes, currency symbols and descriptive words.
==============================================================*/
removed_symbols AS
(
    SELECT
        c.*,

        /* Annual income */
        UPPER(
            REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(
            REPLACE(REPLACE(REPLACE(REPLACE(
                income_text,
                '₹', ''),
                '$', ''),
                '£', ''),
                'R$', ''),
                'BRL', ''),
                'AED', ''),
                'CNY', ''),
                'INR', ''),
                'USD', ''),
                'GBP', ''),
                ' ', '')
        ) AS income_numeric_text,

        /* Unit price */
        UPPER(
            REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(
            REPLACE(REPLACE(REPLACE(REPLACE(
                price_text,
                '₹', ''),
                '$', ''),
                '£', ''),
                'R$', ''),
                'BRL', ''),
                'AED', ''),
                'CNY', ''),
                'INR', ''),
                'USD', ''),
                'GBP', ''),
                ' ', '')
        ) AS price_numeric_text,

        /* Tax */
        LOWER(
            REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(
            REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(
                tax_text,
                '₹', ''),
                '$', ''),
                '£', ''),
                'r$', ''),
                'brl', ''),
                'aed', ''),
                'cny', ''),
                'inr', ''),
                'usd', ''),
                'gbp', ''),
                'percent', '%'),
                ' ', '')
        ) AS tax_numeric_text,

        /* Discount */
        LOWER(
            REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(
            REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(
                discount_text,
                '₹', ''),
                '$', ''),
                '£', ''),
                'r$', ''),
                'brl', ''),
                'aed', ''),
                'cny', ''),
                'inr', ''),
                'usd', ''),
                'gbp', ''),
                'percent', '%'),
                ' ', '')
        ) AS discount_numeric_text,

        /* Shipping */
        LOWER(
            REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(
            REPLACE(REPLACE(REPLACE(REPLACE(
                shipping_text,
                '₹', ''),
                '$', ''),
                '£', ''),
                'r$', ''),
                'brl', ''),
                'aed', ''),
                'cny', ''),
                'inr', ''),
                'usd', ''),
                'gbp', ''),
                ' ', '')
        ) AS shipping_numeric_text,

        /* Refund */
        LOWER(
            REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(
            REPLACE(REPLACE(REPLACE(REPLACE(
                refund_text,
                '₹', ''),
                '$', ''),
                '£', ''),
                'r$', ''),
                'brl', ''),
                'aed', ''),
                'cny', ''),
                'inr', ''),
                'usd', ''),
                'gbp', ''),
                ' ', '')
        ) AS refund_numeric_text,

        /* Gateway fee */
        LOWER(
            REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(
            REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(
                fee_text,
                '₹', ''),
                '$', ''),
                '£', ''),
                'r$', ''),
                'brl', ''),
                'aed', ''),
                'cny', ''),
                'inr', ''),
                'usd', ''),
                'gbp', ''),
                'percent', '%'),
                ' ', '')
        ) AS fee_numeric_text

    FROM cleaned_text AS c
),

/*==============================================================
  Normalize commas and periods.

  Examples:
    12,00,000  -> 1200000
    1,299.99   -> 1299.99
    1.299,99   -> 1299.99
    72.000,50  -> 72000.50
    233,99     -> 233.99
==============================================================*/
normalized_numbers AS
(
    SELECT
        s.*,

        /* Annual income */
        CASE
            WHEN income_numeric_text IS NULL THEN NULL

            /* European: 72.000,50 */
            WHEN CHARINDEX(',', income_numeric_text) > 0
             AND CHARINDEX('.', income_numeric_text) > 0
             AND CHARINDEX(',', REVERSE(income_numeric_text))
                 < CHARINDEX('.', REVERSE(income_numeric_text))
            THEN REPLACE(
                     REPLACE(income_numeric_text, '.', ''),
                     ',', '.'
                 )

            /* Single decimal comma: 233,99 */
            WHEN LEN(income_numeric_text)
                 - LEN(REPLACE(income_numeric_text, ',', '')) = 1
             AND LEN(income_numeric_text)
                 - CHARINDEX(',', income_numeric_text) IN (1, 2)
             AND CHARINDEX('.', income_numeric_text) = 0
            THEN REPLACE(income_numeric_text, ',', '.')

            /* Indian or US thousands separators */
            ELSE REPLACE(income_numeric_text, ',', '')
        END AS income_normalized,

        /* Unit price */
        CASE
            WHEN price_numeric_text IS NULL THEN NULL

            WHEN CHARINDEX(',', price_numeric_text) > 0
             AND CHARINDEX('.', price_numeric_text) > 0
             AND CHARINDEX(',', REVERSE(price_numeric_text))
                 < CHARINDEX('.', REVERSE(price_numeric_text))
            THEN REPLACE(
                     REPLACE(price_numeric_text, '.', ''),
                     ',', '.'
                 )

            WHEN LEN(price_numeric_text)
                 - LEN(REPLACE(price_numeric_text, ',', '')) = 1
             AND LEN(price_numeric_text)
                 - CHARINDEX(',', price_numeric_text) IN (1, 2)
             AND CHARINDEX('.', price_numeric_text) = 0
            THEN REPLACE(price_numeric_text, ',', '.')

            ELSE REPLACE(price_numeric_text, ',', '')
        END AS price_normalized,

        /* Tax */
        CASE
            WHEN tax_numeric_text IS NULL THEN NULL

            WHEN CHARINDEX(',', tax_numeric_text) > 0
             AND CHARINDEX('.', tax_numeric_text) > 0
             AND CHARINDEX(',', REVERSE(tax_numeric_text))
                 < CHARINDEX('.', REVERSE(tax_numeric_text))
            THEN REPLACE(
                     REPLACE(tax_numeric_text, '.', ''),
                     ',', '.'
                 )

            WHEN LEN(REPLACE(tax_numeric_text, '%', ''))
                 - LEN(REPLACE(REPLACE(tax_numeric_text, '%', ''), ',', '')) = 1
             AND LEN(REPLACE(tax_numeric_text, '%', ''))
                 - CHARINDEX(',', REPLACE(tax_numeric_text, '%', '')) IN (1, 2)
             AND CHARINDEX('.', tax_numeric_text) = 0
            THEN REPLACE(tax_numeric_text, ',', '.')

            ELSE REPLACE(tax_numeric_text, ',', '')
        END AS tax_normalized,

        /* Discount */
        CASE
            WHEN discount_numeric_text IS NULL THEN NULL

            WHEN CHARINDEX(',', discount_numeric_text) > 0
             AND CHARINDEX('.', discount_numeric_text) > 0
             AND CHARINDEX(',', REVERSE(discount_numeric_text))
                 < CHARINDEX('.', REVERSE(discount_numeric_text))
            THEN REPLACE(
                     REPLACE(discount_numeric_text, '.', ''),
                     ',', '.'
                 )

            WHEN LEN(REPLACE(discount_numeric_text, '%', ''))
                 - LEN(REPLACE(REPLACE(discount_numeric_text, '%', ''), ',', '')) = 1
             AND LEN(REPLACE(discount_numeric_text, '%', ''))
                 - CHARINDEX(',', REPLACE(discount_numeric_text, '%', '')) IN (1, 2)
             AND CHARINDEX('.', discount_numeric_text) = 0
            THEN REPLACE(discount_numeric_text, ',', '.')

            ELSE REPLACE(discount_numeric_text, ',', '')
        END AS discount_normalized,

        /* Shipping */
        CASE
            WHEN shipping_numeric_text IS NULL THEN NULL

            WHEN CHARINDEX(',', shipping_numeric_text) > 0
             AND CHARINDEX('.', shipping_numeric_text) > 0
             AND CHARINDEX(',', REVERSE(shipping_numeric_text))
                 < CHARINDEX('.', REVERSE(shipping_numeric_text))
            THEN REPLACE(
                     REPLACE(shipping_numeric_text, '.', ''),
                     ',', '.'
                 )

            WHEN LEN(shipping_numeric_text)
                 - LEN(REPLACE(shipping_numeric_text, ',', '')) = 1
             AND LEN(shipping_numeric_text)
                 - CHARINDEX(',', shipping_numeric_text) IN (1, 2)
             AND CHARINDEX('.', shipping_numeric_text) = 0
            THEN REPLACE(shipping_numeric_text, ',', '.')

            ELSE REPLACE(shipping_numeric_text, ',', '')
        END AS shipping_normalized,

        /* Refund */
        CASE
            WHEN refund_numeric_text IS NULL THEN NULL

            WHEN CHARINDEX(',', refund_numeric_text) > 0
             AND CHARINDEX('.', refund_numeric_text) > 0
             AND CHARINDEX(',', REVERSE(refund_numeric_text))
                 < CHARINDEX('.', REVERSE(refund_numeric_text))
            THEN REPLACE(
                     REPLACE(refund_numeric_text, '.', ''),
                     ',', '.'
                 )

            WHEN LEN(refund_numeric_text)
                 - LEN(REPLACE(refund_numeric_text, ',', '')) = 1
             AND LEN(refund_numeric_text)
                 - CHARINDEX(',', refund_numeric_text) IN (1, 2)
             AND CHARINDEX('.', refund_numeric_text) = 0
            THEN REPLACE(refund_numeric_text, ',', '.')

            ELSE REPLACE(refund_numeric_text, ',', '')
        END AS refund_normalized,

        /* Gateway fee */
        CASE
            WHEN fee_numeric_text IS NULL THEN NULL

            WHEN CHARINDEX(',', fee_numeric_text) > 0
             AND CHARINDEX('.', fee_numeric_text) > 0
             AND CHARINDEX(',', REVERSE(fee_numeric_text))
                 < CHARINDEX('.', REVERSE(fee_numeric_text))
            THEN REPLACE(
                     REPLACE(fee_numeric_text, '.', ''),
                     ',', '.'
                 )

            WHEN LEN(REPLACE(fee_numeric_text, '%', ''))
                 - LEN(REPLACE(REPLACE(fee_numeric_text, '%', ''), ',', '')) = 1
             AND LEN(REPLACE(fee_numeric_text, '%', ''))
                 - CHARINDEX(',', REPLACE(fee_numeric_text, '%', '')) IN (1, 2)
             AND CHARINDEX('.', fee_numeric_text) = 0
            THEN REPLACE(fee_numeric_text, ',', '.')

            ELSE REPLACE(fee_numeric_text, ',', '')
        END AS fee_normalized

    FROM removed_symbols AS s
),

converted_values AS
(
    SELECT
        n.*,

        /*------------------------------------------------------
          Income:
          8.5L means 8.5 lakh = 850,000.
          TRY_CONVERT also understands scientific notation when
          converting through FLOAT, such as 1.2e6.
        ------------------------------------------------------*/
        CASE
            WHEN LOWER(income_normalized) IN
                 ('null', 'none', 'unknown', 'notavailable', 'na', 'n/a')
            THEN NULL

            WHEN RIGHT(UPPER(income_normalized), 1) = 'L'
            THEN
                TRY_CONVERT(
                    DECIMAL(19,2),
                    TRY_CONVERT(
                        DECIMAL(19,4),
                        LEFT(
                            income_normalized,
                            LEN(income_normalized) - 1
                        )
                    ) * 100000
                )

            ELSE
                TRY_CONVERT(
                    DECIMAL(19,2),
                    TRY_CONVERT(FLOAT, income_normalized)
                )
        END AS annual_income_clean,

        TRY_CONVERT(
            DECIMAL(19,2),
            TRY_CONVERT(FLOAT, price_normalized)
        ) AS unit_price_clean,

        /* A percent sign means convert 18% to 0.18. */
        CASE
            WHEN tax_normalized LIKE '%[%]'
            THEN
                TRY_CONVERT(
                    DECIMAL(19,6),
                    REPLACE(tax_normalized, '%', '')
                ) / 100.0

            ELSE
                TRY_CONVERT(
                    DECIMAL(19,6),
                    tax_normalized
                )
        END AS tax_clean,

        CASE
            WHEN discount_normalized LIKE '%[%]'
            THEN
                TRY_CONVERT(
                    DECIMAL(19,6),
                    REPLACE(discount_normalized, '%', '')
                ) / 100.0

            ELSE
                TRY_CONVERT(
                    DECIMAL(19,6),
                    discount_normalized
                )
        END AS discount_clean,

        CASE
            WHEN shipping_normalized IN
                 ('free', 'null', 'none', 'unknown')
            THEN
                CASE
                    WHEN shipping_normalized = 'free' THEN 0.00
                    ELSE NULL
                END

            ELSE
                TRY_CONVERT(
                    DECIMAL(19,2),
                    shipping_normalized
                )
        END AS shipping_amount_clean,

        CASE
            WHEN refund_normalized IN
                 ('null', 'none', 'unknown')
            THEN NULL

            ELSE
                TRY_CONVERT(
                    DECIMAL(19,2),
                    refund_normalized
                )
        END AS refund_amount_clean,

        CASE
            WHEN fee_normalized LIKE '%[%]'
            THEN
                TRY_CONVERT(
                    DECIMAL(19,6),
                    REPLACE(fee_normalized, '%', '')
                ) / 100.0

            WHEN fee_normalized IN
                 ('null', 'none', 'unknown')
            THEN NULL

            ELSE
                TRY_CONVERT(
                    DECIMAL(19,6),
                    fee_normalized
                )
        END AS gateway_fee_clean

    FROM normalized_numbers AS n
),

weight_and_quantity AS
(
    SELECT
        v.*,

        /*------------------------------------------------------
          Q13: Convert weights to kilograms.
        ------------------------------------------------------*/
        CASE
            WHEN weight_text IS NULL
              OR weight_text IN
                 ('null', 'none', 'unknown', 'not available')
            THEN NULL

            /* Convert grams to kilograms. */
            WHEN weight_text LIKE '%gram%'
              OR (
                    weight_text LIKE '%g'
                    AND weight_text NOT LIKE '%kg'
                 )
            THEN
                TRY_CONVERT(
                    DECIMAL(18,4),
                    REPLACE(
                        REPLACE(
                            REPLACE(
                                REPLACE(weight_text, 'grams', ''),
                                'gram', ''
                            ),
                            'g', ''
                        ),
                        ',', '.'
                    )
                ) / 1000.0

            /* Value already expressed in kilograms. */
            WHEN weight_text LIKE '%kg%'
            THEN
                TRY_CONVERT(
                    DECIMAL(18,4),
                    REPLACE(
                        REPLACE(weight_text, 'kg', ''),
                        ',', '.'
                    )
                )

            ELSE NULL
        END AS weight_kg_clean,

        /*------------------------------------------------------
          Convert number words before trying numeric conversion.
        ------------------------------------------------------*/
        CASE stock_text
            WHEN 'zero'         THEN 0
            WHEN 'one'          THEN 1
            WHEN 'two'          THEN 2
            WHEN 'three'        THEN 3
            WHEN 'four'         THEN 4
            WHEN 'five'         THEN 5
            WHEN 'six'          THEN 6
            WHEN 'seven'        THEN 7
            WHEN 'eight'        THEN 8
            WHEN 'nine'         THEN 9
            WHEN 'ten'          THEN 10
            WHEN 'twenty'       THEN 20
            WHEN 'five hundred' THEN 500

            ELSE
                CASE
                    /*
                      Convert only whole numeric values.

                      30,0 -> 30
                      120 units -> 120
                      15.5 -> NULL because stock should be whole.
                    */
                    WHEN TRY_CONVERT(
                             DECIMAL(18,4),
                             REPLACE(
                                 REPLACE(stock_text, 'units', ''),
                                 ',', '.'
                             )
                         )
                         =
                         FLOOR(
                             TRY_CONVERT(
                                 DECIMAL(18,4),
                                 REPLACE(
                                     REPLACE(stock_text, 'units', ''),
                                     ',', '.'
                                 )
                             )
                         )
                    THEN
                        TRY_CONVERT(
                            INT,
                            TRY_CONVERT(
                                DECIMAL(18,4),
                                REPLACE(
                                    REPLACE(stock_text, 'units', ''),
                                    ',', '.'
                                )
                            )
                        )

                    ELSE NULL
                END
        END AS stock_quantity_clean,

        CASE order_quantity_text
            WHEN 'zero'         THEN 0
            WHEN 'one'          THEN 1
            WHEN 'two'          THEN 2
            WHEN 'three'        THEN 3
            WHEN 'four'         THEN 4
            WHEN 'five'         THEN 5
            WHEN 'six'          THEN 6
            WHEN 'seven'        THEN 7
            WHEN 'eight'        THEN 8
            WHEN 'nine'         THEN 9
            WHEN 'ten'          THEN 10
            WHEN 'twenty'       THEN 20
            WHEN 'five hundred' THEN 500

            ELSE
                CASE
                    WHEN TRY_CONVERT(
                             DECIMAL(18,4),
                             REPLACE(
                                 REPLACE(
                                     order_quantity_text,
                                     'units',
                                     ''
                                 ),
                                 ',',
                                 '.'
                             )
                         )
                         =
                         FLOOR(
                             TRY_CONVERT(
                                 DECIMAL(18,4),
                                 REPLACE(
                                     REPLACE(
                                         order_quantity_text,
                                         'units',
                                         ''
                                     ),
                                     ',',
                                     '.'
                                 )
                             )
                         )
                    THEN
                        TRY_CONVERT(
                            INT,
                            TRY_CONVERT(
                                DECIMAL(18,4),
                                REPLACE(
                                    REPLACE(
                                        order_quantity_text,
                                        'units',
                                        ''
                                    ),
                                    ',',
                                    '.'
                                )
                            )
                        )

                    ELSE NULL
                END
        END AS order_quantity_clean

    FROM converted_values AS v
)

SELECT
    transaction_id_raw,

    /* Q12 */
    annual_income_raw,
    annual_income_clean,

    unit_price_raw,
    unit_price_clean,

    tax_raw,
    tax_clean,

    discount_raw,
    discount_clean,

    shipping_amount_raw,
    shipping_amount_clean,

    refund_amount_raw,
    refund_amount_clean,

    gateway_fee_raw,
    gateway_fee_clean,

    /* Q13 */
    weight_raw,
    weight_kg_clean,

    /* Q14 */
    stock_quantity_raw,
    stock_quantity_clean,

    order_quantity_raw,
    order_quantity_clean

FROM weight_and_quantity
ORDER BY transaction_id_raw;