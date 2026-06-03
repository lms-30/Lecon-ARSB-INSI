Un ZTNA (Zero Trust Network Access) est une solution d'**accès réseau** qui offre un **accès sécurisé** aux ressources, applications et données de l'entreprise grâce à une vérification d'identité rigoureuse. ZTNA se distingue des méthodes d'accès réseau traditionnelles par son principe « **Toujours vérifier, jamais faire confiance** ». Il est donc idéal pour sécuriser le télétravail et protéger les données sensibles.

#### Pourquoi les entreprises ont-elles besoin d'une solution d'accès réseau Zero Trust (ZTNA) ?


> [!NOTE] Réduction du risque d’intrusion
> Le modèle **Zero Trust** repose sur le principe du **"Never trust, always verify"** :
> Personne n’est automatiquement digne de confiance, même à l’intérieur du réseau de l’entreprise.

✅ Cela signifie que **chaque utilisateur, appareil ou application doit être authentifié et autorisé en continu** pour accéder à des ressources, limitant les mouvements latéraux en cas d'intrusion.


> [!NOTE] Télétravail et mobilité croissante
>Avec l’essor du **travail à distance**, les utilisateurs se connectent depuis divers lieux et appareils.

✅ ZTNA offre un **accès sécurisé aux ressources sans dépendre d’un VPN traditionnel**, souvent vulnérable aux failles de configuration ou aux attaques par vol d’identifiants.

> [!NOTE] Fin du périmètre de sécurité classique
> Le périmètre réseau d’entreprise (intranet sécurisé, pare-feu, VPN, etc.) n’est plus suffisant :
> - Applications hébergées **dans le cloud** (SaaS, IaaS, etc.)
> - Employés, partenaires et sous-traitants **externes au réseau**

✅ ZTNA permet une **gestion d'accès granulaire basée sur l'identité, le contexte et la conformité des appareils**.


> [!NOTE] Visibilité et contrôle accrus
> ZTNA fournit des mécanismes de :
> - **Contrôle d'accès basé sur des politiques dynamiques**
> -  **Surveillance continue des connexions**
> - **Journalisation des activités**

✅ Cela permet aux équipes de sécurité de mieux détecter les comportements suspects et d’y répondre plus rapidement.


> [!NOTE] Renforcement de la conformité
> Des normes comme **ISO 27001**, **RGPD**, **HIPAA** ou **NIST** exigent une protection rigoureuse des données.
> 

✅ ZTNA aide à **segmenter les accès**, **limiter les privilèges** et à **documenter les accès**, ce qui facilite la conformité réglementaire.


> [!NOTE] Protection contre les menaces internes
> Les employés ou partenaires malveillants peuvent causer d’énormes dégâts s’ils ont un accès excessif.

✅ Avec ZTNA, l'accès est **limité au strict nécessaire (principe du moindre privilège)**, et toute action suspecte peut être détectée plus rapidement.

#### En quoi l'accès réseau Zero Trust (ZTNA) est-il différent des réseaux privés virtuels (VPN) traditionnels ?


![[ZTNA_vs_VPNs.jpg]]

> [!NOTE] Sécurité
> ZTNA accorde l'accès selon la philosophie « Know to Access ». Cela signifie que seuls les utilisateurs et appareils autorisés sont explicitement identifiés et authentifiés avant de se voir accorder l'accès aux ressources à chaque fois. En revanche, un VPN ne s'authentifie qu'une seule fois, au début de la connexion. Cela peut être problématique, car cela expose potentiellement le réseau à des menaces internes une fois la confiance initiale établie.

> [!NOTE] Contôle d'Accèss
> Le ZTNA limite l'accès aux seules applications ou données nécessaires, réduisant ainsi considérablement la surface d'attaque. Les VPN, quant à eux, accordent aux utilisateurs un accès étendu à toutes les ressources de l'entreprise une fois authentifiés. Cela peut donner lieu à des accès plus importants que nécessaire, ce qui présente un risque potentiel de non-conformité.

> [!NOTE] Gestion du Trafic
> Le ZTNA achemine uniquement le trafic internet nécessaire via le tunnel, réduisant ainsi les temps d'attente **(exemple : Un employé accède uniquement à `app1` via ZTNA. Sa connexion à d'autres sites (comme Gmail ou LinkedIn) ne passe pas par l’entreprise, évitant toute congestion réseau inutile.) ** . À l'inverse, les VPN acheminent l'intégralité du trafic via le réseau de l'entreprise, créant ainsi des goulots d'étranglement susceptibles d'entraîner des retards et des perturbations pour les utilisateurs accédant aux ressources internes et aux sites web externes ** (exemple : Un utilisateur qui regarde une vidéo sur YouTube pendant qu’il est connecté au VPN consomme la bande passante de l’entreprise, ralentissant tout le réseau.) ** .


> [!NOTE] Scalabilité
> ZTNA est une solution cloud et sans matériel, facilitant l'évolutivité selon les besoins ** (Pas besoin d’acheter plus de serveurs ou de firewalls, On peut **monter en charge très facilement**, selon les besoins (ex. : télétravail massif) et Le fournisseur cloud gère l’infrastructure, ce qui réduit la complexité côté entreprise) ** . Les VPN traditionnels (**Repose sur des équipements physiques** et en plus Un VPN nécessite souvent : (des **appliances matérielles** (boîtiers VPN, pare-feu, etc.), des **licences logicielles** et des **ressources humaines** pour gérer le tout)) s'accompagnent de piles de sécurité qui nécessitent des investissements coûteux et une gestion complexe, ce qui complique leur évolutivité.

#### Quels sont les avantages du réseau Zero Trust ?


> [!NOTE] Sécurité renforcée
> ZTNA crée un tunnel sécurisé et crypté pour l'accès au réseau et la transmission de données, empêchant l'accès non autorisé et les acteurs malveillants.
> 
> ✅ **Exemple concret** :  
Une entreprise de services financiers utilise ZTNA pour que les employés puissent accéder à des bases de données sensibles depuis chez eux. Grâce au chiffrement du tunnel ZTNA, même si un pirate intercepte le trafic, **il ne peut rien lire** ni exploiter les données.

> [!NOTE] Accès authentifié
> ZTNA garantit que l'accès à votre réseau est accordé uniquement aux appareils et applications autorisés disposant des configurations de sécurité appropriées, minimisant ainsi les risques de failles de sécurité.
> 
> ✅ **Exemple concret** :  
 Un consultant externe se connecte au système de gestion de projet d’une entreprise. Avant l’accès, ZTNA vérifie : son identité (via MFA), son appareil (à jour, antivirus actif).                      Si l’un des deux échoue, **l’accès est refusé. **

> [!NOTE] Surface d'attaque réduite
> ZTNA accorde l'accès uniquement aux applications ou données requises, conformément aux politiques configurées, réduisant ainsi la surface d'attaque en cas de menaces internes.
> 
> ✅ **Exemple concret** :  
Un stagiaire en marketing a besoin d’accéder uniquement à l’application CRM. Avec ZTNA, il **ne voit ni n’accède** aux autres systèmes internes (comme les bases de données RH ou les serveurs techniques).  
➡️ Même s’il est piraté, le pirate **ne pourra rien faire en dehors du CRM.**

> [!NOTE] Accès BYOD sécurisé
> ZTNA garantit que les appareils personnels accédant aux ressources de l'entreprise respectent les exigences de sécurité grâce à l'architecture Zero Trust intégrée.
> 
> ✅ **Exemple concret** :  
Un commercial utilise son propre smartphone pour accéder aux emails d’entreprise. ZTNA détecte que le téléphone est :                                                                                                                                                             protégé par mot de passe,                                                                                                            avec antivirus actif,                                                                                                                        sans root ni jailbreak.                                                                    Sinon, **l’accès est bloqué automatiquement.**

> [!NOTE] Travaillez où que vous soyez
> ZTNA permet aux employés distants d'accéder aux ressources de l'entreprise en toute sécurité, où qu'ils soient dans le monde et à tout moment.
> 
> ✅ **Exemple concret** :  
Une développeuse travaille depuis un café à l’étranger. Grâce à ZTNA, elle peut accéder uniquement à son environnement de développement sécurisé via tunnel chiffré, **sans exposer le réseau interne complet** à Internet.

> [!NOTE] Atténuation des violations de données
> Le trafic Internet est acheminé en toute sécurité via le tunnel ZTNA, éliminant ainsi les risques de violations de données et d'accès non autorisés.
> 
> ✅ **Exemple concret** :  
Un employé tente d’envoyer un fichier confidentiel vers un service de stockage personnel (comme Dropbox).  
ZTNA bloque automatiquement ce transfert car : le service n’est pas autorisé et le contenu sort du périmètre défini. ➡️ Cela **évite une fuite accidentelle ou malveillante**.

**1. Qu'est-ce qu’un VPN ?**
Un **VPN (Virtual Private Network)** est un outil qui :
- **masque votre adresse IP** pour cacher votre position réelle,
- **chiffre vos communications** en ligne pour protéger votre vie privée,
- permet **d’accéder à des contenus géo-restreints** (ex : Netflix USA depuis l’Europe).

🎯 **Limite principale** : une fois connecté, l'utilisateur est **considéré comme fiable** dans tout le réseau, ce qui peut être risqué si une menace s’introduit.

**2. Qu’est-ce qu’un réseau Zero Trust (Zero Trust Network) ?**
Un **réseau Zero Trust** repose sur le principe :

> 🔒 "**Ne jamais faire confiance, toujours vérifier**."

Cela signifie que **chaque tentative d'accès** à une ressource (application, fichier, base de données) est :
- **authentifiée** (identité confirmée),
- **autorisée** (vérification des droits d’accès),
- et **réévaluée en continu**, même après connexion. 

➡️ **Aucun utilisateur ou appareil n’est automatiquement digne de confiance**, même s’il est dans le réseau.

**3. Quelles sont les différences entre VPN et ZTNA ?**

| Fonction                   | VPN traditionnel                     | ZTNA (Zero Trust Network Access) |
| -------------------------- | ------------------------------------ | -------------------------------- |
| ✅ Authentification         | Une seule fois à la connexion        | À chaque tentative d’accès       |
| 🔐 Sécurité interne        | Une fois dans le réseau, accès large | Accès limité selon le besoin     |
| ⚠️ Risque en cas d’attaque | Accès à tout le réseau possible      | Accès contrôlé et isolé          |
| 🌍 Télétravail             | Fonctionnel mais lent et risqué      | Sécurisé et performant           |
🧠 **Analogie** :
- **VPN** = château fort : une fois franchie la porte, on accède à toutes les pièces.
    
- **ZTNA** = coffre-fort intelligent : chaque pièce a une serrure différente, et il faut une clé spéciale pour chaque ouverture.

**4. Quels sont les 3 principes fondamentaux de l’architecture Zero Trust ?**

1. 🔄 **Vérification continue** : chaque accès est réévalué (identité, appareil, comportement).
    
2. 🎯 **Accès à privilèges minimaux** : l’utilisateur ne voit que ce qu’il est autorisé à voir.
    
3. 🛡️ **Réduction de l’impact d’une brèche** : si une attaque survient, les dégâts sont limités à une seule zone.

**5. Comment fonctionne ZTNA ?**
Le **ZTNA** fonctionne en analysant et en contrôlant :

- **qui demande l’accès** (identité de l’utilisateur),
    
- **depuis quoi** (état de l'appareil, géolocalisation, antivirus actif),
    
- **pour accéder à quoi** (application ou donnée spécifique).
    

✅ **L’accès est accordé uniquement si toutes les conditions de sécurité sont réunies**.

> 📌 Par exemple : un employé qui se connecte depuis un appareil non à jour ou sans antivirus actif se verra **refuser l’accès**, même s’il entre le bon mot de passe.

# Les 5 étapes pour implémenter un ZTNA

###### Si nous devons mettre en place un ZTNA
### 1. Évaluation des besoins

Il faut commencer par délimiter de façon claire vos besoins en matière de cybersécurité :

- Protection renforcée : ==quelles applications présentent une plus grande vulnérabilité que d’autres== ?
- Répartition des accès : ==quels utilisateurs utilisent quelles applications, à quelles conditions== ?
- Examen du système de sécurité existant : ==votre réseau est-il protégé par une solution VPN ou un pare-feu, par exemple== ?
- Historique des incidents : ==quelles attaques externes ont déjà touché votre architecture réseau malgré ces solutions déjà en place== ?

L’examen des solutions déjà actives permettra d’identifier les zones d’ombres dans notre cybersécurité

### 2. Sélection de la solution ZTNA


> [!NOTE] choix selon nos besoins
> Déterminez laquelle de ces solutions apporte les fonctionnalités capables de couvrir l’ensemble de nos besoins précédemment définis.

### 3. Configuration et déploiement

##### Pour déployer un **ZTNA,** je peux donc utiliser les technologies de **sophos** et de **fortinet** ?

Oui, vous pouvez tout à fait utiliser les technologies de **Sophos** et de **Fortinet** pour déployer un **ZTNA** dans votre infrastructure réseau.

**Sophos ZTNA** propose une solution flexible qui peut être déployée soit avec une passerelle sursite (sur VMware ESXi ou Hyper-V), soit via une **passerelle cloud** gérée par **Sophos** **Central**. Elle inclut un agent **ZTNA** installé sur les **terminaux** pour contrôler l’accès aux **applications** **locales** et **web**, avec une gestion centralisée des politiques d’accès, des utilisateurs et des ressources via **Sophos** Central.

**Fortinet ZTNA** (appelé Universal ZTNA) s’intègre dans la **Fortinet** **Security Fabric**, notamment
via **FortiGate** (pare-feu nouvelle génération) et **FortiClient** (agent endpoint). Cette solution permet un contrôle granulaire des accès applicatifs, une vérification continue de l’identité et de la posture des appareils, et fonctionne aussi bien pour les utilisateurs distants que sur site. **Fortinet** offre aussi une intégration avec **FortiSASE** pour un accès sécurisé dans le **cloud**, avec des fonctionnalités de tagging et de contrôle d’accès dynamique.

En résumé, les deux fournisseurs proposent des architectures complètes **ZTNA** avec :
Passerelles (on-premise ou cloud) : 

- Agents sur endpoints
- Gestion centralisée des politiques et utilisateurs
- Intégration avec les annuaires et MFA
- Contrôle d’accès granulaire et chiffrement des sessions

**quelle est donc le plus bon choix**

Le choix entre **Sophos** et **Fortinet** pour déployer un **ZTNA** dépend principalement de vos besoins spécifiques, de la taille de votre organisation, et de vos ressources **IT**. Voici une comparaison synthétique basée sur les points forts et limites de chaque solution :


| Critère                      | Sophos                                                                | Fortinet                                                                                       |
| ---------------------------- | --------------------------------------------------------------------- | ---------------------------------------------------------------------------------------------- |
| Cible principale             | PME, moyennes entreprises avec IT limitée                             | PME à grandes entreprises, environnements complexes                                            |
| Facilité d’usage             | Interface utilisateur simple, gestion centralisée via Sophos Central  | Plus complexe, courbe d’apprentissage plus élevée                                              |
| Fonctionnalités<br>ZTNA      | ZTNA intégré dans l’écosystème, gestion synchronisée avec endpoints   | ZTNA via FortiGate et FortiClient, intégration<br>dans Fortinet Security Fabric                |
| Performance                  | Bonnes performances, mais<br>généralement inférieures à Fortinet      | Très haute performance grâce aux processeurs SPU dédiés                                        |
| Gestion et<br>administration | Gestion centralisée intuitive, licence<br>HA simplifiée               | Gestion avancée via FortiManager, contrôle d’accès basé sur rôles, rétention des logs sur 1 an |
| Coût                         | Généralement plus abordable avec gestion cloud gratuite               | Coût plus élevé, fonctionnalités avancées<br>souvent payantes                                  |
| Protection<br>avancée        | Sécurité synchronisée, deep learning AI, protection endpoint intégrée | Protection avancée (sandboxing, ATP),<br>écosystème de sécurité étendu                         |
| Adapté pour                  | Organisations recherchant simplicité et intégration facile            | Organisations nécessitant haute performance,<br>personnalisation et large écosystème           |
En résumé, Sophos est souvent recommandé pour les PME et organisations cherchant une
solution ZTNA facile à déployer et à gérer, avec une bonne intégration entre firewall et
endpoint .
Fortinet est plus adapté aux grandes entreprises ou environnements complexes qui ont
besoin de performances élevées, de fonctionnalités avancées et d’une gestion fine des
accès et des logs .

### 4. Surveillance et gestion continue

Après l’implémentation, place à la gestion. Une surveillance accrue et continue des activités du réseau permettra de détecter toute tentative d’intrusion ou de contournement des politiques de sécurité. Les cybermenaces évoluent sans cesse : cela implique de mettre à jour régulièrement les politiques pour contrer de nouvelles menaces.

### 5. Formation et sensibilisation au ZTNA

L’adoption réussie du **ZTNA** repose sur la compréhension et la coopération de vos **utilisateurs**. Organisez des sessions de formation pour expliquer les avantages et les changements apportés par le **ZTNA**. Durant ces sessions, vous pourrez sensibiliser vos utilisateurs aux nouvelles méthodes d’accès sécurisées et aux bonnes pratiques de cybersécurité, insister sur le danger évolutif que représentent les cybercriminels et ainsi les responsabiliser.