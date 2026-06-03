
###### Definition

S.E développé par **Microsoft** .il est conçu pour gérer, stocker et traiter des données, pour exécuter des services réseau et des applications. 
Voici quelques points clés concernant Windows Server:

**Gestion des serveurs, Active Directory,Hyper-V, service web,Fonctionalités de sécurités, Scalabilité et performance, Réseautique,Solutions de stockage**


> [!NOTE] Scalabilité
> miova automatiquement les ressources raha ohatra ka mihatratra 100% ny CPU na RAM ary raha miverina amin'ny normale de midina ndray ny ressources
>


> [!NOTE] WIn serveur vs WIN 10/11
> WIN serveur : milti-utilisateurs qui peuvent connecter simultannement
> WIN 10/11: mono-utilisateurs

> [!NOTE] AZURE et BitLocker
> AZURE: service cloude de Microsoft
> BitLocker: Fonction de sécurité windows qui crypte les disque durs pour protéger nos données en cas de vole ou de perte d'appareil.



> [!NOTE] Rôles et fonctionnalités des win serveurs
> 1. Active Directive directory( AD DS) : service developé par microsoft pour l'evironnement win serveur. son rôle est de gérer des identités et accèss au sein des réseaux  d'entreprise
> 2. Serveur DNS (Domain Name System) : traduire un adresse IP en nom de domaine lisible par l'home
> 3. Serveur DHCP: Un service qui attribut automatiquement des adresse IP et d'autre information réseau aux appareils connectées.
> 4. Serveur de fichier et d'impression : un ==serveur informatique qui gère à la fois les fichiers et les imprimantes==, permettant ainsi aux utilisateurs d'un réseau de stocker et de partager des données, ainsi que d'accéder à des imprimantes centralisées.
> 5. Hyper-V : Plateforme de virtualisation développer par Michrosoft et intégrée dans windows server
> 6. Serveur web (I.I.S) : *l s'agit d'un puissant serveur web qui offre une plateforme robuste pour héberger des sites web, des applicatios web et services web*

alternative de serveur apache 2 en Windows serveur est **I.I.S** (Internet Information services)

La différence entre serveur mail Linux et Windows serveur  Exchange est la gestion des calendrier et contact c-a-d synchronisation des calendrier et contact Mais coûteux
 On promise : manana serveur hoazy manokany mintsy (manana contrôle Total au serveur)

BitLocker est ==une fonctionnalité de chiffrement de lecteur fournie par Microsoft dans ses systèmes d'exploitation Windows==. Son objectif principal est de protéger les données stockées sur un ordinateur en chiffrant l'intégralité du disque dur, rendant ainsi les données inaccessibles sans la clé de décryptage appropriée.
#### Architecture de Windows Serveur (Modèle Client-serveur)

Windows Serveur est fondé sur un modèle **Client-serveur** c'est-à-dire un ==mode de communication informatique où plusieurs clients se connectent à un serveur central pour accéder à des ressources et services==. Le serveur gère ces ressources et répond aux requêtes des clients.

#### Architecture réseau et protocoles, service de base

![[WhatsApp Image 2025-06-11 at 06.23.53.jpeg]]





### Comparaison avec d'autre systèmes serveur


> [!NOTE] Windows
> - Support une large gamme d'applications commerciales et d'entreprise   
> - interface utilisateur graphique (GUI) robuste avec des outils comme PowerShell


> [!NOTE] Linux
> 


### Cas d'utilisation typiques de Windows Serveur
1. Gestion d'identité et d'Accès (AD)
2. Hébergement des services Web
3. Service de messagerie  et collaboration
4. Partage de fichiers et d'impression
5. Virtualisation et Cloud Privé (manana hyperviseur de niveau 1)
6. Sauvegarde et Récupération avec Windows Server Backup : il offre des fonctionnalités de sauvegarde et de récupération pour protéger les données critiques et restaurer les système en cas des senestre
7. Sécurité et Gestion des Systèmes (windows Defender) : offre une protection contre les menaces, les virus et les attaques
8. Analyse des données et Business intelligence (Microsoft SQL serveur)
9. Intégration avec d'autre 


> [!NOTE] SharePoint Serveur
> Plateforme cloud développé par Microsoft: offre une gestion des partages des documents
> 

### Licences et Editions Windows Server 

### 1. **Windows Server Essentials**

- **Fonctionnalité :** Conçu pour les petites entreprises avec des besoins limités.
    
- **Licence :** Licence couvrant un serveur physique, limité généralement à **25 utilisateurs** ou **50 appareils maximum**.
    
- **Fonctionnalités principales :** Active Directory (AD), gestion centralisée des utilisateurs et données, sauvegarde intégrée, administration simplifiée.
    
- **Cas d’usage :** TPE/PME qui ont besoin d’un contrôleur de domaine simple et de services de fichiers.
    

---

### 2. **Windows Server Standard**

- **Fonctionnalité :** Idéal pour les environnements **peu ou moyennement virtualisés**.
    
- **Licence :** Licence par cœur (minimum 16 cœurs par serveur). Chaque licence couvre **2 machines virtuelles (VMs)** + l’hôte physique.
    
- **Fonctionnalités principales :** Active Directory, DNS, DHCP, Hyper-V, conteneurs Windows Server, Storage Spaces Direct, fonctionnalités de sécurité comme Shielded VMs.
    
- **Cas d’usage :** PME ou ETI ayant besoin de services d’infrastructure avec quelques VMs.
    

---

### 3. **Windows Server Datacenter**

- **Fonctionnalité :** Conçu pour les environnements **hautement virtualisés** et les **clouds privés**.
    
- **Licence :** Licence par cœur (minimum 16 cœurs par serveur). **Nombre illimité de VMs** et de conteneurs.
    
- **Fonctionnalités principales :** Toutes celles de la version Standard + fonctionnalités avancées comme Storage Spaces Direct, Shielded VMs, Software-Defined Networking (SDN).
    
- **Cas d’usage :** Grandes entreprises, datacenters, environnements avec forte densité de virtualisation ou cloud privé.
    

---

### 4. **Windows Server IoT (Internet of Things)**

- **Fonctionnalité :** Version spécialisée pour les **solutions embarquées** et intégration dans les **appareils IoT industriels**.
    
- **Licence :** Licence OEM (fournie par les fabricants d’appareils). Usage lié au matériel spécifique.
    
- **Fonctionnalités principales :** Basé sur Windows Server Standard ou Datacenter, mais adapté pour fonctionner dans des environnements dédiés (appareils connectés, terminaux, solutions industrielles).
    
- **Cas d’usage :** Automatisation industrielle, systèmes embarqués, solutions de sécurité physique, passerelles IoT.

# AVANTAGES et INCONVÉNIENTS DE WINDOWS SERVER

## Avantages de Windows Server

- **Intégration avec d’autres produits Microsoft** : Active Directory (AD), Exchange Server, SharePoint, SQL Server, etc.
    
- **Support technique robuste** : Microsoft propose une assistance complète et des mises à jour régulières (sécurité et correctifs).
    
- **Interface conviviale** : Gestion simplifiée via le **Server Manager** et compatibilité avec **PowerShell** pour l’automatisation.
    
- **Écosystème riche** : Compatible avec de nombreux logiciels tiers et services cloud (Azure, Office 365).
    
- **Flexibilité** : Adapté pour différents scénarios (petite entreprise avec Essentials, environnements virtualisés avec Datacenter).
    
- **Sécurité** : Outils avancés comme BitLocker, Shielded VMs, et pare-feu Windows Defender intégré.
    
##  Inconvénients de Windows Server

- **Coût élevé des licences** (surtout pour Standard et Datacenter).
    
- **Consommation de ressources** importante (RAM, CPU, stockage) par rapport à certaines alternatives comme Linux.
    
- **Dépendance à Microsoft** (écosystème fermé).
    
- **Courbe d’apprentissage** pour certaines fonctionnalités avancées (ex : Hyper-V, Active Directory Federation Services).
    
- **Moins flexible** que les solutions Linux pour certains environnements spécialisés.
    

---

## Prérequis matériels (Windows Server 2022 – version récente)

### **Minimum requis :**

- **Processeur :** 1,4 GHz 64-bit compatible (x64) avec support **NX et DEP**, **CMPXCHG16b**, **LAHF/SAHF**, et **PrefetchW**.
    
- **RAM :** 512 Mo (2 Go pour l’option Desktop Experience).
    
- **Stockage :** 32 Go minimum (plus recommandé si plusieurs rôles installés, comme AD DS ou WSUS).
    
- **Carte réseau :** Compatible avec gigabit Ethernet, support PXE boot (optionnel).
    
- **Firmware :** UEFI 2.3.1c avec Secure Boot (recommandé).
    
- **Carte graphique :** Super VGA (1024 × 768) ou plus.
    

### **Recommandé pour de bonnes performances :**

- **Processeur :** 2 GHz ou plus, multi-cœurs.
    
- **RAM :** 8 Go ou plus (16 Go+ recommandé pour Datacenter/virtualisation).
    
- **Stockage :** 64 Go ou plus sur SSD.
    
- **Réseau :** 10 GbE pour datacenter.



#### Active Directory:

##### Définition 
 L'active Directory est un annuaire pour un système d'exploitation Windows, l'objective de centraliser trois fonctionnalités essentielles:
- Identification
- Authentification
- Autorisation
En globalité, Active direcory est une base de données nommées NTDS.DIT()

##### Rôle Active Directory
- stockage centralisé
gestions des informations d'identifications et des ressources réseau.
- Gestion des identités et des accès
gestions des utilisateurs, les groupes, les ordinateurs et d'autres objets
- Répartition des services
gestion de répartition des services et des ressources à travers un réseau, assurant ainsi la disponibilité et l'accès efficace


### Conceptes clés dans un active directory

> [!NOTE] Domaines
> Representé par un triangle
> est un regroupement d'objet qui partagent une même base de données AD
> 

> [!NOTE] Forêt
>Une forêt est un ensemble de domains


> [!NOTE] Contrôleurs de domaine
> Serveurs qui hébergent l'Active Directory et Authentifient les utilisateurs et les ordinateurs sur le réseau.


> [!NOTE] Objets
> Les entités gérér par AD, comme les utilisateurs, les ordinateurs, les imprimantes

> [!NOTE] Organisational Units (OU)
> Conteneurs dans un domaine qui peuvent contenir d'autre objets AD, permettant une gestion hiérarchique et l'app de stratégies de groupe (Groupe Polices)

> [!NOTE] Groupe Polices
> Ensemble des règles qui contrôlent l'environnement de travail des utilisateurs et des ordinateurs

> [!NOTE] Authentification et autorisation
> AD est responsable de vérifier les identités des utilisateurs(Authentification) et determiner à quelles ressources ils peuvent accéder (autorisation)


## Composants du schéma AD


> [!NOTE] Classes d'objets
> Classes structurées
> Classes abstraites
> Classes auxiliaires
> Classes dynamiques


> [!NOTE] Attributs
> Les attributs définissent les propriétés des objets. Par exemple, un utilisateur peut avoir des attributs tels que nom, prénom, mail

> [!NOTE] OID (Object Identifier)
> Chaque classe et attribut est identifié de manière unique par un OID, garantissant l'unicité globale


> [!NOTE] Règles de syntaxe
> Les règle qui définissent les types de données que les attributs peuvent stocker (chaînes de caractères, nombres, dates, etc, ...)

## structure AD

1. structure logique
![[WhatsApp Image 2025-07-23 at 07.50.48.jpeg]]
 GPO: Groupe Onlisize Object





2. structure Physique

![[WhatsApp Image 2025-07-23 at 08.02.32.jpeg]]

Importances de la  Structure Logique et Physique

![[WhatsApp Image 2025-07-23 at 08.06.21.jpeg]]


NB: DC(Domaine Contrôler)



> [!NOTE] Internet Service Provider
> Fournisseurs d'accès internet

### Création des utilisateur

![[WhatsApp Image 2025-07-23 at 08.13.23.jpeg]]


### Création des groupe

![[WhatsApp Image 2025-07-23 at 08.26.25.jpeg]]

### Ajout ordinateur windows dans un domaine

![[WhatsApp Image 2025-07-23 at 08.50.05.jpeg]]
![[WhatsApp Image 2025-07-23 at 08.52.26.jpeg]]

Serveur DNS : mamadika Nom de domaine ho adresse IP

GPI : 