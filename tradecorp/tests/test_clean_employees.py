import sys
from pyspark.sql import SparkSession
from pyspark.sql.functions import trim, initcap, upper, col, round, lit, concat

sys.path.append("/home/jovyan/src")

from utils import clean_employees
from clientBlobAzure import ClientBlobAzure

def test_clean_employees():
    spark = SparkSession.builder.appName("TradeCorpETL").getOrCreate()
    client = ClientBlobAzure()
    client.getFileFromBlob("raw", "TradeCorp/employees.csv", "/home/jovyan/work/data/tmp/employees.csv")
    df_raw = spark.read.csv("/home/jovyan/work/data/tmp/employees.csv", header=True, inferSchema=True)
    df_cleaned = clean_employees(df_raw)
    assert df_cleaned.count() == df_raw.count()
    assert len(df_cleaned.columns) == 8
    assert df_cleaned.filter(col("full_name") == concat(col("first_name"), lit(" "), col("last_name"))).count() == df_cleaned.count()