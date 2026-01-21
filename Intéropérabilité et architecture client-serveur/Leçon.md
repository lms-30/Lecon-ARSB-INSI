**Interopérabilité et architecture client-serveur :** 

Interopérabilité: fomba fiara-miasa @na javatra tsy mitovy (système, matériel, application)

### Introduction

Aujourd'hui, il existe une certaine nombre de plateforme pour créer des application. Chacune d'entre elle utilise généralement ce protocole, le plus souvent de type binaire, pour l'intégration de machine à machine. En conséquence, les application fonctionnant sur des plateformes différentes non qu'une faible de capacité de partage des données. La prise des consciences de ces limites a entraînée un gros effort des standarisation des format des données et échange des données.

En effet , les regard se tourne de plus en plus vers une nouveau paradigme informatique, une intégration transparente des services WEB qui dépasse les barrières logiciels et matériels traditionnels.

Au cœurs de cette vision se trouve les concepts interopérabilité, c'est à dire la capacité pour des système disparate de communiquer et de partager des données de façon transparentes. C'est l'objectifs des services WEB. Un service WEB est une logique d'une application programmable accessible à  l'aide d'un protocole internet Standard que l'on peut aussi décrire comme l'implémentation de standard WEB pour une communication transparents entre les machines et les application.

### Technologie 
Un certain nombre des technologie de service WEB tels que : le s protocole SOAP (Simple Object Access Protocol ), le langage WSDL (), HTTP, sans actuellement utilisé pour transférer les messages entre les machines.  La complexité des ces messages est très variable pouvons aller de l’appelle des méthode à la soumission d'un bon de commande. Une fonction courante, de niveau plus élevée, d'un service WEB consistent a implémenté la communication de RPC (Remote Procedure Call). RPC signifie alors appel des procédure à distance permettant  un programme sur une ordinateur d’exécuter une programme sur un autre ordinateur.


### Chapitre 1 : Middleware

#### 1. Définition
 En architecture informatique, une Middleware est une logiciel tier qui créer une réseau d'échange d'information entre différente application. Les réseau est mis en oeuvre pour par l'utilisation du même technique d’échanges d'information dont toutes les application impliquée a l'aide d'un composant logiciel.
 
Un Middleware est un logiciel de connections qui se compose d'un ensemble des services et ou de milieu développement d'application distribuer qui permette à plusieurs entité (processus, Objet,...) résidents sur un ou plusieurs ordinateurs, d’interagir à travers un réseau d’interconnexion en depuis de différences dont les protocole de communication, architecture d'un réseau locaux, système opérationnels.

#### 2. Système distribués

##### a. Définition
un système distribué est un collection des poste qui sont connecté à l'aide d'un réseau de communication. Chaque poste exécute des composante et utilise une intergiciel qui s'occupe d'activer les composantes et de coordonner leurs activités de tel sorte qu'un utilisateur perçoivent les système comme une unique système intégré.
##### b. Modèles Client/serveur
Voici un schémas général d'intéraction au niveau application :

![[WhatsApp Image 2025-11-19 at 11.36.10.jpeg]]

- Le client demande l’exécution d'un service; les serveur réalise les services
- Client et serveur sont (en général, n'est a nécessairement) localisé sur deux machine distinct
- Indépendance interface - réalisation
- communication par message (plutôt par partage des données, mémoire ou fichier) : 
		- requête : paramètre d'appel, spécification des services requis
		- Réponse : resultat, indication éventuelle d'execution ou d'erreur
- Communication Synchrone : le client est bloqué en entente des réponse

### Avantages de MiddleWare

- **Abstraction de la complexité de la communication** : le middleware fournissent une couche d'abstraction qui masque la complexité de la communication réseau et des protocole sous-jaçent. cela permet au développeur de se concentrée sur la logique métier de leur application plutôt que sur le détails technique de leur communication.
- Intéropérabilité : les middleware facilitent l'intéropérabilité entre des composants distrubués écrit dans les différents langage de programmation, cela signifie qu'on peut combiné des technologie hétérogène pour construire des systèmes distribués.
- Réutilisation : Les middleware permet de réutilisé des composants logicielles, des services ou des objets distribuées. Cela favorise la modularité, la réutilisation du code, et réduit le développement d'application.
- La scalabilité : les middleware sont conçues pour évolué de manière transparentes. Il permette de gérer de manière efficace et croissante de la charge et de la demande, ce qui est essentielles dans les environnements distribuées.
- sécurité : les middleware propose souvent des mécanismes des sécurités intégrés pour protège de la communication .
- Gestion des transactions : certains middleware offrent des fonctionnalités des gestion des transaction, ce qui permet de garantir la cohérence des données dans un système distribué, même en cas d'échec.
- Gestion de la file d'attente : les middlewares orienté message(MOM) offrent des mécanisme de la gestion des file d'attentes, qui sont utils pour la communication asynchrone.
- Extensibilité : les middleware sont souvent extensible ce qui signifie qu'on peut ajouter des nouvelles fonctionnalités ou composants à un système distribuées san remèttre en cause les systèmes global.

### Différent Type des Middleware
Les types d'unité distribué des traitements fait l'objet des classification des middleware :
- Middleware par file d'attente (MOM(Message Oriented Middleware))
- Middleware par appelle de procédure éloignée (RPC(Remote Procedure Call))
- Middleware orientée Objet(RMI(Remote Methode Invocation),COBRA(Comon Object Request Broken Architecture, COM(Component Object Model)(Microsoft)


