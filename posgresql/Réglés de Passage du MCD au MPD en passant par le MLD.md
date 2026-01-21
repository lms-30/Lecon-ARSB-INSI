
### 🧩 Étapes de création d’un MCD :

1. **Lister les entités** : éléments principaux du domaine (ex : Client, Commande, Produit).
    
2. **Identifier les attributs** de chaque entité (ex : nom, prénom, adresse).
    
3. **Définir les relations** entre les entités (ex : un client passe plusieurs commandes).
    
4. **Préciser les cardinalités** (1, N, 0…1) pour chaque relation.
5. - Utiliser une notation (Merise, UML, etc.).

**Exemple: Système de gestion de commandes d'une boutique**

| Client                         | Commande      | Produit     | **Contenir** |
| :----------------------------- | :------------ | :---------- | ------------ |
| id_client (identifiant unique) | id_commande   | id_produit  | quantité     |
| - nom                          | date_commande | nom_produit |              |
| - prénom                       | total         | prix        |              |
| - email                        |               |             |              |
2. MLD – **Modèle Logique de Données** (tables relationnelles)

Le MLD dérive directement du MCD. Voici la représentation sous forme de tables :

🗂 Tables :

🟩 CLIENT
```
CLIENT (
  id_client INT PRIMARY KEY,
  nom VARCHAR(100),
  prénom VARCHAR(100),
  email VARCHAR(150)
)
```
🟩 PRODUIT
```
PRODUIT (
  id_produit INT PRIMARY KEY,
  nom_produit VARCHAR(100),
  prix DECIMAL(10,2)
)
```
🟧 CONTENIR (table de liaison avec attribut quantité)
```
CONTENIR (
  id_commande INT,
  id_produit INT,
  quantité INT,
  PRIMARY KEY (id_commande, id_produit),
  FOREIGN KEY (id_commande) REFERENCES COMMANDE(id_commande),
  FOREIGN KEY (id_produit) REFERENCES PRODUIT(id_produit)
)
```

```
|Commande      |Description|
|              |
| \dt          |Liste des tables|
| \dv          |Liste des vues|
| \di          |Liste des index|
| \ds          |Liste des séquences|
| \d nom_table`|Détail de la structure d'une table|
| \c nom_bdd   | changer de base de données|
```

