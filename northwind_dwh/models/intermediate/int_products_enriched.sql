SELECT pdt.product_id,
	   pdt.product_name,
	   pdt.unit_price,
	   pdt.units_in_stock,
	   pdt.units_on_order,
	   pdt.discontinued,
	   pdt.en_stock,
	   ctg.category_name,
	   ctg.description AS category_description,
	   sup.company_name AS supplier_name,
	   sup.country AS supplier_country
FROM {{ ref('stg_products') }} pdt
INNER JOIN {{ ref('stg_categories') }} ctg ON ctg.category_id = pdt.category_id
INNER JOIN {{ ref('stg_suppliers') }} sup ON sup.supplier_id = pdt.supplier_id