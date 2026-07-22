
-- EXERCICES — Administration PostgreSQL
-- clients, produits, commandes, lignes_commande


 
-- RÔLES ET UTILISATEURS
 

-- Q1 — Créer un rôle ecommerce_readonly qui ne peut que lire les données
-- TODO : écrivez votre code ici


-- Q2 — Créer un rôle ecommerce_engineer qui peut lire et modifier les données
-- TODO : écrivez votre code ici


-- Q3 — Créer un utilisateur analyste_user avec le mot de passe analyste123
--       et lui assigner le rôle ecommerce_readonly
-- TODO : écrivez votre code ici


-- Q4 — Créer un utilisateur engineer_user avec le mot de passe engineer123
--       et lui assigner le rôle ecommerce_engineer
-- TODO : écrivez votre code ici


 
-- PRIVILÈGES
 

-- Q5 — Donner accès à la base de données aux deux rôles
-- TODO : écrivez votre code ici


-- Q6 — Donner accès au schéma public aux deux rôles
-- TODO : écrivez votre code ici


-- Q7 — Accorder le privilège SELECT sur toutes les tables au rôle ecommerce_readonly
-- TODO : écrivez votre code ici


-- Q8 — Accorder les privilèges SELECT, INSERT, UPDATE, DELETE
--       sur toutes les tables au rôle ecommerce_engineer
-- TODO : écrivez votre code ici


-- Q9 — Faire en sorte que ces privilèges s'appliquent automatiquement aux futures tables
-- TODO : écrivez votre code ici


-- Q10 — Révoquer tous les accès publics sur les tables
-- TODO : écrivez votre code ici


 
-- INDEX
 

-- Q11 — Créer un index sur la colonne client_id de la table commandes
-- TODO : écrivez votre code ici


-- Q12 — Créer un index sur la colonne date_commande de la table commandes
-- TODO : écrivez votre code ici


-- Q13 — Créer un index sur la colonne statut de la table commandes
-- TODO : écrivez votre code ici


-- Q14 — Créer un index sur la colonne commande_id de la table lignes_commande
-- TODO : écrivez votre code ici


-- Q15 — Créer un index sur la colonne produit_id de la table lignes_commande
-- TODO : écrivez votre code ici


-- Q16 — Créer un index sur la colonne categorie de la table produits
-- TODO : écrivez votre code ici


-- Q17 — Créer un index partiel sur date_commande
--        uniquement pour les commandes avec statut 'livre'
-- TODO : écrivez votre code ici


-- Q18 — Utiliser EXPLAIN ANALYZE pour vérifier l'impact de l'index
--        sur une requête filtrée par statut
-- TODO : écrivez votre code ici


-- Q19 — Utiliser EXPLAIN ANALYZE pour vérifier l'impact de l'index
--        sur une requête filtrée par date
-- TODO : écrivez votre code ici


 
-- CONTRAINTES
 

-- Q20 — Ajouter une contrainte : prix d'un produit toujours positif
-- TODO : écrivez votre code ici


-- Q21 — Ajouter une contrainte : stock d'un produit toujours positif ou nul
-- TODO : écrivez votre code ici


-- Q22 — Ajouter une contrainte : statut d'une commande uniquement
--        'en_attente', 'expedie', 'livre' ou 'annule'
-- TODO : écrivez votre code ici


-- Q23 — Ajouter une contrainte : quantité dans lignes_commande toujours positive
-- TODO : écrivez votre code ici


-- Q24 — Ajouter une contrainte : prix_unitaire dans lignes_commande toujours positif
-- TODO : écrivez votre code ici


-- Q25 — Tester qu'une contrainte fonctionne
--        en essayant d'insérer une valeur invalide (doit retourner une erreur)
-- TODO : écrivez votre code ici


 
-- VÉRIFICATIONS
 

-- Q26 — Lister tous les index créés sur les tables du schéma public
-- TODO : écrivez votre code ici


-- Q27 — Lister toutes les contraintes sur les 4 tables
-- TODO : écrivez votre code ici


-- Q28 — Vérifier les privilèges accordés aux rôles ecommerce_readonly et ecommerce_engineer
-- TODO : écrivez votre code ici


 
-- SAUVEGARDE (à exécuter dans le terminal)
 

-- Q29 — Faire un dump compressé de la base de données
-- Commande à exécuter dans le terminal :
-- TODO : écrivez la commande ici


-- Q30 — Faire un dump SQL lisible de la base de données
-- Commande à exécuter dans le terminal :
-- TODO : écrivez la commande ici


-- Q31 — Créer une nouvelle base ecommerce_restauree et y restaurer le dump compressé
-- Commandes à exécuter dans le terminal :
-- TODO : écrivez les commandes ici


-- Q32 — Vérifier que les 4 tables et leurs données sont bien présentes
--        dans la base restaurée (doit retourner les mêmes chiffres qu'avant)
-- TODO : écrivez votre code ici



-- FIN DES EXERCICES

