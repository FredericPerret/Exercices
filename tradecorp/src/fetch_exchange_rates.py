import sys
import requests
from os import remove
from os.path import dirname, abspath

PROJECTDIR = dirname(dirname(abspath(__file__)))
sys.path.append(PROJECTDIR+"/src")

from clientBlobAzure import ClientBlobAzure

jsonname = "exchange_rates.json"   
ficjson = PROJECTDIR + "/data/tmp/" + jsonname
response = requests.get('https://api.exchangerate-api.com/v4/latest/USD')
data = response.json()
fd = open(ficjson, "w")
fd.write(str(data))
fd.close()
client = ClientBlobAzure()
client.putFileToBlob("raw", "reference/" + jsonname, ficjson)
remove(ficjson)