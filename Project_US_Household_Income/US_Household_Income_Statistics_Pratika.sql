
# Author: Pratika Binani
## World Life Expectancy Data 
### Data Cleaning and Exploratory Analysis Project

#Data Cleaning
SELECT 
    *
FROM
    us_project.us_household_income;

SELECT 
    COUNT(id)
FROM
    us_project.us_household_income
;


SELECT 
    *
FROM
    us_project.us_household_income_statistics;
 
 ALTER TABLE us_project.us_household_income_statistics
 RENAME COLUMN `ï»¿id` TO `id`
 ;

SELECT COUNT(id)
 FROM us_project.us_household_income_statistics -- 32526
 ;

SELECT * 
FROM us_project.us_household_income;




SELECT 
    id, COUNT(id)
FROM
    us_project.us_household_income
GROUP BY id
HAVING COUNT(id) > 1
;

SELECT *
FROM(
	SELECT 
	row_id,
	id,
	ROW_NUMBER() OVER(PARTITION BY id ORDER BY id) row_num
	FROM us_project.us_household_income 
    ) duplicates
    WHERE row_num > 1
 ;
 
 # delete duplicate records
DELETE FROM us_project.us_household_income 
WHERE row_id IN(
SELECT row_id
FROM(
	SELECT 
	row_id,
	id,
	ROW_NUMBER() OVER(PARTITION BY id ORDER BY id) row_num
	FROM us_project.us_household_income 
    ) duplicates
    WHERE row_num > 1
    )
 ;
 
 
SELECT COUNT(id)
 FROM us_project.us_household_income_statistics 
 GROUP BY id
 HAVING COUNT(id) > 1
 ;--  duplicate records


SELECT 
  --  State_Name,
   --  COUNT(State_Name)
DISTINCT State_Name
FROM
    us_project.us_household_income
    ORDER BY 1
    -- GROUP BY State_Name
    
    ;

UPDATE us_project.us_household_income 
SET 
    State_Name = 'Georgia'
WHERE
    State_Name = 'georia'
;

UPDATE us_project.us_household_income 
SET 
    State_Name = 'georia'
WHERE
    State_Name = 'Georgia'
;

UPDATE us_project.us_household_income 
SET 
    State_Name = 'Alabama'
WHERE
    State_Name = 'alabama'
;


SELECT 
    *
FROM
    us_project.us_household_income
WHERE
    County = 'Autauga County'
ORDER BY 1;


UPDATE us_project.us_household_income 
SET 
    Place = 'Autaugaville'
WHERE
    County = 'Autauga County'
        AND City = 'Vinemont'
;

SELECT 
    Type,
    COUNT(Type)
FROM
    us_project.us_household_income
GROUP BY Type
;




UPDATE us_project.us_household_income 
SET 
    Type = 'Borough'
WHERE
	Type = 'Boroughs'
;


SELECT 
    *
FROM
    us_project.us_household_income
;

SELECT 
    ALand, AWater
FROM
    us_project.us_household_income
WHERE
    (AWater = 0 OR AWater IS NULL
        OR AWater = '')
        AND (ALand = 0 OR ALand IS NULL OR ALand = '')
;


  -- xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx---------------------------------------------------------




#Exploratory Data Analysis


SELECT 
    *
FROM
    us_project.us_household_income;



SELECT 
    *
FROM
    us_project.us_household_income_statistics;



SELECT 
    State_Name,
    County,
    City,
    ALand,
    AWater
FROM
    us_project.us_household_income
    ;


SELECT 
    State_Name, SUM(ALand), SUM(AWater)
FROM
    us_project.us_household_income
GROUP BY State_Name
ORDER BY 3 DESC
;
    
SELECT 
    State_Name, SUM(ALand), SUM(AWater)
FROM
    us_project.us_household_income
GROUP BY State_Name
ORDER BY 3 DESC
LIMIT 10
;




 SELECT 
    *
FROM
    us_project.us_household_income u
RIGHT JOIN us_project.us_household_income_statistics us
	ON u.id = us.id
WHERE u.id IS NULL
    ;   


 SELECT 
    *
FROM
    us_project.us_household_income u
INNER JOIN us_project.us_household_income_statistics us
	ON u.id = us.id
    WHERE Mean <> 0
    ;

    
 SELECT 
	u.State_Name,
    u.County,
    u.Type,
    `Primary`,
    Mean,
    Median
FROM
    us_project.us_household_income u
INNER JOIN us_project.us_household_income_statistics us
	ON u.id = us.id
    WHERE Mean <> 0
    ;

    
   SELECT 
	u.State_Name,
    ROUND(AVG(Mean),1),
    ROUND(AVG(Median),1)
FROM
    us_project.us_household_income u
INNER JOIN us_project.us_household_income_statistics us
	ON u.id = us.id
    WHERE Mean <> 0
GROUP BY u.State_Name
-- ORDER BY 2
-- ORDER BY 2 DESC
-- ORDER BY 3 DESC
ORDER BY 3 ASC
-- LIMIT 5
LIMIT 10
    ;  

 SELECT 
    u.Type,
    COUNT(u.Type),
    ROUND(AVG(Mean),1),
    ROUND(AVG(Median),1)
FROM
    us_project.us_household_income u
INNER JOIN us_project.us_household_income_statistics us
	ON u.id = us.id
    WHERE Mean <> 0
GROUP BY u.Type
HAVING COUNT(Type) > 100 
-- ORDER BY 3
ORDER BY 4 DESC
    ;
    
    
    SELECT 
    *
FROM
    us_project.us_household_income
    WHERE Type = 'Community'
    ;


 SELECT 
    u.State_Name,
    City,
    ROUND(AVG(Mean),1),
    ROUND(AVG(Median),1)
FROM
    us_project.us_household_income u
JOIN us_project.us_household_income_statistics us
	ON u.id = us.id
GROUP BY u.State_Name, City
ORDER BY 3 DESC
    ;   




