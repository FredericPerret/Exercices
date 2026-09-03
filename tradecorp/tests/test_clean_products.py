import sys
from pyspark.sql import SparkSession
from pyspark.sql.functions import trim, initcap, upper, col, round, lit, concat

sys.path.append("/home/jovyan/src")

from utils import clean_products
from clientBlobAzure import ClientBlobAzure

def test_clean_products():
    spark = SparkSession.builder.appName("TradeCorpETL").getOrCreate()
    client = ClientBlobAzure()
    client.getFileFromBlob("raw", "TradeCorp/products.csv", "/home/jovyan/work/data/tmp/products.csv")
    df_raw = spark.read.csv("/home/jovyan/work/data/tmp/products.csv", header=True, inferSchema=True)
    df_cleaned = clean_products(df_raw)
    assert df_cleaned.count() == df_raw.count()
    assert df_cleaned.filter(col("en_stock") == True).count() == df_cleaned.filter(col("units_in_stock") > 0).count()