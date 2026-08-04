SELECT employee_id,
	   CAST(INITCAP(TRIM(REGEXP_REPLACE(CONCAT(first_name,' ',last_name),'\s+',' ','g'))) AS VARCHAR(32)) AS fullname,
	   CAST(INITCAP(TRIM(REGEXP_REPLACE(title,'\s+',' ','g'))) AS VARCHAR(30)) AS title, 
	   hire_date,
	   CAST(INITCAP(TRIM(REGEXP_REPLACE(city,'\s+',' ','g'))) AS VARCHAR(15)) AS city, 
	   CAST(INITCAP(TRIM(REGEXP_REPLACE(country,'\s+',' ','g'))) AS VARCHAR(15)) AS country
FROM {{ source('northwind', 'employees') }}