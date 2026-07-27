## Exercice 1 : Compréhension du cours

#### **1. Explication de DNS et de DHCP**

**A. DNS**
C'est un service informatique qui traduit un nom de domaine lisible par des humains en adresse IP lisible par une machine.

Son avantage est de facilitation de navigation sur internet qui aide les internautes de mémoriser des nom au lieu de d'adresse IP d'une machine parce qu'il est très difficile de retenir par coeur le adresse IP des machines au lieu d'un nom de domain

**B. DHCP**
C'est un service qui gère l'attribution automatique des configurations réseaux.
C'est à dire lorsqu'une machine se connecte à un réseau, le serveur DHCP va attribué un adresse IP unique, avec une masque réseau, un passerelle et des addesses Ip du serveur DNS s'il en a.

#### **2. Explication de SQUID et de FTP.**

**A. SQUID**

**Squid** est un logiciel libre très populaire qui agit comme un **serveur proxy** et un **serveur de cache**. Il sert d'intermédiaire entre les ordinateurs d'un réseau et Internet pour filtrer, sécuriser et accélérer le trafic Web

C'est à dire il stocke temporairement les pages web ou les images les plus visitées. Lorsqu'un utilisateur demande un contenu déjà en cache, Squid le fournit instantanément. Cela réduit l'utilisation de la bande passante et accélère la connexion.

En plus, Il permet aux administrateurs réseau de bloquer l'accès à certains sites web ou types de fichiers. Il agit comme une passerelle sécurisée entre le réseau local et Internet.

**B. FTP**
C'est un protocole réseau standard utilisé pour transférer des fichiers d'un ordinateur à un autre. Il permet de copier, télécharger ou envoyer des données (images, documents, dossiers de sites web) entre un appareil client et un serveur distant via Internet.

Le système repose sur un échange entre deux entités connectées à Interne :
- **Le client FTP :** Le logiciel sur votre ordinateur (ex: FileZilla ou Cyberduck) qui demande à accéder aux fichiers.
- **Le serveur FTP :** L'ordinateur distant qui stocke les fichiers et répond aux requêtes du client après authentification (nom d'utilisateur et mot de passe). 

## Exercice 2
1. Configurez l’adresse IP 192.168.90.1 pour le machine Debian.
![[Pasted image 20260616101048.png]]

Restarter le service networking et afficher l'addressse IP de l'interface eth0
![[Pasted image 20260616101256.png]]

2. Configuration du DHCP eavec de d'adresse allant 
de 192.168.90.10 à 192.168.90.20
![[Pasted image 20260616101623.png]]

redémarrée les service isc-dhcp-server
![[Pasted image 20260616102117.png]]

3. Allumons une machine Windows XP pour verifier si c'est une adresse IP
provenant du serveur DHCP.
![[Pasted image 20260616102556.png]]

4. configuration de SQUID et faites en sorte que toutes les adresses
appartenant à notre plage soient bloquées
![[Pasted image 20260616104959.png]]
![[Pasted image 20260616105157.png]]

Redémarrée le service Squid
![[Pasted image 20260616105437.png]]

Teste dépuis la machine Windows XP :
Configuration le navigateur pour qu'il utilise le serveur proxy Debian
![[Pasted image 20260616110311.png]]

Résultat
![[Pasted image 20260616110420.png]]
==Access Denied==

Donc le serveur proxy est bien fonctionnel.

## Exercice 3

Voici un programme qui permet d’appeler les fichiers de l’exercice précédent tel que si
l’utilisateur tape 1, on va dans la configuration du DHCP et si l’utilisateur tape 2, on va dans la
configuration de SQUID.
![[Pasted image 20260616111022.png]]

Rendre le script exécutable et le tester
```
chmod +x menu_config.sh

./menu_config.sh
```
Test 1 :
![[Pasted image 20260616111423.png]]

Résultat :
![[Pasted image 20260616111652.png]]

Teste 2
![[Pasted image 20260616111942.png]]
Résultat :
![[Pasted image 20260616111846.png]]

## Exercice 4

Voici un programme capable de gèrer les options suivantes :
	1 : création de dossier
	2 : suppression de dossier
	3 : création d’utilisateur
	4 : suppression d’utilisateur
	5 : configuration de l’adresse IP
	6 : configuration des paramètres de SQUID
	7 : configuration des paramètres du DHCP
	8 : ouverture de Filezilla

![[Pasted image 20260616112259.png]]
![[Pasted image 20260616112628.png]]
![[Pasted image 20260616112722.png]]
![[Pasted image 20260616112804.png]]

Rendre le script exécutable et le tester
![[Pasted image 20260616113016.png]]

Test 1: Creation de dossier
![[Pasted image 20260616113323.png]]

resultat
![[Pasted image 20260616113429.png]]

Teste 2 : Suppression de dossier
![[Pasted image 20260616113607.png]]

Resultat :
![[Pasted image 20260616113655.png]]

Teste 3 : Création d'utilisateur 
![[Pasted image 20260616113934.png]]

Resultat :
![[Pasted image 20260616114053.png]]

Teste 4:
![[Pasted image 20260616114205.png]]

Resultat :
![[Pasted image 20260616114252.png]]

Teste 5:
![[Pasted image 20260616114532.png]]

Résultat :
![[Pasted image 20260616114645.png]]
![[Pasted image 20260616114725.png]]


