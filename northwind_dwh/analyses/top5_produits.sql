SELECT DENSE_RANK() OVER(ORDER BY SUM(quantity) DESC) AS rang, product_name, category_name, SUM(quantity) AS quantite, SUM(sous_total) AS CA
FROM {{ ref('dim_products') }} pr
LEFT OUTER JOIN {{ ref('fac_orders_lines') }} ol ON ol.product_id = pr.product_id
GROUP BY product_name, category_name
ORDER BY rang
LIMIT 5