
### l'objectif principal

 **Protéger le serveur, les données qu'il héberge et les utilisateurs qui y accèdent** 

---

**1. Masquage des informations du serveur**
La version d'Apache ainsi que les modules actifs ne doivent jamais être divulgués.

**2. Protection contre les attaques par déni de service (DoS)**
Le nombre de connexions simultanées et de connexions persistantes doit être limité afin de réduire l'impact d'éventuelles attaques DoS.

**3. Configuration des Virtual Hosts**
Chaque Virtual Host doit être défini par son adresse IP, puis son nom de domaine doit être précisé via la directive `ServerName`. Cette mesure permet de limiter les risques liés à des pannes DNS ou à des manipulations frauduleuses.

**4. Gestion des fichiers de log**
Les fichiers de log doivent être correctement configurés afin de permettre la surveillance et la détection de comportements anormaux sur le serveur.

**5. Gestion des droits d'accès (Directory, Files, Location)**
Les autorisations ne doivent être accordées qu'explicitement et au strict nécessaire,
Les accès aux répertoires légitimes sont ensuite ouverts individuellement.

**6. Sécurité des modules**
Seuls les modules strictement nécessaires au fonctionnement du serveur doivent être activés.

**7. Exécution du serveur et séparation des privilèges**
Le serveur Apache doit s'exécuter sous un utilisateur dédié sans privilèges élevés. Le compte `root` ne doit en aucun cas être autorisé à publier des pages via `UserDir`.
