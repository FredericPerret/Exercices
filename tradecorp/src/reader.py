import sys
from os.path import dirname, abspath

PROJECTDIR = dirname(dirname(abspath(__file__)))
sys.path.append(PROJECTDIR+"/src")

from clientBlobAzure import ClientBlobAzure

def reader():
    # Lit tous les csv du conteneur raw
    # lit également les fichiers de référence country_currency.csv et exchange_rates.json
    data_tmp_raw_dir = PROJECTDIR + "/data/tmp/raw"
    client = ClientBlobAzure()
    # Load raw data files
    client.getFileFromBlob("raw", "reference/country_currency.csv", f"{data_tmp_raw_dir}/country_currency.csv")
    client.getFileFromBlob("raw", "reference/exchange_rates.json", f"{data_tmp_raw_dir}/exchange_rates.json")
    for file in ["categories", "products", "orders", "customers", "employees", "order_details", "suppliers", "shippers"]:
        client.getFileFromBlob("raw", f"TradeCorp/{file}.csv", f"{data_tmp_raw_dir}/{file}.csv")

if __name__ == "__main__":
    reader()