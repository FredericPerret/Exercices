---------------------------------- CHAPITRE 4 ----------------------------------
-- Q46 : afficher les produits dont le prix est supérieur au prix moyen de leur catégorie :
SELECT produits.nom, produits.categorie, produits.prix, ROUND(prix_moyen_categorie.prix_moyen,2) AS prix_moyen_categorie
FROM produits
INNER JOIN (SELECT categorie, AVG(prix) AS prix_moyen FROM produits GROUP BY categorie) AS prix_moyen_categorie ON prix_moyen_categorie.categorie = produits.categorie AND prix_moyen_categorie.prix_moyen < produits.prix;