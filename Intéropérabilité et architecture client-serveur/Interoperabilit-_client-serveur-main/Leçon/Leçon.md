## Introduction

- **contexte**:
	Aujourd'hui il existe un certain nombre de plateforme pou créer des apps. Chacune d'entre elle utilise généralement ses propres protocoles, le plus souvent de type **binaires**, pour l'intégration de machine à machine.

- **problématique**:
	En conséquence, les apps fonctionnant sur des plateformes différentes n'ont qu'une faible capacité de partages de données. 

La prise de conscience de ces limites a entraîné un gros efforts de standardisation de formats de données et échange de donnée. En effet les regards se tournent de plus en plus vers un nouveau paradigme informatique, une intégration transparente des services web qui dépasse les barrières logiciel et matériels traditionnel . Au cours de cette vision se trouve le concept d'**intéropérabilité**, c-a-d la capacité pour des sys disparates de **comm** et de **shares** des data de façon transparente. C'est l'objectif des services web.

Un service web est une logique d'application programmable accessible à l'aide des protocoles Internet standard que l'on peut aussi décrire comme l'implémentation de standard web por une comm transparente entre les machines et les apps.

Un certain nbr de tech de service web tel que le protocole **SWAP**, le langage **VSDL**, et le protocole **HTTP**, sont actuellement utilisés pour transférer les messages entre les machines. La complexité de ces messages est très variables pouvant aller de l'appel de méthode à la soumission d'un bon de commande. Une fct courante, de niveau plus élevé, d'un service web consiste à implémenter la comm de type **RPC** (Remote Procedure all). RPC signifie alors `appel de procédure à distance` permettant à un pg sur un PC d'exécuter un pg sur un autre PC.

## Middleware

### Définition
En architecture info, un **middleware** est un logiciel tiers qui crée un réseau d'échange d'info entre différentes app informatique. Le réseau est mis en oeuvre par l'utilisation d'une même technique d'échange d'informations dans toutes les apps impliquées à l'aide des composants logiciel.

Un **middleware** est aussi un logiciel de connexion qui se compose d'un ensemble de service et/ou de milieu de dev d'app distribuée qui permettent à plusieurs entités (processus, objet, ...) résidant sur un ou plusieurs PC, d'interagir à travers un réseau d'interconnexion en dépit des différences dans les protocoles de comm, architecture des réseau locaux, sys opérationnels, etc.

### Système distribué
#### Définition
Un sys distribué est une collection de postes qui sont connectés à l'aide d'un réseau de comm. Chaque poste exécute des composants et utilise un **midddleware** qui s'occupe d'activer les composants et de coordonner leurs activités de tel sorte qu'un user perçoive le sys comme un unique sys distribué

#### Modèle client/serveur
Voici un schéma gal d'interraction au niveau app

- Le client demande l'exécution d'un service (requête), le serveur réalise le service (réponse)
- Client et serveur sont (en gal ,pas nécessairement) localisés sur deux machines distincts
- Indépendances interfaces-réalisations
- Comm par message (plutôt par partage de données, mémoire ou fichier): 
	- requête: paramètre d'appel, spécification du service requis
	- réponse: résultat, indicateur éventuel d'exécution ou d'erreur
	- Comm synchrone (comm en même temps)(ds le modèle de base: le clt est bloqué en attente de la réponse)


#### Avantages des middleware

- **Abstraction de la complexité de la comm**:
	Les middlewares fournissent une couche d'abstraction qui masque la complexité de la comm réseaux et des protocoles sous-jacentes. Cela permet au dev de se concentrer sur la logique métier de leurs apps plutôt que sur les détails tech de la comm
- **Interopérabilité**:
	Ils facilitent l'interopérabilité entre les composants distribués écrits avec des langages de programmation différents. Cela signifie qu'on peut combiner des tech hétero pour construire des sys distribués.
- **Réutilisation**
	Les middlewares permettent de réutiliser des composants logiciels, des services, ou des objets distribués. Cela favorise la modularité, la réutilisation du code, et réduit le développement d'app.
- **La scalabilité**
	Ils sont conçus pour évoluer de manière transparente. Ils permettent de gérer de manière efficace une croissance de la charge et de la demande, ce qui est essentiel dans env distribué
- **Sécurité**:
	Les middlewares proposent souvent des mécanismes de sécurité intégré pour protéger la comm et les données.
- **Gestion des transactions**:
	Certains Middleware offrent des fonctionnalités de gestion de transactions, ce qui permet de garantir la cohérence des données dans un sys distribué, même en cas d'échec.
- **Gestion de la file d'attente**:
	Les middleware orientés message (MOM) offrent des mécanismes de gestion de la file d'attente, qui sont utile pour la comm asynchrone entre les composants.
- **Extensibilité**:
	Les middlewares sont souvent extensible, ce qui signifie qu'on peut ajouter de nouvelles fonctionnalités ou composants à un sys distribué sans remettre en cause l'arch globale.


#### Les différents types de Middleware

Le type d'unité distribué de traitement fait l'objet de la classification des middleware:
- **MOM**: Middleware par file d'attente ou par échange de message
- **RPC**: midleware par appel de procédure éloignée. 
- **RMI, COBRA, COM**: Middleware orienté objet