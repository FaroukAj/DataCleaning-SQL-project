USE housing;



-- Remove duplicate records: Identify and eliminate any duplicate entries in the dataset based on unique identifiers such as Location_account_no.
DELETE 
FROM businessdata
WHERE Location_account_no 
NOT IN (SELECT Location_account_no
FROM (select Row_number() over (Partition by Location_account_no, Business_name ORDER BY location_account_no ) AS row_num FROM businessdata) AS dup_rowss
WHERE row_num = 1
);


-- Handle missing values: Identify missing values in the 'Mailing_Address', 'Mailing_city', 'Mailing_zip_code' and fill with Street Address data respectively
SELECT *
FROM businessdata
WHERE Mailing_Address = "" ;

-- updating mailing address
UPDATE businessdata
SET Mailing_Address = (select Street_Address)
WHERE Mailing_Address = "" ;


SELECT *
FROM businessdata
WHERE Mailing_City = "" ;

-- Updating mailing city
UPDATE businessdata
SET Mailing_City = (select City)
WHERE Mailing_City = "" ;

SELECT *
FROM businessdata
WHERE Mailing_Zip_code = "" ;

-- updating mailing zip code
UPDATE businessdata
SET Mailing_Zip_code = (select City)
WHERE Mailing_Zip_code = "" ;

-- Validate zip codes: Truncate zip codes to the conventional 5 digit format.
SELECT 
	LENGTH(Zip_code)
FROM businessdata;

SELECT *
, SUBSTR(zip_code, 1, 5) AS Updated_zipcode
FROM businessdata;

UPDATE businessdata
SET Zip_code =  (select SUBSTR(zip_code, 1, 5));


-- Format dates: Standardize the format of date columns like Location_start_datee to a consistent format (e.g., YYYY-MM-DD).

SHOW COLUMNS 
FROM businessdata;

/*Check to see how many empty rows are in the column*/
SELECT 
	Location_start_date
FROM businessdata
WHERE Location_start_date IN ('');

/* DELETE empty rows */ -- Note: Data can not be restored after deleted
DELETE 
FROM businessdata
WHERE Location_start_date IN ('');


/* Dealing with incorrect year format data*/
SELECT REPLACE(Location_start_date, '00', '') 
FROM businessdata
WHERE Location_start_date LIKE ('%0019%');

/* Dealing with incorrect year format data*/
UPDATE businessdata
SET Location_start_date = (SELECT REPLACE(Location_start_date, '00', '') )
WHERE Location_start_date LIKE ('%0021%');


/*Update Location_start_date column with no missing data */
UPDATE businessdata
SET Location_start_date = (SELECT str_to_date(Location_start_date, '%m/%d/%y'))
WHERE Location_start_date NOT IN ('');


-- Remove unnecessary columns: Analyze the relevance of each column and remove any that are irrelevant or redundant for the analysis.
ALTER TABLE businessdata
DROP COLUMN Location_end_date
,DROP COLUMN Location
,DROP COLUMN Dba_name;



SELECT * 
FROM businessdata;





























