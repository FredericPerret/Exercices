SELECT category_id,
	   CAST(TRIM(REGEXP_REPLACE(category_name,'\s+',' ','g')) AS VARCHAR(15)) AS category_name,
	   description
FROM {{ source('northwind', 'categories') }}