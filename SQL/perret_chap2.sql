---------------------------------- CHAPITRE 2 ----------------------------------
-- Q16 : compter le nombre total de clients :
SELECT COUNT(*) FROM clients;

-- Q17 : calculer le prix moyen des produits :
SELECT round(AVG(prix),2) AS prix_moyen FROM produits;

-- Q18 : afficher le produit le plus cher et le moins cher :
SELECT * FROM produits WHERE prix = (SELECT MAX(prix) FROM produits) OR prix = (SELECT MIN(prix) FROM produits);

-- Q19 : calculer le chiffre d'affaire total :
SELECT SUM(total) AS CA_total FROM commandes;

-- Q20 : compter le nombre de produits par catégorie :
SELECT categorie, COUNT(*) FROM produits GROUP BY categorie;

-- Q21 : afficher le total des commandes par statut :
SELECT statut, COUNT(*) FROM commandes GROUP BY statut;

-- Q22 : calculer le panier moyen par mois :
SELECT extract(month from date_commande) AS mois, round(AVG(total),2) as panier_moyen FROM commandes GROUP BY mois ORDER BY mois ASC;

-- Q23 : afficher les catégories avec un prix moyen > 50€ :
SELECT categorie, round(AVG(prix),2) AS prix_moyen FROM produits GROUP BY categorie HAVING AVG(prix) > 50;

-- Q24 : afficher le nombre de commandes par client (client_id + nombre) :
SELECT client_id, COUNT(*) AS nb_commandes FROM commandes GROUP BY client_id ORDER BY client_id;

-- Q25 : afficher les clients ayant passé plus de 3 commandes :
SELECT client_id, COUNT(*) AS nb_commandes FROM commandes GROUP BY client_id HAVING COUNT(*) > 3;

-- Q26 : afficher le CA par mois, trié chronologiquement :
SELECT extract(month from date_commande) AS mois, SUM(total) AS CA_mensuel FROM commandes GROUP BY mois ORDER BY mois ASC;

-- Q27 : afficher les catégories ayant au moins 3 produits en stock supérieur à 0 :
SELECT categorie FROM produits WHERE stock > 0 GROUP BY categorie HAVING COUNT(*) >= 3;

-- Q28 : calculer la valeur totale du stock pour chaque catégorie (prix * stock) :
SELECT categorie, SUM(prix*stock) AS valeur_stock FROM produits GROUP BY categorie;

-- Q29 : afficher le nombre de clients par pays, uniquement pout les pays avec plus de 10 clients :
SELECT pays, COUNT(*) AS nbre_clients FROM clients GROUP BY pays HAVING COUNT(*) > 10;

-- Q30 : afficher le mois ayant généré le plus de commandes :
SELECT extract(month from date_commande) AS mois, COUNT(*) AS nbre_commandes FROM commandes GROUP BY mois ORDER BY nbre_commandes DESC LIMIT 1;

