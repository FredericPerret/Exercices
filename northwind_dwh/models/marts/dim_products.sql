SELECT	*,
		CASE
			WHEN unit_price < 20 THEN 'Entrée de gamme'
			WHEN unit_price < 50 THEN 'Milieu de gamme'
			ELSE 'Premium'
		END AS gamme
FROM {{ ref('int_products_enriched') }}