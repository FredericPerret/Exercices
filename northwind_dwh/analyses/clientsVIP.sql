SELECT * FROM (
	SELECT	DISTINCT cu.company_name,
			ROUND(100*SUM(fo.montant_total) OVER(PARTITION BY FO.customer_id) / SUM(fo.montant_total) OVER(),1) AS pct_ca_total
	FROM {{ ref('dim_customers') }} cu
	LEFT JOIN {{ ref('fact_orders') }} fo ON fo.customer_id = cu.customer_id
) WHERE pct_ca_total > 2
ORDER BY pct_ca_total DESC