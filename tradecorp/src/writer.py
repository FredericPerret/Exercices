import sys
from shutil import rmtree

sys.path.append("/home/jovyan/src")

from clientBlobAzure import ClientBlobAzure

def writer(df_orders_enriched):
    # Ecrit le DataFrame dans un fichier parquet local et le charge ensuite dans Azure Blob Storage
    parquet_name = "enriched_orders.parquet"
    tmp_local_parquet = "/home/jovyan/work/data/tmp/" + parquet_name
    df_orders_enriched.write.mode("overwrite").parquet(tmp_local_parquet)
    client = ClientBlobAzure()
    client.putDirectoryToBlob("clean", "TradeCorp/"+parquet_name, tmp_local_parquet)
    # A ce stade, on peut supprimer le fichier parquet local
    rmtree(tmp_local_parquet)