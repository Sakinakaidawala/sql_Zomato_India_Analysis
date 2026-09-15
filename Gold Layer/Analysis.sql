/* ============================================================================
   Project: Zomato India Market Analysis & Data Pipeline
   Author: Sakina Kaidawala
   Description: Gold Layer - Business Intelligence & Strategic Insights
                This script queries the cleansed s_zomato_india table to extract 
                actionable insights regarding market penetration, pricing 
                strategies, customer preferences, and operational "sweet spots".
   ============================================================================ */
-- total restaurent ragistar on zameto in a city
SELECT CITY,
COUNT(Restaurant_ID) AS total_restaurants
FROM s_zomato_india
GROUP BY City
ORDER BY total_restaurants DESC;

-- part to whole analysis
SELECT City,
COUNT(Restaurant_ID) AS City_total_rest,
ROUND((COUNT(Restaurant_ID)/SUM(COUNT(Restaurant_ID)) OVER())*100,2) AS Percentage_of_whole
FROM s_zomato_india
GROUP BY city
ORDER BY 3 DESC;

-- city wise average cost for two
SELECT city,
ROUND(AVG(Average_Cost_for_two),2) AS avg_cost
FROM s_zomato_india
WHERE Average_Cost_for_two IS NOT NULL
GROUP BY city
ORDER BY 2 DESC
LIMIT 10;

-- Price categories and rating
SELECT
CASE
	WHEN Average_Cost_for_two < 350 THEN 'Budget (under 350)'
    WHEN Average_Cost_for_two BETWEEN 350 AND 750 THEN 'Mid (350-750)'
    WHEN Average_Cost_for_two BETWEEN 750 AND 1550 THEN 'Premium (750-1550)'
    ELSE 'Super Premium (1550+)'
END AS Price_category,
COUNT(*) AS rest_count,
ROUND(AVG(Aggregate_rating),2) AS avg_rating,
ROUND(AVG(votes),0) AS avg_vote
FROM s_zomato_india
WHERE Average_Cost_for_two IS NOT NULL
GROUP BY Price_category;

-- which city has most online order adptation 
SELECT city,
COUNT(*) AS total_rest,
ROUND((SUM(Has_Online_delivery)/COUNT(*)) * 100,2) AS percentage_count
FROM s_zomato_india
GROUP BY city
HAVING total_rest >= 10
ORDER BY 3 DESC;

-- is table booking affect the rating 
SELECT Has_Table_booking,
COUNT(*),
ROUND(AVG(Aggregate_rating),2) AS avg_rating,
ROUND(AVG(votes),0) AS avg_votes
FROM s_zomato_india
WHERE Aggregate_rating > 0
GROUP BY Has_Table_booking;

-- which restaurant have low cost and high ratings
SELECT Restaurant_ID,
Restaurant_Name,
City,
Average_Cost_for_two,
Aggregate_rating,
Votes
FROM s_zomato_india
WHERE Average_Cost_for_two < 750
	AND Aggregate_rating > 4.0
    AND votes > 200
ORDER BY Aggregate_rating  DESC, Votes DESC
LIMIT 20;

-- Franchise vise analysis of rating
SELECT Restaurant_Name, COUNT(*) AS total_outlets,
ROUND(AVG(Aggregate_rating),2) AS avg_chain_rating,
ROUND(AVG(votes),0) AS avg_votes
FROM s_zomato_india
GROUP BY Restaurant_Name
HAVING COUNT(*) > 1
ORDER BY total_outlets DESC;

SELECT
ROUND(AVG(Aggregate_rating),2) AS avg_rating,
ROUND(AVG(votes),0) AS avg_votes
FROM s_zomato_india
WHERE Aggregate_rating IS NOT NULL
	AND Restaurant_Name IN (SELECT Restaurant_Name 
							FROM s_zomato_india
							GROUP BY Restaurant_Name
							HAVING COUNT(*) <= 3);
                            
-- Rank top 5 budget friendly restaurant in city
SELECT *
	FROM (SELECT Restaurant_ID,
			Restaurant_Name, City,
			Average_Cost_for_two,
			Aggregate_rating,
			Votes,
			DENSE_RANK() OVER(PARTITION BY City ORDER BY Average_Cost_for_two,Aggregate_rating DESC) AS Rest_rank
			FROM s_zomato_india
			WHERE Average_Cost_for_two IS NOT NULL AND Votes > 25)t
WHERE rest_rank <= 5;

-- Rank top 5 highest-rated premium restaurants in city
SELECT *
	FROM (SELECT Restaurant_ID,
			Restaurant_Name, City,
			Average_Cost_for_two,
			Aggregate_rating,
			Votes,
			DENSE_RANK() OVER(PARTITION BY City ORDER BY Aggregate_rating DESC, Votes DESC,Average_Cost_for_two DESC) AS Rest_rank
			FROM s_zomato_india
			WHERE Average_Cost_for_two IS NOT NULL AND Votes > 25)t
WHERE rest_rank <= 5;
                            
-- which strategy will genrate the highest rating
SELECT Price_range,
Has_Online_delivery,
Has_Table_booking,
COUNT(*) AS total_restaurant,
ROUND(AVG(Aggregate_rating),2) AS avg_rating
FROM s_zomato_india
WHERE Aggregate_rating IS NOT NULL
	AND Price_range IS NOT NULL
GROUP BY Price_range,
		Has_Online_delivery,
		Has_Table_booking
ORDER BY avg_rating DESC
