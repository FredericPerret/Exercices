import sys
from os import remove
from pyspark.sql import SparkSession
from pyspark.sql.functions import trim, initcap, upper, col, round, lit, concat

sys.path.append("/home/jovyan/src")

from utils import clean_customers
from clientBlobAzure import ClientBlobAzure

def test_clean_customers():
    spark = SparkSession.builder.appName("TradeCorpETL").getOrCreate()
    csvfile = "/home/jovyan/work/data/tmp/customers.csv"
    client = ClientBlobAzure()
    client.getFileFromBlob("raw", "TradeCorp/customers.csv", csvfile)
    df_raw = spark.read.csv(csvfile, header=True, inferSchema=True)
    df_cleaned = clean_customers(df_raw)
    assert df_cleaned.count() == df_raw.dropDuplicates(["customer_id"]).count()
    df1 = df_cleaned.select("country")
    df2 = df_raw.select("country").withColumn("country", upper(trim("country")))
    assert df1.subtract(df2).count() == 0
    df1 = df_cleaned.select("contact_name")
    df2 = df_raw.select("contact_name").withColumn("contact_name", initcap(trim("contact_name")))
    assert df1.subtract(df2).count() == 0
    remove(csvfile)
