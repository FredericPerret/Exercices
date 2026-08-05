SELECT	empl.employee_id,
		empl.fullname,
		empl.title,
		empl.country,
		stat.ca_total,
		stat.nb_commandes_traitees AS nb_commandes,
		ROUND(stat.ca_total/stat.nb_commandes_traitees,2) AS panier_moyen,
		stat.taux_livraison_a_temps,
		stat.delai_moyen_livraison_jours AS delai_moyen_jours,
		RANK() OVER (ORDER BY stat.ca_total DESC)AS rang,
		CAST(stat.ca_total*100/SUM(stat.ca_total) OVER() AS INTEGER) AS pct_ca_total
FROM {{ ref('stg_employees') }} empl
LEFT OUTER JOIN {{ ref('int_employee_stats') }} stat ON stat.employee_id = empl.employee_id