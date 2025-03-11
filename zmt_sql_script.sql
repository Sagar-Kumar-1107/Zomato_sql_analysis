CREATE DATABASE zmtproject;
USE zmtproject;
CREATE TABLE zmt(
RestaurantID INT PRIMARY KEY,
RestaurantName VARCHAR(255),
CountryCode INT,
City VARCHAR(100),
Address VARCHAR(500),
Locality VARCHAR(255),
LocalityVerbose VARCHAR(500),
Cuisines VARCHAR(255),
Currency VARCHAR(50),
Has_Table_booking ENUM('Yes', 'No'),
Has_Online_delivery ENUM('Yes', 'No'),
Is_delivering_now ENUM('Yes', 'No'),
Switch_to_order_menu ENUM('Yes', 'No'),
Price_range INT,
Votes INT,
Average_Cost_for_two INT,
Rating DECIMAL(2,1)
);
LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/Zomato_Dataset.csv'
INTO TABLE zmt
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;
SELECT * FROM zmt;
SELECT COUNT(*) FROM zmt;
DESCRIBE zmt;
SELECT * FROM zmt LIMIT 10;
SELECT RestaurantID,COUNT(RestaurantID) FROM zmt
GROUP BY RestaurantID
ORDER BY 2 DESC;
SELECT COUNT(RestaurantID) FROM zmt,

USE zmtproject;
SELECT * FROM zmt;
CREATE TABLE Zomato_Country (
    CountryCode INT PRIMARY KEY,
    CountryName VARCHAR(100) NOT NULL
);
ALTER TABLE zmt MODIFY COLUMN Has_Table_booking TINYINT DEFAULT 0;
ALTER TABLE zmt MODIFY COLUMN Has_Online_delivery TINYINT DEFAULT 0;
ALTER TABLE zmt MODIFY COLUMN Is_delivering_now TINYINT DEFAULT 0;
ALTER TABLE zmt MODIFY COLUMN Switch_to_order_menu TINYINT DEFAULT 0;

ALTER TABLE zmt MODIFY COLUMN Price_range INT CHECK (Price_range BETWEEN 1 AND 4);
ALTER TABLE zmt MODIFY COLUMN Rating DECIMAL(2,1) CHECK (Rating BETWEEN 0 AND 5);

ALTER TABLE zmt ADD CONSTRAINT FK_Country FOREIGN KEY (CountryCode) REFERENCES Zomato_Country(CountryCode);
SELECT DISTINCT CountryCode FROM zmt ORDER BY CountryCode;

DESC zmt;
INSERT INTO Zomato_Country (CountryCode, CountryName) VALUES
(1, 'India'),
(14, 'Australia'),
(30, 'Brazil'),
(37, 'Canada'),
(94, 'Indonesia'),
(148, 'New Zealand'),
(162, 'Philippines'),
(166, 'Qatar'),
(184, 'Singapore'),
(189, 'South Africa'),
(191, 'Sri Lanka'),
(208, 'Turkey'),
(214, 'UAE'),
(215, 'United Kingdom'),
(216, 'United States');
SELECT * FROM Zomato_Country;
ALTER TABLE zmt 
ADD CONSTRAINT FK_Country FOREIGN KEY (CountryCode) 
REFERENCES Zomato_Country(CountryCode);
DESC zmt;
DESC Zomato_Country;
SELECT RestaurantID ,COUNT(*) FROM zmt GROUP BY RestaurantID HAVING COUNT(*)>1;  
DELETE FROM zmt
WHERE RestaurantID IN (
    SELECT z1.RestaurantID
    FROM zmt z1
    JOIN zmt z2 
    ON z1.RestaurantID = z2.RestaurantID 
    AND z1.Address = z2.Address 
    WHERE z1.Votes < z2.Votes
);
CREATE TEMPORARY TABLE temp_delete AS
SELECT z1.RestaurantID 
FROM zmt z1
JOIN zmt z2 
ON z1.RestaurantID = z2.RestaurantID 
AND z1.Address = z2.Address 
WHERE z1.Votes < z2.Votes;

DELETE FROM zmt
WHERE RestaurantID IN (SELECT RestaurantID FROM temp_delete);

DROP TEMPORARY TABLE temp_delete;
ALTER TABLE zmt ADD COLUMN CountryName VARCHAR(50);

UPDATE zmt z
JOIN Zomato_Country c ON z.CountryCode = c.CountryCode
SET z.CountryName = c.CountryName;

SELECT * FROM zmt;
SELECT DISTINCT City FROM zmt WHERE City LIKE '%?%';

UPDATE zmt 
SET City = REPLACE(City, '?', 'i')
WHERE City LIKE '%?%';
SET SQL_SAFE_UPDATES =1;

SELECT * FROM zmt WHERE Cuisines IS NULL OR Cuisines = '';
UPDATE zmt SET Cuisines = 'Unknown' WHERE Cuisines IS NULL OR Cuisines = '';

SELECT CountryName, City, COUNT(City) AS TOTAL_REST  
FROM zmt  
GROUP BY CountryName, City  
ORDER BY CountryName, City, TOTAL_REST DESC;

SELECT City, Locality, COUNT(Locality) AS COUNT_LOCALITY,  
       SUM(COUNT(Locality)) OVER(PARTITION BY City ORDER BY City, Locality) AS ROLL_COUNT  
FROM zmt  
GROUP BY Locality, City  
ORDER BY City, Locality, COUNT_LOCALITY DESC;

SELECT Currency, COUNT(Currency) FROM zmt
GROUP BY Currency
ORDER BY 2 DESC;
UPDATE zmt  
SET Currency = '£'  
WHERE Currency = '?';
SHOW VARIABLES LIKE 'character_set_database';
SELECT Currency FROM zmt WHERE Currency LIKE 'Po%';

UPDATE zmt 
SET Currency = '£' 
WHERE Currency = '(?)';

SELECT '£' FROM zmt; 
UPDATE zmt 
SET Currency = REPLACE(Currency, '?', '£') 
WHERE Currency LIKE '%?%';

SELECT DISTINCT(Has_Table_booking) FROM zmt;
SELECT DISTINCT(Has_Online_delivery) FROM zmt;
SELECT DISTINCT(Is_delivering_now) FROM zmt;
SELECT DISTINCT(Switch_to_order_menu) FROM zmt;
SELECT * FROM zmt;

ALTER TABLE zmt DROP COLUMN Switch_to_order_menu;

SELECT DISTINCT(Price_range) FROM zmt;

ALTER TABLE zmt modify COLUMN Votes INT ;
SELECT MIN(CAST(Votes AS SIGNED)) MIN_VT,AVG(CAST(Votes AS SIGNED)) AVG_VT,MAX(CAST(Votes AS SIGNED)) MAX_VT
FROM zmt ;

SELECT Average_Cost_for_two 
FROM zmt 
WHERE CAST(Average_Cost_for_two AS DECIMAL(10,2)) IS NULL;


ALTER TABLE zmt 
MODIFY COLUMN Average_Cost_for_two FLOAT;

SELECT 
    Currency,
    MIN(CAST(Average_Cost_for_two AS FLOAT)) AS MIN_CST,
    AVG(CAST(Average_Cost_for_two AS FLOAT)) AS AVG_CST,
    MAX(CAST(Average_Cost_for_two AS FLOAT)) AS MAX_CST
FROM zmt
GROUP BY Currency;

SELECT MIN(Rating),
ROUND(AVG(CAST(Rating AS DECIMAL)),1), 
MAX(Rating)  
FROM zmt ;

ALTER TABLE zmt MODIFY COLUMN Rating DECIMAL(3,1);

SELECT CAST(Rating AS DECIMAL(3,1)) AS NUM FROM zmt WHERE CAST(Rating AS DECIMAL(3,1)) >= 5;

SELECT Rating FROM zmt WHERE Rating >= 4;

SELECT Rating,
    CASE 
        WHEN Rating >= 1 AND Rating < 2.5 THEN 'POOR'
        WHEN Rating >= 2.5 AND Rating < 3.5 THEN 'GOOD'
        WHEN Rating >= 3.5 AND Rating < 4.5 THEN 'GREAT'
        WHEN Rating >= 4.5 THEN 'EXCELLENT'
    END AS RATE_CATEGORY
FROM zmt;

ALTER TABLE zmt ADD COLUMN RATE_CATEGORY VARCHAR(20);

UPDATE zmt 
SET RATE_CATEGORY = CASE 
    WHEN Rating >= 1 AND Rating < 2.5 THEN 'POOR'
    WHEN Rating >= 2.5 AND Rating < 3.5 THEN 'GOOD'
    WHEN Rating >= 3.5 AND Rating < 4.5 THEN 'GREAT'
    WHEN Rating >= 4.5 THEN 'EXCELLENT'
END;

SET SQL_SAFE_UPDATES = 1;

SELECT * FROM zmt;

CREATE OR REPLACE VIEW TOTAL_COUNT AS
SELECT DISTINCT CountryName, 
       COUNT(RestaurantID) OVER () AS TOTAL_REST
FROM zmt;

WITH CT1 AS (
    SELECT CountryName, COUNT(RestaurantID) AS REST_COUNT
    FROM zmt
    GROUP BY CountryName
)
SELECT A.CountryName, 
       A.REST_COUNT, 
       ROUND(CAST(A.REST_COUNT AS DECIMAL) / CAST(B.TOTAL_REST AS DECIMAL) * 100, 2) AS PERCENTAGE
FROM CT1 A 
JOIN TOTAL_COUNT B ON A.CountryName = B.CountryName
ORDER BY 3 DESC;
