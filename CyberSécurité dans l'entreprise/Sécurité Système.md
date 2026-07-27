### Linux :
#### 1) Gestion des vulnérabilités
**Définition :**
est un processus continue qui consiste a identifié, évaluée , priorisé, corrigé et suivre les failles de sécurités présent dans le SI.

**Etape de gestion de vulnérabilité :**
- identifier
- évaluée, priorisé
- corriger
**Objectif :**
- Réduire la surface d'attaque : le moyen d'un attaque peut introduire das un système
- Prévenir les incidents de sécurité
- Assurer la conformité
- Améliorer le niveau de sécurité global
**Cycle de vie de la gestion des vulnérabilités :**
	1. Découverte et Inventaire des actifs
	Avant de chercher les failles, il faut savoir ce que l'on doit protéger. Cette étape cartographie l'ensemble du parc informatique.
	- **Périmètre :** Serveurs, bases de données (BDD), postes de travail, applications, équipements réseau.
    2. Détection des vulnérabilités
    C'est la phase technique où l'on cherche les faiblesses et les portes d'entrée potentielles dans le périmètre inventorié.
	**Techniques utilisées :** Scans automatisés, audits de sécurité, tests d'intrusion (pentest) et veille de sécurité active.
     3. Évaluation et Priorisation
	Toutes les failles ne se valent pas. On analyse ici le risque réel pour classer les vulnérabilités et savoir par quoi commencer.
	- **Niveaux :** Faible (Low), Moyen, Élevé, Critique.
	- Critères de tri : Impact potentiel sur les activités et importance métier (criticité de l'actif touché).
     4. Traitement et Remédiation
	C'est l'action concrète pour corriger, atténuer ou éliminer les risques identifiés.
	- **Actions :** Application de correctifs (patch management), mises à jour logicielles, changements de configuration sécurisés ou mesures d'atténuation (comme la segmentation réseau).
     5. Vérification et Suivi (Reporting)
	La dernière étape permet de s'assurer que les corrections ont fonctionné et de documenter l'état de la sécurité.
	- **Objectifs :** Contre-scans pour valider la remédiation, génération de rapports de conformité et mise à jour des tableaux de bord pour la gouvernance

**2) Hardening (CIS)**

**3) Sécurité Serveur Web**

### Windows :
1) GPO / OU
2) WSUS : gestion de mise à jours

