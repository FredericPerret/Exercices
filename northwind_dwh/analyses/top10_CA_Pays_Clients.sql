SELECT * FROM (
	SELECT RANK() OVER(PARTITION BY CASE WHEN cu.customer_id IS NULL THEN 1 ELSE 2 END ORDER BY COALESCE(SUM(fo.montant_total),0) DESC) AS rang, cu.customer_id, cu.company_name, cu.country, ROUND(COALESCE(SUM(fo.montant_total),0),2) as ca_total, CASE WHEN cu.customer_id IS NULL THEN 1 ELSE 2 END AS ord
	FROM {{ ref('dim_customers') }} cu
	LEFT OUTER JOIN {{ ref('fact_orders') }} fo ON cu.customer_id = fo.customer_id
	GROUP BY GROUPING SETS (
	    (cu.country, cu.customer_id, cu.company_name),
	    (cu.country)
	)
	ORDER BY ord, rang
)
WHERE rang <= 10
