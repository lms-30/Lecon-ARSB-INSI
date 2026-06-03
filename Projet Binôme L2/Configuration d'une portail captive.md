Pour créer une portail captive avec pfsense, nous allons se rendre sur le chemin **Services > Captive Portal** et on clique sur le boutons **+Add**

![[Pasted image 20250719153624.png]]
Ici nous allons créer une portail captive d’accès au réseau LAN pour une raison de sécurité

Lorsqu'on a fini de remplir les formulaires (nom de la zone et sa description), On clique sur le boutons **Save & Continue** 

![[Pasted image 20250719154427.png]]

Pour configurer le poratil captive de LAN, nous allons cocher boutons **Enable Captive portal**

![[Pasted image 20250719154852.png]]

D'apres l'image, nous avons configurer une poratail sur l'inerface LAN avec de 3 maximum connections dont le durée de connectons de 10 minutes. Et nous avons indiquer aussi que si l'utilisateur n'est pas actifs pendants 10, il sera déconnecté automatiquement

Et après, la configuration du page d'authentification:

![[Pasted image 20250719160203.png]]

Pour que les utilisateurs puissent s'authentifié, il suffit d'activer le page d'authentification

![[Pasted image 20250719160613.png]]

Ici, nous indiquons notre serveur d'authentification qui nommé RADIUS
Si on active l'options Reauthentication Users, les utilisateurs seraient s'authentifier chaque minute, donc on laisse comme ça.

![[Pasted image 20250719161502.png]]
On active, le transmission de la comptabilité des informations reçus par pfsense vers la serveur Radius
![[Pasted image 20250719162058.png]]

Et on sauvegarde les configurations


##### Teste de configuration
Pour tester ce configuration, nous allons connecter sur le réseau LAN, et après nous sur un navigateurs et nous allons tenter d’accéder sur une page web

ce que nous allons faire maintenant, c'est d'essayer d'accéder le serveur BDD sur l'interface sur le réseau local LAN

![[Pasted image 20250719164128.png]]

Lorsque je demade d'accéder au serveur BDD, je suis obligé de s'authentifier avant d'accéder, alors je me connecte en tant que l'utilisateur sylvain avec son mot de passe


![[Pasted image 20250719165546.png]]
Et maintenant, j'ai une accès au serveur grâce au authentification de l'utilisateur sylvain avec le mot de passe correcte

