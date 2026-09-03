import sys
from pyspark.sql import SparkSession

sys.path.append("/home/jovyan/src")

from utils import ClientBlobAzure

def reader():
    spark = SparkSession.builder.appName("TradeCorpETL").getOrCreate()
    dfs_raw = {}
    client = ClientBlobAzure()
    for file in ["categories", "products", "orders", "customers", "employees", "order_details", "suppliers", "shippers"]:
        client.getFileFromBlob("raw", f"TradeCorp/{file}.csv", f"/home/jovyan/work/data/tmp/{file}.csv")
        dfs_raw[file] = spark.read.csv(f"/home/jovyan/work/data/tmp/{file}.csv", header=True, inferSchema=True)
    return dfs_raw
