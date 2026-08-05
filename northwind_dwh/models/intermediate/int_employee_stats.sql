SELECT employee_id,
	   COUNT(*) AS nb_commandes_traitees,
	   SUM(montant_total) AS ca_total,
	   CAST(AVG(CAST(is_on_time AS INTEGER))*100 AS INTEGER) AS taux_livraison_a_temps,
	   ROUND(AVG(delai_livraison_jours),1) AS delai_moyen_livraison_jours
FROM {{ ref('int_orders_enriched') }}
GROUP BY employee_id