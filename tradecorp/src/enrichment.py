from pyspark.sql.functions import round, col

def enrichment(df, df_country_rate):
    # le dataframe en entrée est supposé avoir au moins les colonnes suivantes : sous_total, customer_country
    # en sortie on lui rajoute sous_total_local et currency, avec sous_total_local = sous_total * rate,
    # rate étant le taux de change du pays du client par rapport au dollar lu dans df_country_rate (colonnes country, currency, rate)
    return df.join(df_country_rate.withColumnRenamed("country", "customer_country"),on="customer_country",how="left").withColumn("sous_total_local",round(col("sous_total")*col("rate"), 2)).drop("rate")
