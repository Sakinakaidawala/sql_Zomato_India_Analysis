/* ============================================================================
   Project: Zomato India Market Analysis & Data Pipeline
   Author: Sakina Kaidawala
   Description: Data Exploration & Quality Assurance
                This script executes exploratory data analysis (EDA) on the raw 
                b_zomato table to identify duplicates, missing values, schema 
                inconsistencies, and logical anomalies prior to Silver layer ETL.
   ============================================================================ */
-- FINDING dublicat entry
SELECT *
FROM (SELECT *,
	ROW_NUMBER() OVER(PARTITION BY Restaurant_ID,Restaurant_Name,Country_Code,city,Address,Locality,Cuisines, Average_Cost_for_two,Currency,Has_Online_delivery ORDER BY Restaurant_ID)ROW_no
	FROM b_zomato
	WHERE Country_Code = 1)t
WHERE row_no > 1 ;

-- Validating Primary Key (ID) vs Name Collisions
SELECT
COUNT(DISTINCT Restaurant_ID) total_id
FROM b_zomato
WHERE Country_Code = 1
GROUP BY Restaurant_Name
HAVING total_id > 1;

SELECT
COUNT(DISTINCT Restaurant_Name) total_name
FROM b_zomato
WHERE Country_Code = 1
GROUP BY Restaurant_id
HAVING total_name > 1;

-- Null & Blank Value Checks for  Columns
SELECT *
FROM b_zomato
WHERE Restaurant_ID IS NULL OR Restaurant_ID = '';

SELECT *
FROM b_zomato
WHERE Restaurant_Name IS NULL OR Restaurant_Name = '';

-- Distinct Value
SELECT DISTINCT city
FROM b_zomato
WHERE Country_Code = 1;

SELECT DISTINCT Cuisines
FROM b_zomato
WHERE Country_Code = 1;

SELECT Restaurant_ID,Restaurant_Name,Average_Cost_for_two
FROM b_zomato
WHERE Country_Code = 1 
	AND (Average_Cost_for_two IS NULL 
	OR Average_Cost_for_two = '' 
    OR Average_Cost_for_two < 0);
    
SELECT DISTINCT Currency
FROM b_zomato;

SELECT DISTINCT Has_Table_booking
FROM b_zomato;

SELECT DISTINCT Has_Online_delivery
FROM b_zomato;

SELECT DISTINCT Is_delivering_now
FROM b_zomato;

SELECT Restaurant_ID,Restaurant_Name,Price_range
FROM b_zomato
WHERE Country_Code = 1 
	AND (Price_range IS NULL 
	OR Price_range = '' 
    OR Price_range < 0);
    
SELECT Restaurant_ID,Restaurant_Name,Aggregate_rating
FROM b_zomato
WHERE Country_Code = 1 
	AND (Aggregate_rating IS NULL 
	OR Aggregate_rating = '' 
    OR Aggregate_rating < 0
    OR Aggregate_rating > 5);

SELECT Votes
FROM b_zomato
WHERE Country_Code = 1 AND votes < 0;

SELECT Restaurant_ID, Restaurant_Name,Aggregate_rating, Votes
FROM b_zomato
WHERE country_code = 1 AND votes > 0 AND Aggregate_rating = 0;

SELECT MAX(Votes)
FROM b_zomato
WHERE country_code = 1 AND Aggregate_rating = 0;
