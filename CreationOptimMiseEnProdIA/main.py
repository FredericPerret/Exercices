from fastapi import FastAPI, HTTPException
from pydantic import BaseModel
from keras.models import load_model
from joblib import load
from pathlib import Path
import json
import yaml

MODEL_DIR = Path("model")

app = FastAPI()

# Chargement une seule fois au démarrage
modele = load_model("model/modele.keras")
vectorizer = load("model/vectorizer.joblib")
with open("config.yml", "r", encoding="utf-8") as fichier:
    config = yaml.safe_load(fichier)

# Structure des données reçues par /predict
class PredictionRequest(BaseModel):
    texte: str

@app.get("/health")
def health():
    with open(MODEL_DIR / "metrics.json", "r", encoding="utf-8") as f:
        metrics = json.load(f)
    erreurs = []
    if metrics["f1_test"] < config["modele"]["f1_test_min"]:
        erreurs.append("F1 insuffisant")
    if metrics["taille_test"] < config["modele"]["taille_test_min"]:
        erreurs.append("échantillon de test insuffisant")
    if erreurs:
        raise HTTPException(
            status_code=503, # service non disponible/non conforme
            detail={
                "status": "ko",
                "version": metrics["version"],
                "erreurs": erreurs
            }
        )
    return {"status": "ok", "version": metrics["version"]}


@app.post("/predict")
def predict(data: PredictionRequest):
    # Barrière qualité
    if len(data.texte) < config["barriere"]["taille_min_texte"]:
        raise HTTPException(
            status_code=400, # Bad Request
            detail="Le texte est trop court pour effectuer une prédiction."
        )
    # Vectorisation du texte
    X = vectorizer.transform([data.texte])
    mots = data.texte.lower().split()
    nb_reconnus = sum(mot in vectorizer.vocabulary_ for mot in mots)
    ratio = nb_reconnus / len(mots)
    if X.nnz < config["barriere"]["min_mots_reconnus"] or ratio < config["barriere"]["ratio_min_mots_vocabulaire"]:
        raise HTTPException(
            status_code=422, # Unprocessable Content
            detail="Le modèle ne reconnait pas assez de mots."
        )

    # Prédiction du réseau
    proba = float(modele.predict(X, verbose=0)[0][0])

    # Passage probabilité → classe
    # Le modèle est-il suffisamment sûr de son choix ?
    if config["barriere"]["marge_confiance"] < proba < 1. - config["barriere"]["marge_confiance"]:
        raise HTTPException(
            status_code=422, # Unprocessable Content
            detail=f"Prédiction trop incertaine, probabilité = {int(proba*100)}%."
        )
    if proba > 0.5:
        classe = "horreur"
    else:
        classe = "comédie"

    return {"prediction": classe}