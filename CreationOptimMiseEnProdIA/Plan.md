## Etapes du projet
Les étapes et les tâches associées présentées dans ce document ont été définies à partir des cahiers des charges du brief :
- C12_fiche_planifier_le_projet.pdf
- SUITE_deploiement_pipeline_production.pdf

### Etape préliminaire : planification du projet

- T0 : rédaction du présent document Plan.md

### Partie 1 : développement du processus de traitement

- T1.1 : audit et nettoyage du jeu de données
- T1.2 : découpage du jeu de données (apprentissage / test / production)
- T1.3 : vectorisation des textes avec TF-IDF
- T1.4 : comparaison de 3 modèles
- T1.5 : optimisation avec KerasTuner
- T1.6 : optimisation avec Optuna
- T1.7 : choix des hyperparamètres
- T1.8 : sauvegarde

### Partie 2 : mise en ligne du modèle

#### Développement de l'application :
- T2.1 : développement de l'API et du chargement du modèle
- T2.2 : tests manuels de l'API
- T2.3 : tests automatiques de l'API
- T2.4 : configuration de la barrière qualité

#### Conteneurisation de l'application :
- T2.5 : création de l'image docker avec l'application
- T2.6 : test de l'application dockerisée sur le poste local

#### Mise en place d'un mécanisme CI/CD avec GitHub Actions :
- T2.7 : écriture du workflow avec deux jobs
- T2.8 : test du workflow

#### Déploiement sous Azure :
- T2.9 : création d'un registre de conteneurs
- T2.10 : ajout du job publier dans le workflow
- T2.11 : test manuel de l'application publiée
- T2.12 : test du workflow complet
- T2.13 : rédaction PROCEDURE_MISE_EN_PRODUCTION.md

#### Arrêt de l'application :
- T2.14 : estimation des coûts liés au déploiement et à l'utilisation sous Azure
- T2.15 : suppression de toutes les ressources sous Azure liées à l'application
- T2.16 : rédaction FIN_DE_VIE.md

## Tâches du projet
| id | entrées | sorties | charge prévue (h) | charge effective (h) |
|---|---|---|---|---|
| T0 | CdC brief | Plan.md | 4 | 4  |
| T1.1 | textes_films_horreur_comedie.csv | modele.ipynb données nettoyées | 2 | 1 |
| T1.2 | modele.ipynb données nettoyées | modele.ipynb données train / test / prod | 1 | 0.5 |
| T1.3 | modele.ipynb données train / test / prod | modele.ipynb train, test, prod vectorisées | 1 | 0.5 |
| T1.4 | modele.ipynb train, test, prod vectorisées | modele.ipynb résultats 3 modèles 5 graines | 2 | 1 |
| T1.5 | modele.ipynb résultats 3 modèles 5 graines | modele.ipynb réglage optimal KerasTuner sur meilleur modèle | 2 | |
| T1.6 | modele.ipynb résultats 3 modèles 5 graines | modele.ipynb réglage optimal Optuna sur meilleur modèle | 2 | |
| T1.7 | modele.ipynb réglage optimal KerasTuner et Optuna sur meilleur modèle | modele.ipynb  hyperparamètres optimaux évalués sur tests | 2 | |
| T1.8 | modele.ipynb modèle optimal évalué | modele.keras, vectoriseur.joblib, metrics.json, reference.csv dans répertoire model| 2| |
|T2.1 | répertoire model avec les 4 fichiers |  API accessible en local avec /health et /predict | 3 | |
| T2.2 | API accessible en local | résultats tests testsAPI.md  | 1 | |
| T2.3 | API accessible en local testée manuellement | répertoire testsAuto avec tous les tests .py exécutables via pytest | 3 | |
| T2.4 |  API accessible en local testée | API avec barrière configurée et testée | 2 | |
|T2.5 | API accessible en local avec barrière | image docker construite avec l'API | 2 | |
| T2.6 | image docker | résultats tests testsAPI.md | 1 | |
| T2.7 | API avec barrière, répertoire testsAuto | workflow GitHub Actions avec jobs test et image | 3 | |
| T2.8 | workflow avec les deux jobs | résultats tests testsAPI.md | 1 | |
| T2.9 | accès Azure | registre de conteneurs rempli | 1 | |
| T2.10 | registre conteneurs rempli | job publier ajouté au workflow | 2 | |
| T2.11 | job publier fonctionnel | résultats tests testsAPI.md | 1 | |
| T2.12 | workflow complet fonctionnel | résultats tests testsAPI.md | 1 | |
| T2.13 | publication complète réussie | PROCEDURE_MISE_EN_PRODUCTION.md | 3 | |
| T2.14 | Azure Cost Calculator | FIN_DE_VIE.md | 1 | |
| T2.15 | publication complète réussie | FIN_DE_VIE.md | 1 | |
| T2.16 | suppression complète effectuée | FIN_DE_VIE.md | 2 | |




