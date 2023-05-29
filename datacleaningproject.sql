USE housing;

SHOW COLUMNS FROM housing_data;

-- Standardize Date Format
UPDATE housing_data
SET Sale_date = (SELECT  STR_TO_DATE(Sale_Date, '%m/%d/%y') AS Updated_Sale_date);

-- Populate Address data
SELECT * FROM housing_data WHERE Address = "";

UPDATE housing_data
SET Address = (SELECT Property_Address);

-- Change Y and N to Yes and No in "Sold as Vacant" field
UPDATE housing_data
SET Sold_As_Vacant = (SELECT  
CASE
	WHEN Sold_As_Vacant = 'N' THEN 'No' 
    WHEN Sold_As_Vacant = 'Y' THEN 'YES'
    
END AS Sold_As_Vacant);


-- Renamd Unamed Column AS Unique ID
ALTER TABLE housing_data
RENAME COLUMN unamed_1 TO unique_ID;
    
-- Remove Duplicates
WITH dup_rows AS (
SELECT *, ROW_NUMBER() OVER (PARTITION BY Parcel_ID, 
Property_Address,
Sale_Date, 
Sale_Price 

ORDER BY Unique_ID ) AS row_num
FROM housing_data

)
SELECT * FROM dup_rows;

DELETE
FROM dup_rows
WHERE row_num >1
;
-- OR USING subquery WITHOUT CTE

DELETE FROM housing_data
WHERE Unique_ID NOT IN (
  SELECT Unique_ID
  FROM (
    SELECT Unique_ID, ROW_NUMBER() OVER (PARTITION BY Parcel_ID, Property_Address, Sale_Date, Sale_Price ORDER BY Unique_ID) AS row_num
    FROM housing_data
  ) AS dup_rows
  WHERE row_num = 1
);


-- Delete Unused Columns
ALTER TABLE housing_data
DROP COLUMN unnamed_2, 
DROP COLUMN City, 
DROP COLUMN Owner_Name,
DROP COLUMN  Address;

SELECT * FROM housing_data;