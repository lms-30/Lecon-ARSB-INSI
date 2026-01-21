Il y a deux version d'Oracle : Expresse et entreprise

### introduction

chaque table doit avoir au moins une clé primaire ou unique et doit être en relation

### Les étape général 

- Concept, modélisation des données
- LDD : création, modification, insertion, mise à jour
- LMD____Requête

| mysql   | Oracle   |
| ------- | -------- |
| int     | NUMBER   |
| VARCHAR | VARCHAR2 |

exemple :

```
CREATE TABLE Clients
(
	numero NUMBER(6) CONSTRAINT pk_clients PRIMARY KEY,
	nom VARCHAR2(63) NOT NULL,
	naissance DATE
)
```

### Colonnes calculé 
```
SELECT designation, prix * 1.196 AS "prix TTC" FROM articles;


---- Pour afficher l'initiale + nom et l'age des Client
SELECT SUBSTR(prenom, 1, 1) || '. ' nom AS "identité",
	FLOOR((SYSDATE - naissance) / 365.25) AS "age",
	MOD((SYSDATE - naissance), 365) AS "nombre de jours depuis l'anniv"
	FROM clients;
```

DISCTINCT : pour evité les doublons
ORDER BY : triage par ordre 
UNION : 

raha tsy en relation ny table dia tsy afaka atao jointure, fa ny UNION de mety fona