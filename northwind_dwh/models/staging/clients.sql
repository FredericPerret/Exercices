
SELECT CAST(UPPER(customer_id) AS VARCHAR(5)) AS customer_id, 
	   CAST(TRIM(REGEXP_REPLACE(company_name,'\s+',' ','g')) AS VARCHAR(40)) AS company_name, 
	   CAST(INITCAP(TRIM(REGEXP_REPLACE(contact_name,'\s+',' ','g'))) AS VARCHAR(30)) AS contact_name, 
	   CAST(INITCAP(TRIM(REGEXP_REPLACE(contact_title,'\s+',' ','g'))) AS VARCHAR(30)) AS contact_title, 
	   CAST(INITCAP(TRIM(REGEXP_REPLACE(city,'\s+',' ','g'))) AS VARCHAR(15)) AS city, 
	   CAST(INITCAP(TRIM(REGEXP_REPLACE(country,'\s+',' ','g'))) AS VARCHAR(15)) AS country, 
	   CAST(TRIM(phone) AS VARCHAR(24)) AS phone
FROM {{ source('northwind', 'customers') }}

