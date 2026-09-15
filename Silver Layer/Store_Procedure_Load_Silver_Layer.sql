/* ============================================================================
   Project: Zomato India Market Analysis & Data Pipeline
   Author: Sakina Kaidawala
   Description: Silver Layer - Data Cleansing & ETL Automation
                Automates transformation from the raw Bronze staging table into
                the cleansed Silver layer (s_zomato_india). Standardizes data 
                types, trims strings, converts text flags to booleans, enforces 
                logical data boundaries, and nullifies suppressed 0.00 ratings.
   ============================================================================ */
DROP TABLE IF EXISTS s_zomato_india;
CREATE TABLE s_zomato_India(
  `Restaurant_ID` int DEFAULT NULL,
  `Restaurant_Name` varchar(150) DEFAULT NULL,
  `Country_Code` varchar(150) DEFAULT NULL,
  `City` varchar(150) DEFAULT NULL,
  `Address` varchar(150) DEFAULT NULL,
  `Cuisines` varchar(100) DEFAULT NULL,
  `Average_Cost_for_two` decimal(10,2) DEFAULT NULL,
  `Has_Table_booking` INT DEFAULT NULL,
  `Has_Online_delivery` INT DEFAULT NULL,
  `Is_delivering_now` INT DEFAULT NULL,
  `Price_range` decimal(10,2) DEFAULT NULL,
  `Aggregate_rating` decimal(5,2) DEFAULT NULL,
  `Votes` int DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

DROP PROCEDURE IF EXISTS Load_Clean_Data_Silver_layer;
DELIMITER $$
CREATE PROCEDURE Load_Clean_Data_Silver_layer ()
BEGIN
	TRUNCATE TABLE s_zomato_india;
	INSERT INTO s_zomato_india(
		Restaurant_ID,
		Restaurant_Name,
		Country_Code , 
		City ,
		Address,
		Cuisines,
		Average_Cost_for_two,
		Has_Table_booking,
		Has_Online_delivery, 
		Is_delivering_now,
		Price_range,
		Aggregate_rating,
		Votes
			)
			SELECT
			Restaurant_ID ,
			TRIM(Restaurant_Name) Restaurant_Name,
			c.country,
			TRIM(City) City, 
			Address,  
			TRIM(Cuisines) Cuisines,
			CASE WHEN Average_Cost_for_two <= 0 THEN NULL
				ELSE Average_Cost_for_two
			END AS Average_Cost_for_two,
			CASE WHEN LOWER(TRIM(has_table_booking)) = 'yes' THEN 1 ELSE 0
			END AS Has_Table_booking,
			CASE WHEN LOWER(TRIM(Has_Online_delivery)) = 'yes' THEN 1 ELSE 0
			END AS Has_Online_delivery, 
			CASE WHEN LOWER(TRIM(Is_delivering_now)) = 'yes' THEN 1 ELSE 0
			END AS Is_delivering_now,
			CASE WHEN Price_range <= 0 THEN NULL
				ELSE Price_range
			END AS Price_range, 
			CASE WHEN Aggregate_rating <= 0 THEN NULL
				WHEN Aggregate_rating > 5 THEN NULL
				ELSE Aggregate_rating
			END AS Aggregate_rating,
			Votes
			FROM b_zomato 
            LEFT JOIN country_codes c
				ON b_zomato.Country_Code = c.Country_Code
			WHERE c.Country = 'India';
END $$
DELIMITER ;
CALL Load_Clean_Data_Silver_layer();

SELECT * FROM s_zomato_india;
