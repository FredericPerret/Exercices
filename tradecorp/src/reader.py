import sys
from os import remove
from pyspark.sql import SparkSession
from pyspark.sql.functions import create_map, lit, col, explode

sys.path.append("/home/jovyan/src")

from clientBlobAzure import ClientBlobAzure

def reader():
    # Lit tous les csv du conteneur raw et les stocke dans un dictionnaire de dataframes
    # lit également les fichiers de référence country_currency.csv et exchange_rates.json pour construire
    # le dataframe df_country_rate avec les colonnes country, currency et rate (taux de change par rapport au dollar)
    spark = SparkSession.builder.appName("TradeCorpETL").getOrCreate()
    dfs_raw = {}
    data_tmp_dir = "/home/jovyan/work/data/tmp"
    client = ClientBlobAzure()
    client.getFileFromBlob("raw", "reference/country_currency.csv", f"{data_tmp_dir}/country_currency.csv")
    client.getFileFromBlob("raw", "reference/exchange_rates.json", f"{data_tmp_dir}/exchange_rates.json")
    # Load the country currency data
    df_country_currency = spark.read.csv(f"{data_tmp_dir}/country_currency.csv", header=True, inferSchema=True)
    df_currency_exchange_rate = spark.read.json(f"{data_tmp_dir}/exchange_rates.json")
    rate_fields = df_currency_exchange_rate.schema["rates"].dataType.fieldNames()
    rates_map = create_map(*[x for field in rate_fields for x in (lit(field), col(f"rates.{field}"))])
    df_rates = df_currency_exchange_rate.select(explode(rates_map).alias("currency", "rate"))
    df_country_rate = df_country_currency.join(df_rates, on="currency", how="left").select("country", "currency", "rate")
    # Load raw data files
    for file in ["categories", "products", "orders", "customers", "employees", "order_details", "suppliers", "shippers"]:
        client.getFileFromBlob("raw", f"TradeCorp/{file}.csv", f"{data_tmp_dir}/{file}.csv")
        dfs_raw[file] = spark.read.csv(f"{data_tmp_dir}/{file}.csv", header=True, inferSchema=True)
    # A ce stade on ne peut pas effacer les fichiers csv du répertoire data_tmp_dir car spark n'a pas encore réellement exécuté la commande,
    # en attente d'une action sur les dataframes
    return dfs_raw, df_country_rate

def reader_clean():
    # efface tous les fichiers du répertoire data_tmp_dir lus par reader
    # ne peut être exécutée qu'après toutes les actions sur les dataframes
    data_tmp_dir = "/home/jovyan/work/data/tmp"
    for file in ["categories", "products", "orders", "customers", "employees", "order_details", "suppliers", "shippers"]:
        remove(f"{data_tmp_dir}/{file}.csv")
    remove (f"{data_tmp_dir}/country_currency.csv")
    remove (f"{data_tmp_dir}/exchange_rates.json")