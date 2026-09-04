Voici deux nouveaux exercices d'examen conçus exactement sur la même structure, fondés sur votre canevas et vos consignes de cours.

  

### **Exercice 1 : Analyse critique et réécriture d'un projet de mémoire sur la virtualisation**

**Contexte :**

Un étudiant présente son projet de mémoire intitulé _"Mise en place d'une infrastructure de virtualisation KVM sous Arch Linux pour le laboratoire de l'établissement"_. Il vous soumet son introduction et son résumé pour validation.

  

#### **Texte de l'étudiant :**

> **INTRODUCTION**
> 
> Il y a aujourd'hui beaucoup de serveurs physiques qui consomment trop d'énergie dans les entreprises. Je vais montrer dans ce travail comment utiliser KVM pour créer des machines virtuelles. On a constaté que la gestion de plusieurs serveurs physiques est difficile et coûteuse. On veut optimiser les ressources informatiques de l'école. Faire ce projet permet de réduire les coûts. Dans le chapitre 1 on aura la présentation du lieu de stage, dans le chapitre 2 la méthode de projet et les outils, et dans le chapitre 3 la réalisation et l'évaluation. (Note : la liste des abréviations contient : _KVM : Kernel-based Virtual Machine (un logiciel de virtualisation libre sous Linux)_).
> 
>   

> **RÉSUMÉ** _(Nombre de mots : 72 mots)_
> 
> Ce travail présente la virtualisation avec KVM. On a installé des machines virtuelles pour remplacer les serveurs physiques. La méthode appliquée a permis de réduire les coûts d'énergie. Les tests montrent que le système fonctionne très bien et qu'il y a une bonne performance globale pour les étudiants.
> 
> _Mots-clés : Virtualisation, KVM, Serveur, Linux._
> 
>   

#### **Travail demandé :**

1. **Analyse critique (Trouver au moins 5 fautes selon le cours) :**
    
    - Identifiez la faute de structure dans l'introduction (regardez le nombre de paragraphes).
          
    - Identifiez les mots interdits présents dans les textes (`je`, `on a`, `il y a`, `faire`, `être`).
        
    - Vérifiez la longueur du résumé par rapport à la règle (250 à 500 mots).
        
    - Identifiez la faute commise dans la liste des abréviations selon les consignes du cours.
        
    - Analysez le choix des mots-clés.
        
2. **Rédaction conforme :**
    
    - **Rédigez l'Introduction Générale** en respectant strictement la structure en **3 paragraphes** (Situation générale $\rightarrow$ Cas particulier et problématique $\rightarrow$ Énoncé du titre de l'ouvrage et plan des 3 chapitres).
        
    - **Rédigez le Résumé** (entre 250 et 500 mots) et donnez des **mots-clés** pertinents.
        
    - **Règle absolue :** N'utilisez aucun des mots interdits (`je`, `on a`, `il y a`, `être`, `faire`).
        
          
        

### **Correction indicative - Exercice 1**

#### **1. Analyse critique (Erreurs identifiées) :**

- **Structure de l'introduction :** Rédigée en un seul bloc au lieu de **3 paragraphes distincts**.
    
- **Mots interdits :** Utilisation de `il y a`, `je`, `on a`, `faire`, `on aura`.
    
- **Règle de la liste des abréviations violée :** L'étudiant a ajouté des explications entre parenthèses (_"un logiciel de virtualisation libre..."_), ce qui est explicitement interdit par la consigne du cours.
    
- **Taille du résumé non conforme :** Contient 72 mots (la norme exige entre **250 et 500 mots**).
    
- **Mots-clés :** Termes trop vagues et insuffisamment caractéristiques de la réalisation technique.
    
#### **2. Proposition de réécriture conforme :**

**INTRODUCTION GÉNÉRALE**

  

L'évolution des architectures informatiques impose une optimisation constante des ressources matérielles et une réduction des coûts d'exploitation. La consolidation des serveurs au travers de la virtualisation s'impose comme une stratégie incontournable pour maximiser l'efficacité énergétique et simplifier l'administration des systèmes informatiques modernes.

  

Au sein des centres de calcul et des laboratoires universitaires, la multiplication des serveurs physiques dédiés génère une sous-utilisation des capacités de traitement ainsi qu'une hausse significative des charges de maintenance. L'absence d'une infrastructure mutualisée limite la souplesse d'allocation des ressources et complexifie le déploiement de nouveaux services applicatifs. Il devient donc primordial de concevoir une architecture virtuelle centralisée capable d'isoler les services tout en rationalisant l'usage du matériel existant.

  

L'ouvrage intitulé _"Conception et déploiement d'une infrastructure de virtualisation KVM sous environnement Linux"_ répond à cette problématique d'optimisation matérielle. La démarche adoptée s'articule autour de trois chapitres principaux. Le premier chapitre présente l'établissement d'accueil, le cadre d'étude ainsi que l'analyse de l'existant. Le deuxième chapitre décrit la méthodologie de déploiement et l'inventaire des outils logiciels retenus. Enfin, le troisième chapitre détaille la réalisation technique, la mise en production ainsi que l'évaluation des performances globales de l'infrastructure.

  

**RÉSUMÉ**

  

Ce mémoire étudie la rationalisation des ressources matérielles au travers du déploiement d'une solution de virtualisation à haut rendement au sein d'une infrastructure informatique d'établissement. La prolifération des équipements physiques et la sous-exploitation des capacités de calcul représentent des contraintes majeures pour la gestion opérationnelle des réseaux. L'adoption d'un hyperviseur de type 1 permet de surmonter ces contraintes en offrant une gestion dynamique des capacités de traitement, de mémoire et de stockage.

  

La méthodologie retenue repose sur un audit préalable des charges de travail afin de dimensionner l'architecture cible. L'analyse comparative des hyperviseurs du marché a conduit à la sélection de la technologie KVM intégrée au noyau Linux. Le projet comprend la configuration de l'hyperviseur, la création de commutateurs virtuels pour la segmentation du trafic, la mise en place de politiques de stockage optimisées ainsi que l'élaboration de procédures de sauvegarde des machines virtuelles.

  

La phase d'évaluation confirme le succès de l'implémentation. Les tests de montée en charge démontrent une répartition équilibrée des ressources, une réduction significative de l'empreinte matérielle ainsi qu'une flexibilité accrue pour l'administration quotidienne. La solution garantit une haute disponibilité des services informatiques et offre une plateforme évolutive adaptée aux besoins pédagogiques et administratifs.

  

**Mots-clés :** Virtualisation, Hyperviseur KVM, Consolidation de serveurs, Linux, Segmentation réseau, Allocation dynamique.

  

### **Exercice 2 : Évaluation d'un mémoire sur la supervision et gestion des logs (Loki / Grafana)**

**Contexte :**

Un étudiant soumet la section d'introduction et le résumé d'un travail portant sur la centralisation des journaux d'événements et la surveillance réseau.

  

#### **Texte de l'étudiant :**

> **INTRODUCTION**
> 
> Dans les réseaux informatiques, il y a beaucoup de logs qui sont générés chaque minute. Je vais vous présenter la mise en place de Grafana et Loki. On a constaté que quand une panne arrive, on met beaucoup de temps à trouver la cause. Être capable de surveiller le réseau est très important. Faire l'installation de ces outils permet de résoudre les pannes rapidement. Mon livre contient trois chapitres : le chapitre 1 pour la présentation de l'entreprise et la situation actuelle, le chapitre 2 pour la démarche du projet et la présentation des outils, et le chapitre 3 pour la réalisation et l'évaluation.
> 
>   

> **RÉSUMÉ** _(Nombre de mots : 65 mots)_
> 
> On a travaillé sur la centralisation des logs dans une entreprise. L'utilisation de Grafana et Loki a permis d'afficher des graphiques pour surveiller les serveurs. Il y a eu des tests pour vérifier si les pannes sont détectées. Le travail est fini et donne entière satisfaction à la direction de l'entreprise.
> 
> _Mots-clés : Logs, Grafana, Loki, Panne._
> 
>   

#### **Travail demandé :**

1. **Analyse critique (Dresser le bilan des non-conformités) :**
    
    - Relevez les manques de structure (absence du découpage en 3 paragraphes).
        
    - Citez les verbes et pronoms proscrits utilisés par l'étudiant.
        
    - Évaluez le résumé par rapport au volume de mots minimal (250 mots) et aux principes du cours (absence de numérotation de page sur cette feuille, etc.).
        
    - Critiquez la formulation du titre et de la démarche dans le 3ᵉ paragraphe.
        
2. **Rédaction conforme :**
    
    - **Rédigez l'Introduction Générale** sous forme de **3 paragraphes équilibrés** sans aucun terme interdit.
        
    - **Rédigez le Résumé** conforme aux limites de mots (entre 250 et 500 mots) accompagné de ses **Mots-clés**.
        

### **Correction indicative - Exercice 2**

#### **1. Analyse critique (Erreurs identifiées) :**

- **Défaut de structuration :** Introduction rédigée sous forme d'un paragraphe unique sans séparation entre le cadre général, le cas particulier et le plan.
    
- **Présence de termes interdits :** `il y a`, `je`, `on a`, `être`, `faire`, `mon livre`.
    
- **Non-respect du volume du résumé :** Résumé de 65 mots (insuffisant par rapport à la fourchette **250 – 500 mots**).
    
- **Rappel des règles de mise en page du cours :** Le résumé et l'abstract **ne doivent pas porter de numéro de page**.
    
- **Mots-clés :** Manque de précision technique.
    
#### **2. Proposition de réécriture conforme :**

**INTRODUCTION GÉNÉRALE**

  
La complexification des infrastructures informatiques et la dispersion des équipements réseau imposent une visibilité constante sur l'état de santé des systèmes. La centralisation des journaux d'événements et la surveillance en temps réel constituent des mécanismes essentiels pour garantir la disponibilité des services, détecter les anomalies de fonctionnement et prévenir les cybermenaces.

  

Au sein des architectures décentralisées, l'absence de collecte automatisée des journaux d'audit rend la recherche d'incidents fastidieuse et inefficace. La dispersion des données d'événements sur chaque équipement ralentit considérablement le temps moyen de résolution des pannes et masque les signes annonciateurs de dysfonctionnements majeurs. L'élaboration d'une plateforme de supervision centralisée devient alors indispensable pour corréler les événements réseau et rationaliser l'intervention des équipes d'exploitation.

  

L mémoire intitulé _"Mise en place d'une plateforme de centralisation des journaux et de supervision avec Grafana et Loki"_ répond à ce besoin d'observabilité. La démarche adoptée comporte trois chapitres distincts. Le premier chapitre aborde la présentation de la structure d'accueil, l'analyse du cadre de stage ainsi que le diagnostic de la situation existante. Le deuxième chapitre détaille la démarche projet choisie et l'étude des solutions matérielles et logicielles à déployer. Enfin, le troisième chapitre expose la réalisation technique, l'évaluation des fonctionnalités mises en œuvre ainsi que le bilan global du projet.

  

**RÉSUMÉ**

  

Ce mémoire porte sur la conception et l'intégration d'une solution de centralisation des journaux d'événements et de visualisation métrique appliquée à une infrastructure réseau d'entreprise. Dans un environnement informatique distribué, l'hétérogénéité des équipements rend la traçabilité des incidents complexe et compromet la rapidité d'intervention en cas d'anomalie. La centralisation et l'analyse automatisée des données de logs constituent une réponse adaptée aux exigences de continuité de service et de sécurité opérationnelle.

  

La démarche méthodologique débute par la cartographie des flux d'événements et l'identification des sources d'informations critiques au sein du réseau. L'étude comparative des solutions de collecte et d'indexation a orienté le choix vers le déploiement du moteur d'agrégation Loki couplé à l'interface de restitution Grafana. La phase d'implémentation englobe l'installation d'agents de collecte sur les serveurs, la création de pipelines de transformation des données, la configuration de tableaux de bord personnalisés ainsi que le paramétrage de règles d'alerte automatisées en cas de dépassement de seuils critiques.

  

L'évaluation finale du système confirme une amélioration substantielle de la visibilité sur l'état opérationnel du réseau. La centralisation des informations réduit de façon significative le temps de diagnostic lors des incidents informatiques. La solution offre une plateforme robuste, évolutive et parfaitement intégrée aux activités quotidiennes d'administration et de gestion des systèmes.

  

**Mots-clés :** Supervision réseau, Centralisation des logs, Grafana, Loki, Observabilité, Traçabilité d'incidents.