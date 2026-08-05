SELECT	*,
		CAST(montant_total+freight AS NUMERIC(10,2)) AS montant_total_avec_frais
FROM {{ ref('int_orders_enriched') }}