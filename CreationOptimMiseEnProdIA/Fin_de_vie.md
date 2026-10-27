### Coût Azure avant suppression
Estimation du coût Azure : après création du registre Azure Container Registry, déploiement de l'API dans Azure Container Apps et plusieurs mises à jour de l'image Docker, le coût réel observé est de 0,06 €. Azure estime cependant le coût à environ 6,81 € sur la période si les ressources restent actives. Le coût observé provient principalement d'Azure Container Registry, tandis que l'exécution ponctuelle de l'API dans Container Apps reste négligeable dans le cadre de ce brief. Cf. CoûtAzure.png.

### Suppressions sous Azure
Toutes les ressources utilisées pour ce brief ont été sous le groupe de ressources fperretRG, les images Ressources_fperretRG_avant_suppression.png et Ressources_fperretRG_après_suppression.png montrent ce qui a été supprimé.