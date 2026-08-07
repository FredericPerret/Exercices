SELECT RANK() OVER(ORDER BY AVG(fo.delai_livraison_jours)) as classement, sh.shipper_id, sh.company_name, ROUND(AVG(fo.delai_livraison_jours),1) as delai_moyen_livraison
FROM {{ ref('dim_shippers') }} sh
LEFT OUTER JOIN {{ ref('fact_orders') }} fo ON sh.shipper_id = fo.ship_via
GROUP BY sh.shipper_id, sh.company_name
ORDER BY delai_moyen_livraison  