---------------------------------- CHAPITRE 3 ----------------------------------
-- Q31 : afficher toutes les commandes avec le nom et l'email du client associé :
SELECT commandes.*, clients.nom, clients.email
FROM commandes
LEFT OUTER JOIN clients ON clients.client_id = commandes.client_id;

-- Q32 : afficher les lignes de commandes avec le nom du produit et la quantité commandée :
SELECT lignes_commande.*, produits.nom 
FROM lignes_commande 
LEFT OUTER JOIN produits ON produits.produit_id = lignes_commande.produit_id;

-- Q33 : afficher les clients qui n'ont jamais passé de commande :
SELECT clients.* FROM clients LEFT OUTER JOIN commandes ON commandes.client_id = clients.client_id WHERE commandes.commande_id IS NULL;

-- Q34 : afficher le détail complet des commandes : client, produit, quantité, sous-total :
SELECT commandes.*, clients.nom as nom_client, clients.email, produits.nom as nom_produit, lignes_commande.quantite, lignes_commande.quantite*lignes_commande.prix_unitaire as sous_total
FROM commandes
INNER JOIN clients ON commandes.client_id = clients.client_id
INNER JOIN lignes_commande ON lignes_commande.commande_id = commandes.commande_id
INNER JOIN produits ON produits.produit_id = lignes_commande.produit_id;

-- Q35 : afficher le CA total généré par chaque client (nom + total CA), trié par CA décroissant :
SELECT clients.nom, SUM(commandes.total) AS CA_total
FROM clients
INNER JOIN commandes ON commandes.client_id = clients.client_id
GROUP BY clients.nom
ORDER BY CA_total DESC;

-- Q36 : afficher le nombre de fois que chaque produit a été commandé :
SELECT produits.nom, COUNT(commandes.commande_id) AS nb_commandes
FROM produits
INNER JOIN lignes_commande ON lignes_commande.produit_id = produits.produit_id
INNER JOIN commandes ON commandes.commande_id = lignes_commande.commande_id
GROUP BY produits.nom;

-- Q37 : afficher les produits qui n'ont jamais été commandés :
SELECT produits.* FROM produits LEFT OUTER JOIN lignes_commande ON lignes_commande.produit_id = produits.produit_id WHERE lignes_commande.ligne_id IS NULL;

-- Q38 : afficher le CA total par catégorie de produit :
SELECT produits.categorie, SUM(lignes_commande.quantite*lignes_commande.prix_unitaire) AS CA_total
FROM produits
INNER JOIN lignes_commande ON lignes_commande.produit_id = produits.produit_id
GROUP BY produits.categorie;

-- Q39 : afficher les 5 clients ayant le CA total le plus élevé :
SELECT clients.nom, SUM(commandes.total) AS CA_total
FROM clients
INNER JOIN commandes ON commandes.client_id = clients.client_id
GROUP BY clients.nom
ORDER BY CA_total DESC
LIMIT 5;

-- Q40 : afficher le produit le plus vendu (en quantité) :
SELECT produits.nom, SUM(lignes_commande.quantite) AS quantite_totale
FROM produits
INNER JOIN lignes_commande ON lignes_commande.produit_id = produits.produit_id
GROUP BY produits.nom
ORDER BY quantite_totale DESC
LIMIT 1;

-- Q41 : afficher pour chaque commande : nom client, nombre d'articles, total commande
SELECT commandes.commande_id, clients.nom, COUNT(lignes_commande.produit_id) AS nb_articles, commandes.total AS total_enregistre, SUM(lignes_commande.quantite*lignes_commande.prix_unitaire) AS total_calcule
FROM commandes
INNER JOIN clients ON clients.client_id = commandes.client_id
INNER JOIN lignes_commande ON lignes_commande.commande_id = commandes.commande_id
GROUP BY commandes.commande_id, clients.nom, commandes.total
ORDER BY commandes.commande_id ASC;

-- Q42 : afficher les clients ayant commandé des produits de la catégorie Electronique :
SELECT DISTINCT clients.*
FROM clients
INNER JOIN commandes ON clients.client_id = commandes.client_id
INNER JOIN lignes_commande ON lignes_commande.commande_id = commandes.commande_id
INNER JOIN produits ON produits.produit_id = lignes_commande.produit_id AND produits.categorie = 'Electronique';

-- Q43 : afficher le CA moyen par commande pour chaque client
SELECT clients.nom, ROUND(AVG(commandes.total),2) AS CA_moyen
FROM clients
INNER JOIN commandes ON clients.client_id = commandes.client_id
GROUP BY clients.nom;

-- Q44 : afficher les produits vendus en 2023 avec leur catégorie et quantité totale :
SELECT produits.nom, produits.categorie, SUM(lignes_commande.quantite) AS quantite_totale
FROM produits
INNER JOIN lignes_commande ON lignes_commande.produit_id = produits.produit_id
INNER JOIN commandes ON commandes.commande_id = lignes_commande.commande_id AND EXTRACT (YEAR FROM commandes.date_commande) = 2023
GROUP BY produits.nom, produits.categorie;

-- Q45 : afficher les clients et le montant total de leurs commandes livrées uniquement :
SELECT clients.nom, SUM(commandes.total) AS montant_total_livre
FROM clients
INNER JOIN commandes ON commandes.client_id = clients.client_id AND commandes.statut = 'livre'
GROUP BY clients.nom;