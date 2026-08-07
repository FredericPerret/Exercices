SELECT * FROM (
	SELECT	cu.company_name,
			ROW_NUMBER() OVER(PARTITION BY cu.company_name ORDER BY SUM(fo.montant_total) DESC) as rang_CA,
			dt.annee_mois,
			SUM(fo.montant_total) AS ca
	FROM {{ ref('dim_customers') }} cu
	LEFT JOIN {{ ref('fact_orders') }} fo ON fo.customer_id = cu.customer_id
	LEFT JOIN {{ ref('dim_temps') }} dt ON dt.date_id = fo.order_date
	GROUP BY cu.company_name, dt.annee_mois
) WHERE rang_CA <= 3
ORDER BY company_name, rang_CA