import sys
from pyspark.sql import SparkSession
from os.path import dirname, abspath

PROJECTDIR = dirname(dirname(abspath(__file__)))
sys.path.append(PROJECTDIR+"/src")

from reader import reader

def test_reader():
    reader()
    data_tmp_dir = PROJECTDIR + "/data/tmp"
    spark = SparkSession.builder.appName("TradeCorpETL").getOrCreate()
    for file in ["categories", "products", "orders", "customers", "employees", "order_details", "suppliers", "shippers"]:
        df = spark.read.csv(f"{data_tmp_dir}/raw/{file}.csv", header=True, inferSchema=True)
        assert df.count() > 0
    df_country_rate = spark.read.parquet(f"{data_tmp_dir}/silver/country_rate.parquet")
    assert df_country_rate.count() > 0
    assert df_country_rate.columns == ["country", "currency", "rate"]