import sys
from pyspark.sql import SparkSession
from shutil import rmtree

sys.path.append("/home/jovyan/src")

from reader import reader, reader_clean
from transformer import transformer
from writer import writer
from clientBlobAzure import ClientBlobAzure

def test_writer():
    # on se constitue un dataframe pour tester la fonction writer
    spark = SparkSession.builder.appName("TradeCorpETL").getOrCreate()
    dfs_raw, df_country_rate = reader()
    dfs_cleaned, df_orders_enriched = transformer(dfs_raw)
    # exécution de la fonction writer pour écrire le dataframe de test dans un fichier parquet sous Azure Blob Storage
    writer(df_orders_enriched)
    # on récupère le fichier parquet écrit dans Azure Blob Storage et on le lit pour vérifier qu'il est identique au dataframe initial
    parquet_file = "/home/jovyan/work/data/tmp/enriched_orders_ld.parquet"
    client = ClientBlobAzure()
    client.getDirectoryFromBlob("clean", "TradeCorp/enriched_orders.parquet", parquet_file)
    df_orders_enriched_ld = spark.read.parquet(parquet_file)
    assert df_orders_enriched_ld.subtract(df_orders_enriched).count() == 0
    assert df_orders_enriched.subtract(df_orders_enriched_ld).count() == 0
    rmtree(parquet_file)
    reader_clean()