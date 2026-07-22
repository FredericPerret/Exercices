DROP TABLE If EXISTS public.clients;

CREATE TABLE public.clients
(
    client_id			SERIAL PRIMARY KEY,
    nom 				VARCHAR(100) 			NOT NULL,
    email				VARCHAR(150)	UNIQUE	NOT NULL,
    ville				VARCHAR(100),
    pays        		VARCHAR(50) DEFAULT 'France',
	date_inscription	DATE
);

INSERT INTO public.clients (nom, email, ville, pays, date_inscription) VALUES
('Alice Martin',    'alice.martin@gmail.com',    'Paris',      'France',  '2021-03-15'),
('Bob Dupont',      'bob.dupont@yahoo.fr',        'Lyon',       'France',  '2021-07-22'),
('Claire Moreau',   'claire.moreau@gmail.com',    'Marseille',  'France',  '2022-01-10'),
('David Bernard',   'david.bernard@outlook.com',  'Paris',      'France',  '2022-04-05'),
('Emma Petit',      'emma.petit@gmail.com',        'Bordeaux',   'France',  '2022-06-18'),
('François Leroy',  'francois.leroy@free.fr',      'Nantes',     'France',  '2022-09-30'),
('Grace Roux',      'grace.roux@gmail.com',        'Lille',      'France',  '2023-01-12'),
('Hugo Simon',      'hugo.simon@hotmail.com',      'Paris',      'France',  '2023-02-28'),
('Isabelle Faure',  'isabelle.faure@gmail.com',    NULL,         'France',  '2023-05-14'),
('Jules Garcia',    'jules.garcia@gmail.com',      'Toulouse',   'France',  '2023-07-01'),
('Karla Muller',    'karla.muller@gmail.com',      'Strasbourg', 'France',  '2023-08-20'),
('Luc Bonnet',      'luc.bonnet@yahoo.fr',         'Lyon',       'France',  '2021-11-03'),
('Marie Chevalier', 'marie.chevalier@gmail.com',   'Nantes',     'France',  '2022-12-25'),
('Nicolas Morel',   'nicolas.morel@outlook.com',   NULL,         'France',  '2023-03-17'),
('Olivia Laurent',  'olivia.laurent@gmail.com',    'Paris',      'France',  '2021-05-09'),
('Paul Mercier',    'paul.mercier@free.fr',         'Bordeaux',   'France',  '2022-08-14'),
('Quentin Blanc',   'quentin.blanc@gmail.com',     'Marseille',  'France',  '2023-09-05'),
('Rachel Guerin',   'rachel.guerin@hotmail.com',   'Lyon',       'France',  '2021-12-31'),
('Samuel Robin',    'samuel.robin@gmail.com',      'Paris',      'France',  '2022-03-22'),
('Théa Fontaine',   'thea.fontaine@gmail.com',     'Lille',      'France',  '2023-10-08');

DROP TABLE If EXISTS public.produits;

CREATE TABLE public.produits (
    produit_id SERIAL PRIMARY KEY,
    nom        VARCHAR(150) NOT NULL,
    categorie  VARCHAR(100),
    prix       DECIMAL(10,2) NOT NULL,
    stock      INTEGER DEFAULT 0
);

INSERT INTO public.produits (nom, categorie, prix, stock) VALUES
('Smartphone Galaxy A54',     'Electronique',   349.99,  25),
('Cable USB-C 2m',            'Electronique',     8.99, 150),
('Casque Bluetooth Pro',      'Electronique',    79.99,  40),
('Chargeur rapide 65W',       'Electronique',    34.99,  80),
('Clé USB 128Go',             'Electronique',    19.99,  60),
('Laptop Stand aluminium',    'Informatique',    45.99,  35),
('Souris ergonomique sans fil','Informatique',   29.99,  55),
('Clavier mécanique RGB',     'Informatique',    89.99,  20),
('Webcam HD 1080p',           'Informatique',    59.99,  30),
('Hub USB 7 ports',           'Informatique',    24.99,  45),
('T-shirt coton bio',         'Vetements',       19.99, 100),
('Jean slim stretch',         'Vetements',       49.99,  60),
('Veste imperméable',         'Vetements',       89.99,  25),
('Baskets running',           'Vetements',       79.99,  40),
('Chaussettes lot x5',        'Vetements',        9.99, 200),
('Livre Python avancé',       'Livres',          34.99,  15),
('Livre SQL pour débutants',  'Livres',          24.99,  20),
('Livre Data Engineering',    'Livres',          39.99,  10),
('Agenda 2024',               'Livres',          12.99,  50),
('Cahier A5 lot x3',          'Livres',           7.99,  80),
('Cafetière à piston',        'Maison',          29.99,  30),
('Gourde isotherme 500ml',    'Maison',          22.99,  70),
('Lampe de bureau LED',       'Maison',          44.99,  25),
('Coussin ergonomique',       'Maison',          35.99,  20),
('Tapis de bureau XL',        'Maison',          19.99,  40);

DROP TABLE IF EXISTS public.commandes;

CREATE TABLE public.commandes (
    commande_id   SERIAL PRIMARY KEY,
    client_id     INTEGER REFERENCES clients(client_id),
    date_commande DATE NOT NULL,
    statut        VARCHAR(50) DEFAULT 'en_attente',
    total         DECIMAL(10,2)
);

INSERT INTO public.commandes (client_id, date_commande, statut, total) values
(1,  '2023-01-05', 'livre',      358.98),
(1,  '2023-04-20', 'livre',       89.99),
(2,  '2023-01-15', 'livre',       54.98),
(2,  '2023-06-10', 'expedie',    119.98),
(3,  '2023-02-01', 'livre',       29.99),
(4,  '2023-02-14', 'livre',      139.98),
(4,  '2023-07-22', 'livre',       49.99),
(5,  '2023-03-08', 'annule',      79.99),
(6,  '2023-03-15', 'livre',       34.99),
(7,  '2023-04-01', 'livre',       94.97),
(8,  '2023-04-18', 'expedie',     59.99),
(9,  '2023-05-02', 'en_attente',  22.99),
(10, '2023-05-20', 'livre',      169.97),
(11, '2023-06-05', 'livre',       44.99),
(12, '2023-06-25', 'livre',       89.98),
(13, '2023-07-10', 'livre',       34.99),
(14, '2023-07-30', 'expedie',    109.98),
(15, '2023-08-12', 'livre',       79.99),
(16, '2023-08-28', 'livre',       54.97),
(17, '2023-09-05', 'annule',      89.99),
(18, '2023-09-22', 'livre',      129.98),
(19, '2023-10-08', 'livre',       39.99),
(20, '2023-10-25', 'expedie',     69.98),
(1,  '2023-11-11', 'livre',      199.97),
(3,  '2023-11-20', 'livre',       74.98),
(5,  '2023-12-01', 'livre',      124.98),
(7,  '2023-12-15', 'en_attente',  44.99),
(10, '2022-11-05', 'livre',       59.99),
(12, '2022-12-20', 'livre',       34.98),
(15, '2022-08-14', 'livre',       89.99);

DROP TABLE IF EXISTS public.lignes_commande;

CREATE TABLE public.lignes_commande (
    ligne_id      SERIAL PRIMARY KEY,
    commande_id   INTEGER REFERENCES commandes(commande_id),
    produit_id    INTEGER REFERENCES produits(produit_id),
    quantite      INTEGER NOT NULL,
    prix_unitaire DECIMAL(10,2) NOT NULL
);

INSERT INTO public.lignes_commande (commande_id,produit_id,quantite,prix_unitaire) VALUES
(1,  1, 1, 349.99),
(1,  2, 1,   8.99),
(2,  3, 1,  79.99),
(3,  2, 2,   8.99),
(3, 15, 1,   9.99),
(4,  3, 1,  79.99),
(4,  4, 1,  34.99),
(5,  21, 1, 29.99),
(6,  7, 1, 29.99),
(6,  8, 1, 89.99),
(7, 12, 1, 49.99),
(8,  3, 1, 79.99),
(9,  4, 1, 34.99),
(10, 5, 1, 19.99),
(10,17, 1, 24.99),
(10,19, 1, 12.99),
(11, 9, 1, 59.99),
(12,22, 1, 22.99),
(13, 3, 1, 79.99),
(13, 4, 1, 34.99),
(13, 5, 1, 19.99),
(14,23, 1, 44.99),
(15,11, 2, 19.99),
(15,15, 1,  9.99),
(16,16, 1, 34.99),
(17,10, 1, 24.99),
(17, 9, 1, 59.99),
(18,14, 1, 79.99),
(19,20, 2,  7.99),
(19,15, 1,  9.99),
(19,22, 1, 22.99),
(20,13, 1, 89.99),
(21, 7, 1, 29.99),
(21,10, 1, 24.99),
(22,18, 1, 39.99),
(23, 4, 1, 34.99),
(23, 5, 1, 19.99),
(24, 6, 1, 45.99),
(24, 3, 1, 79.99),
(24,20, 2,  7.99),
(25,24, 1, 35.99),
(25,25, 1, 19.99),
(26,13, 1, 89.99),
(26,15, 1,  9.99),
(27,19, 1, 12.99),
(28, 9, 1, 59.99),
(29, 2, 2,  8.99),
(30, 3, 1, 79.99);
