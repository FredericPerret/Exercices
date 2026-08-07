Welcome to your new dbt project!

### Using the starter project

Try running the following commands:
- dbt run
- dbt test


### Resources:
- Learn more about dbt [in the docs](https://docs.getdbt.com/docs/introduction)
- Check out [Discourse](https://discourse.getdbt.com/) for commonly asked questions and answers
- Join the [chat](https://community.getdbt.com/) on Slack for live discussions and support
- Find [dbt events](https://events.getdbt.com) near you
- Check out [the blog](https://blog.getdbt.com/) for the latest news on dbt's development and best practices

psql -U dbt_user -d northwind
northwind=> insert into categories (category_name, description) values ('Antipasti', 'Que buono');
ERREUR:  droit refusé pour la table categories

Lorsqu'on effectue dbt build --select <model>+
cela signifie : Inclure le modèle sélectionné ainsi que tous ses descendants

dt build :
14:02:48  Finished running 8 table models, 99 data tests, 14 view models in 0 hours 0 minutes and 7.89 seconds (7.89s).
14:02:48
14:02:48  Completed successfully
14:02:48
14:02:48  Done. PASS=121 WARN=0 ERROR=0 SKIP=0 NO-OP=0 REUSED=0 TOTAL=121

Q23g :
```SQL
CREATE VIEW dbt_dev.v_score_client AS (
SELECT  cu.company_name,
		SUM(fo.montant_total) OVER (PARTITION BY cu.company_name ORDER BY fo.order_date ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS ca_cumule,
		ROUND(100 * fo.montant_total / SUM(fo.montant_total) OVER(PARTITION BY cu.company_name),1) AS pct_CA_total_client,
		RANK() OVER(PARTITION BY cu.company_name ORDER BY fo.montant_total DESC) AS rang
FROM dbt_dev.dim_customers cu
LEFT OUTER JOIN dbt_dev.fact_orders fo ON cu.customer_id = fo.customer_id
ORDER BY company_name, rang
)
```