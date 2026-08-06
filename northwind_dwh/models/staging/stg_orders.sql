
SELECT order_id, 
	   CAST(UPPER(customer_id) AS VARCHAR(5)) AS customer_id, 
	   employee_id, 
	   order_date, 
	   required_date, 
	   shipped_date,
	   CASE WHEN shipped_date IS NULL THEN False ELSE True END AS is_shipped,
	   ship_via,
	   freight,
	   CAST(INITCAP(TRIM(REGEXP_REPLACE(ship_city,'\s+',' ','g'))) AS VARCHAR(15)) AS ship_city,
	   CAST(INITCAP(TRIM(REGEXP_REPLACE(ship_country,'\s+',' ','g'))) AS VARCHAR(15)) AS ship_country
FROM {{ source('northwind', 'orders') }}

