from pymongo import MongoClient
import uuid
from datetime import datetime
import random
import json

client_mongo = MongoClient("mongodb://mongodb:mongodb@localhost:27017")

db = client_mongo["catalogue_films"]

clients = list(db["clients"].find())
filmsLivres = list(db["FilmsLivres"].find())

client = random.choice(clients)
filmLivre = random.choice(filmsLivres)

commande = {
    "order_id": str(uuid.uuid4()),
    "order_date": datetime.now().isoformat(),
    "id_client": client["_id"],
    "id_movieBook": filmLivre["_id"],
    "type": filmLivre["type"],
    "title": filmLivre["title"],
    "price": 7.99
}
commande_json = json.dumps(commande)
print(commande_json)

from azure.eventhub import EventHubProducerClient, EventData, TransportType

CONNECTION_STRING = "Endpoint=sb://fredeventhub.servicebus.windows.net/;SharedAccessKeyName=RootManageSharedAccessKey;SharedAccessKey=xxxx"
EVENT_HUB_NAME = "commandes"

producer = EventHubProducerClient.from_connection_string(
    conn_str=CONNECTION_STRING,
    eventhub_name=EVENT_HUB_NAME,
    transport_type=TransportType.AmqpOverWebsocket
)
try:
    batch = producer.create_batch()

    batch.add(EventData(commande_json))

    producer.send_batch(batch)

    print("Connexion OK - commande envoyée !")

finally:
    producer.close()