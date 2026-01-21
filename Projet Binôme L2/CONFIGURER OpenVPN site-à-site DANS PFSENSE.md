
OpenVPN permet de monter un VPN site-à-site de manière très simple et efficace.  
  
L'un des sites est configuré comme _client_ et l'autre site comme _serveur_.  
  
Pour monter notre VPN, nous utiliserons ici le système de clés partagées.  
Si vous avez peu de liens VPN site-à-site à monter, il est recommandé d'utiliser des clés partagées. Au delà de 5 à 6 liens VPN site-à-site, il peut être judicieux d'utiliser la [gestion de certificat (SSL/TLS - PKI)](https://www.provya.net/?d=2014/08/02/08/28/30-pfsense-la-gestion-des-certificats-pour-les-connexions-openvpn) par simplicité d'administration.

## IPsec vs OpenVPN

  
Faut-il monter son VPN site-à-site avec OpenVPN ou IPsec ? Vaste question à laquelle nous ne répondrons pas ici ! :-)  
  
Nous préciserons simplement qu'IPsec et OpenVPN peuvent tous les deux être actifs et en service en parallèle sur un même serveur pfSense. La seule contrainte étant, évidemment, de ne pas utiliser les mêmes sous-réseaux sur vos lien OpenVPN et IPsec.  
  
  
  

## OpenVPN Client & Serveur

  
OpenVPN est basé sur un mode de fonctionnement client-serveur. Qu'un pfSense soit défini comme client ou comme serveur ne changera strictement rien d'un point de vue réseau. Cependant, si vous souhaitez connecter plusieurs sites distants sur un site principal, le plus logique est bien-sûr de définir le site principal comme "serveur" et les sites distants comme "clients".  
  
Dans cet article, nous prendrons l'exemple de configuration suivant :

![[schema-reseau-open-vpn-pfsense-provya.webp]]
Le pfSense du **site A** sera configuré comme **serveur** OpenVPN. Le pfSense du **site B** sera configuré comme **client** OpenVPN.  
  

## Configurer OpenVPN côté "serveur"

  
Sur le pfSense du site A, se rendre dans le menu VPN > OpenVPN. Nous serons par défaut dirigé sur l'onglet _Servers_ :

![[menu-vpn-openvpn-pfsense-provya.webp]]
  
  
Cliquer sur le bouton "+ Add" pour ajouter un serveur VPN.  
  
Les champs à configurer sont les suivants :  
  

- **Server Mode** : ici, nous avons cinq possibilités :

1. **Peer to peer (SSL/TLS)** : pour monter un VPN site-à-site en utilisant une authentification par certificat.
2. **Peer to peer (Shared Key)** : pour monter un VPN site-à-site en utilisant une authentification par clé partagée.
3. **Remote Access (SSL/TLS)** : pour monter un accès distant pour clients nomades en utilisant une authentification par certificat.
4. **Remote Access (User Auth)** : pour monter un accès distant pour clients nomades en utilisant une authentification par login/password.
5. **Remote Access (SSL/TLS + User Auth)** : pour monter un accès distant pour clients nomades en utilisation une authentification par certificat et par login/password.

Nous choisissons **Peer to peer (Shared Key)**.  
  

- **Protocol** : nous choisissons "UDP on IPv4 only".

L'utilisation du protocole TCP n'est pas adaptée à un environnement VPN, car en cas de pertes de paquets ceux-ci devront être retransmis. Ce qui n'est pas forcément souhaité. La conséquence serait un ralentissement du lien VPN à cause d'une forte ré-émission de paquets.  
TCP est en revanche particulièrement intéressant si vous devez passer au travers d'une connexion particulièrement restrictive. Dans ce cas, l'utilisation du port 443 (correspondant au port HTTPS) est particulièrement judicieux (il est rare que le port 443 soit bloqué en sortie d'un réseau vers Internet). Attention toutefois, si vous choisissez le port 443, assurez-vous d'abord que le WebGUI de pfSense ne tourne pas déjà sur ce port !  
  

- **Device Mode** : nous choisissons tun

TUN travaille avec des frames IP.  
TAP travaille avec des frames Ethernet.  

- **Interface** : l'interface sur laquelle le serveur va recevoir les connexions entrantes. Généralement WAN ou OPT1. Il est également possible de choisir "any" et dans ce cas le serveur sera en écoute sur toutes les interfaces.
- **Local port** : port d'écoute du serveur OpenVPN. Par défaut, c'est le 1194. Il est à noter que chaque serveur VPN doit disposer de son propre port d'écoute. De la même manière, il est important de s'assurer qu'aucun autre service ne soit déjà en écoute sur le port choisi... [y'en a qui ont essayé ils ont eu des problèmes](https://www.youtube.com/watch?v=gNI9a-K1JoU) :-)
- **Description** : nom que l'on souhaite donner à ce serveur VPN. C'est ce nom qui apparaîtra dans les listes déroulantes de sélection de VPN se trouvant aux différents endroits du WebGUI pfSense. Dans notre cas, nous saisissons "VPN Provya".
- **Shared Key** : nous conseillons de laisser coché la case "_Automatically generate a shared key_". La clé sera à copier/coller côté client.
- **Encryption algorithm** : ce paramètre doit être le même côté client et côté serveur si l'une des deux parties ne supporte pas le protocole NCP. N'importe quel algorithme travaillant avec une clé d'au moins 128 bits sera bon. 256 bits sera encore mieux. **CAST/DES/RC2** sont moins sécurisés, et donc **à bannir**. Notre choix se porte sur _**AES 256 bits CBC**_
- **Enable NCP** : cocher la case permet d'activer le protocole NCP pour que le client et le serveur négocie le protocole de chiffrement le plus approprié. Nous laissons la case cochée.
- **NCP Algorithms** : Les algortithmes de chiffrement que nous souhaitons supporter côté serveur.
- **Auth digest algorithm** : nous laissons la valeur par défaut SHA256.
- **Hardware Crypto** : précise si le serveur dispose d'un support cryptographique.
- **IPv4 Tunnel Network** : réseau utilisé pour le tunnel VPN. N'importe quel réseau privé inutilisé dans l'espace d'adressage de la [RFC 1918](https://fr.wikipedia.org/wiki/R%C3%A9seau_priv%C3%A9) peut être utilisé. Pour une connexion site-à-site, l'utilisation d'un /30 est suffisant (inutile d'utiliser un /24). Dans notre cas, nous utilisons le sous-réseau 10.0.8.0/30.
- **IPv4 Remote network(s)** : désigne le ou les réseaux distants accessibles par le serveur. Il convient d'utiliser la notation CIDR (ex : 192.168.1.0/24). Dans le cas où l'on souhaite indiquer plusieurs réseaux, il faut les séparer par une virgule. Dans notre cas, nous indiquons le réseau utilisé sur le site B, soit 192.168.2.0/24.
- **Concurrent connections** : précise le nombre de connexion client possible en simultanée sur ce serveur. Dans le cas d'un VPN site-à-site, ce paramètre peut être renseigné à 1.
- **Compression** : permet d'activer la compression LZO/LZ4 sur l'ensemble des flux transitant par ce tunnel VPN. Si les données transitant dans ce tunnel VPN sont principalement des données chiffrées (HTTPS, SSH, etc.), cocher cette option ne fera qu'ajouter un overhead inutile aux paquets.
- **Custom options** : permet de passer des paramètres avancés à OpenVPN. Cela peut notamment être utile si l'on décide de faire du VPN natté (entre deux sites ayant le même plan d'adressage) ou pour pousser des routes spécifiques. Nous ne rentrerons pas dans le détail ici.

  
Une fois la configuration renseignée, nous cliquons sur "Save" pour valider notre configuration.  
  
Exemple de résultat obtenu :  
  

![exemple configuration OpenVPN clée partagée pfSense Provya](https://www.provya.net/img/02/exemple-configuration-openvpn-serveur-clee-partagee-pfsense-provya.png)

  
  
La configuration openVPN est terminée côté serveur. Il faut maintenant ajouter les règles de filtrage pour rendre accessible le serveur openVPN.  
  
  
  

## Configuration du Firewall

  
Il est maintenant nécessaire d'autoriser le flux VPN au niveau du firewall. Pour cela, se rendre dans le menu Firewall > Rules :  
  

![menu Firewall > Rules pfSense Provya](https://www.provya.net/img/02/menu-firewall-rules-pfsense-provya.png)

  
  
Sur l'interface sur laquelle le serveur OpenVPN est en écoute (WAN, dans notre exemple), créer une règle autorisant le trafic à atteindre l'adresse IP et le port du serveur OpenVPN.  
  
Dans notre exemple, nous travaillons sur l'interface WAN, l'adresse IP du pfSense sur le site A est 109.190.190.10, et l'adresse IP publique du site B est 108.198.198.8. Ce qui donne la configuration suivante :  
  

- Interface : WAN
- Protocol : UDP
- Source : si l'adresse IP publique du site distant n'est **pas** connue on laisse any, sinon on la renseigne en choisissant le type "Single host or alias"
- Destination : type "Single host or alias", address à 109.190.190.10
- Destination port range : port choisi lors de la configuration du serveur OpenVPN, soit 1194 dans notre cas.

  
Ce qui nous donne la règle suivante :  
  

![règle firewall openVPN server pfSense Provya](https://www.provya.net/img/02/regle-firewall-open-vpn-serveur-pfsense-provya.png)

  
  
  
La configuration côté serveur est terminée. Il nous reste simplement à penser à autoriser ou filtrer nos flux transitant à travers notre nouvelle interface OpenVPN. Pour cela, se rendre dans Firewall > Rules > OpenVPN pour créer ses règles.  
  
Exemple de règle à configurer sur l'interface LAN du pfSense du site A :  
  

![règle firewall openVPN pour trafic LAN vers LAN pfSense Provya](https://www.provya.net/img/02/filtrage-pfsense-site-a-vers-site-b-provya.png)

  
  
Exemple de règle à configurer sur l'interface OpenVPN du pfSense du site A :  
  

![règle firewall openVPN pour trafic LAN vers LAN pfSense Provya](https://www.provya.net/img/02/filtrage-pfsense-site-b-vers-site-a-provya.png)

  
  
  
Passons à la configuration côté client.  
  
  
  

## Configurer OpenVPN côté "client"

  
Sur le pfSense du site "client", se rendre dans VPN > OpenVPN, puis dans l'onglet "Clients".  
  
Cliquer sur l'icône "+ Add" pour ajouter un client VPN.  
  
Les champs à configurer sons sensiblement les mêmes que ceux côté serveur :  
  

- **Server Mode** : ici, nous avons deux possibilités :

1. **Peer to peer (SSL/TLS)**
2. **Peer to peer (Shared Key)**

Nous choisissons **Peer to peer (Shared Key)**, conformément à ce que nous avons configuré côté OpenVPN serveur.  
  

- **Protocol** : choisir le même protocole que celui choisi côté serveur (soit UDP on IPv4 only)
- **Device mode** : choisir tun
- **Interface** : l'interface via laquelle le client OpenVPN va joindre le serveur. Dans notre cas, ce sera WAN
- **Local port** : si ce champ est laissé vide, un port aléatoire sera choisi
- **Server host or address** : l'adresse IP publique du site distant, c'est-à-dire l'adresse IP publique du site A dans notre cas (109.190.190.10)
- **Server port** : port d'écoute du serveur OpenVPN distant (ici, 1194)
- **Proxy host or address** : adresse du proxy si le pfSense client nécessite de passer par un proxy
- **Proxy port** : idem ci-dessus
- **Proxy Authentification** : idem ci-dessus
- **Description** : le nom que vous souhaitez donner à votre tunnel VPN (ici, VPN Provya)
- **Auto generate / Shared Key** : décochez la case "Auto generate" et copier/coller la clé générée côté OpenVPN serveur
- **Encryption algorithm** : renseigner le même algorithme que celui saisi côté OpenVPN serveur (AES-256-CBC). Cet algorithme sera utilisé uniquement si NCP n'est pas activé ou supporté
- **NCP Algorithms** : les mêmes que ceux sélectionnés côté serveur
- **Auth digest algorithm** : on laisse la valeur par défaut, soit SHA256
- **Hardware Crypto** : précise si le serveur dispose d'un support cryptographique
- **IPv4 Tunnel Network** : même réseau que celui renseigné côté OpenVPN serveur, soit 10.0.8.0/30
- **IPv4 Remote Network(s)** : on renseigne le réseau du site distant. Il convient d'utiliser la notation CIDR. Dans le cas où l'on souhaite indiquer plusieurs réseaux, il faut les séparer par une virgule. Dans notre cas, cela donne : 192.168.1.0/24
- **Limit ourgoing bandwidth** : bande-passante maxi allouée à ce tunnel VPN. Laisser vide pour ne pas fixer de limite.
- **Compression** : doit être similaire à la configuration côté OpenVPN serveur
- **Advanced** : permet de passer des paramètres avancés à OpenVPN. Nous ne rentrerons pas dans le détail ici.

  
Exemple de résultat obtenu :  
  

![exemple configuration openVPN client clée partagée pfSense Provya](https://www.provya.net/img/02/exemple-configuration-openvpn-client-clee-partagee-pfsense-provya.png)

  
  
  
La configuration côté client est terminée. Il nous reste simplement à penser à autoriser ou filtrer nos flux transitant à travers notre nouvelle interface OpenVPN.  
  
Exemple de règle à configurer sur l'interface LAN du pfSense du site B :  
  

![règle firewall openVPN pour trafic LAN vers LAN pfSense Provya](https://www.provya.net/img/02/filtrage-pfsense-site-b-vers-site-a-provya.png)

  
  
Exemple de règle à configurer sur l'interface OpenVPN du pfSense du site B :  
  

![règle firewall openVPN pour trafic LAN vers LAN pfSense Provya](https://www.provya.net/img/02/filtrage-pfsense-site-a-vers-site-b-provya.png)

  
## Debug

Pour disposer d'informations sur vos liens OpenVPN (état, date de début de mise en service, volume entrant/sortant, etc.), se rendre dans Status > OpenVPN.  
  
Pour les logs du firewall, se rendre dans Status > System logs > Firewall.


Lien du documentation:
https://www.provya.net/?d=2014/06/15/15/20/04-pfsense-monter-un-acces-openvpn-site-a-site