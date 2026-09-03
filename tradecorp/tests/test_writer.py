import sys
from pyspark.sql import SparkSession

sys.path.append("/home/jovyan/src")

from reader import reader
from transformer import transformer
from writer import writer
from utils import ClientBlobAzure

def test_writer():
    spark = SparkSession.builder.appName("TradeCorpETL").getOrCreate()
    dfs_raw = reader()
    dfs_cleaned, df_orders_enriched = transformer(dfs_raw)
    writer(df_orders_enriched)
    client = ClientBlobAzure()
    client.getDirectoryFromBlob("clean", "TradeCorp/enriched_orders.parquet", "/home/jovyan/work/data/tmp/enriched_orders_ld.parquet")
    df_orders_enriched_ld = spark.read.parquet("/home/jovyan/work/data/tmp/enriched_orders_ld.parquet")
    assert df_orders_enriched_ld.subtract(df_orders_enriched).count() == 0
    assert df_orders_enriched.subtract(df_orders_enriched_ld).count() == 0