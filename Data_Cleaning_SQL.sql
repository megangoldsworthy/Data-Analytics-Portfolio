SELECT *
FROM nashville_housing

--Reformat Sale Date--

SELECT FORMAT(sale_date, 'yyyy-MM-dd') as formatted_date
FROM nashville_housing

ALTER TABLE nashville_housing
Add COLUMN formatted_date Date

UPDATE formatted_date
SET formatted_date = FORMAT(sale_date, 'yyyy-MM-dd') 

SELECT *
FROM nashville_housing

--Property Address Populating and Formatting--

SELECT property_address
FROM nashville_housing
WHERE property_address is null

SELECT *
FROM nashville_housing
WHERE property_address is null

SELECT*
FROM nashville_housing
ORDER BY parcel_id

SELECT ta.parcel_id, ta.property_address, tb.parcel_id, tb.property_address, 
COALESCE(ta.property_address, tb.property_address)
FROM nashville_housing as ta
INNER JOIN nashville_housing as tb
	on ta.parcel_id = tb.parcel_id
	AND ta.unique_id <> tb.unique_id
WHERE ta.property_address is null
		
-- Breaking Address Into Individual Columns--


SELECT SPLIT_PART(owner_address, ',', 1) as address,
SPLIT_PART(owner_address, ',', 2) as city
FROM nashville_housing

ALTER TABLE nashville_housing
Add COLUMN split_address varchar(200)

UPDATE nashville_housing
SET split_address = SPLIT_PART(owner_address, ',', 1)

ALTER TABLE nashville_housing
Add COLUMN split_city varchar(200)

UPDATE nashville_housing
SET split_city = SPLIT_PART(owner_address, ',', 2)

--Change Y and N to Yes and No in sold_as_vacant to Standardize--

SELECT COUNT(DISTINCT sold_as_vacant) as Counts, sold_as_vacant as response
FROM nashville_housing
GROUP BY sold_as_vacant

SELECT sold_as_vacant,
CASE WHEN sold_as_vacant = 'Y' THEN 'Yes'
	WHEN sold_as_vacant = 'N' THEN 'No'
	ELSE sold_as_vacant
	END
FROM nashville_housing

UPDATE nashville_housing
SET sold_as_vacant = CASE WHEN sold_as_vacant = 'Y' THEN 'Yes'
	WHEN sold_as_vacant = 'N' THEN 'No'
	ELSE sold_as_vacant
	END

--Remove Duplicates--

WITH rownumCTE AS(
SELECT*,
	ROW_NUMBER() OVER( 
	PARTITION BY parcel_id, property_address, sale_price,sale_date,legal_reference
	ORDER BY unique_id)
	row_num
FROM nashville_housing)

SELECT*
FROM rownumCTE
WHERE row_num > 1
ORDER BY property_address


WITH rownumCTE AS(
SELECT*,
	ROW_NUMBER() OVER( 
	PARTITION BY parcel_id, property_address, sale_price,sale_date,legal_reference
	ORDER BY unique_id)
	row_num
FROM nashville_housing)

DELETE
FROM rownumCTE
WHERE row_num > 1

--Removing Unused Columns--

SELECT*
FROM nashville_housing

ALTER TABLE nashville_housing
DROP COLUMN tax_district