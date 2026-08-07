SELECT category_name, COUNT(*) AS nb_orders, SUM(sous_total) AS CA
FROM {{ ref('dim_products') }} pr
LEFT OUTER JOIN {{ ref('fac_orders_lines') }} ol ON ol.product_id = pr.product_id
GROUP BY category_name
ORDER BY nb_orders DESC