-- QUESTIONS BONUS

-- B1 — Afficher les produits dont le prix est supérieur au prix moyen
--       de TOUS les produits.
--       Colonnes attendues : nom, categorie, prix
SELECT nom, categorie, prix FROM produits
WHERE prix > (SELECT AVG(prix) FROM produits);


-- B2 — Afficher les clients qui ont passé au moins une commande
--       dont le total est supérieur à 200€.
--       Utiliser une sous-requête avec IN.
--       Colonnes attendues : nom, email
SELECT nom, email FROM clients
WHERE client_id IN (SELECT client_id FROM commandes WHERE total > 200);


-- B3 — Afficher les produits qui n'ont JAMAIS été commandés.
--       Utiliser une sous-requête avec NOT IN.
--       Colonnes attendues : nom, categorie, prix
SELECT nom, categorie, prix FROM produits
WHERE produit_id NOT IN (SELECT produit_id FROM lignes_commande);


-- B4 — Afficher les clients ayant passé plus de commandes
--       que la moyenne du nombre de commandes par client.
--       Utiliser une sous-requête dans le FROM.
--       Colonnes attendues : client_id, nb_commandes
WITH nbcmd_client AS (
	SELECT client_id, COUNT(*) AS nb_commandes FROM commandes GROUP BY client_id
)
SELECT * FROM nbcmd_client
WHERE nb_commandes > (SELECT AVG(nb_commandes) FROM nbcmd_client);


-- B5 — Afficher pour chaque produit son nom, son prix
--       et le nombre de fois qu'il a été commandé.
--       Utiliser une sous-requête dans le SELECT.
--       Colonnes attendues : nom, prix, nb_fois_commande
SELECT nom, prix, (SELECT COUNT(*) FROM lignes_commande WHERE lignes_commande.produit_id = produits.produit_id) AS nb_fois_commande FROM produits;


-- B6 — Afficher les produits dont le prix est supérieur
--       au prix moyen de leur propre catégorie.
--       (Sous-requête corrélée)
--       Colonnes attendues : nom, categorie, prix
SELECT nom, categorie, prix FROM produits p1
WHERE prix > (SELECT AVG(prix) FROM produits p2 WHERE p2.categorie = p1.categorie);


-- B7 — Afficher les clients dont le total cumulé de commandes
--       est supérieur au total moyen de tous les clients.
--       Utiliser une sous-requête dans le HAVING.
--       Colonnes attendues : client_id, total_ca
WITH catotal_client AS (
	SELECT client_id, SUM(total) AS total_ca FROM commandes
	GROUP BY client_id
)
SELECT * FROM catotal_client
WHERE total_ca > (SELECT AVG(total_ca) FROM catotal_client);
 

-- B8 — Avec une CTE, calculer le CA total par client
--       puis afficher uniquement les clients dont le CA dépasse 100€.
--       Colonnes attendues : nom, email, ca_total
WITH catotal_client AS (
	SELECT client_id, SUM(total) AS total_ca FROM commandes
	GROUP BY client_id
)
SELECT nom, email, total_ca FROM clients
INNER JOIN catotal_client ON catotal_client.client_id = clients.client_id AND total_ca > 100;


-- B9 — Avec deux CTEs enchaînées :
--       CTE 1 : CA total par catégorie
--       CTE 2 : filtrer les catégories avec CA > 200€
--       Afficher les résultats triés par CA décroissant.
--       Colonnes attendues : categorie, ca_total
WITH catotal_categorie AS (
	SELECT categorie, SUM(quantite*prix_unitaire) AS total_ca
	FROM lignes_commande
	INNER JOIN produits ON produits.produit_id = lignes_commande.produit_id
	GROUP BY categorie
),
catotal_200_categorie AS (
	SELECT categorie, total_ca
	FROM catotal_categorie
	WHERE total_ca > 200
)
SELECT * FROM catotal_200_categorie
ORDER BY total_ca DESC;


-- B10 — Avec une CTE, trouver le produit le plus vendu
--        (en quantité totale commandée).
--        Colonnes attendues : nom, categorie, quantite_totale
WITH quantite_produit AS (
	SELECT nom, categorie, SUM(quantite) AS quantite_totale
	FROM produits
	INNER JOIN lignes_commande ON produits.produit_id = lignes_commande.produit_id
	GROUP BY nom, categorie
)
SELECT nom, categorie, quantite_totale FROM quantite_produit
ORDER BY quantite_totale DESC LIMIT 1;


-- B11 — Avec une CTE, afficher pour chaque mois
--        le CA total et le nombre de commandes.
--        Trier par mois chronologiquement.
--        Colonnes attendues : mois, ca_mensuel, nb_commandes
WITH bilan_mensuel AS (
	SELECT EXTRACT(YEAR FROM date_commande) AS annee, EXTRACT(MONTH FROM date_commande) AS mois, SUM(total) AS ca_mensuel, COUNT(*) AS nb_commandes
	FROM commandes
	GROUP BY annee, mois
)
SELECT annee, mois, ca_mensuel, nb_commandes FROM bilan_mensuel
ORDER BY annee ASC, mois ASC;


-- B12 — Avec deux CTEs :
--        CTE 1 : nombre de commandes par client
--        CTE 2 : CA total par client
--        Afficher les clients avec leur nb de commandes ET leur CA total.
--        Trier par CA décroissant.
--        Colonnes attendues : nom, nb_commandes, ca_total
WITH nbcmd_client AS (
	SELECT client_id, COUNT(*) AS nb_commandes FROM commandes
	GROUP BY client_id
),
ca_client AS (
	SELECT client_id, SUM(total) AS ca_total FROM commandes
	GROUP BY client_id
)
SELECT nom, nb_commandes, ca_total
FROM clients
INNER JOIN nbcmd_client ON nbcmd_client.client_id = clients.client_id
INNER JOIN ca_client ON ca_client.client_id = clients.client_id
ORDER BY ca_total DESC;
 

-- B13 — Créer une vue v_commandes_details qui affiche pour chaque commande :
--        commande_id, nom du client, date, statut, total, nombre d'articles.
--        Puis l'utiliser pour afficher uniquement les commandes livrées
--        avec plus de 1 article.
CREATE OR REPLACE VIEW v_commandes_details AS (
	SELECT commandes.commande_id, nom, date_commande, statut, total, SUM(quantite) AS nbre_articles
	FROM commandes
	INNER JOIN clients ON clients.client_id = commandes.client_id
	INNER JOIN lignes_commande ON lignes_commande.commande_id = commandes.commande_id
	GROUP BY commandes.commande_id, nom, date_commande, statut, total
);
SELECT * FROM v_commandes_details
WHERE nbre_articles > 1;


-- B14 — Créer une vue v_produits_vendus qui affiche pour chaque produit :
--        nom, categorie, prix, quantite_totale_vendue, ca_genere.
--        Inclure les produits jamais vendus (quantite = 0).
--        Puis afficher les 5 produits ayant généré le plus de CA.
CREATE OR REPLACE VIEW v_produits_vendus AS (
	SELECT nom, categorie, prix, SUM(quantite) AS quantite_totale_vendue, SUM(quantite*prix_unitaire) AS ca_genere
	FROM produits
	INNER JOIN lignes_commande ON lignes_commande.produit_id = produits.produit_id
	GROUP BY nom, categorie, prix
);
SELECT * FROM v_produits_vendus
ORDER BY ca_genere DESC LIMIT 5;


-- B15 — Afficher pour chaque client :
--        son nom en majuscules,
--        son domaine email (partie après le @),
--        le nombre de caractères de son nom.
--        Colonnes attendues : nom_majuscule, domaine_email, longueur_nom
SELECT UPPER(nom) AS nom_majuscule, SPLIT_PART(email,'@',2) AS domaine_email, LENGTH(nom) AS longueur_nom
FROM clients;


-- B16 — Afficher les clients dont l'email se termine par 'gmail.com',
--        en affichant leur nom en title case (première lettre majuscule)
--        et leur ville avec les espaces de début/fin supprimés.
--        Colonnes attendues : nom_formate, email, ville_nettoyee
SELECT INITCAP(nom) AS nom_formate, email, TRIM(ville) AS ville_nettoyee
FROM clients
WHERE SPLIT_PART(email,'@',2) = 'gmail.com';
 

-- B17 — Afficher pour chaque commande :
--        la date de commande formatée en 'JJ/MM/AAAA',
--        le jour de la semaine en texte (Lundi, Mardi...),
--        le nombre de jours écoulés depuis la commande.
--        Colonnes attendues : date_formatee, jour_semaine, jours_ecoules
-- Indice pour le jour en texte : TO_CHAR(date_commande, 'Day')
SELECT TO_CHAR(date_commande,'DD/MM/YYYY') AS date_formatee, TO_CHAR(date_commande, 'Day') AS jour_semaine, CURRENT_DATE - date_commande AS jours_ecoules FROM commandes;


-- B18 — Afficher le CA total par trimestre et par année.
--        Colonnes attendues : annee, trimestre, ca_trimestriel
--        Trier par année et trimestre.
-- Indice : EXTRACT(QUARTER FROM ...) et EXTRACT(YEAR FROM ...)
SELECT EXTRACT(YEAR FROM date_commande) AS annee, EXTRACT(QUARTER FROM date_commande) AS trimestre, SUM(total) AS ca_trimestriel
FROM commandes
GROUP BY annee, trimestre
ORDER BY annee, trimestre;


-- B19 — Afficher chaque produit avec une colonne 'segment' :
--        'Entrée de gamme'  si prix < 20
--        'Milieu de gamme'  si prix entre 20 et 80
--        'Haut de gamme'    si prix > 80
--        Et une colonne 'disponibilite' :
--        'En stock'         si stock > 0
--        'Rupture'          si stock = 0
--        Colonnes attendues : nom, prix, segment, disponibilite
SELECT nom, prix, 
	   CASE WHEN prix < 20 THEN 'Entrée de gamme' WHEN prix < 80 THEN 'Milieu de gamme' ELSE 'Haut de gamme' END AS segment,
	   CASE WHEN stock > 0 THEN 'En stock' ELSE 'Rupture' END AS disponibilite
FROM produits;


-- B20 — Afficher chaque client avec :
--        sa ville (remplacer NULL par 'Ville non renseignée'),
--        son statut :
--        'Client actif'   s'il a au moins une commande
--        'Sans commande'  sinon
--        Utiliser COALESCE pour la ville et une sous-requête pour le statut.
--        Colonnes attendues : nom, ville_affichee, statut_client
SELECT nom, COALESCE(ville,'Ville non renseignée') AS ville_affichee, CASE WHEN COUNT(commandes.*) > 0 THEN 'Client actif' ELSE 'Sans commande' END AS statut_client
FROM clients
INNER JOIN commandes ON commandes.client_id = clients.client_id
GROUP BY nom, ville;
