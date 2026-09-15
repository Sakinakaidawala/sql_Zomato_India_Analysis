# sql_Zomato_India_Analysis
This project transforms raw Zomato restaurant data into actionable business intelligence. It features a fully automated SQL ETL pipeline that cleans, standardizes, and structures the data to uncover market trends, customer satisfaction metrics, and operational "sweet spots" within India's restaurant industry.

Data Architecture
Bronze Layer: Raw data ingestion featuring initial schema definitions, primary key validation, and anomaly detection.

Silver Layer: An idempotent data cleaning pipeline automated via a MySQL Stored Procedure (TRUNCATE and INSERT). Transformations include converting text booleans to integers, standardizing strings with TRIM(), and nullifying unrated 0.00 scores caused by platform minimum-vote algorithms.

Gold Layer: Business-ready aggregations utilizing multi-column grouping, subqueries, and HAVING filters to eliminate small-sample statistical noise and extract strategic insights.

Key Business Insights
The Mega-Chain Quality Drop: Market-saturating franchises (like Domino's and Cafe Coffee Day) average a 2.93 to 3.00 rating, indicating that corporate scaling often results in a mediocre baseline customer experience.

Local Gems Outperform Franchises: Independent establishments and small local chains (3 or fewer outlets) significantly outperform global franchises, securing a much higher grand average rating of 3.38 alongside massive spikes in digital customer engagement.

The Market Sweet Spot: The highest-rated, statistically reliable business model is the "Exclusive Premium" setup (Price Tier 4, no online delivery, no digital table booking), yielding an average rating of 3.93 by focusing entirely on the in-house dining experience.

Technical Skills Demonstrated
ETL Automation: Stored Procedures, TRUNCATE/INSERT idempotency.

Data Cleaning: CASE statements, NULLIF, SUBSTRING_INDEX, schema realignment.

Advanced Analytics: Subqueries, CTEs, complex GROUP BY matrices, and statistical noise filtering (HAVING).
