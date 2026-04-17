
-- =====================================================
-- BASE DE DONNÉES CUISINE - VERSION CAMEROUNAISE CORRIGÉE
-- Localisation: Yaoundé, Douala, Bafoussam
-- =====================================================

SET client_min_messages TO WARNING;

-- =====================================================
-- NETTOYAGE COMPLET
-- =====================================================
DROP VIEW IF EXISTS V_STOCK_CRITIQUE;
DROP VIEW IF EXISTS V_CARTE_RECETTES;
DROP VIEW IF EXISTS V_PLANNING_MENUS;
DROP VIEW IF EXISTS V_COMPETENCES_CHEFS;
DROP FUNCTION IF EXISTS calculer_cout_menu(INT);
DROP FUNCTION IF EXISTS liste_courses();
DROP TABLE IF EXISTS REALISATION;
DROP TABLE IF EXISTS CONSTITUTION;
DROP TABLE IF EXISTS COMPOSITION;
DROP TABLE IF EXISTS INGREDIENT;
DROP TABLE IF EXISTS RECETTE;
DROP TABLE IF EXISTS MENU;
DROP TABLE IF EXISTS CHEF;
DROP TABLE IF EXISTS FOURNISSEUR;

-- =====================================================
-- STRUCTURE DES TABLES
-- =====================================================

CREATE TABLE FOURNISSEUR (
    CODE_FOUR INT PRIMARY KEY,
    RAISON_SOC VARCHAR(50) NOT NULL,
    ADRESSE VARCHAR(100),
    TELEPHONE VARCHAR(20),  -- CORRIGÉ: 20 caractères pour +237 6 XX XX XX XX
    EMAIL VARCHAR(50),
    SPECIALITE VARCHAR(30)
);

CREATE TABLE INGREDIENT (
    CODE_ING INT PRIMARY KEY,
    NOM_ING VARCHAR(50) NOT NULL,
    CAT_ING VARCHAR(30),
    UNITE VARCHAR(10),
    PRIX_UNIT DECIMAL(10,2) DEFAULT 0,
    QTE_STOCK DECIMAL(10,2) DEFAULT 0,
    SEUIL_MIN DECIMAL(10,2) DEFAULT 0,
    CODE_FOUR INT,
    FOREIGN KEY (CODE_FOUR) REFERENCES FOURNISSEUR(CODE_FOUR)
);

CREATE TABLE RECETTE (
    CODE_REC INT PRIMARY KEY,
    NOM_REC VARCHAR(50) NOT NULL,
    CAT_REC VARCHAR(30),
    TEMPS_PREP INT DEFAULT 0,
    NB_COUVERTS INT DEFAULT 1,
    DIFFICULTE VARCHAR(10)
);

CREATE TABLE MENU (
    CODE_MENU INT PRIMARY KEY,
    NOM_MENU VARCHAR(50) NOT NULL,
    DATE_MENU DATE,
    TYPE_MENU VARCHAR(20),
    PRIX_MENU DECIMAL(10,2) DEFAULT 0
);

CREATE TABLE CHEF (
    CODE_CHEF INT PRIMARY KEY,
    NOM_CHEF VARCHAR(30) NOT NULL,
    PRENOM_CHEF VARCHAR(30),
    SPECIALITE VARCHAR(30),
    NIVEAU VARCHAR(20),  -- CORRIGÉ: 20 caractères pour les titres longs
    DATE_EMB DATE
);

CREATE TABLE COMPOSITION (
    CODE_REC INT,
    CODE_ING INT,
    QUANTITE DECIMAL(8,2) NOT NULL DEFAULT 0,
    PRIMARY KEY (CODE_REC, CODE_ING),
    FOREIGN KEY (CODE_REC) REFERENCES RECETTE(CODE_REC) ON DELETE CASCADE,
    FOREIGN KEY (CODE_ING) REFERENCES INGREDIENT(CODE_ING) ON DELETE CASCADE
);

CREATE TABLE CONSTITUTION (
    CODE_MENU INT,
    CODE_REC INT,
    ORDRE INT DEFAULT 1,
    PRIMARY KEY (CODE_MENU, CODE_REC),
    FOREIGN KEY (CODE_MENU) REFERENCES MENU(CODE_MENU) ON DELETE CASCADE,
    FOREIGN KEY (CODE_REC) REFERENCES RECETTE(CODE_REC) ON DELETE CASCADE
);

CREATE TABLE REALISATION (
    CODE_CHEF INT,
    CODE_REC INT,
    PRIMARY KEY (CODE_CHEF, CODE_REC),
    FOREIGN KEY (CODE_CHEF) REFERENCES CHEF(CODE_CHEF) ON DELETE CASCADE,
    FOREIGN KEY (CODE_REC) REFERENCES RECETTE(CODE_REC) ON DELETE CASCADE
);

-- =====================================================
-- DONNÉES: FOURNISSEURS CAMEROUNAIS
-- =====================================================

INSERT INTO FOURNISSEUR VALUES
(1, 'Boucherie Akwa', 'Rue Joss, Akwa, Douala', '+237 677 88 99 01', 'akwa@boucherie.cm', 'Viandes'),
(2, 'Marché Mfoundi', 'Avenue Kennedy, Yaoundé', '+237 666 55 44 02', 'contact@mfoundi.cm', 'Légumes'),
(3, 'Épices Bonamoussadi', 'Boulevard République, Douala', '+237 699 88 77 03', 'epices@bonamoussadi.cm', 'Épices'),
(4, 'Fruits Maképé', 'Rue Manguiers, Yaoundé', '+237 622 33 44 04', 'fruits@makepe.cm', 'Fruits'),
(5, 'Laiterie Melen', 'Avenue Indépendance, Yaoundé', '+237 644 55 66 05', 'lait@melen.cm', 'Produits laitiers'),
(6, 'Céréales Bafoussam', 'Rue Marché, Bafoussam', '+237 611 22 33 06', 'cereales@bafoussam.cm', 'Céréales'),
(7, 'Poissonnerie Kotto', 'Quai de Kotto, Douala', '+237 633 44 55 07', 'poisson@kotto.cm', 'Poissons'),
(8, 'Chocolaterie Bastos', 'Rue Ambassades, Yaoundé', '+237 655 66 77 08', 'choco@bastos.cm', 'Chocolat');

-- =====================================================
-- DONNÉES: INGRÉDIENTS
-- =====================================================

INSERT INTO INGREDIENT VALUES
(1, 'Farine de blé', 'Céréales', 'kg', 1200, 50, 10, 6),
(2, 'Semoule de maïs', 'Céréales', 'kg', 800, 30, 8, 6),
(3, 'Manioc râpé', 'Céréales', 'kg', 600, 20, 5, 6),
(4, 'Sucre en poudre', 'Sucreries', 'kg', 900, 100, 20, 1),
(5, 'Miel local', 'Sucreries', 'L', 3500, 15, 5, 1),
(6, 'Banane plantain', 'Légumes', 'kg', 400, 60, 15, 2),
(7, 'Igname', 'Légumes', 'kg', 500, 40, 10, 2),
(8, 'Macabo', 'Légumes', 'kg', 450, 35, 8, 2),
(9, 'Haricot noir', 'Légumes', 'kg', 1200, 25, 6, 2),
(10, 'Gombo', 'Légumes', 'kg', 800, 20, 5, 2),
(11, 'Épinards locaux', 'Légumes', 'botte', 300, 30, 10, 2),
(12, 'Tomates', 'Légumes', 'kg', 600, 45, 12, 2),
(13, 'Oignons', 'Légumes', 'kg', 400, 50, 15, 2),
(14, 'Piment', 'Légumes', 'kg', 1000, 15, 5, 2),
(15, 'Poulet braise', 'Viandes', 'kg', 3500, 20, 8, 1),
(16, 'Bœuf', 'Viandes', 'kg', 4500, 15, 5, 1),
(17, 'Mouton', 'Viandes', 'kg', 5500, 12, 4, 1),
(18, 'Poisson tilapia', 'Poissons', 'kg', 3000, 25, 8, 7),
(19, 'Poisson machoiron', 'Poissons', 'kg', 2500, 20, 6, 7),
(20, 'Crevettes', 'Poissons', 'kg', 6000, 10, 3, 7),
(21, 'Cumin', 'Épices', 'g', 50, 500, 100, 3),
(22, 'Curry africain', 'Épices', 'g', 80, 400, 80, 3),
(23, 'Piment en poudre', 'Épices', 'g', 100, 600, 120, 3),
(24, 'Clou de girofle', 'Épices', 'g', 200, 300, 60, 3),
(25, 'Noix de muscade', 'Épices', 'g', 300, 250, 50, 3),
(26, 'Mangues', 'Fruits', 'kg', 800, 40, 12, 4),
(27, 'Ananas', 'Fruits', 'unité', 1500, 30, 10, 4),
(28, 'Papaye', 'Fruits', 'kg', 600, 35, 10, 4),
(29, 'Noix de coco', 'Fruits', 'unité', 500, 50, 15, 4),
(30, 'Beurre de karité', 'Produits laitiers', 'kg', 2500, 15, 5, 5),
(31, 'Lait caillé', 'Produits laitiers', 'L', 800, 20, 6, 5),
(32, 'Fromage local', 'Produits laitiers', 'kg', 3500, 12, 4, 5),
(33, 'Œufs', 'Produits laitiers', 'unité', 150, 200, 50, 5),
(34, 'Huile de palme', 'Huiles', 'L', 1800, 40, 10, 2),
(35, 'Huile d''arachide', 'Huiles', 'L', 2200, 35, 8, 2),
(36, 'Chocolat local', 'Chocolat', 'kg', 8500, 10, 4, 8),
(37, 'Cacao brut', 'Chocolat', 'kg', 6000, 15, 5, 8),
(38, 'Café robusta', 'Boissons', 'kg', 4000, 20, 6, 8),
(39, 'Bouillie de maïs', 'Céréales', 'kg', 700, 30, 8, 6),
(40, 'Sang de bœuf', 'Viandes', 'L', 2000, 8, 3, 1);

-- =====================================================
-- DONNÉES: RECETTES AFRICAINES
-- =====================================================

INSERT INTO RECETTE VALUES
(1, 'Salade de mangue avocat', 'Entrée', 15, 4, 'Facile'),
(2, 'Sauce gombo', 'Entrée', 45, 6, 'Moyen'),
(3, 'Koki', 'Entrée', 60, 4, 'Moyen'),
(4, 'Accra de haricot', 'Entrée', 30, 4, 'Facile'),
(5, 'Poulet DG', 'Plat', 90, 4, 'Moyen'),
(6, 'Ndolé', 'Plat', 120, 6, 'Difficile'),
(7, 'Kondre', 'Plat', 180, 8, 'Difficile'),
(8, 'Eru', 'Plat', 60, 4, 'Moyen'),
(9, 'Mbongo tchobi', 'Plat', 75, 4, 'Moyen'),
(10, 'Sauce pistache', 'Plat', 90, 6, 'Moyen'),
(11, 'Riz au gras', 'Plat', 60, 6, 'Facile'),
(12, 'Poisson braisé', 'Plat', 45, 2, 'Facile'),
(13, 'Beignets de banane', 'Dessert', 30, 8, 'Facile'),
(14, 'Gâteau au chocolat local', 'Dessert', 60, 6, 'Moyen'),
(15, 'Tapioca coco', 'Dessert', 45, 4, 'Facile'),
(16, 'Salade de fruits tropicaux', 'Dessert', 20, 4, 'Facile'),
(17, 'Sang glacé', 'Dessert', 40, 6, 'Difficile'),
(18, 'Banane flambée', 'Dessert', 25, 4, 'Facile');

-- =====================================================
-- DONNÉES: COMPOSITIONS
-- =====================================================

INSERT INTO COMPOSITION VALUES
(1, 26, 1.5), (1, 28, 0.5), (1, 29, 0.3), (1, 33, 2),
(2, 10, 1.0), (2, 16, 0.8), (2, 13, 0.3), (2, 21, 5), (2, 34, 0.2),
(3, 9, 1.0), (3, 33, 2), (3, 35, 0.3), (3, 14, 0.05),
(4, 9, 0.5), (4, 13, 0.1), (4, 23, 3), (4, 35, 0.5),
(5, 15, 1.5), (5, 6, 1.0), (5, 12, 0.5), (5, 13, 0.2), (5, 14, 0.1), (5, 34, 0.3),
(6, 11, 2.0), (6, 18, 1.0), (6, 13, 0.3), (6, 10, 0.5), (6, 33, 3), (6, 35, 0.2),
(7, 16, 1.5), (7, 7, 1.0), (7, 8, 0.5), (7, 12, 0.4), (7, 13, 0.2), (7, 21, 5), (7, 24, 2),
(8, 11, 1.5), (8, 20, 0.5), (8, 13, 0.2), (8, 14, 0.1), (8, 35, 0.3),
(9, 16, 1.0), (9, 14, 0.2), (9, 21, 8), (9, 23, 5), (9, 24, 3), (9, 34, 0.2),
(10, 17, 1.0), (10, 7, 0.8), (10, 13, 0.3), (10, 14, 0.1), (10, 21, 5), (10, 34, 0.3),
(11, 2, 0.8), (11, 16, 0.6), (11, 12, 0.4), (11, 13, 0.2), (11, 34, 0.2),
(12, 18, 1.0), (12, 12, 0.3), (12, 13, 0.1), (12, 14, 0.1), (12, 35, 0.1),
(13, 6, 2.0), (13, 1, 0.5), (13, 4, 0.2), (13, 33, 2), (13, 35, 0.5),
(14, 1, 0.4), (14, 4, 0.3), (14, 36, 0.2), (14, 33, 4), (14, 30, 0.2),
(15, 29, 2.0), (15, 4, 0.2), (15, 33, 2),
(16, 26, 0.5), (16, 27, 0.5), (16, 28, 0.5), (16, 29, 0.3),
(17, 40, 1.0), (17, 13, 0.2), (17, 23, 3), (17, 24, 2),
(18, 6, 1.5), (18, 5, 0.1), (18, 30, 0.1);

-- =====================================================
-- DONNÉES: MENUS
-- =====================================================

INSERT INTO MENU VALUES
(1, 'Menu Tradition Bamiléké', '2026-04-20', 'Déjeuner', 15000),
(2, 'Menu Littoral', '2026-04-21', 'Déjeuner', 12000),
(3, 'Menu Gastronomique', '2026-04-22', 'Dîner', 25000),
(4, 'Menu Végétarien', '2026-04-23', 'Déjeuner', 8000),
(5, 'Menu Nord-Sud', '2026-04-24', 'Dîner', 18000),
(6, 'Menu Enfant', '2026-04-25', 'Déjeuner', 5000),
(7, 'Menu Bord de Mer', '2026-04-26', 'Dîner', 20000),
(8, 'Menu Buffet Froid', '2026-04-27', 'Buffet', 10000);

-- =====================================================
-- DONNÉES: CONSTITUTIONS
-- =====================================================

INSERT INTO CONSTITUTION VALUES
(1, 3, 1), (1, 7, 2), (1, 13, 3),
(2, 2, 1), (2, 9, 2), (2, 14, 3),
(3, 3, 1), (3, 6, 2), (3, 17, 3),
(4, 1, 1), (4, 8, 2), (4, 16, 3),
(5, 4, 1), (5, 10, 2), (5, 15, 3),
(6, 4, 1), (6, 11, 2), (6, 13, 3),
(7, 2, 1), (7, 12, 2), (7, 18, 3),
(8, 1, 1), (8, 4, 2), (8, 16, 3);

-- =====================================================
-- DONNÉES: CHEFS
-- =====================================================

INSERT INTO CHEF VALUES
(1, 'Nkom', 'Jean-Marc', 'Plat', 'Chef de cuisine', '2018-03-15'),
(2, 'Mballa', 'Rose', 'Entrée', 'Sous-chef', '2019-06-20'),
(3, 'Fotso', 'Aïcha', 'Dessert', 'Chef de partie', '2020-01-10'),
(4, 'Tchanou', 'Paul', 'Plat', 'Chef de partie', '2021-04-05'),
(5, 'Kamdem', 'Marie-Claire', 'Entrée', 'Commis', '2022-09-12'),
(6, 'Essomba', 'François', 'Dessert', 'Commis', '2023-02-28'),
(7, 'Owona', 'Patrice', 'Plat', 'Sous-chef', '2019-11-18'),
(8, 'Bikoi', 'Sandrine', 'Entrée', 'Chef de partie', '2020-07-30');

-- =====================================================
-- DONNÉES: RÉALISATIONS
-- =====================================================

INSERT INTO REALISATION VALUES
(1, 5), (1, 6), (1, 7), (1, 8), (1, 11),
(2, 1), (2, 2), (2, 3), (2, 4), (2, 12),
(3, 13), (3, 14), (3, 15), (3, 16), (3, 17), (3, 18),
(4, 9), (4, 10), (4, 5),
(5, 1), (5, 4),
(6, 16), (6, 18),
(7, 6), (7, 7), (7, 8), (7, 11),
(8, 2), (8, 3), (8, 12);

-- =====================================================
-- VUES
-- =====================================================

CREATE VIEW V_STOCK_CRITIQUE AS
SELECT 
    I.NOM_ING, I.CAT_ING, I.QTE_STOCK, I.SEUIL_MIN,
    (I.SEUIL_MIN - I.QTE_STOCK) AS MANQUE, I.UNITE,
    F.RAISON_SOC AS FOURNISSEUR
FROM INGREDIENT I
JOIN FOURNISSEUR F ON I.CODE_FOUR = F.CODE_FOUR
WHERE I.QTE_STOCK < I.SEUIL_MIN;

CREATE VIEW V_CARTE_RECETTES AS
SELECT 
    R.CODE_REC, R.NOM_REC, R.CAT_REC, R.DIFFICULTE,
    R.TEMPS_PREP, R.NB_COUVERTS,
    COALESCE(SUM(C.QUANTITE * I.PRIX_UNIT), 0) AS COUT_TOTAL_FCFA,
    CASE WHEN R.NB_COUVERTS > 0 
         THEN ROUND(SUM(C.QUANTITE * I.PRIX_UNIT) / R.NB_COUVERTS, 2)
         ELSE 0 END AS COUT_PAR_PERSONNE
FROM RECETTE R
LEFT JOIN COMPOSITION C ON R.CODE_REC = C.CODE_REC
LEFT JOIN INGREDIENT I ON C.CODE_ING = I.CODE_ING
GROUP BY R.CODE_REC, R.NOM_REC, R.CAT_REC, R.DIFFICULTE, R.TEMPS_PREP, R.NB_COUVERTS;

CREATE VIEW V_PLANNING_MENUS AS
SELECT 
    M.CODE_MENU, M.NOM_MENU, M.DATE_MENU, M.TYPE_MENU,
    M.PRIX_MENU || ' FCFA' AS PRIX_FORMATTE,
    C.ORDRE, R.NOM_REC, R.CAT_REC
FROM MENU M
JOIN CONSTITUTION C ON M.CODE_MENU = C.CODE_MENU
JOIN RECETTE R ON C.CODE_REC = R.CODE_REC;

CREATE VIEW V_COMPETENCES_CHEFS AS
SELECT 
    C.CODE_CHEF, C.NOM_CHEF || ' ' || C.PRENOM_CHEF AS NOM_COMPLET,
    C.SPECIALITE, C.NIVEAU,
    COUNT(RE.CODE_REC) AS NB_RECETTES_MAITRISEES
FROM CHEF C
LEFT JOIN REALISATION RE ON C.CODE_CHEF = RE.CODE_CHEF
GROUP BY C.CODE_CHEF, C.NOM_CHEF, C.PRENOM_CHEF, C.SPECIALITE, C.NIVEAU;

-- =====================================================
-- FONCTIONS STOCKÉES
-- =====================================================

CREATE OR REPLACE FUNCTION calculer_cout_menu(p_code_menu INT)
RETURNS TABLE(nom_menu VARCHAR, prix_vente DECIMAL, cout_total DECIMAL, marge DECIMAL) AS $$
BEGIN
    RETURN QUERY
    SELECT 
        M.NOM_MENU::VARCHAR(50),
        M.PRIX_MENU,
        COALESCE(SUM(CMP.QUANTITE * I.PRIX_UNIT), 0)::DECIMAL,
        (M.PRIX_MENU - COALESCE(SUM(CMP.QUANTITE * I.PRIX_UNIT), 0))::DECIMAL
    FROM MENU M
    JOIN CONSTITUTION C ON M.CODE_MENU = C.CODE_MENU
    JOIN RECETTE R ON C.CODE_REC = R.CODE_REC
    LEFT JOIN COMPOSITION CMP ON R.CODE_REC = CMP.CODE_REC
    LEFT JOIN INGREDIENT I ON CMP.CODE_ING = I.CODE_ING
    WHERE M.CODE_MENU = p_code_menu
    GROUP BY M.CODE_MENU, M.NOM_MENU, M.PRIX_MENU;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION liste_courses()
RETURNS TABLE(ingredient VARCHAR, categorie VARCHAR, quantite DECIMAL, unite VARCHAR, fournisseur VARCHAR) AS $$
BEGIN
    RETURN QUERY
    SELECT 
        I.NOM_ING::VARCHAR(50),
        I.CAT_ING::VARCHAR(30),
        (I.SEUIL_MIN * 2 - I.QTE_STOCK)::DECIMAL,
        I.UNITE::VARCHAR(10),
        F.RAISON_SOC::VARCHAR(50)
    FROM INGREDIENT I
    JOIN FOURNISSEUR F ON I.CODE_FOUR = F.CODE_FOUR
    WHERE I.QTE_STOCK < I.SEUIL_MIN
    ORDER BY I.CAT_ING, I.NOM_ING;
END;
$$ LANGUAGE plpgsql;

-- =====================================================
-- DOCUMENTATION DES REQUÊTES SQL POSSIBLES
-- =====================================================

/*
============================================================
CATÉGORIE 1: REQUÊTES DE SÉLECTION SIMPLES (SELECT)
============================================================

-- R1.1: Sélectionner tous les ingrédients
SELECT * FROM INGREDIENT;

-- R1.2: Sélectionner des colonnes spécifiques
SELECT NOM_ING, PRIX_UNIT FROM INGREDIENT;

-- R1.3: Sélection avec alias
SELECT NOM_ING AS Produit, PRIX_UNIT AS Prix FROM INGREDIENT;

-- R1.4: Sélection sans doublons (DISTINCT)
SELECT DISTINCT CAT_ING FROM INGREDIENT;

-- R1.5: Sélection avec tri (ORDER BY)
SELECT * FROM INGREDIENT ORDER BY PRIX_UNIT DESC;

-- R1.6: Sélection avec limitation (LIMIT)
SELECT * FROM INGREDIENT LIMIT 10;

============================================================
CATÉGORIE 2: REQUÊTES AVEC FILTRES (WHERE)
============================================================

-- R2.1: Filtre égalité
SELECT * FROM INGREDIENT WHERE CAT_ING = 'Viandes';

-- R2.2: Filtre différent
SELECT * FROM INGREDIENT WHERE CAT_ING != 'Légumes';

-- R2.3: Filtre comparaison
SELECT * FROM INGREDIENT WHERE PRIX_UNIT > 1000;

-- R2.4: Filtre intervalle (BETWEEN)
SELECT * FROM INGREDIENT WHERE PRIX_UNIT BETWEEN 500 AND 1500;

-- R2.5: Filtre liste (IN)
SELECT * FROM INGREDIENT WHERE CAT_ING IN ('Viandes', 'Poissons');

-- R2.6: Filtre motif (LIKE)
SELECT * FROM INGREDIENT WHERE NOM_ING LIKE '%sauce%';
SELECT * FROM CHEF WHERE NOM_CHEF LIKE 'N%';

-- R2.7: Filtre NULL
SELECT * FROM CHEF WHERE DATE_EMB IS NULL;

-- R2.8: Filtre combiné (AND/OR)
SELECT * FROM INGREDIENT WHERE CAT_ING = 'Légumes' AND PRIX_UNIT < 1000;
SELECT * FROM INGREDIENT WHERE CAT_ING = 'Viandes' OR CAT_ING = 'Poissons';

============================================================
CATÉGORIE 3: REQUÊTES AVEC JOINTURES (JOIN)
============================================================

-- R3.1: Jointure interne (INNER JOIN)
SELECT I.NOM_ING, F.RAISON_SOC 
FROM INGREDIENT I 
INNER JOIN FOURNISSEUR F ON I.CODE_FOUR = F.CODE_FOUR;

-- R3.2: Jointure avec alias
SELECT 
    I.NOM_ING AS Produit,
    I.PRIX_UNIT AS Prix,
    F.RAISON_SOC AS Fournisseur
FROM INGREDIENT I
JOIN FOURNISSEUR F ON I.CODE_FOUR = F.CODE_FOUR;

-- R3.3: Jointure multiple (3 tables)
SELECT 
    R.NOM_REC AS Recette,
    I.NOM_ING AS Ingredient,
    C.QUANTITE
FROM RECETTE R
JOIN COMPOSITION C ON R.CODE_REC = C.CODE_REC
JOIN INGREDIENT I ON C.CODE_ING = I.CODE_ING;

-- R3.4: Jointure gauche (LEFT JOIN)
SELECT F.RAISON_SOC, COUNT(I.CODE_ING) AS NbIngredients
FROM FOURNISSEUR F
LEFT JOIN INGREDIENT I ON F.CODE_FOUR = I.CODE_FOUR
GROUP BY F.CODE_FOUR, F.RAISON_SOC;

-- R3.5: Auto-jointure
SELECT C1.NOM_CHEF, C2.NOM_CHEF 
FROM CHEF C1, CHEF C2 
WHERE C1.SPECIALITE = C2.SPECIALITE AND C1.CODE_CHEF != C2.CODE_CHEF;

============================================================
CATÉGORIE 4: REQUÊTES D'AGRÉGATION (GROUP BY)
============================================================

-- R4.1: Comptage (COUNT)
SELECT CAT_ING, COUNT(*) AS NbIngredients
FROM INGREDIENT
GROUP BY CAT_ING;

-- R4.2: Somme (SUM)
SELECT SUM(QTE_STOCK * PRIX_UNIT) AS ValeurTotale FROM INGREDIENT;

-- R4.3: Moyenne (AVG)
SELECT CAT_ING, AVG(PRIX_UNIT) AS PrixMoyen
FROM INGREDIENT
GROUP BY CAT_ING;

-- R4.4: Minimum et Maximum (MIN/MAX)
SELECT 
    MIN(PRIX_UNIT) AS PrixMin,
    MAX(PRIX_UNIT) AS PrixMax
FROM INGREDIENT;

-- R4.5: Agrégation avec condition (HAVING)
SELECT CAT_ING, COUNT(*) AS Nb
FROM INGREDIENT
GROUP BY CAT_ING
HAVING COUNT(*) > 5;

-- R4.6: Plusieurs agrégations
SELECT 
    CAT_ING,
    COUNT(*) AS Nb,
    SUM(QTE_STOCK) AS QteTotale,
    AVG(PRIX_UNIT) AS PrixMoy,
    MIN(PRIX_UNIT) AS PrixMin,
    MAX(PRIX_UNIT) AS PrixMax
FROM INGREDIENT
GROUP BY CAT_ING;

============================================================
CATÉGORIE 5: REQUÊTES DE MISE À JOUR
============================================================

-- R5.1: Mise à jour simple
UPDATE INGREDIENT SET PRIX_UNIT = 1300 WHERE NOM_ING = 'Farine de blé';

-- R5.2: Mise à jour avec calcul
UPDATE INGREDIENT SET PRIX_UNIT = PRIX_UNIT * 1.10 WHERE CAT_ING = 'Viandes';

-- R5.3: Mise à jour multiple colonnes
UPDATE CHEF 
SET NIVEAU = 'Sous-chef', SPECIALITE = 'Plat'
WHERE NOM_CHEF = 'Kamdem';

-- R5.4: Mise à jour avec jointure (PostgreSQL)
UPDATE INGREDIENT I
SET PRIX_UNIT = PRIX_UNIT * 1.05
FROM FOURNISSEUR F
WHERE I.CODE_FOUR = F.CODE_FOUR AND F.SPECIALITE = 'Légumes';

============================================================
CATÉGORIE 6: REQUÊTES DE SUPPRESSION
============================================================

-- R6.1: Suppression simple
DELETE FROM INGREDIENT WHERE CODE_ING = 40;

-- R6.2: Suppression avec condition
DELETE FROM INGREDIENT WHERE QTE_STOCK = 0;

-- R6.3: Suppression avec sous-requête
DELETE FROM INGREDIENT 
WHERE CODE_FOUR IN (SELECT CODE_FOUR FROM FOURNISSEUR WHERE SPECIALITE = 'Chocolat');

-- R6.4: Truncation (suppression totale rapide)
TRUNCATE TABLE REALISATION;

============================================================
CATÉGORIE 7: REQUÊTES D'INSERTION
============================================================

-- R7.1: Insertion simple
INSERT INTO FOURNISSEUR VALUES (9, 'Nouveau Fournisseur', 'Adresse', '+237 600 00 00 00', 'email@test.cm', 'Spécialité');

-- R7.2: Insertion colonnes spécifiques
INSERT INTO INGREDIENT (CODE_ING, NOM_ING, CAT_ING, UNITE, PRIX_UNIT)
VALUES (41, 'Nouvel Ingrédient', 'Légumes', 'kg', 500);

-- R7.3: Insertion multiple
INSERT INTO INGREDIENT (CODE_ING, NOM_ING, CAT_ING) VALUES
(42, 'Ingrédient A', 'Fruits'),
(43, 'Ingrédient B', 'Viandes'),
(44, 'Ingrédient C', 'Épices');

-- R7.4: Insertion avec SELECT
INSERT INTO INGREDIENT (CODE_ING, NOM_ING, CAT_ING, UNITE, PRIX_UNIT)
SELECT CODE_ING + 100, NOM_ING || ' (Copie)', CAT_ING, UNITE, PRIX_UNIT
FROM INGREDIENT WHERE CAT_ING = 'Légumes';

============================================================
CATÉGORIE 8: SOUS-REQUÊTES (SUBQUERIES)
============================================================

-- R8.1: Sous-requête scalaire (retourne une valeur)
SELECT NOM_ING, 
       (SELECT AVG(PRIX_UNIT) FROM INGREDIENT) AS PrixMoyenGeneral
FROM INGREDIENT;

-- R8.2: Sous-requête corrélée
SELECT NOM_ING, PRIX_UNIT
FROM INGREDIENT I
WHERE PRIX_UNIT > (SELECT AVG(PRIX_UNIT) FROM INGREDIENT WHERE CAT_ING = I.CAT_ING);

-- R8.3: Sous-requête avec IN
SELECT * FROM RECETTE
WHERE CODE_REC IN (SELECT CODE_REC FROM COMPOSITION WHERE CODE_ING = 6);

-- R8.4: Sous-requête avec EXISTS
SELECT * FROM RECETTE R
WHERE EXISTS (SELECT 1 FROM COMPOSITION C WHERE C.CODE_REC = R.CODE_REC);

-- R8.5: Sous-requête avec NOT EXISTS
SELECT * FROM INGREDIENT I
WHERE NOT EXISTS (SELECT 1 FROM COMPOSITION C WHERE C.CODE_ING = I.CODE_ING);

============================================================
CATÉGORIE 9: REQUÊTES AVEC UNION/INTERSECT/EXCEPT
============================================================

-- R9.1: UNION (union de résultats)
SELECT NOM_ING FROM INGREDIENT WHERE CAT_ING = 'Viandes'
UNION
SELECT NOM_ING FROM INGREDIENT WHERE CAT_ING = 'Poissons';

-- R9.2: UNION ALL (avec doublons)
SELECT NOM_CHEF FROM CHEF WHERE SPECIALITE = 'Plat'
UNION ALL
SELECT NOM_CHEF FROM CHEF WHERE NIVEAU = 'Chef de partie';

-- R9.3: INTERSECT (intersection)
SELECT CODE_CHEF FROM CHEF WHERE SPECIALITE = 'Plat'
INTERSECT
SELECT CODE_CHEF FROM REALISATION WHERE CODE_REC = 5;

-- R9.4: EXCEPT (différence)
SELECT CODE_ING FROM INGREDIENT
EXCEPT
SELECT CODE_ING FROM COMPOSITION;

============================================================
CATÉGORIE 10: REQUÊTES DE FENÊTRAGE (WINDOW FUNCTIONS)
============================================================

-- R10.1: ROW_NUMBER (numérotation)
SELECT 
    NOM_ING,
    PRIX_UNIT,
    ROW_NUMBER() OVER (ORDER BY PRIX_UNIT DESC) AS Rang
FROM INGREDIENT;

-- R10.2: RANK (classement avec ex-aequo)
SELECT 
    NOM_ING,
    PRIX_UNIT,
    RANK() OVER (ORDER BY PRIX_UNIT DESC) AS Rang
FROM INGREDIENT;

-- R10.3: DENSE_RANK (classement sans trous)
SELECT 
    CAT_ING,
    NOM_ING,
    PRIX_UNIT,
    DENSE_RANK() OVER (PARTITION BY CAT_ING ORDER BY PRIX_UNIT DESC) AS Rang
FROM INGREDIENT;

-- R10.4: Fonctions de navigation
SELECT 
    NOM_ING,
    PRIX_UNIT,
    LAG(PRIX_UNIT) OVER (ORDER BY PRIX_UNIT) AS PrixPrecedent,
    LEAD(PRIX_UNIT) OVER (ORDER BY PRIX_UNIT) AS PrixSuivant
FROM INGREDIENT;

-- R10.5: Somme cumulative
SELECT 
    NOM_ING,
    PRIX_UNIT,
    SUM(PRIX_UNIT) OVER (ORDER BY PRIX_UNIT) AS SommeCumulative
FROM INGREDIENT;

============================================================
CATÉGORIE 11: REQUÊTES SUR VUES
============================================================

-- R11.1: Utilisation vue stock critique
SELECT * FROM V_STOCK_CRITIQUE ORDER BY MANQUE DESC;

-- R11.2: Utilisation vue carte recettes
SELECT * FROM V_CARTE_RECETTES WHERE COUT_TOTAL_FCFA > 5000;

-- R11.3: Utilisation vue planning
SELECT * FROM V_PLANNING_MENUS WHERE DATE_MENU = '2026-04-20';

-- R11.4: Utilisation vue compétences
SELECT * FROM V_COMPETENCES_CHEFS ORDER BY NB_RECETTES_MAITRISEES DESC;

============================================================
CATÉGORIE 12: APPEL DE FONCTIONS
============================================================

-- R12.1: Calculer coût d'un menu
SELECT * FROM calculer_cout_menu(1);

-- R12.2: Liste des courses
SELECT * FROM liste_courses();

-- R12.3: Fonctions système
SELECT CURRENT_DATE;
SELECT CURRENT_TIMESTAMP;
SELECT NOW();

============================================================
CATÉGORIE 13: REQUÊTES AVANCÉES ET RAPPORTS
============================================================

-- R13.1: Rentabilité des menus
SELECT 
    M.NOM_MENU,
    M.PRIX_MENU,
    SUM(COALESCE(CMP.QUANTITE * I.PRIX_UNIT, 0)) AS COUT_TOTAL,
    M.PRIX_MENU - SUM(COALESCE(CMP.QUANTITE * I.PRIX_UNIT, 0)) AS MARGE
FROM MENU M
JOIN CONSTITUTION C ON M.CODE_MENU = C.CODE_MENU
JOIN RECETTE R ON C.CODE_REC = R.CODE_REC
LEFT JOIN COMPOSITION CMP ON R.CODE_REC = CMP.CODE_REC
LEFT JOIN INGREDIENT I ON CMP.CODE_ING = I.CODE_ING
GROUP BY M.CODE_MENU, M.NOM_MENU, M.PRIX_MENU
ORDER BY MARGE DESC;

-- R13.2: Analyse ABC des ingrédients
WITH VALEURS AS (
    SELECT 
        NOM_ING,
        (QTE_STOCK * PRIX_UNIT) AS VALEUR,
        SUM(QTE_STOCK * PRIX_UNIT) OVER () AS TOTAL
    FROM INGREDIENT
),
CLASSEMENT AS (
    SELECT 
        NOM_ING,
        VALEUR,
        SUM(VALEUR) OVER (ORDER BY VALEUR DESC) AS CUMULE,
        ROUND(SUM(VALEUR) OVER (ORDER BY VALEUR DESC) / TOTAL * 100, 2) AS PCT
    FROM VALEURS
)
SELECT 
    NOM_ING,
    VALEUR,
    PCT,
    CASE 
        WHEN PCT <= 80 THEN 'A'
        WHEN PCT <= 95 THEN 'B'
        ELSE 'C'
    END AS CLASSE
FROM CLASSEMENT
ORDER BY VALEUR DESC;

-- R13.3: Matrice des compétences chefs/recettes
SELECT 
    C.NOM_CHEF,
    COUNT(CASE WHEN R.CAT_REC = 'Entrée' THEN 1 END) AS Entrees,
    COUNT(CASE WHEN R.CAT_REC = 'Plat' THEN 1 END) AS Plats,
    COUNT(CASE WHEN R.CAT_REC = 'Dessert' THEN 1 END) AS Desserts,
    COUNT(*) AS Total
FROM CHEF C
JOIN REALISATION RE ON C.CODE_CHEF = RE.CODE_CHEF
JOIN RECETTE R ON RE.CODE_REC = R.CODE_REC
GROUP BY C.CODE_CHEF, C.NOM_CHEF;

-- R13.4: Recettes réalisables avec stock actuel
SELECT R.NOM_REC
FROM RECETTE R
WHERE NOT EXISTS (
    SELECT 1 FROM COMPOSITION C
    JOIN INGREDIENT I ON C.CODE_ING = I.CODE_ING
    WHERE C.CODE_REC = R.CODE_REC AND C.QUANTITE > I.QTE_STOCK
);

-- R13.5: Historique et tendances
SELECT 
    DATE_TRUNC('month', DATE_EMB) AS Mois,
    COUNT(*) AS Recrutements
FROM CHEF
GROUP BY DATE_TRUNC('month', DATE_EMB)
ORDER BY Mois;

============================================================
FIN DE LA DOCUMENTATION
============================================================
*/

-- =====================================================
-- FIN DU SCRIPT
-- =====================================================
