import sys

sys.path.append("/home/jovyan/src")

from clientBlobAzure import ClientBlobAzure

def writer(df_orders_enriched):
    # Write the enriched orders DataFrame to a parquet file
    df_orders_enriched.write.mode("overwrite").parquet("/home/jovyan/work/data/tmp/enriched_orders.parquet")
    client = ClientBlobAzure()
    client.putDirectoryToBlob("clean", "TradeCorp/enriched_orders.parquet", "/home/jovyan/work/data/tmp/enriched_orders.parquet")