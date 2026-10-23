from fastapi import FastAPI, HTTPException
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
    # Barrière qualité
    if len(data.texte) < 20:
        raise HTTPException(
            status_code=400,
            detail="Le texte est trop court pour effectuer une prédiction."
        )
    # Vectorisation du texte
    X = vectorizer.transform([data.texte])
    mots = data.texte.lower().split()
    nb_reconnus = sum(mot in vectorizer.vocabulary_ for mot in mots)
    ratio = nb_reconnus / len(mots)
    if X.nnz < 3 or ratio < 0.2:
        raise HTTPException(
            status_code=422,
            detail="Le modèle ne reconnait pas assez de mots."
        )

    # Prédiction du réseau
    proba = float(modele.predict(X, verbose=0)[0][0])

    # Passage probabilité → classe
    # Le modèle est-il suffisamment sûr de son choix ?
    if 0.1 < proba < 0.9:
        raise HTTPException(
            status_code=422,
            detail=f"Prédiction trop incertaine, probabilité = {int(proba*100)}%."
        )
    if proba > 0.5:
        classe = "horreur"
    else:
        classe = "comédie"

    return {"prediction": classe}