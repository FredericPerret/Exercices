
SELECT order_id,
	   product_id,
	   unit_price::numeric(10,2) AS unit_price,
	   quantity,
	   discount::numeric(3,2) AS discount,
	   ROUND(unit_price::numeric*quantity::numeric*(1::numeric-discount::numeric),2)::numeric(10,2) AS sous_total
FROM {{ source('northwind', 'order_details') }}