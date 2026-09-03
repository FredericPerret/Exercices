import sys
import requests

sys.path.append("/home/jovyan/src")

from clientBlobAzure import ClientBlobAzure

ficjson = "/home/jovyan/work/data/tmp/exchange_rates.json"
response = requests.get('https://api.exchangerate-api.com/v4/latest/USD')
data = response.json()
fd = open(ficjson, "w")
fd.write(str(data))
fd.close()
client = ClientBlobAzure()
client.putFileToBlob("raw", "reference/exchange_rates.json", ficjson)