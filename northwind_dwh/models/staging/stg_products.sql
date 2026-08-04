
SELECT product_id,
	   CAST(TRIM(REGEXP_REPLACE(product_name,'\s+',' ','g')) AS VARCHAR(40)) AS product_name,
	   supplier_id,
	   category_id,
	   CAST(TRIM(REGEXP_REPLACE(quantity_per_unit,'\s+',' ','g')) AS VARCHAR(20)) AS quantity_per_unit,
	   unit_price::numeric(10,2) AS unit_price,
	   units_in_stock,
	   (units_in_stock > 0) AS en_stock,
	   units_on_order,
	   CAST(discontinued AS BOOLEAN) AS discontinued
FROM {{ source('northwind', 'products') }}