SELECT
    od.order_id,
    od.product_id,
    o.customer_id,
    o.employee_id,
    o.ship_via,
    o.order_date,
    od.quantity,
    od.unit_price,
    od.discount,
    od.sous_total
FROM {{ ref('stg_order_details') }} od
JOIN {{ ref('stg_orders') }} o ON od.order_id = o.order_id