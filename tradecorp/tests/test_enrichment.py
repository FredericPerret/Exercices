import sys
from shutil import rmtree
sys.path.append("/home/jovyan/src")
from pyspark.sql import SparkSession
from pyspark.sql.functions import col, round
from enrichment import enrichment
from clientBlobAzure import ClientBlobAzure

def test_enrichment():
    spark = SparkSession.builder.appName("TestEnrichment").getOrCreate()
    parquet_dir = "/home/jovyan/work/data/tmp/enriched_orders_ld.parquet"
    client = ClientBlobAzure()
    client.getDirectoryFromBlob("clean", "TradeCorp/enriched_orders.parquet", parquet_dir)
    df_orders_enriched = spark.read.parquet(parquet_dir)
    df_orders_enriched = df_orders_enriched.drop("currency", "sous_total_local")  # Drop the columns to test enrichment
    countries = [row.customer_country for row in df_orders_enriched.select("customer_country").distinct().collect()]
    taux_test = 1.1 # le même taux de change pour tous les pays pour simplifier le test
    currencies = ["CHOC"] * len(countries) # la même devise en chocolat pour tous les pays !
    rates = [taux_test] * len(countries)
    data = list(zip(countries, currencies, rates))
    df_country_rate = spark.createDataFrame(data, ["country", "currency", "rate"])
   # Create a DataFrame for the country rates
    df_orders_enriched_rate = enrichment(df_orders_enriched, df_country_rate)
    assert df_orders_enriched_rate.count() == df_orders_enriched.count()
    assert df_orders_enriched_rate.filter(col("currency").isNull()).count() == 0
    assert df_orders_enriched_rate.filter(col("sous_total_local").isNull()).count() == 0
    assert df_orders_enriched_rate.filter(col("sous_total_local") != round(col("sous_total")*taux_test ,2)).count() == 0
    rmtree(parquet_dir)
