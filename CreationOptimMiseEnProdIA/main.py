from fastapi import FastAPI
from pydantic import BaseModel
from keras.models import load_model
from joblib import load
from pathlib import Path
import json

MODEL_DIR = Path("model")

app = FastAPI()

# Chargement une seule fois au démarrage
modele = load_model("model/modele.keras")
vectorizer = load("model/vectorizer.joblib")

# Structure des données reçues par /predict
class PredictionRequest(BaseModel):
    texte: str


@app.get("/health")
def health():
    with open(MODEL_DIR / "metrics.json", "r", encoding="utf-8") as f:
        metrics = json.load(f)
    return {"status": "ok", "version": metrics["version"]}


@app.post("/predict")
def predict(data: PredictionRequest):
    # Vectorisation du texte
    X = vectorizer.transform([data.texte])

    # Prédiction du réseau
    proba = modele.predict(X, verbose=0)[0][0]

    # Passage probabilité → classe
    prediction = int(proba >= 0.5)

    return {
        "prediction": prediction
    }