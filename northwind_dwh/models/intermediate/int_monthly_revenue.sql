WITH orders_agreg AS (
	SELECT	CAST(TO_CHAR(DATE_TRUNC('MONTH',order_date),'YYYY-MM') AS CHAR(7)) AS mois,
			COUNT(*) AS nb_commandes,
			SUM(montant_total) AS ca_mensuel
	FROM {{ ref('int_orders_enriched') }}
	GROUP BY mois
)
SELECT	mois,
		nb_commandes,
		ca_mensuel,
		ROUND(ca_mensuel/nb_commandes,2) AS panier_moyen,
		LAG(ca_mensuel) OVER(ORDER BY mois) AS ca_mois_precedent,
		CAST((ca_mensuel - LAG(ca_mensuel) OVER (ORDER BY mois))/LAG(ca_mensuel,1,ca_mensuel) OVER (ORDER BY mois)*100 AS INTEGER) AS variation_pct
FROM orders_agreg