import sys
sys.path.append("/home/jovyan/src")
from pyspark.sql import SparkSession
from pyspark.sql.functions import col
from enrichment import enrichment

def test_enrichment():
    spark = SparkSession.builder.appName("TestEnrichment").getOrCreate()
    df_orders_enriched = spark.read.parquet("/home/jovyan/work/data/tmp/enriched_orders.parquet")
    df_orders_enriched_rate = enrichment(df_orders_enriched)
    assert df_orders_enriched_rate.count() == df_orders_enriched.count()
    assert df_orders_enriched_rate.filter(col("currency").isNull()).count() == 0
    assert df_orders_enriched_rate.filter(col("sous_total_local").isNull()).count() == 0
