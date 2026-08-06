SELECT order_id
FROM {{ ref('fact_orders') }}
WHERE montant_total_avec_frais < montant_total