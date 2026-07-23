---------------------------------- CHAPITRE 4 ----------------------------------
-- Q46 : afficher les produits dont le prix est supérieur au prix moyen de leur catégorie :
SELECT produits.nom, produits.categorie, produits.prix, ROUND(prix_moyen_categorie.prix_moyen,2) AS prix_moyen_categorie
FROM produits
INNER JOIN (SELECT categorie, AVG(prix) AS prix_moyen FROM produits GROUP BY categorie) AS prix_moyen_categorie ON prix_moyen_categorie.categorie = produits.categorie AND prix_moyen_categorie.prix_moyen < produits.prix;

-- Q47 : afficher les clients qui n'ont passé aucune commande en 2022 :
SELECT clients.nom
FROM clients
LEFT OUTER JOIN commandes ON commandes.client_id = clients.client_id AND EXTRACT(YEAR FROM commandes.date_commande) = 2022
WHERE commandes.commande_id IS NULL;

-- Q48 : avec une CTE, calculer le CA par client puis afficher ceux dont le CA dépasse 1000€ :
WITH CA_client AS (
	SELECT clients.nom, SUM(commandes.total) AS CA_total
	FROM clients
	INNER JOIN commandes ON commandes.client_id = clients.client_id
	GROUP BY clients.nom
)
SELECT * FROM CA_client
WHERE CA_total > 1000;

-- Q49 : créer une vue v_catalogue affichant nom, categorie, prix et stock de tous les produits en stock :
CREATE OR REPLACE VIEW v_catalogue AS
	SELECT nom, categorie, prix, stock FROM produits
	WHERE stock > 0;

-- Q50 : avec une CTE, trouver le mois ayant généré le plus de CA :
WITH CA_mensuel AS (
	SELECT EXTRACT(MONTH FROM date_commande) AS mois, SUM(total) AS CA
	FROM commandes
	GROUP BY mois
)
SELECT * FROM CA_mensuel
ORDER BY CA DESC
LIMIT 1;

-- Q51 : afficher les produits commandés par au moins 3 clients différents :
SELECT produits.nom, COUNT(DISTINCT commandes.client_id) AS nb_clients_distincts
FROM produits
INNER JOIN lignes_commande ON lignes_commande.produit_id = produits.produit_id
INNER JOIN commandes ON commandes.commande_id = lignes_commande.commande_id
GROUP BY produits.nom
HAVING COUNT(DISTINCT commandes.client_id) >= 3;

-- Q52 : avec 2 CTE : CA par catégorie, puis afficher uniquement les catégories dans le top 3 :
WITH CA_categorie AS (
	SELECT produits.categorie, SUM(lignes_commande.quantite*lignes_commande.prix_unitaire) AS CA
	FROM produits
	INNER JOIN lignes_commande ON lignes_commande.produit_id = produits.produit_id
	GROUP BY produits.categorie
),
top3_categories AS (
	SELECT * FROM CA_categorie
	ORDER BY CA DESC
	LIMIT 3
)
SELECT * FROM top3_categories;

-- Q53 : créer une vue v_top_clients affichant les 10 clients avec le plus grand nombre de commandes :
CREATE OR REPLACE VIEW v_top_clients AS
	SELECT clients.nom, COUNT(commandes.commande_id) AS nb_commandes
	FROM clients
	INNER JOIN commandes ON commandes.client_id = clients.client_id
	GROUP BY clients.nom
	ORDER BY nb_commandes DESC
	LIMIT 10;

-- Q54 : afficher les commandes dont le total est supérieur à la moyenne des commandes du même mois :
SELECT commandes.*, ROUND(moyenne_mensuelle.total_moyen,2) AS total_moyen_mois
FROM commandes
INNER JOIN (SELECT EXTRACT(MONTH FROM date_commande) AS mois, AVG(total) AS total_moyen FROM commandes GROUP BY mois) AS moyenne_mensuelle
	ON moyenne_mensuelle.mois = EXTRACT(MONTH FROM commandes.date_commande) AND commandes.total > moyenne_mensuelle.total_moyen;

-- Q55 : avec une CTE récursive : générer une suite de nombres de 1 à 10 :
WITH RECURSIVE serie(n) AS (
	SELECT 1 AS n
	UNION ALL
	SELECT n+1 FROM serie WHERE n < 10
)
SELECT n FROM serie;

-- Q56 : afficher les emails des clients en majuscules :
SELECT nom, UPPER(email) AS email FROM clients;

-- Q57 : afficher le nom du produit et le domaine de l'email du client dans la même requête :
SELECT produits.nom, SPLIT_PART(clients.email,'@',2) AS domaine_email_client
FROM produits
INNER JOIN lignes_commande ON lignes_commande.produit_id = produits.produit_id
INNER JOIN commandes ON commandes.commande_id = lignes_commande.commande_id
INNER JOIN clients ON commandes.client_id = clients.client_id;

-- Q58 : afficher les commandes passées un lundi :
SELECT * FROM commandes WHERE EXTRACT(DOW FROM date_commande) = 1;

-- Q59 : catégoriser les produits en 'Pas cher' (<20€), 'Raisonnable' (<100€), 'Cher' :
SELECT *, CASE WHEN prix < 20 THEN 'Pas cher' WHEN prix < 100 THEN 'Raisonnable' ELSE 'Cher' END AS categorie_prix
FROM produits;

-- Q60 : afficher les clients avec leur ville, en remplaçant les NULL par 'Ville inconnue' :
SELECT nom, COALESCE(ville,'Ville inconnue') FROM clients;

-- Q61 : afficher le CA par année et par mois sous le format YYYY-MM :
SELECT TO_CHAR(date_commande, 'YYYY-MM') AS annee_mois, SUM(total) AS CA FROM commandes GROUP BY annee_mois ORDER BY annee_mois ASC;

-- Q62 : afficher le nombre de jours écoulés depuis chaque commande :
SELECT *, CURRENT_DATE - date_commande AS nb_jours_ecoules FROM commandes;

-- Q63 : afficher les produits dont le nom contient un chiffre :
SELECT * FROM produits WHERE REGEXP_LIKE(nom,'[0-9]');

-- Q64 : afficher le CA total pour les commandes du dernier trimestre :
SELECT EXTRACT(YEAR FROM date_commande) AS annee, EXTRACT(QUARTER FROM date_commande) AS trimestre, SUM(total) AS CA_trimestre
FROM commandes
GROUP BY annee, trimestre
ORDER BY annee DESC, trimestre DESC
LIMIT 1;