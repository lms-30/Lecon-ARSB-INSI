# 📌 **1. Les Entités**

## **A. ÉTUDIANT**

Un étudiant peut emprunter des livres et peut recevoir des pénalités.

## **B. LIVRE**

Un livre appartient à une catégorie et peut être emprunté par plusieurs étudiants (à des périodes différentes).

## **C. CATÉGORIE**

Chaque livre appartient à une catégorie (exemple : Roman, Science, Informatique…).

## **D. PÉNALITÉ**

Une pénalité est créée lorsqu’un étudiant dépasse la date prévue de retour d’un livre.

---

# 📌 **2. Les Relations**

L’image contient **3 relations principales** :

---

## **🔹 Relation : ÉTUDIANT — EMPRUNTER — LIVRE**

C’est une relation binaire entre :

- un **étudiant**
    
- un **livre**
    
- à travers l’acte **EMPRUNTER**
    

### **Cardinalités**

- **Un étudiant peut emprunter 0 à N livres** → _(0,N)_
    
- **Un livre doit être emprunté 1 à 1 fois dans la relation** → _(1,1)_ lorsque l’emprunt existe
    

Ainsi :  
✔ Un étudiant peut avoir plusieurs emprunts  
✔ Un livre peut être emprunté plusieurs fois (mais un emprunt individuel est lié à un seul livre)

---

## **🔹 Relation : LIVRE — CATÉGORIE**

Relation d’appartenance du livre à une catégorie.

### **Cardinalités**

- **Un livre appartient obligatoirement à une seule catégorie** → _(1,N)_ côté livre
    
- **Une catégorie peut avoir 0 à N livres** → _(0,N)_
    

Donc :  
✔ Une catégorie peut contenir plusieurs livres  
✔ Un livre appartient forcément à une catégorie

---

## **🔹 Relation : ÉTUDIANT — PÉNALITÉ — CATÉGORIE**

Ici l’image montre que la **pénalité est liée à l’étudiant**, et aussi associée à une **catégorie**.

### **Cardinalités**

- **Un étudiant peut avoir 0 à N pénalités**
    
- **Une pénalité appartient obligatoirement à un étudiant (1,1)**
    
- **Une pénalité peut concerner une catégorie (0,1)**
    
- **Une catégorie peut être liée à 0,N pénalités**
    

Cela signifie :  
✔ Un étudiant peut avoir plusieurs pénalités  
✔ Une pénalité ne concerne qu’un étudiant  
✔ Une pénalité peut être catégorisée ou non

---

# 📌 **3. Résumé des cardinalités**

|Relation|Explication|
|---|---|
|ÉTUDIANT — EMPRUNTER — LIVRE|1 étudiant → plusieurs emprunts ; 1 livre → plusieurs emprunts|
|LIVRE — CATÉGORIE|1 livre → 1 catégorie ; 1 catégorie → plusieurs livres|
|ÉTUDIANT — PÉNALITÉ|1 étudiant → plusieurs pénalités|
|PÉNALITÉ — CATÉGORIE|1 catégorie → plusieurs pénalités|

---

# 🎯 **Conclusion**

Ce MCD représente un système classique de bibliothèque où :

- Les étudiants empruntent des livres
    
- Chaque livre appartient à une catégorie
    
- Les étudiants peuvent recevoir des pénalités
    
- Les pénalités peuvent être liées à une catégorie
    

# MLD

# Schéma relationnel (MLD) — résumé des tables

- **etudiant**(id_etudiant PK, nom, prenom, mail, parcours, classe)
    
- **categorie**(id_categorie PK, nom)
    
- **livre**(id_livre PK, titre, auteur, date_publication, disponibilite, couleur, id_categorie FK → categorie.id_categorie)
    
- **emprunt**(id_emprunt PK, id_etudiant FK → etudiant.id_etudiant, id_livre FK → livre.id_livre, date_emprunt, date_retour_prevue, statut)
    
- **penalite**(id_penalite PK, id_emprunt FK → emprunt.id_emprunt, montant, date_imposition, statut_paiement)
    

> Remarques de mapping :
> 
> - `emprunt` est l’entité associative (un emprunt = un étudiant emprunte un livre à un instant donné).
>     
> - `penalite` est rattachée à un emprunt (on peut retrouver l’étudiant via l’emprunt).
>     
> - `livre` référence `categorie`. Une catégorie peut contenir plusieurs livres (0,N).
>