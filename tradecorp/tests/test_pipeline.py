import sys
from shutil import rmtree
from pyspark.sql import SparkSession

sys.path.append("/home/jovyan/src")

from reader import reader
from transformer import transformer
from pipeline import pipeline
from clientBlobAzure import ClientBlobAzure

def test_pipeline():
    pipeline()
    client = ClientBlobAzure()
    parquet_dir = "/home/jovyan/work/data/tmp/enriched_orders_ld.parquet"
    client.getDirectoryFromBlob("clean", "TradeCorp/enriched_orders.parquet", parquet_dir)
    spark = SparkSession.builder.appName("TestPipeline").getOrCreate()
    df_orders_enriched = spark.read.parquet(parquet_dir)
    assert df_orders_enriched.count() > 0
    list_col = {"order_id":"int","customer_id":"string","employee_id":"int","product_id":"int","order_date":"date","required_date":"date",\
                "shipped_date":"date","freight":"double","is_shipped":"boolean","prix_unitaire":"double","quantite":"int","discount":"double",\
                    "sous_total":"double","customer_name":"string","customer_country":"string","customer_city":"string","product_name":"string",\
                    "category_name":"string","en_stock":"boolean","full_name":"string","shipper_name":"string","currency":"string","sous_total_local":"double"}
    assert len(df_orders_enriched.columns) == len(list_col)
    for c,type in df_orders_enriched.dtypes:
        assert c in list_col
        assert type == list_col[c]
    rmtree(parquet_dir)