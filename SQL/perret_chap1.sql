---------------------------------- CHAPITRE 1 ----------------------------------
-- Q1 : afficher le nom et l'email de tous les clients :
SELECT nom, email FROM clients;

-- Q2 : afficher tous les produits de la catégorie Electronique :
SELECT * FROM produits WHERE categorie = 'Electronique';

-- Q3 : afficher les produits dont le prix est supérieur à 50€ :
SELECT * FROM produits WHERE prix > 50;

-- Q4 : afficher les 5 produits les plus chers :
SELECT * FROM produits ORDER BY prix DESC LIMIT 5;

-- Q5 : afficher les clients qui habitent à Paris ou Lyon :
SELECT * FROM clients WHERE ville IN ('Paris','Lyon');

-- Q6 : afficher les commandes avec le statut livre ou expedie :
SELECT * FROM commandes WHERE statut IN ('livre','expedie');

-- Q7 : affichier les produits dont le nom contient cable (insensible à la casse) :
SELECT * FROM produits WHERE nom ILIKE '%cable%';

-- Q8 : afficher les clients sans ville renseignée :
SELECT * FROM clients WHERE ville IS NULL;
 
-- Q9 : afficher les produits dont le prix est ente 20 et 100€, triés par prix croissant :
SELECT * FROM produits WHERE prix BETWEEN 20 AND 100 ORDER BY prix ASC;

-- Q10 : afficher la liste des catégories distinctes de produits :
SELECT DISTINCT categorie FROM produits;

-- Q11 : afficher les commandes passées en 2023, triées du plus récent au plus ancien :
SELECT * FROM commandes WHERE extract(year from date_commande) = 2023 ORDER BY date_commande DESC;

-- Q12 : afficher le nom et le prix TTC (*1,2) des produits, avec l'alias prix_ttc :
SELECT nom, round(prix*1.2,2) AS prix_ttc FROM produits; 

-- Q13 : afficher les 3 produits avec le moins de stock :
SELECT * FROM produits ORDER BY stock ASC LIMIT 3;

-- Q14 : afficher les clients inscrits après le 1/1/2022 :
SELECT * FROM clients WHERE date_inscription > '2022-01-01';

-- Q15 : afficher les commandes dont le total est supérieur à 200€ et le statut à livre :
SELECT * FROM commandes WHERE total > 200 AND statut = 'livre';
