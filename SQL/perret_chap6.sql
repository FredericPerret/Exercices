-- EXERCICES — Chapitre 6 : Window Functions


-- Q1 — Classer tous les produits par prix décroissant avec ROW_NUMBER().
--       Colonnes attendues : nom, categorie, prix, rang
SELECT nom, categorie, prix, ROW_NUMBER() OVER(ORDER BY prix DESC) AS rang
FROM produits ORDER BY categorie, rang;


-- Q2 — Pour chaque catégorie, classer les produits par prix décroissant
--       avec RANK(). Le classement doit repartir à 1 pour chaque catégorie.
--       Colonnes attendues : nom, categorie, prix, rang_dans_categorie
SELECT nom, categorie, prix, RANK() OVER(PARTITION BY categorie ORDER BY prix DESC) AS rang_dans_categorie
FROM produits;


-- Q3 — Même chose qu'en Q2 mais avec DENSE_RANK() au lieu de RANK().
--       Observer la différence en cas d'ex-aequo.
--       Colonnes attendues : nom, categorie, prix, rang_dense
SELECT nom, categorie, prix, DENSE_RANK() OVER(PARTITION BY categorie ORDER BY prix DESC) AS rang_dense
FROM produits;


-- Q4 — Afficher uniquement le produit le plus cher de chaque catégorie.
--       Utiliser ROW_NUMBER() dans une CTE puis filtrer rang = 1.
--       Colonnes attendues : categorie, nom, prix
-- Indice : WITH cte AS (SELECT ..., ROW_NUMBER() ...) SELECT ... FROM cte WHERE rang = 1
 WITH produits_tries AS (
	SELECT categorie, nom, prix, RANK() OVER(PARTITION BY categorie ORDER BY prix DESC) AS rang
	FROM produits
 )
 SELECT categorie, nom, prix FROM produits_tries WHERE rang = 1;


-- Q5 — Classer les commandes par total décroissant avec les trois fonctions
--       ROW_NUMBER(), RANK() et DENSE_RANK() dans la même requête.
--       Observer les différences en cas d'ex-aequo.
--       Colonnes attendues : commande_id, total, rn, rk, dr
SELECT commande_id, total,
		ROW_NUMBER() OVER(ORDER BY total DESC) AS rn,
		RANK() OVER(ORDER BY total DESC) AS rk,
		DENSE_RANK() OVER(ORDER BY total DESC) AS dr
FROM commandes;
 
  
-- Q6 — Pour chaque commande, afficher le total de la commande précédente
--       (dans l'ordre chronologique).
--       La première ligne doit afficher NULL pour le total précédent.
--       Colonnes attendues : commande_id, date_commande, total, total_precedent
 SELECT commande_id, date_commande, total, LAG(total) OVER(ORDER BY date_commande) AS total_precedent
 FROM commandes;


-- Q7 — Calculer l'évolution en euros entre chaque commande et la précédente.
--       Colonnes attendues : commande_id, date_commande, total, total_precedent, evolution_euros
-- Indice : total - LAG(total) OVER (ORDER BY date_commande)
SELECT commande_id, date_commande, total,
		LAG(total) OVER(ORDER BY date_commande) AS total_precedent,
		total - LAG(total) OVER(ORDER BY date_commande) AS evolution_euros
FROM commandes;


-- Q8 — Pour chaque commande, afficher le total de la commande suivante.
--       La dernière ligne doit afficher NULL pour le total suivant.
--       Colonnes attendues : commande_id, date_commande, total, total_suivant
SELECT commande_id, date_commande, total, LEAD(total) OVER(ORDER BY date_commande) AS total_suivant
FROM commandes;


-- Q9 — Pour chaque client, afficher ses commandes avec le total de
--       SA commande précédente (pas celle d'un autre client).
--       Utiliser PARTITION BY client_id.
--       Colonnes attendues : client_id, commande_id, date_commande, total, commande_prec_client
SELECT client_id, commande_id, date_commande, total, LAG(total) OVER(PARTITION BY client_id ORDER BY date_commande) AS commande_prec_client
FROM commandes
ORDER BY client_id, date_commande;


-- Q10 — Calculer la variation en % entre chaque commande et la précédente.
--        Arrondir à 1 décimale. Remplacer NULL par 0 pour la première ligne.
--        Colonnes attendues : commande_id, date_commande, total, variation_pct
-- Indice : ROUND((total - LAG(total)...) / NULLIF(LAG(total)..., 0) * 100, 1)
--          LAG(total, 1, total) OVER (...) pour éviter le NULL
SELECT commande_id, date_commande, total,
		ROUND((total - LAG(total) OVER(ORDER BY date_commande))/LAG(total, 1, total) OVER (ORDER BY date_commande) * 100,1) AS variation_pct
FROM commandes;
  
-- Q11 — Afficher pour chaque commande son total ET le CA global de toutes
--        les commandes sur la même ligne.
--        Colonnes attendues : commande_id, total, ca_global
SELECT commande_id, total, SUM(total) OVER() AS ca_global
FROM commandes;


-- Q12 — Calculer le pourcentage que représente chaque commande
--        dans le CA total. Arrondir à 2 décimales.
--        Colonnes attendues : commande_id, total, ca_global, pct_du_total
SELECT commande_id, total, SUM(total) OVER() AS ca_global, ROUND(total/SUM(total) OVER()*100,2) AS pct_du_total
FROM commandes;


-- Q13 — Pour chaque client, afficher chaque commande avec le CA total
--        de CE client (PARTITION BY client_id).
--        Colonnes attendues : client_id, commande_id, total, ca_total_client
SELECT client_id, commande_id, total, SUM(total) OVER(PARTITION BY client_id) AS ca_total_client
FROM commandes;


-- Q14 — Pour chaque commande d'un client, calculer le pourcentage
--        qu'elle représente dans le CA total de ce client.
--        Colonnes attendues : client_id, commande_id, total, ca_total_client, pct_du_client
SELECT client_id, commande_id, total, SUM(total) OVER(PARTITION BY client_id) AS ca_total_client, ROUND(total/SUM(total) OVER(PARTITION BY client_id)*100,2) AS pct_du_client
FROM commandes;


-- Q15 — Calculer le CA cumulé de toutes les commandes par ordre chronologique.
--        Chaque ligne doit afficher la somme de toutes les commandes
--        depuis la première jusqu'à elle-même.
--        Colonnes attendues : commande_id, date_commande, total, ca_cumule
SELECT commande_id, date_commande, total, SUM(total) OVER(ORDER BY date_commande ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS ca_cumule
FROM commandes;


-- Q16 — Calculer le CA cumulé PAR CLIENT et par date.
--        Le cumul repart à 0 pour chaque nouveau client.
--        Colonnes attendues : client_id, commande_id, date_commande, total, ca_cumule_client
-- Indice : SUM(total) OVER (PARTITION BY client_id ORDER BY date_commande)
SELECT client_id, commande_id, date_commande, total, SUM(total) OVER(PARTITION BY client_id ORDER BY date_commande ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS ca_cumule_client
FROM commandes;
 

-- Q17 — Pour chaque commande, afficher aussi la date de la toute première
--        commande passée (tous clients confondus).
--        Colonnes attendues : commande_id, date_commande, total, premiere_commande_globale
SELECT commande_id, date_commande, total, FIRST_VALUE(date_commande) OVER(ORDER BY date_commande) AS premiere_commande_globale
FROM commandes;


-- Q18 — Pour chaque client, afficher sur chaque commande
--        la date de sa première commande et la date de sa dernière commande.
--        Colonnes attendues : client_id, commande_id, date_commande, premiere, derniere
-- Indice : LAST_VALUE nécessite ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING
SELECT client_id, commande_id, date_commande,
		FIRST_VALUE(date_commande) OVER(PARTITION BY client_id ORDER BY date_commande) AS premiere,
		LAST_VALUE(date_commande) OVER(PARTITION BY client_id ORDER BY date_commande ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) AS derniere
FROM commandes;


-- Q19 — Diviser les produits en 4 quartiles selon leur prix.
--        Quartile 1 = produits les moins chers, 4 = les plus chers.
--        Colonnes attendues : nom, categorie, prix, quartile
SELECT nom, categorie, prix, NTILE(4) OVER(ORDER BY prix ASC) AS quartile
FROM produits;


-- Q20 — Diviser les commandes en 3 groupes égaux selon leur total.
--        Groupe 1 = commandes les moins élevées, 3 = les plus élevées.
--        Colonnes attendues : commande_id, total, groupe
SELECT commande_id, total, NTILE(3) OVER(ORDER BY total ASC) AS groupe
FROM commandes;

  
-- Q21 — Classer les clients par CA total décroissant avec DENSE_RANK().
--        Utiliser une CTE pour calculer d'abord le CA par client.
--        Colonnes attendues : nom, ca_total, rang
WITH catotal_client AS (
	SELECT client_id, SUM(total) AS ca_total
	FROM commandes
	GROUP BY client_id
)
SELECT nom, ca_total, DENSE_RANK() OVER(ORDER BY ca_total DESC) AS rang
FROM clients
INNER JOIN catotal_client ON catotal_client.client_id = clients.client_id;


-- Q22 — Calculer le CA mensuel et la variation en % par rapport
--        au mois précédent. Utiliser une CTE + LAG.
--        Colonnes attendues : mois, ca_mensuel, ca_precedent, variation_pct
-- Indice : DATE_TRUNC('month', date_commande) pour grouper par mois
WITH ca_mensuel AS (
	SELECT 	EXTRACT(YEAR FROM date_commande) AS annee,
			EXTRACT(MONTH FROM date_commande) AS mois,
			SUM(total) AS ca_mensuel
			FROM commandes
			GROUP BY annee, mois
)
SELECT annee, mois, ca_mensuel, LAG(ca_mensuel) OVER(ORDER BY annee,mois) AS ca_precedent,
		ROUND((ca_mensuel - LAG(ca_mensuel,1,0) OVER(ORDER BY annee,mois))/LAG(ca_mensuel,1,ca_mensuel) OVER(ORDER BY annee,mois)*100,2) AS variation_pct
FROM ca_mensuel;

-- Q23 — Pour chaque produit vendu, afficher la quantité commandée
--        et la quantité cumulée depuis le début (par produit).
--        Jointure lignes_commande + produits + commandes nécessaire.
--        Colonnes attendues : produit, date_commande, quantite, quantite_cumulee
SELECT nom AS produit, date_commande, quantite,
		SUM(quantite) OVER(PARTITION BY lignes_commande.produit_id ORDER BY date_commande ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS quantite_cumulee
FROM produits
INNER JOIN lignes_commande ON lignes_commande.produit_id = produits.produit_id
INNER JOIN commandes ON commandes.commande_id = lignes_commande.commande_id;

-- Q24 — Identifier la première et la dernière commande de chaque client
--        en une seule requête. Afficher une ligne par client.
--        Colonnes attendues : nom, premiere_commande, derniere_commande, nb_commandes
-- Indice : DISTINCT + FIRST_VALUE + LAST_VALUE + COUNT OVER (PARTITION BY)
WITH bilan_commandes AS (
	SELECT	DISTINCT nom,
			FIRST_VALUE(date_commande) OVER(PARTITION BY commandes.client_id ORDER BY date_commande) AS premiere_commande,
			LAST_VALUE(date_commande) OVER(PARTITION BY commandes.client_id ORDER BY date_commande ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) AS derniere_commande,
			COUNT(commande_id) OVER(PARTITION BY commandes.client_id) AS nb_commandes
	FROM clients
	INNER JOIN commandes ON commandes.client_id = clients.client_id
)
SELECT * FROM bilan_commandes
-- WHERE nb_commandes > 1
ORDER BY nb_commandes DESC, premiere_commande ASC;

SELECT  nom,
        MIN(date_commande) AS premiere_commande,
        MAX(date_commande) AS derniere_commande,
        COUNT(*) AS nb_commandes
FROM clients
JOIN commandes
    ON commandes.client_id = clients.client_id
GROUP BY clients.client_id, nom
-- HAVING COUNT(*) > 1
ORDER BY nb_commandes DESC, premiere_commande ASC;

-- Q25 — Pour chaque commande, afficher :
--        - son total
--        - le total de la commande précédente (LAG)
--        - le CA cumulé jusqu'à cette commande (SUM OVER ORDER BY)
--        - son rang parmi toutes les commandes (RANK par total décroissant)
--        Colonnes attendues : commande_id, date_commande, total,
--                             total_prec, ca_cumule, rang_total
SELECT	commande_id, date_commande, total,
		LAG(total) OVER(ORDER BY date_commande) AS total_prec,
		SUM(total) OVER(ORDER BY date_commande ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS ca_cumule,
		RANK() OVER(ORDER BY total DESC) AS rang_total
FROM commandes;