WITH lignes_cmd AS (
	SELECT order_id,
		   COUNT(*) AS nb_articles,
		   SUM(quantity) AS quantite_total,
		   SUM(sous_total) AS montant_total
	FROM {{ ref('stg_order_details') }}
	GROUP BY order_id
)
SELECT cmd.order_id,
	   cmd.customer_id,
	   cmd.employee_id,
	   cmd.ship_via,
	   cmd.order_date,
	   cmd.required_date,
	   cmd.shipped_date,
	   cmd.ship_city,
	   cmd.ship_country,
	   cmd.freight,
	   cmd.is_shipped,
	   cmd.required_date >= cmd.shipped_date AS is_on_time, -- si shipped_date NULL : on veut is_on_time à False
	   shipped_date - order_date AS delai_livraison_jours,
	   lignes_cmd.nb_articles,
	   lignes_cmd.quantite_total,
	   lignes_cmd.montant_total
FROM {{ ref('stg_orders') }} cmd
INNER JOIN lignes_cmd ON lignes_cmd.order_id = cmd.order_id