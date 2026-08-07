SELECT	DENSE_RANK() OVER(ORDER BY SUM(fo.montant_total) DESC) AS rang, 
		cu.country, 
		SUM(fo.montant_total) AS CA_total,
		ROUND(SUM(fo.montant_total)*100/SUM(SUM(fo.montant_total)) OVER(),1) AS pct_CA_mondial,
		COUNT(*) AS nb_commandes, 
		ROUND(AVG(fo.montant_total),2) AS panier_moyen
FROM {{ ref('dim_customers') }} cu
LEFT JOIN {{ ref('fact_orders') }} fo ON fo.customer_id = cu.customer_id
GROUP BY cu.country