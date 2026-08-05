WITH customer_agreg AS (
	SELECT customer_id,
		   COUNT(*) AS nb_commandes,
		   SUM(montant_total) AS ca_total,
		   MIN(order_date) AS date_premiere_commande,
		   MAX(order_date) AS date_derniere_commande
	FROM {{ ref('int_orders_enriched') }}
	GROUP BY customer_id
)
SELECT cu.customer_id,
	   COALESCE(nb_commandes,0) AS nb_commandes,
	   COALESCE(ca_total,0) AS ca_total,
	   date_premiere_commande,
	   date_derniere_commande,
	   CASE WHEN nb_commandes > 1 THEN CAST((date_derniere_commande-date_premiere_commande)/(nb_commandes-1) AS INTEGER)
								  ELSE NULL
	   END AS delai_moyen_entre_commandes
FROM {{ ref('stg_customers') }} cu
LEFT OUTER JOIN customer_agreg ca ON ca.customer_id = cu.customer_id