
### l'objectif principal

 **Protéger le serveur, les données qu'il héberge et les utilisateurs qui y accèdent** 

---

**1. Masquage des informations du serveur**

La version d'Apache ainsi que les modules actifs ne doivent jamais être divulgués. La directive `ServerTokens Prod` doit être ajoutée dans le fichier de configuration principal (`httpd.conf`) afin de limiter la bannière du serveur à la seule mention `Apache`. De plus, la directive `ServerSignature Off` doit être activée pour supprimer la signature automatique dans les pages d'erreur générées par le serveur. Une page d'erreur personnalisée doit être définie via la directive `ErrorDocument 404 /missing.html`.

---

**2. Protection contre les attaques par déni de service (DoS)**

Le nombre de connexions simultanées et de connexions persistantes doit être limité afin de réduire l'impact d'éventuelles attaques DoS. La configuration suivante est recommandée pour un petit serveur :

```
MaxClients 150
KeepAlive On
MaxKeepAliveRequests 100
KeepAliveTimeout 5
```

---

**3. Configuration des Virtual Hosts**

Chaque Virtual Host doit être défini par son adresse IP, puis son nom de domaine doit être précisé via la directive `ServerName`. Cette mesure permet de limiter les risques liés à des pannes DNS ou à des manipulations frauduleuses.

```
<VirtualHost 194.57.201.103>
    ServerName www.mon-serveur.fr
    ...
</VirtualHost>
```

---

**4. Gestion des fichiers de log**

Les fichiers de log doivent être correctement configurés afin de permettre la surveillance et la détection de comportements anormaux sur le serveur. Les formats de journalisation `combined` et `common` doivent être définis, et les logs doivent être enregistrés dans des fichiers dédiés. La résolution inverse des adresses IP doit être activée via la directive `HostnameLookups On`, afin de faire apparaître le nom des machines à la place de leurs adresses IP.

---

**5. Gestion des droits d'accès (Directory, Files, Location)**

Par défaut, tout accès doit être interdit. Les autorisations ne doivent être accordées qu'explicitement et au strict nécessaire. La configuration de base obligatoire est la suivante :

```
<Directory />
    Order deny,allow
    Deny from all
    Options SymLinksIfOwnerMatch
    AllowOverride None
</Directory>
```

Les accès aux répertoires légitimes sont ensuite ouverts individuellement. Les fichiers `.htaccess` doivent être protégés contre tout accès via le web :

```
AccessFileName .htaccess
<Files ~ "^\.ht">
    Order deny,allow
    Deny from all
</Files>
```

Les options à risque telles que `FollowSymLinks`, `Includes`, `ExecCGI` et `Indexes` ne doivent pas être activées par défaut. Les scripts CGI doivent être limités à des répertoires strictement définis.

---

**6. Sécurité des modules**

Seuls les modules strictement nécessaires au fonctionnement du serveur doivent être activés. Les modules présentant des risques de sécurité doivent être désactivés ou configurés de manière restrictive. Pour le module PHP, les paramètres suivants doivent être appliqués dans `php.ini` :

```
safe_mode = On
expose_php = Off
max_execution_time = 30
memory_limit = 8M
magic_quotes_gpc = On
display_errors = Off
sql.safe_mode = On
```

---

**7. Exécution du serveur et séparation des privilèges**

Le serveur Apache doit s'exécuter sous un utilisateur dédié sans privilèges élevés. Le compte `root` ne doit en aucun cas être autorisé à publier des pages via `UserDir`. La configuration suivante est obligatoire :

```
User apache
Group apache
UserDir disabled root
```

L'utilisation de `suexec` pour séparer les contextes d'exécution entre Virtual Hosts doit faire l'objet d'une analyse approfondie avant activation, en raison des risques qu'il introduit s'il est mal configuré.
