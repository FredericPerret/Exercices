from fastapi.testclient import TestClient
import sys
from pathlib import Path
import pandas as pd
import yaml

parent_dir = Path(__file__).parent.parent
sys.path.append(parent_dir)
from main import app
with open(parent_dir / "config.yml", "r", encoding="utf-8") as fichier:
    config = yaml.safe_load(fichier)

client = TestClient(app)
MODEL_DIR = parent_dir / "model"

class TestPredict:

    def predict(self, texte):
        return client.post("/predict", json={"texte": texte})

    def test_valide(self):
        df = pd.read_csv(MODEL_DIR / "echantillon_reference.csv", sep=",")
        response = self.predict(df["resume"].iloc[0])
        assert response.status_code == 200
        resultat = response.json()
        assert "prediction" in resultat

    def test_invalide(self):
        response = self.predict("To short")
        assert response.status_code == 400
        response = self.predict("Ce texte a assez de mots mais l'API attend de l'anglais ...")
        assert response.status_code == 422

    def test_performance(self):
        # on vérifie qu'avec l'échantillon prod, on atteind un taux de prédictions correctes minimum
        df_prod = pd.read_csv(MODEL_DIR / "echantillon_prod.csv", sep=",")
        nbOK = 0
        nbPredits = 0
        for ligne in df_prod.itertuples():
            response = self.predict(ligne.resume)
            assert response.status_code in (200, 422) # on accepte une abstention du modèle pour proba trop incertaine = 422
            if response.status_code == 200:
                nbPredits += 1
                prediction = response.json()["prediction"]
                if ligne.cible == 0:
                    cible = "comédie"
                else:
                    cible = "horreur"
                if prediction == cible:
                    nbOK += 1
        tauxOK = nbOK / nbPredits
        tauxConfiance = nbPredits / len(df_prod)
        assert tauxOK >= config["tests"]["taux_reussite_min"]
        assert tauxConfiance >= config["tests"]["taux_confiance_min"]
