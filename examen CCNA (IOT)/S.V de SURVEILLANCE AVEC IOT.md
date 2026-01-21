
**INTRODUCTION**
Dans cette chapitre nous allons simuler un mini-réseau LAN avec une technologie IOT(Internet Of Things)  suivi d'une simulation de l’utilisation de serveur DNS,FTP,HTTP/HTTPS,Mails et aussi serveur IOT pour assure l'utilisation des Objets connectés.

## 1-TOPOLOGIE

Dans cette simulation, nous allons utilisée un topologie en étoile avec deux bâtiments :

Bâtiment A : il y a 5 salles accompagner des vidéos surveillance de chaque chambre pour renforcer la sécurité matérielles des nos réseaux.

Bâtiment B : il y a 2 salles dont l'un d'eux est salle de contrôleur pour contrôler d'entrée/sortie et la faille dans le réseau et l'autre est le salle de la direction

voici nos topologie:

![[Pasted image 20250601201000.png]]

Pour assurer la sécurité de nos réseau, il faur créer des VLANs de chaque salle et donnez une plage d'adresse IP de chaque VLAN 

#### VLANs & Sous-réseaux DHCP

| VLAN ID | Nom VLAN | Sous-réseau IP    | Gateway (sous-interface) | Plage DHCP attribuée            |
| ------- | -------- | ----------------- | ------------------------ | ------------------------------- |
| 10      | SALLE0   | 192.168.80.0/27   | 192.168.80.1             | 192.168.80.2 –192.168.80.30     |
| 20      | SALLE1   | 192.168.80.32/27  | 192.168.80.33            | 192.168.80.34 – 192.168.80.62   |
| 30      | SALLE2   | 192.168.80.64/27  | 192.168.80.65            | 192.168.80.66 – 192.168.80.94   |
| 40      | SERVEURS | 192.168.80.96/27  | 192.168.80.97            | statique                        |
| 50      | IOT      | 192.168.80.112/28 | 192.168.80.113           | 192.168.80.114 – 192.168.80.126 |
Pour le table d'adresse IP des serveurs , on a configurer en statique parce que si elle est configurer en dynamique,lorsque l'adresse IP du serveur change, on risque de n'est pas trouver du serveur et reconfigurer le serveur a chaque fois l'adresse IP change.


| SERVEURS | ADRESSES IP    |
| -------- | -------------- |
| DNS      | 192.168.80.98  |
| MAIL     | 192.168.80.99  |
| FTP      | 192.168.80.100 |
| WEB      | 192.168.80.101 |
| IOT      | 192.168.80.102 |

Passons sur la configuration:
###### 1.Switch – Création des VLANs et ports d’accès
```
Switch(config)#vlan 10
Switch(config-vlan)# name SALLE0
Switch(config-vlan)#vlan 20
Switch(config-vlan)# name SALLE1
Switch(config-vlan)#vlan 30
Switch(config-vlan)# name SALLE2
Switch(config-vlan)#vlan 40
Switch(config-vlan)# name SERVEURS
Switch(config-vlan)#vlan 50
Switch(config-vlan)# name IOT
Switch(config-vlan)#exit
```
###### ports d’accès
```
Switch(config)#int fa0/8
Switch(config-if)#switchport mode access
Switch(config-if)#switchport access vlan 10
Switch(config-if)#exit
Switch(config)#int fa0/9
Switch(config-if)#switchport mode access
Switch(config-if)#switchport access vlan 20
Switch(config-if)#exit
Switch(config)#int fa0/10
Switch(config-if)#switchport mode access
Switch(config-if)#switchport access vlan 30
Switch(config-if)#exit
Switch(config)#int range fa0/1 - 5
Switch(config-if-range)#switchport mode access
Switch(config-if-range)#switchport access vlan 40
Switch(config)#int fa0/7
Switch(config-if)#switchport mode access
Switch(config-if)#switchport access vlan 50
Switch(config-if)#exit
Switch(config)#int fa0/11
Switch(config-if)#switchport mode trunk
Switch(config-if)#no shutdown
```

###### 2. 📡 Routeur – Sous-interfaces(routage inter-vlan)
```
Router(config)#int gig0/0.10
Router(config-subif)#encapsulation dot1q 10
Router(config-subif)#ip add 192.168.80.1 255.255.255.224
Router(config-subif)#exit
Router(config)#int gig0/0.20
Router(config-subif)#encapsulation dot1q 20
Router(config-subif)#ip add 192.168.80.33 255.255.255.224
Router(config-subif)#exit
Router(config)#int gig0/0.30
Router(config-subif)#encapsulation dot1q 30
Router(config-subif)#ip add 192.168.80.65 255.255.255.224
Router(config-subif)#exit
Router(config)#int gig0/0.40
Router(config-subif)#encapsulation dot1q 40
Router(config-subif)#ip add 192.168.80.97 255.255.255.224
Router(config)#int gig0/0.50
Router(config-subif)#encapsulatio dot1q 50
Router(config-subif)#ip add 192.168.80.113 255.255.255.240
```
###### 3.  Configuration du serveur DHCP
```
Router(config)#ip dhcp excluded-address 192.168.80.1
Router(config)#ip dhcp excluded-address 192.168.80.33
Router(config)#ip dhcp excluded-address 192.168.80.65
Router(config)#ip dhcp excluded-address 192.168.80.113
Router(config)#ip dhcp pool SALLE0
Router(dhcp-config)#network 192.168.80.0 255.255.255.224
Router(dhcp-config)#default-router 192.168.80.1
Router(dhcp-config)#dns-server 192.168.80.98
Router(dhcp-config)#exit
Router(config)#ip dhcp pool SALLE1
Router(dhcp-config)#network 192.168.80.32 255.255.255.224
Router(dhcp-config)#default-router 192.168.80.33
Router(dhcp-config)#dns-server 192.168.80.98
Router(dhcp-config)#exit
Router(config)#ip dhcp pool SALLE2
Router(dhcp-config)#network 192.168.80.64 255.255.255.224
Router(dhcp-config)#default-router 192.168.80.65
Router(dhcp-config)#dns-server 192.168.80.98 
Router(dhcp-config)#exit
Router(config)#ip dhcp pool IOT
Router(dhcp-config)#network 192.168.80.112 255.255.255.240
Router(dhcp-config)#default-router 192.168.80.113
Router(dhcp-config)#dns-server 192.168.80.98
Router(dhcp-config)#exit
```


###### 4. sur le routage entre deux réseau

Pour que les contrôleurs et la direction arrive a joindre les serveurs au bâtiment A 
Puisqu'on a que deux réseau différents, je veux utilisé le routage statique
	- sur le routeur R0
```
Router(config)#ip route 192.168.60.0 255.255.255.0 10.10.10.2
```
Table de routage du routeur du bâtiment A
			![[Pasted image 20250602065948.png]]	
	-sur le routeur R1
```
Router(config)#ip route 192.168.80.0 255.255.255.0 10.10.10.1	
```
Table de routage du routeur du bâtiment B
				![[Pasted image 20250602070041.png]]
**d-sur les serveurs**

tout d'abord la configuration de serveur DNS pour la résolution de nom de tous les équipement qui le besoin
**CONFIGURATION DU ==DNS==**
![[Pasted image 20250602070154.png]]

**NB:**
		[[	http://file.lmsentreprise.com]] : le lien pour le serveur FTP
		   [[http://lmsmail.com]] : pour le serveur MAIL
		   [[http://www.iot.connect.com]] : pour le serveur IOT
		   [[http://www.lmsentreprise.com]] :pour le serveur WEB

**CONF DU HTTP/HTTPS
![[Pasted image 20250516150630.png]]


On a créer deux fichier nouveau dans le serveur (script.js et style.css) avec des page html personaliser

**CONF MAIL**
![[Pasted image 20250516152040.png]]
Il y a les listes des utilisateurs de notre mail avec le nom de domain : lmsmail.com

**CONF FTP**
![[Pasted image 20250516153842.png]]
 On a ajouté des utilisateur qui ont une droit d'accéder sur le serveur FTP avec de permission:
 par exemple: contrôleur: on une permission de éditer,lire,supprimer,renommer,lister (RWDNL)
             et l'utilisateur1: on une permission de éditer et lire tout simplement
## 2-CONFIGURATIONS DES EQUIPEMENTS A CONTRÔLÉES

Pour pouvoir contrôler les équipements connectées il faut avoir une serveur IOT et une compte de contrôleur pour avoir la sécurité de nos objets connectés.

Donc, voici les configurations complets de nos objets avec des condition:

**+ les contrôleur :** qui peut contrôlé tous les réseaux de la bâtiment A et B
et System d’alerte lorsqu'il y a une intrusion et aussi manipuler les vidéos de surveillances de chaque salle , même dans la direction

On va créer un compte pour le contrôleur pour qu'il puissent surveillées de chaque salles
![[Pasted image 20250516155202.png]]
après il affiche une page vide. C'est dans cette interface que nous allons ajouter de liste des objets que nous allons manipuler.
![[Pasted image 20250516155700.png]]
 Et maintenant, on va ajouter les objets dans le compte de contrôleur :
 ![[Pasted image 20250602070434.png]]
on fait comme ça a chaque objets qu'on peut ajouter que se soit dans le compte de contrôleur ou la direction(avec le compte de la directeur)
![[Pasted image 20250516163758.png]]

**+ direction :** qui contrôle la tous les actions dans la salle de direction avec le smartphone ou l'ordinateur du direction

![[Pasted image 20250516164010.png]]


Et maintenant, nous allons ajusté quelques conditions sur le système d'alarme lorsqu'il y a une intrusion dans le salle des serveurs, on alerte   les contrôleurs et les employés dans le bâtiment A

Pour faire ça nous allons connecter au compte IOT de contrôleur parce que ce lui qui doit alerter lorsqu'il y une intrusion dans la salle des serveurs.

![[Pasted image 20250523120731.png]]

D'après l'image, on ajouter une condition que si le détecteur détecte quelque mouvement,
 les deux cameras,l'alarme dans la salle des serveurs s'active et l'alarme dans la salle de contrôleur aussi pour que les contrôleurs savent immédiatement ce qui se passe dans le bâtiment A et réagir immédiat.

Mais lorsqu'il n'y a pas détection d'intrusion dans la salle, il faut éteindre les alarmes et les caméras c'est pourquoi on ajoute une deuxième condition.

![[Pasted image 20250523120646.png]]

Et en fin on va configurer quelques Access vers les serveurs IOT pour les utilisateurs dans le bâtiment A donnez Access aux bâtiment B de le contrôler  

Pour faire cela, on utiliser Router ACLs en raison de bloquer les utilisateur dans le bâtiments A d'acceder au serveur IOT et autoriser les bâtiment B.

Pour **empêcher les utilisateurs des VLANs 10, 20 et 30** (bâtiment A) d’accéder au **serveur IOT** ayant l’adresse `192.168.80.102`, on peut utiliser une **ACL standard ou étendue**. Ici, une **ACL étendue** est la plus adaptée, car elle permet de bloquer un trafic **source → destination spécifique**.

## Objectif

- Bloquer **tout accès** (ping, HTTP, etc.) des utilisateurs dans les sous-réseaux :
    - `192.168.80.0/27` (VLAN 10)
    - `192.168.80.32/27` (VLAN 20)
    - `192.168.80.64/27` (VLAN 30)
    
- Vers **le serveur** `192.168.80.102` (IOT).

- **Autoriser le reste du trafic** normalement.
###### 1. Créer l’ACL étendue
 
```
Router(config)#ip access-list extended BLOQUE_IOT
Router(config-ext-nacl)#deny ip 192.168.80.0 0.0.0.31 host 192.168.80.102
Router(config-ext-nacl)#deny ip 192.168.80.32 0.0.0.31 host 192.168.80.102
Router(config-ext-nacl)#deny ip 192.168.80.64 0.0.0.31 host 192.168.80.102
Router(config-ext-nacl)#permit ip any any
Router(config-ext-nacl)#exit
```
###### 2. Appliquer l’ACL sur l’interface ROUTEUR en **entrée des VLANs utilisateurs**

Sur **chaque sous-interface** concernée (`Gig0/0.10`, `.20`, `.30`) :

```
Router(config)# interface GigabitEthernet0/0.10
Router(config-subif)# ip access-group BLOQUE_IOT in
Router(config-subif)# exit

Router(config)# interface GigabitEthernet0/0.20
Router(config-subif)# ip access-group BLOQUE_IOT in
Router(config-subif)# exit

Router(config)# interface GigabitEthernet0/0.30
Router(config-subif)# ip access-group BLOQUE_IOT in
Router(config-subif)# exit

```
