SELECT order_id
FROM {{ ref('fact_orders') }} fo
LEFT OUTER JOIN {{ ref('dim_temps') }} dt ON dt.date_id = fo.order_date
WHERE dt.date_id IS NULL