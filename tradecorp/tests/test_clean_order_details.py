import sys
from os import remove
from pyspark.sql import SparkSession
from pyspark.sql.functions import trim, initcap, upper, col, round, lit, concat

sys.path.append("/home/jovyan/src")

from utils import clean_order_details
from clientBlobAzure import ClientBlobAzure

def test_clean_order_details():
    spark = SparkSession.builder.appName("TradeCorpETL").getOrCreate()
    csvfile = "/home/jovyan/work/data/tmp/order_details.csv"
    client = ClientBlobAzure()
    client.getFileFromBlob("raw", "TradeCorp/order_details.csv", csvfile)
    df_raw = spark.read.csv(csvfile, header=True, inferSchema=True)
    df_cleaned = clean_order_details(df_raw)
    df1 = df_cleaned.select("prix_unitaire")
    df2 = df_raw.select("unit_price").withColumnRenamed("unit_price", "prix_unitaire")
    assert df1.subtract(df2).count() == 0
    df1 = df_cleaned.select("quantite")
    df2 = df_raw.select("quantity").withColumnRenamed("quantity", "quantite")
    assert df1.subtract(df2).count() == 0
    assert df_cleaned.filter(col("sous_total") == round(col("prix_unitaire")*col("quantite")*(1-col("discount")),2)).count() == df_cleaned.count()
    remove(csvfile)