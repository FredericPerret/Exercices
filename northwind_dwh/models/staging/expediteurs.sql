SELECT shipper_id,
	   CAST(TRIM(REGEXP_REPLACE(company_name,'\s+',' ','g')) AS VARCHAR(40)) AS company_name, 
	   CAST(TRIM(phone) AS VARCHAR(24)) AS phone
FROM {{ source('northwind', 'shippers') }}