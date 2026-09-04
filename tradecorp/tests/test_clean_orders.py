import sys
from os import remove
from pyspark.sql import SparkSession
from pyspark.sql.functions import trim, initcap, upper, col, round, lit, concat

sys.path.append("/home/jovyan/src")

from utils import clean_orders
from clientBlobAzure import ClientBlobAzure

def test_clean_orders():
    spark = SparkSession.builder.appName("TradeCorpETL").getOrCreate()
    csvfile = "/home/jovyan/work/data/tmp/orders.csv"
    client = ClientBlobAzure()
    client.getFileFromBlob("raw", "TradeCorp/orders.csv", csvfile)
    df_raw = spark.read.csv(csvfile, header=True, inferSchema=True)
    df_cleaned = clean_orders(df_raw)
    assert df_cleaned.count() == df_raw.filter(col("shipped_date").isNotNull()).count()
    df1 = df_cleaned.select("shipper_id")
    df2 = df_raw.select("ship_via").withColumnRenamed("ship_via", "shipper_id")
    assert df1.subtract(df2).count() == 0
    assert df_cleaned.filter(col("is_shipped") == True).count() == df_raw.filter(col("shipped_date").isNotNull()).count()
    remove(csvfile)