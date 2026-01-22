CREATE DATABASE project;


SELECT * FROM [dbo].[FACT_InternetSales]
SELECT COUNT(*) FROM FACT_InternetSales

--DATATYPE CHECKING
SELECT 
    COLUMN_NAME,
    DATA_TYPE,
	CHARACTER_MAXIMUM_LENGTH,
    IS_NULLABLE
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'FACT_InternetSales'; 


--NULL VALUES CHECKING

SELECT 
    SUM(CASE WHEN ProductKey IS NULL THEN 1 ELSE 0 END) AS NullProductKey,
    SUM(CASE WHEN OrderDateKey IS NULL THEN 1 ELSE 0 END) AS NullOrderDateKey,
    SUM(CASE WHEN DueDateKey IS NULL THEN 1 ELSE 0 END) AS NullDueDateKey,
    SUM(CASE WHEN ShipDateKey IS NULL THEN 1 ELSE 0 END) AS NullShipDateKey,
    SUM(CASE WHEN CustomerKey IS NULL THEN 1 ELSE 0 END) AS NullCustomerKey,
    SUM(CASE WHEN SalesOrderNumber IS NULL THEN 1 ELSE 0 END) AS NullSalesOrderNumber,
    SUM(CASE WHEN SalesAmount IS NULL THEN 1 ELSE 0 END) AS NullSalesAmount
FROM FACT_InternetSales;

SELECT TOP 20 *
FROM FACT_InternetSales
WHERE SalesAmount IS NULL;

--REMOVING NULL VALUE
DELETE FROM FACT_InternetSales
WHERE SalesAmount IS NULL;

--DUPLICATE VALUE CHECKING
SELECT SalesOrderNumber , COUNT (*) as count
FROM FACT_InternetSales
GROUP BY SalesOrderNumber
HAVING COUNT(*)>1

SELECT SalesOrderNumber, ProductKey, COUNT(*) AS Cnt
FROM FACT_InternetSales
GROUP BY SalesOrderNumber, ProductKey
HAVING COUNT(*) > 1;

--CHECKING ZERO SALES
SELECT COUNT(*)
FROM FACT_InternetSales
WHERE SalesAmount >= 0;



SELECT * FROM [dbo].[DIM_Product]
SELECT COUNT(*) FROM DIM_Product

--DATATYPE CHECKING
SELECT 
   COLUMN_NAME,
   DATA_TYPE,
   CHARACTER_MAXIMUM_LENGTH,
   IS_NULLABLE
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME ='DIM_Product'

--CHECKING NULL VALUES

SELECT 
   SUM(CASE WHEN ProductKey IS NULL THEN 1 ELSE 0 END) AS Productkey,
   SUM(CASE WHEN ProductItemCode IS NULL THEN 1 ELSE 0 END) AS ProductItemCode,
   SUM(CASE WHEN Product_Name IS NULL THEN 1 ELSE 0 END) AS Product_Name,
   SUM(CASE WHEN Sub_Category IS NULL THEN 1 ELSE 0 END) AS Sub_cat,
   SUM(CASE WHEN Product_Category IS NULL THEN 1 ELSE 0 END) AS Product_cat,
   SUM(CASE WHEN Product_Color IS NULL THEN 1 ELSE 0 END) AS Product_color,
   SUM(CASE WHEN Product_Size IS NULL THEN 1 ELSE 0 END) AS Product_size,
   SUM(CASE WHEN Product_Line IS NULL THEN 1 ELSE 0 END) AS Product_line,
   SUM(CASE WHEN Product_Model_Name IS NULL THEN 1 ELSE 0 END) AS Product_model_name,
   SUM(CASE WHEN Product_Description IS NULL THEN 1 ELSE 0 END) AS Product_description,
   SUM(CASE WHEN Product_Status IS NULL THEN 1 ELSE 0 END) AS Product_status
FROM DIM_Product

--CHANGE IT TO NULL VALUES
UPDATE DIM_Product
SET Sub_Category = NULL
WHERE Sub_Category IN ('NA', 'N/A', 'NULL', '');

UPDATE DIM_Product
SET Product_Category = NULL
WHERE Product_Category IN ('NA', 'N/A', 'NULL', '');

UPDATE DIM_Product
SET Product_Color = NULL
WHERE Product_Color IN ('NA', 'N/A', 'NULL', '');

UPDATE DIM_Product
SET Product_Size = NULL
WHERE Product_Size IN ('NA', 'N/A', 'NULL', '');

UPDATE DIM_Product
SET Product_Line = NULL
WHERE Product_Line IN ('NA', 'N/A', 'NULL', '');

UPDATE DIM_Product
SET Product_Model_Name = NULL
WHERE Product_Model_Name IN ('NA', 'N/A', 'NULL', '');

UPDATE DIM_Product
SET Product_Description = NULL
WHERE Product_Description IN ('NA', 'N/A', 'NULL', '');

--CHECKING DISTINCT VALUES
SELECT DISTINCT Sub_Category FROM DIM_Product;
SELECT DISTINCT Product_Color FROM DIM_Product;
SELECT DISTINCT Product_Category FROM DIM_Product;
SELECT DISTINCT Product_Size FROM DIM_Product;
SELECT DISTINCT Product_Line FROM DIM_Product;
SELECT DISTINCT Product_Model_Name FROM DIM_Product;
SELECT DISTINCT Product_Description FROM DIM_Product;




SELECT * FROM [dbo].[DIM_Customer]
SELECT COUNT(*) FROM DIM_Customer

--DATATYPE CHECKING
SELECT 
   COLUMN_NAME,
   DATA_TYPE,
   CHARACTER_MAXIMUM_LENGTH,
   IS_NULLABLE
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME ='DIM_Customer'

--NULL VALUE CHECKING
SELECT COUNT(*) FROM DIM_Customer WHERE CustomerKey IS NULL;
SELECT COUNT(*) FROM DIM_Customer WHERE First_Name IS NULL;
SELECT COUNT(*) FROM DIM_Customer WHERE Last_Name IS NULL;
SELECT COUNT(*) FROM DIM_Customer WHERE Gender IS NULL;
SELECT COUNT(*) FROM DIM_Customer WHERE Customer_City IS NULL;

--DUPLICATE VALUE CHECKING
SELECT CustomerKey, COUNT(*)
FROM DIM_Customer
GROUP BY CustomerKey
HAVING COUNT(*) > 1;


SELECT * FROM [dbo].[DIM_Calendar]
SELECT COUNT(*) FROM DIM_Calendar
--DATATYPE CHECKING
SELECT 
   COLUMN_NAME,
   DATA_TYPE,
   CHARACTER_MAXIMUM_LENGTH,
   IS_NULLABLE
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME ='DIM_Calendar'

--DUPLICATE VALUE CHECKING
SELECT DateKey,COUNT(*) AS No_of_duplicates
FROM DIM_Calendar
GROUP BY DateKey
HAVING COUNT(DateKey)>1;

--MISSING DATE CHECKING
SELECT 
    d1.Date AS CurrentDate,
    DATEADD(day, 1, d1.Date) AS ExpectedNextDate,
    d2.Date AS ActualNextDate
FROM DIM_Calendar d1
LEFT JOIN DIM_Calendar d2
    ON d2.Date = DATEADD(day, 1, d1.Date)
WHERE d2.Date IS NULL
ORDER BY d1.Date;


SELECT * FROM [dbo].[Sent Over Data - SalesBudget]
SELECT COUNT(*) FROM [Sent Over Data - SalesBudget];

--DATATYPE CHECKING
SELECT 
   COLUMN_NAME,
   DATA_TYPE,
   CHARACTER_MAXIMUM_LENGTH,
   IS_NULLABLE
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME ='Sent Over Data - SalesBudget';


--DUPLICATE DATE CHECKING
SELECT [Date],COUNT(*) AS No_of_duplicates
FROM [Sent Over Data - SalesBudget]
GROUP BY [Date]
HAVING COUNT([Date])>1;

--NULL CHECKING
SELECT
SUM(CASE WHEN [Date] IS NULL THEN 1 ELSE 0 END) AS NullDate,
SUM(CASE WHEN Budget IS NULL THEN 1 ELSE 0 END) AS NullBudget
FROM [Sent Over Data - SalesBudget]

--CHEKING ALL DATES ARE IN CALENDAR TABLE
SELECT b.[Date]
FROM [Sent Over Data - SalesBudget] AS b
LEFT JOIN DIM_Calendar AS c
ON b.[Date]=c.[Date]
WHERE c.[Date] IS NULL;






SELECT * FROM [dbo].[DIM_Calendar]


SELECT * FROM [dbo].[DIM_Customer]


SELECT * FROM [dbo].[DIM_Product]


SELECT * FROM [dbo].[FACT_InternetSales]


SELECT * FROM [dbo].[Sent Over Data - SalesBudget]
