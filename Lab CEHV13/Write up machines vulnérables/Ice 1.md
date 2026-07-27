#### Phase de reconaissance
![[Pasted image 20260621062525.png]]

Après avoir décourvert l'adresse IP de 192.168.43.217, j'ai fait une scan SYN de la cible.
![[Pasted image 20260621063033.png]]

On voient bien que les ports 22 pour SSH, 80 http, 3306 et 33060 pour mysql sont ouverts sur le macine cible.

J'ai suis allé sur le page web pour voir ce qu'il y avait:
![[Pasted image 20260621065137.png]]

La page Web exécutait qdPM 9.2. Grâce à la recherche sur sur cette version, il y avait une vulnérabilité d'exposition par mot de passe, où le mot de passe de base de données était stocké dans dans un fichier YAML accessible. YAML est un format de sérialisation de données lisible par l'homme.

Pour accéder au fichier, je suis allé sur http://192.168.43.217/core/config/databases.yml
![[Pasted image 20260621082604.png]]

Pour voir s'il y avait d'autre vulnérabilités de version, j'ai utilisé nmap à nouveau et utilisé -sV pour touver les versions de chaque service, pour voir s'il y avait d'autre vulnérabilités que je pouvais trouver.

![[Pasted image 20260621083006.png]]

J'ai ensuite utilisé le nom d'utilisateur et le mot de passe du fichier yml et je me sis connecté au serveursql. j'ai dû utiliser mysql, et utiliser l'option --skip-ssl parce qu'il y avait un certificat non fiable.
![[Pasted image 20260621083419.png]]

J'ai ensuite examiné toutes les bases de données
![[Pasted image 20260621083551.png]]

À partir de la liste ci-dessus, le personnel était le plus intrigant. J'ai choisi celui-ci et j'ai obtenu une liste des noms du personne, ainsi que leur rôle et leur numéro. Cele m'a dit qu'il s'agit d'un nom d'utilisateur ssh.
![[Pasted image 20260621083937.png]]

en regardant les informations de connexion, j'ai trouvé leurs mot de passe encodés (non chiffrés).
![[Pasted image 20260621084218.png]]

J'ai dû décoder les mot de passe, en utilisant la commande de base 64 -d, et faire correspondre chaque mot de passe avec l'identifiant utilisateur, mais j'ai utiliser le mot de passe de Travis pour me connecter au système.
![[Pasted image 20260621085539.png]]

J'ai testé ce que Travis était autorisé à faire sur le système. D'abord, j'ai couru sudo -l pour voir s'il y avit quelque chose qu'il pouvait courir comme sudo, mais Travis n'était pas autorisé à courir sudo.
![[Pasted image 20260621090037.png]]

J'ai ensuite utilisé la commande Find pour rechercher des binaires avec l'ensemble de bits SUID. Les fichier avec l'ensemble de bits SUID s'exécutent en tant que propriétaire du fichier, et non en tant qu'utilisateur qui les a exécutés. Pour certains binaires, cela peut conduire à l'escalade de privilères si le binaire est détenu par root. En obenant la liste des binaires, il y en avaitun qui était bloqué, appelé /opt/get_access.
![[Pasted image 20260621090803.png]]

En reardant le fichier, il semble donner accès au système ICA, mais seulment dans certaines heures. j'ai utilisé la commande strings pour trouver des caractères lisibles par l'home dans le binaire.
![[Pasted image 20260621091055.png]]

Ce binaire utilise la commande de cat pour ouvrir un fichier, mais il n'utilise pas un chemin absolu. Lorsqu'une commande est appelée, le système recherche à travers le $PATH, une liste de répertoires, pour l'exécutable du même nom. Si un binaire appelle une commande, comme cat, sans chemin absolu, le système recherchera cette liste de répertoire pour la commande cat. Cela peut être exploité en manipilant la variable de chemin pour inclure un répertoire du choix d'un attaquant. À l'interieur de ce répertoire se trouvait un fichier exécutable du nom appelé, et il pourrait faire tout ce que l'attaquent veut qu'il fasse.

J'ai changé les répertoires dans le répertoire /tmp, créé un fichier appelé cat qui va juste changer en un shell recine et a rendu mon /tmp/cat exécutable.
![[Pasted image 20260621092626.png]]

J'ai ensuite changé la variable PATH pour que /tmp y soit ajouté. de cette façon, lorsque j'ai appelé /opt/get_access, il ferait d'abord une recherche à travers /tmp.
![[Pasted image 20260621092924.png]]

J'ai ensuite appelé /opt/get_access, et j'ai basculé vers l'utilisateur root et j'ai eu le drapeau.
![[Pasted image 20260621094108.png]]
![[Pasted image 20260621094129.png]]


> [!NOTE] Vulnérabilité d'exposition
> - Mauvais chiffrement/stockages des mots de passe, en utilisant plutôt
> l'encodage
> 
> - Appeler des binaires sans le chemin absolu.

