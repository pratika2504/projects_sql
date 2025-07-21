

# Author: Pratika Binani
## World Life Expectancy Data 
### Data Cleaning and Exploratory Analysis Project

#Data Cleaning

SELECT 
    *
FROM
    world_life_expectancy
;

SELECT 
    Country,
    Year,
    CONCAT(Country, Year),
    COUNT(CONCAT(Country, Year))
FROM
    world_life_expectancy
GROUP BY 1 , 2
HAVING COUNT(CONCAT(Country, Year)) > 1
;

# Identifying row_id of duplicate records
SELECT *
FROM
(
	SELECT 
	Row_ID,
	CONCAT(Country, Year),
	ROW_NUMBER() OVER(PARTITION BY CONCAT(Country, Year) ORDER BY CONCAT(Country, Year)) AS ROW_NUM
	FROM world_life_expectancy) AS ROW_TABLE
WHERE ROW_NUM>1
;

#Deleting row_id of duplicate records
DELETE FROM world_life_expectancy
WHERE 
	Row_ID IN(
	SELECT Row_ID
FROM(SELECT 
	Row_ID,
	CONCAT(Country, Year),
	ROW_NUMBER() OVER(PARTITION BY CONCAT(Country, Year) ORDER BY CONCAT(Country, Year)) AS ROW_NUM
	FROM world_life_expectancy
    ) AS ROW_TABLE
    WHERE ROW_NUM>1
    )
    ;
 
 #Empty values
SELECT DISTINCT
    (Status)
FROM
    world_life_expectancy
WHERE
    Status = ''
;

SELECT DISTINCT
    (Status)
FROM
    world_life_expectancy
WHERE
    Status <> ''
;

SELECT DISTINCT
    (Country)
FROM
    world_life_expectancy
WHERE
    Status = 'Developing'
;

#Populate the data correctly
UPDATE world_life_expectancy 
SET 
    Status = 'Developing'
WHERE
    Country IN (SELECT DISTINCT
            (Country)
        FROM
            world_life_expectancy
        WHERE
            Status = 'Developing')
;     -- error

# Populate the data correctly using self join instead
UPDATE world_life_expectancy t1
        JOIN
    world_life_expectancy t2 ON t1.Country = t2.Country 
SET 
    t1.Status = 'Developing'
WHERE
    t1.Status = '' AND t2.Status <> ''
        AND t2.Status = 'Developing'
;

UPDATE world_life_expectancy t1
        JOIN
    world_life_expectancy t2 ON t1.Country = t2.Country 
SET 
    t1.Status = 'Developed'
WHERE
    t1.Status = '' AND t2.Status <> ''
        AND t2.Status = 'Developed'
;
#check
SELECT 
    *
FROM
    world_life_expectancy
    WHERE Status IS NULL
;


 # Empty values
 # Identifying empty values
SELECT 
    *
FROM
    world_life_expectancy
    WHERE `Life Expectancy` = ''
;


SELECT 
    Country,
    Year,
    `Life Expectancy`
FROM
    world_life_expectancy
     WHERE `Life Expectancy` = ''
;


# Applying logic of populating values based on average of previous and next year using self join ( three tables)
SELECT 
    t1.Country,
    t1.Year,
    t1.`Life Expectancy`,
    t2.Country,
    t2.Year,
    t2.`Life Expectancy`,
	t3.Country,
    t3.Year,
    t3.`Life Expectancy`,
    ROUND(t2.`Life Expectancy` + t3.`Life Expectancy` / 2,1)
FROM
    world_life_expectancy t1
        JOIN
    world_life_expectancy t2 ON t1.Country = t2.Country
        AND t1.Year = t2.Year - 1
        JOIN
    world_life_expectancy t3 ON t1.Country = t3.Country
        AND t1.Year = t3.Year + 1
	WHERE t1.`Life Expectancy` = ''
;

# Updating and populating based on above logic
UPDATE  world_life_expectancy t1
        JOIN
    world_life_expectancy t2 ON t1.Country = t2.Country
        AND t1.Year = t2.Year - 1
        JOIN
    world_life_expectancy t3 ON t1.Country = t3.Country
        AND t1.Year = t3.Year + 1
SET t1.`Life Expectancy`=  ROUND(t2.`Life Expectancy` + t3.`Life Expectancy` / 2,1)
WHERE t1.`Life Expectancy` = ''
;

#check
SELECT 
    Country,
    Year,
    `Life Expectancy`
FROM
    world_life_expectancy
     WHERE `Life Expectancy` = ''
;


 -------------------------------------------------------- xxxxxxxxxxxxxxxxxxxxxxxxxxx-----------------------------------------------------

#Exploratory Data Analysis

SELECT 
    *
FROM
    world_life_expectancy
;

SELECT 
    Country,
    MIN(`Life Expectancy`),
    MAX(`Life Expectancy`),
    ROUND(MAX(`Life Expectancy`) - MIN(`Life Expectancy`),
            1) AS Life_Increase_15_Years
FROM
    world_life_expectancy
GROUP BY Country
HAVING MIN(`Life Expectancy`) <> 0
    AND MAX(`Life Expectancy`) <> 0
ORDER BY Life_Increase_15_Years DESC
;

SELECT 
    Year, ROUND(AVG(`Life Expectancy`), 2)
FROM
    world_life_expectancy
WHERE
    `Life Expectancy` <> 0
GROUP BY Year
ORDER BY Year
;


SELECT 
    *
FROM
    world_life_expectancy
;

SELECT 
    Country,
    ROUND(AVG(`Life Expectancy`), 2) AS Life_Exp,
    ROUND(AVG(GDP), 1) AS GDP
FROM
    world_life_expectancy
GROUP BY Country
HAVING Life_Exp > 0 AND GDP > 0
ORDER BY GDP DESC
;


SELECT 
    SUM(CASE
        WHEN GDP >= 1500 THEN 1
        ELSE 0
    END) High_GDP_Count,
    AVG(CASE
        WHEN GDP >= 1500 THEN `Life Expectancy`
        ELSE NULL
    END) High_GDP_Life_Expectancy,
    SUM(CASE
        WHEN GDP <= 1500 THEN 1
        ELSE 0
    END) Low_GDP_Count,
    AVG(CASE
        WHEN GDP <= 1500 THEN `Life Expectancy`
        ELSE NULL
    END) Low_GDP_Life_Expectancy
FROM
    world_life_expectancy
;


SELECT 
    Status, ROUND(AVG(`Life Expectancy`), 1)
FROM
    world_life_expectancy
GROUP BY Status
;

SELECT 
    Status,
    COUNT(DISTINCT Country),
    ROUND(AVG(`Life Expectancy`), 1)
FROM
    world_life_expectancy
GROUP BY Status
;


SELECT 
    Country,
    ROUND(AVG(`Life Expectancy`), 2) AS Life_Exp,
    ROUND(AVG(BMI), 1) AS BMI
FROM
    world_life_expectancy
GROUP BY Country
HAVING Life_Exp > 0 AND BMI > 0
ORDER BY BMI ASC
;


SELECT 
    Country,
    Year,
    `Life Expectancy`,
    `Adult Mortality`,
    SUM(`Adult Mortality`) OVER(PARTITION BY Country ORDER BY Year) AS Rolling_Total  
FROM
    world_life_expectancy
    WHERE Country LIKE '%United%'
;





-------------------------------------------------------Xxxxxxxxxxxxxxxxxxxxxxxxxx----------------------------------------------------



 
 

























	