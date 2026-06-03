## Contenus du cours

### Redondances dans un réseau

1. **La redondance est une partie essentielle dans une architecture réseau**  
     La redondance signifie qu’on ajoute des équipements ou des chemins supplémentaires pour éviter qu’un seul problème bloque tout le réseau.
2. **Dans un réseau moderne, le réseau fonctionne 24h/24, 7j/7, 365j/an**  
     Une petite coupure peut être **catastrophique pour une entreprise** (perte d’argent, clients insatisfaits, arrêt des services).
3. **Si un composant réseau tombe en panne**  
     Il faut que **d’autres composants prennent automatiquement le relais**  
    ✔ Exemple :
    - Un switch tombe → un autre switch prend le relais
    - Un lien réseau est coupé → un autre chemin est utilisé
4. **Il faut implémenter la redondance à chaque point du réseau**  
     Cela concerne :
    - les **switchs**
    - les **routeurs**
    - les **liens réseau (câbles)**
    - les **serveurs**

 **Exemple simple :**  
Imagine une route unique vers une ville. Si elle est bloquée → plus personne ne passe.  
Avec plusieurs routes → on peut toujours circuler même si une route est coupée.

---

### STP (Spanning Tree Protocol)

#### Définition

Le **STP (Spanning Tree Protocol)** est un protocole réseau qui permet d’**éviter les boucles (loops)** dans un réseau avec redondance.

---

####  Problème sans STP

Quand on met de la redondance (plusieurs chemins), on crée souvent des **boucles réseau**.

 Une boucle peut provoquer :

- Tempêtes de broadcast (trafic qui tourne en boucle)
- Saturation du réseau
- Pannes complètes

---


> [!NOTE] Mots-clés
> Spanning-Tree, Arbre de recouvrement STP, commutateur racine, port racine, port désigné, port bloqué,


#### Solution avec STP

Le STP va :

1. **Analyser tous les chemins du réseau**
2. **Choisir un seul chemin actif (le meilleur)**
3. **Bloquer les autres chemins (redondants)**

 Mais ces chemins bloqués restent disponibles en cas de panne.

---

#### Fonctionnement simple

1. STP choisit un **switch racine (Root Bridge)**
2. Il calcule le **chemin le plus court vers ce switch**
3. Il bloque les liens inutiles pour éviter les boucles

---

#### Exemple simple

Sans STP :

Switch A ---- Switch B  
   |              |  
   |              |  
Switch C ----------

 Les données tournent en boucle 

Avec STP :  
 Un lien est bloqué automatiquement  
 Plus de boucle 

---

#### Avantage principal

- Évite les pannes réseau dues aux boucles
- Permet la **redondance intelligente**
- Assure la **stabilité du réseau**

---

#### Inconvénient

- Peut être un peu lent à réagir (version classique)  
     Solution : utiliser **RSTP (Rapid STP)** plus rapide

---

##  Conclusion

- La **redondance** permet d’avoir un réseau **fiable et disponible**
- Le **STP** permet d’utiliser cette redondance **sans créer de problèmes**
- Ensemble, ils assurent un réseau **stable, performant et sécurisé**




à recherché :
### Tempête de broadcast


### Rôle des ports STP :
	- Port root : Meilleurs chemin vers le "root bridge"
	- Port désigné : Port non root en "forwarding"
	- Port Bloqué : Port ni root, ni désigné