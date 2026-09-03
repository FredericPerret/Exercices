from pyspark.sql import SparkSession
from pyspark.sql.functions import create_map, lit, col, explode, round

def enrichment(df):
    # le dataframe en entrée est supposé avoir au moins les colonnes suivantes : sous_total, customer_country
    # en sortie on lui rajoute sous_total_local et currency, avec sous_total_local = sous_total * rate,
    # rate étant le taux de change du pays du client par rapport au dollar lu via l'API https://api.exchangerate-api.com/v4/latest/USD (exchange_rates.json)
    # complété par la correspondance pays - devise lu dans country_currency.csv
    spark = SparkSession.builder.appName("TradeCorpETL").getOrCreate()
    # Load the country currency data
    df_country_currency = spark.read.csv("/home/jovyan/data/tmp/country_currency.csv", header=True, inferSchema=True)
    df_currency_exchange_rate = spark.read.json("/home/jovyan/data/tmp/exchange_rates.json")
    rate_fields = df_currency_exchange_rate.schema["rates"].dataType.fieldNames()
    rates_map = create_map(*[x for field in rate_fields for x in (lit(field), col(f"rates.{field}"))])
    df_rates = df_currency_exchange_rate.select(explode(rates_map).alias("currency", "rate"))
    df_country_rate = df_country_currency.join(df_rates, on="currency", how="left").select("country", "currency", "rate").withColumnRenamed("country", "customer_country")
    # Enrich the dataframe with the local subtotal
    return df.join(df_country_rate,on="customer_country",how="left").withColumn("sous_total_local",round(col("sous_total")*col("rate"), 2)).drop("rate")
