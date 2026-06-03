Dans cette site B, On va crée et configurée un réseau LAN pour les utilisateurs des ressources dans le site A , DMZ pour le serveur freeradius pour pour gérer l'accès aux internet et WAN pour l'internet.

Structure des Réseaux:
- LAN : 192.168.100.0/24
- DMZ : 192.168.200.0/24
- WAN : 172.16.171.0/24

Pour configurer l'interface réseau, il existe deux options sur pfsense sont les suivants:

1. Le premier c'est d'utilisé la ligne de commande
On va configurer l'interface LAN par ligne de commande

![[Pasted image 20250711184400.png]]

sur le routeur Pfsense, on a créer sur 3 interfaces pour nos besoin(WAN en mode NAT, LAN et DMZ en mode LAN segment)

Et maintenant le serveur DHCP sur l'interface LAN pour que les utilisateur qui se connecte dans le réseau LAN, il obtiennent d'un adresse IP automatiquement au lieu de l'attribué manuellement.

Pour faire cela, il faute lancé pfsense et une fois lancé, on voit cette interface :

![[Pasted image 20250711190956.png]]
Comme nous voyons, il n'y a que l'interface WAN qui est activé, pour cela, nous allons activé les deux interfaces, en choisissant l'option 1 sur laquelle assignent de l'interface :

![[Pasted image 20250711191818.png]]
Et maintenant, nous n'avons pas configurer cette interface par un VLANs
donc , on tape **N**

![[Pasted image 20250711192101.png]]
Nous avons vue qu'il y a 3 interfaces
Pour assigné les interfaces, il suffit de taper successivement l'interface que nous souhaitons d'activer.

![[Pasted image 20250711193015.png]]
Puis, tapons y pour appliquer la configuration

![[Pasted image 20250711193244.png]]
et maintenant, les deux interfaces sont activés mais n'a pas d'adresse IP 

Pour activer et configurer le serveur DHCPv4, il faut choisir l'option 2

![[Pasted image 20250711193834.png]]
Et entrons 2 pour la configuration de la serveur DHCP du réseau LAN
![[Pasted image 20250711194257.png]]

On entre N pour la configuration statique de l'interface, et ensiute, on ajouter l'adresse IP de l'interface qui est 192.168.100.1 et de masque /24

![[Pasted image 20250711194609.png]]
et ajouter le passerelle de l'interface
![[Pasted image 20250711194731.png]]

Dans cette projet, on utilise que l'adresse IPv4, donc, on n'a pas besoin l'IPv6

![[Pasted image 20250711195001.png]]

On active, le serveur DHCP sur l'interface dont le plage 192.168.100.100 à 192.168.100.200
![[Pasted image 20250711195231.png]]
 Et enfin, on active la configuration de pfsense sur l'interface web et puis entrée

Résultat:
![[Pasted image 20250711195507.png]]

2. Configuration de serveur DHCPv4 sur l'interface DMZ avec l'inerface web du pfsense
Pour accéder au interface web du pfsense, nous allons ajouter une machine administrateur en entrant cette lien http://192.168.100.1 

![[Pasted image 20250711200940.png]]
Par le login de pfsense est par défaut user est **admin** et le mot de passe **pfsense**
![[Pasted image 20250711201412.png]]

Pour configurer le serveur DHCPv4 pour le DMZ, nous allons rendre dans **Interfaces / assignment**

![[Pasted image 20250711201847.png]]

Nous allons cliqué sur le nom de l'interface **OPT1**
- il faut coché **Enable interface** 
- et on va changé le nom de l'interface par **DMZ**
- il afut aussi sélectionner l'**IPv4 Configuration Type** en **Statique IPv4** 
![[Pasted image 20250711202154.png]]



 