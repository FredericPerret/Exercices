import sys
from pyspark.sql.functions import col

sys.path.append("/home/jovyan/src")

from reader import reader
from transformer import transformer

def test_transformer():
    dfs_raw = reader()
    dfs_cleaned, df_orders_enriched = transformer(dfs_raw)
    assert df_orders_enriched.count() == dfs_cleaned["order_details"].join(dfs_cleaned["orders"], on="order_id", how="inner").count()
    list_col = {"order_id":"int","customer_id":"string","employee_id":"int","product_id":"int","order_date":"date","required_date":"date",\
                "shipped_date":"date","freight":"double","is_shipped":"boolean","prix_unitaire":"double","quantite":"int","discount":"double",\
                "sous_total":"double","customer_name":"string","customer_country":"string","customer_city":"string","product_name":"string",\
                "category_name":"string","en_stock":"boolean","full_name":"string","shipper_name":"string"}
    assert len(df_orders_enriched.columns) == len(list_col)
    for c,type in df_orders_enriched.dtypes:
        assert c in list_col
        assert type == list_col[c]
