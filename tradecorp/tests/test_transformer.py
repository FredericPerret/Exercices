import sys
from pyspark.sql import SparkSession

sys.path.append("/home/jovyan/src")

from reader import reader
from transformer import transformer

def test_transformer():
    reader()
    transformer()
    data_tmp_dir = "/home/jovyan/work/data/tmp"
    spark = SparkSession.builder.appName("TradeCorpETL").getOrCreate()
    df_orders_enriched = spark.read.parquet(f"{data_tmp_dir}/clean/orders_enriched.parquet")
    list_col = {"order_id":"int","customer_id":"string","employee_id":"int","product_id":"int","order_date":"date","required_date":"date",\
                "shipped_date":"date","freight":"double","is_shipped":"boolean","prix_unitaire":"double","quantite":"int","discount":"double",\
                "sous_total":"double","customer_name":"string","customer_country":"string","customer_city":"string","product_name":"string",\
                "category_name":"string","en_stock":"boolean","full_name":"string","shipper_name":"string","currency":"string","sous_total_local":"double"}
    assert set(df_orders_enriched.columns) == set(list_col.keys())
    assert df_orders_enriched.count() > 0
    for c,type in df_orders_enriched.dtypes:
        assert type == list_col[c]
