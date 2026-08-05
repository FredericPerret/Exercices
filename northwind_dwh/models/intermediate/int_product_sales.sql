SELECT	pd.product_id,
		CAST(COALESCE(SUM(od.quantity),0) AS SMALLINT) AS quantite_totale_vendue,
		COALESCE(SUM(od.sous_total),0) AS ca_genere,
		CAST(COALESCE(COUNT(DISTINCT od.order_id),0) AS SMALLINT) AS nb_commandes_distinctes,
		pd.units_in_stock AS stock_restant
FROM {{ ref('stg_products') }} pd
LEFT OUTER JOIN {{ ref('stg_order_details') }} od ON od.product_id = pd.product_id
GROUP BY pd.product_id, pd.units_in_stock