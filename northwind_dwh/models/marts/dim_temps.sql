SELECT	DISTINCT order_date AS date_id,
		EXTRACT(DAY FROM order_date) AS jour,
		EXTRACT(MONTH FROM order_date) AS mois,
		EXTRACT(YEAR FROM order_date) AS annee,
		EXTRACT(QUARTER FROM order_date) AS trimestre,
		TO_CHAR(order_date, 'YYYY_MM') AS annee_mois,
		EXTRACT(ISODOW FROM order_date) IN (6, 7) AS est_weekend
FROM {{ ref('stg_orders') }}
ORDER BY date_id