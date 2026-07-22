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

-- Q38 : 