/* ============================================================================
   Project: Zomato India Market Analysis & Data Pipeline
   Author: Sakina Kaidawala
   Description: Bronze Layer - Raw Data Ingestion
                This script creates the initial database schema, defines the 
                raw staging tables (b_zomato, country_codes), and bulk-loads 
                the raw CSV dataset into MySQL.
   ============================================================================ */
CREATE DATABASE zomato;
USE ZOMATO;
DROP TABLE IF EXISTS b_zomato;
CREATE TABLE b_zomato(
Restaurant_ID 		INT,
Restaurant_Name 	VARCHAR(150),
Country_Code 		INT,
City 				VARCHAR(150),
Address 			VARCHAR(150),
Locality 			VARCHAR(100),
Locality_Verbose 	VARCHAR(100),
Longitude 			DECIMAL(10,6),
Latitude 			DECIMAL(10,6),
Cuisines 			VARCHAR (100),
Average_Cost_for_two DECIMAL(10,2),
Currency 			VARCHAR(50),
Has_Table_booking 	ENUM('yes', 'no'),
Has_Online_delivery ENUM('yes', 'no'),
Is_delivering_now 	ENUM('yes', 'no'),
Switch_to_order_menu VARCHAR(50),
Price_range 		DECIMAL(10,2),
Aggregate_rating 	DECIMAL(5,2),
Rating_color 		VARCHAR(50),
Rating_text 		VARCHAR(150),
Votes 				INT
);

DROP TABLE IF EXISTS country_codes;
CREATE TABLE country_codes (
country_code INT,
country 	 VARCHAR(50)
);

TRUNCATE TABLE b_zomato;
LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/zomato.csv'
INTO TABLE b_zomato
CHARACTER SET latin1 -- language errors
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 ROWS;

SHOW WARNINGS;

SELECT *
FROM b_zomato;
