WITH CA_mensuel AS (
	SELECT TO_CHAR(order_date,'YYYY-MM') AS mois, SUM(montant_total) AS CA_mensuel
	FROM {{ ref('fact_orders') }}
	GROUP BY mois
)
SELECT	mois, CA_mensuel, 
		ROUND((CA_mensuel - LAG(CA_mensuel) OVER(ORDER BY mois))/LAG(CA_mensuel,1,CA_mensuel) OVER(ORDER BY mois)*100,1) AS variation_mensuelle,
		ROUND((CA_mensuel - LAG(CA_mensuel,12) OVER(ORDER BY mois))/LAG(CA_mensuel,12,CA_mensuel) OVER(ORDER BY mois)*100,1) AS variation_annuelle
FROM CA_mensuel 
ORDER BY mois
