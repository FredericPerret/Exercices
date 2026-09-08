import sys
from pyspark.sql import SparkSession
from pyspark.sql.functions import create_map, lit, col, explode
from os.path import dirname, abspath

PROJECTDIR = dirname(dirname(abspath(__file__)))
sys.path.append(PROJECTDIR+"/src")

from utils import clean_customers, clean_orders, clean_order_details, clean_employees, clean_products, build_enriched
from enrichment import enrichment

def transformer():
    data_tmp_dir = PROJECTDIR + "/data/tmp"
    spark = SparkSession.builder.appName("TradeCorpETL").getOrCreate()

    # Load and transform the country currency data
    df_country_currency = spark.read.csv(f"{data_tmp_dir}/raw/country_currency.csv", header=True, inferSchema=True)
    df_currency_exchange_rate = spark.read.json(f"{data_tmp_dir}/raw/exchange_rates.json")
    rate_fields = df_currency_exchange_rate.schema["rates"].dataType.fieldNames()
    rates_map = create_map(*[x for field in rate_fields for x in (lit(field), col(f"rates.{field}"))])
    df_rates = df_currency_exchange_rate.select(explode(rates_map).alias("currency", "rate"))
    df_country_rate = df_country_currency.join(df_rates, on="currency", how="left").select("country", "currency", "rate")
    df_country_rate.write.mode("overwrite").parquet(f"{data_tmp_dir}/silver/country_rate.parquet")

    # clean the raw dataframes:
    dfs_cleaned = {}
    df = spark.read.csv(f"{data_tmp_dir}/raw/customers.csv", header=True, inferSchema=True)
    dfs_cleaned["customers"] = clean_customers(df)
    df = spark.read.csv(f"{data_tmp_dir}/raw/orders.csv", header=True, inferSchema=True)
    dfs_cleaned["orders"] = clean_orders(df)
    df = spark.read.csv(f"{data_tmp_dir}/raw/order_details.csv", header=True, inferSchema=True)
    dfs_cleaned["order_details"] = clean_order_details(df)
    df = spark.read.csv(f"{data_tmp_dir}/raw/employees.csv", header=True, inferSchema=True)
    dfs_cleaned["employees"] = clean_employees(df)
    df = spark.read.csv(f"{data_tmp_dir}/raw/products.csv", header=True, inferSchema=True)
    dfs_cleaned["products"] = clean_products(df)
    dfs_cleaned["categories"] = spark.read.csv(f"{data_tmp_dir}/raw/categories.csv", header=True, inferSchema=True)
    dfs_cleaned["suppliers"] = spark.read.csv(f"{data_tmp_dir}/raw/suppliers.csv", header=True, inferSchema=True)
    dfs_cleaned["shippers"] = spark.read.csv(f"{data_tmp_dir}/raw/shippers.csv", header=True, inferSchema=True)

    # build the enriched dataframe:
    df_orders_enriched = build_enriched(dfs_cleaned)
    df_orders_enriched = enrichment(df_orders_enriched, df_country_rate)
    df_orders_enriched.write.mode("overwrite").parquet(f"{data_tmp_dir}/clean/orders_enriched.parquet")

if __name__ == "__main__":
    transformer()
