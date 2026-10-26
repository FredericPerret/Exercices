## Tests manuels de l'API
Après avoir lancé le serveur qui porte l'API :
uvicorn main:app --host 0.0.0.0 --port 8000
- test direct de l'API /health : depuis un navigateur, http://localhost:8000/health affiche {"status":"ok","version":"1.0"}
- test avec le swagger via http://localhost:8000/docs :
  * même résultat avec GET / health dans Response body : {"status":"ok","version":"1.0"}
  * avec POST / predict :
     + request body : {"texte":"string"} => réponse 400 : {"detail": "Le texte est trop court pour effectuer une prédiction."}
     + request body {"texte":"Ceci est un texte avec assez de mots mais en français"} => réponse 422 : {"detail": "Le modèle ne reconnait pas assez de mots."}
     + request body {"texte":<le premier texte de l'échantillon sous model/echantillon_reference.csv>} => réponse 200 : {"prediction": "comédie"}
     + request body {"texte":<le quatrième texte de l'échantillon sous model/echantillon_reference.csv>} => réponse 200 : {"prediction": "horreur"}

## Tests de l'API sous Docker
Après avoir lancé le conteneur à partir de l'image api-films :
docker run --rm -p 8000:8000 api-films
on effectue les mêmes tests que ci-dessus => mêmes résultats.

## Tests workflow GitHub
Dans le fichier config.yml, f1_test_min passé de 0.8 à 0.9 + commit + push => workflow arrêté à l'étape tests (cf. EchecWorkflow_f1_test_min_0,9.png).
Lorsque la valeur est rétablie à 0.8 + commit + push => les deux étapes du workflow fonctionne correctement.