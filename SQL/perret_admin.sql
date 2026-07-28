
-- EXERCICES — Administration PostgreSQL
-- clients, produits, commandes, lignes_commande


 
-- RÔLES ET UTILISATEURS
 

-- Q1 — Créer un rôle ecommerce_readonly qui ne peut que lire les données
-- TODO : écrivez votre code ici
CREATE ROLE ecommerce_readonly WITH 
	NOSUPERUSER
	NOCREATEDB
	NOCREATEROLE
	NOINHERIT
	NOLOGIN
	NOREPLICATION
	NOBYPASSRLS
	CONNECTION LIMIT -1;
GRANT SELECT ON ALL TABLES IN SCHEMA public TO ecommerce_readonly;
GRANT USAGE ON SCHEMA public TO ecommerce_readonly;



-- Q2 — Créer un rôle ecommerce_engineer qui peut lire et modifier les données
-- TODO : écrivez votre code ici
CREATE ROLE ecommerce_engineer WITH 
	NOSUPERUSER
	NOCREATEDB
	NOCREATEROLE
	NOINHERIT
	NOLOGIN
	NOREPLICATION
	NOBYPASSRLS
	CONNECTION LIMIT -1;
GRANT SELECT, INSERT, UPDATE, DELETE ON ALL TABLES IN SCHEMA public TO ecommerce_engineer;
GRANT USAGE ON SCHEMA public TO ecommerce_engineer;

SELECT grantee, table_schema, table_name, privilege_type
FROM information_schema.role_table_grants
WHERE grantee LIKE 'ecommerce%';

-- Q3 — Créer un utilisateur analyste_user avec le mot de passe analyste123
--       et lui assigner le rôle ecommerce_readonly
-- TODO : écrivez votre code ici
create user analyste_user with password 'analyste123';
grant ecommerce_readonly to analyste_user;


-- Q4 — Créer un utilisateur engineer_user avec le mot de passe engineer123
--       et lui assigner le rôle ecommerce_engineer
-- TODO : écrivez votre code ici
create user engineer_user with password 'engineer123';
grant ecommerce_engineer to engineer_user;

 
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
ALTER DEFAULT PRIVILEGES IN SCHEMA public
GRANT SELECT ON TABLES to ecommerce_readonly;
ALTER DEFAULT PRIVILEGES IN SCHEMA public
GRANT select, insert, update, delete ON TABLES to ecommerce_engineer;

SELECT
    defaclrole::regrole AS createur,
    defaclnamespace::regnamespace AS schema,
    defaclobjtype AS type_objet,
    defaclacl
FROM pg_default_acl;


-- Q10 — Révoquer tous les accès publics sur les tables
-- TODO : écrivez votre code ici
REVOKE ALL ON all tables in SCHEMA public FROM ecommerce_readonly;


 
-- INDEX
 

-- Q11 — Créer un index sur la colonne client_id de la table commandes
-- TODO : écrivez votre code ici
create index idx_commandes_client_id on commandes (client_id);
SELECT indexname, indexdef
FROM pg_indexes
WHERE tablename = 'commandes';


-- Q12 — Créer un index sur la colonne date_commande de la table commandes
-- TODO : écrivez votre code ici
create index idx_commandes_date_commande on commandes (date_commande);
SELECT indexname, indexdef
FROM pg_indexes
WHERE tablename = 'commandes';


-- Q13 — Créer un index sur la colonne statut de la table commandes
-- TODO : écrivez votre code ici
create index idx_commandes_statut on commandes (statut);
SELECT indexname, indexdef
FROM pg_indexes
WHERE tablename = 'commandes';


-- Q14 — Créer un index sur la colonne commande_id de la table lignes_commande
-- TODO : écrivez votre code ici
create index idx_lignes_commande_commande_id on lignes_commande (commande_id);
SELECT indexname, indexdef
FROM pg_indexes
WHERE tablename = 'lignes_commande';


-- Q15 — Créer un index sur la colonne produit_id de la table lignes_commande
-- TODO : écrivez votre code ici
create index idx_lignes_commande_produit_id on lignes_commande (produit_id);
SELECT indexname, indexdef
FROM pg_indexes
WHERE tablename = 'lignes_commande';


-- Q16 — Créer un index sur la colonne categorie de la table produits
-- TODO : écrivez votre code ici
create index idx_produits_categorie on produits (categorie);
SELECT indexname, indexdef
FROM pg_indexes
WHERE tablename = 'produits';


-- Q17 — Créer un index partiel sur date_commande
--        uniquement pour les commandes avec statut 'livre'
-- TODO : écrivez votre code ici
create index idx_commandes_date_commande_livre on commandes (date_commande)
where statut = 'livre';
SELECT indexname, indexdef
FROM pg_indexes
WHERE tablename = 'commandes';


-- Q18 — Utiliser EXPLAIN ANALYZE pour vérifier l'impact de l'index
--        sur une requête filtrée par statut
-- TODO : écrivez votre code ici
EXPLAIN ANALYSE SELECT * FROM commandes WHERE statut = 'livre';


-- Q19 — Utiliser EXPLAIN ANALYZE pour vérifier l'impact de l'index
--        sur une requête filtrée par date
-- TODO : écrivez votre code ici

EXPLAIN ANALYSE SELECT * FROM commandes WHERE date_commande > '2023-04-01';
 
-- CONTRAINTES
 

-- Q20 — Ajouter une contrainte : prix d'un produit toujours positif
-- TODO : écrivez votre code ici
ALTER TABLE produits
ADD CONSTRAINT prix_positif
CHECK (prix > 0);
SELECT prix FROM produits WHERE produit_id = 1;
UPDATE produits SET prix = -349.99 WHERE produit_id = 1;


-- Q21 — Ajouter une contrainte : stock d'un produit toujours positif ou nul
-- TODO : écrivez votre code ici
ALTER TABLE produits
ADD CONSTRAINT stock_positif_nul
CHECK (stock >= 0);
SELECT stock FROM produits WHERE produit_id = 1;
UPDATE produits SET stock = stock - 50 WHERE produit_id = 1;


-- Q22 — Ajouter une contrainte : statut d'une commande uniquement
--        'en_attente', 'expedie', 'livre' ou 'annule'
-- TODO : écrivez votre code ici
ALTER TABLE commandes
ADD CONSTRAINT statut_valide
CHECK (statut IN ('en_attente', 'expedie', 'livre', 'annule'));
SELECT statut FROM commandes WHERE commande_id = 1;
UPDATE commandes SET statut = 'pas livre' WHERE commande_id = 1;


-- Q23 — Ajouter une contrainte : quantité dans lignes_commande toujours positive
-- TODO : écrivez votre code ici
ALTER TABLE lignes_commande
ADD CONSTRAINT quantite_positive
CHECK (quantite > 0);
SELECT quantite FROM lignes_commande WHERE ligne_id = 1;
UPDATE lignes_commande SET quantite = quantite - 1 WHERE ligne_id = 1;


-- Q24 — Ajouter une contrainte : prix_unitaire dans lignes_commande toujours positif
-- TODO : écrivez votre code ici
ALTER TABLE lignes_commande
ADD CONSTRAINT prix_unitaire_positif
CHECK (prix_unitaire > 0);
UPDATE lignes_commande SET prix_unitaire = - prix_unitaire WHERE ligne_id = 1;



-- Q25 — Tester qu'une contrainte fonctionne
--        en essayant d'insérer une valeur invalide (doit retourner une erreur)
-- TODO : écrivez votre code ici
-- cf. plus haut

 
-- VÉRIFICATIONS
 

-- Q26 — Lister tous les index créés sur les tables du schéma public
-- TODO : écrivez votre code ici
SELECT tablename, indexname, indexdef
FROM pg_indexes
WHERE schemaname = 'public' AND indexname NOT LIKE '%key%'
ORDER BY tablename;


-- Q27 — Lister toutes les contraintes sur les 4 tables
-- TODO : écrivez votre code ici
SELECT *
FROM pg_constraint
WHERE connamespace = 2200;


-- Q28 — Vérifier les privilèges accordés aux rôles ecommerce_readonly et ecommerce_engineer
-- TODO : écrivez votre code ici
SELECT grantee, table_schema, table_name, string_agg(privilege_type,' ' ORDER BY privilege_type)
FROM information_schema.role_table_grants
WHERE grantee LIKE 'ecommerce%'
GROUP BY grantee, table_schema, table_name;

 
-- SAUVEGARDE (à exécuter dans le terminal)
 

-- Q29 — Faire un dump compressé de la base de données
-- Commande à exécuter dans le terminal :
-- TODO : écrivez la commande ici
pg_dump -Fc -U postgres -d e-commerce -f e-commerce.dump

-- Q30 — Faire un dump SQL lisible de la base de données
-- Commande à exécuter dans le terminal :
-- TODO : écrivez la commande ici
pg_dump -U postgres -d e-commerce > e-commerce.sql


-- Q31 — Créer une nouvelle base ecommerce_restauree et y restaurer le dump compressé
-- Commandes à exécuter dans le terminal :
-- TODO : écrivez les commandes ici
createdb -U postgres ecommerce_restauree
pg_restore -U postgres -d ecommerce_restauree e-commerce.dump


-- Q32 — Vérifier que les 4 tables et leurs données sont bien présentes
--        dans la base restaurée (doit retourner les mêmes chiffres qu'avant)
-- TODO : écrivez votre code ici
pg_dump -U postgres -d ecommerce_restauree > ecommerce_restauree.sql
fc /n e-commerce.sql ecommerce_restauree.sql :
***** e-commerce.sql
    4:
    5:  \restrict fiLDaGhPLBO8zAfOIaGifZeHOvHkLy9p8vaIcrufrpav9UG7HEhu1ZqcfMKrHaw
    6:
***** ECOMMERCE_RESTAUREE.SQL
    4:
    5:  \restrict oW1xqSX62HDPOaqZju5V8h6KfwmLtID0YNIWO2nI2SH9i310LHLqoVoNO8aTTnT
    6:
*****

***** e-commerce.sql
   72:      total numeric(10,2),
   73:      CONSTRAINT statut_valide CHECK (((statut)::text = ANY ((ARRAY['en_attente'::character varying, 'expedie'::character varying
   74:  , 'livre'::character varying, 'annule'::character varying])::text[])))
   75:  );
***** ECOMMERCE_RESTAUREE.SQL
   72:      total numeric(10,2),
   73:      CONSTRAINT statut_valide CHECK (((statut)::text = ANY (ARRAY[('en_attente'::character varying)::text, ('expedie'::character
   74:   varying)::text, ('livre'::character varying)::text, ('annule'::character varying)::text])))
   75:  );
*****

***** e-commerce.sql
  656:
  657:  \unrestrict fiLDaGhPLBO8zAfOIaGifZeHOvHkLy9p8vaIcrufrpav9UG7HEhu1ZqcfMKrHaw
  658:
***** ECOMMERCE_RESTAUREE.SQL
  656:
  657:  \unrestrict oW1xqSX62HDPOaqZju5V8h6KfwmLtID0YNIWO2nI2SH9i310LHLqoVoNO8aTTnT
  658:
*****
-- test CONSTRAINT statut_valide dans ecommerce_restauree :
update commandes set statut = 'NON LIVRE' where commande_id = 1; -- > erreur OK

-- FIN DES EXERCICES

