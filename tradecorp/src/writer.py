import sys
from os.path import dirname, abspath

PROJECTDIR = dirname(dirname(abspath(__file__)))
sys.path.append(PROJECTDIR+"/src")

from clientBlobAzure import ClientBlobAzure

def writer():
    # Ecrit le DataFrame dans un fichier parquet local et le charge ensuite dans Azure Blob Storage
    parquet_name = "orders_enriched.parquet"
    tmp_local_parquet = PROJECTDIR + "/data/tmp/clean/" + parquet_name
    client = ClientBlobAzure()
    client.putDirectoryToBlob("clean", "TradeCorp/"+parquet_name, tmp_local_parquet)

if __name__ == "__main__":
    writer()
