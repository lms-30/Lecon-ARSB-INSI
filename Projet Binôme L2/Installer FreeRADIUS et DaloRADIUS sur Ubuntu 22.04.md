FreeRADIUS est un serveur RADIUS open-source largement utilisé pour l’authentification, l’autorisation et la comptabilité des utilisateurs réseau.

DaloRADIUS est une interface web open-source pour FreeRADIUS, conçue pour simplifier la gestion et l’administration d’un serveur FreeRADIUS.

Cela permet aux administrateurs réseau de configurer, surveiller et gérer leur serveur RADIUS via une interface conviviale basée sur le web.

### Mise à jour des paquets
```
sudo apt update & sudo apt upgrade
```
### Installer le serveur web Apache
```
sudo apt install apache2
```
#### **Activez Apache pour qu’il démarre au démarrage d’Ubuntu.**
```
sudo systemctl enable --now apache2
```
### Installer PHP et ses modules supplémentaires
```
sudo apt -y install php libapache2-mod-php php-{gd,common,mail,mail-mime,mysql,pear,db,mbstring,xml,curl}
```
### Installer MySQL
```
sudo apt install mysql-server
```
### Configurer MySQL
```
sudo mysql_secure_installation
```
### Installer FreeRADIUS et ses modules
```
sudo apt -y install freeradius freeradius-mysql freeradius-utils -y
```
### Tester le serveur FreeRADIUS

- Arrêtez le serveur FreeRADIUS :
```
sudo systemctl stop freeradius
```
- Exécutez FreeARDIUS en mode débogage :
```
sudo freeradius -X
```
![[Pasted image 20250711132101.png]]

Redémarrez et activez le service FreeRADIUS :
```
sudo systemctl enable --now freeradius
```
### Autoriser FreeRADIUS dans le pare-feu
```
sudo ufw allow to any port 1812 proto udp
sudo ufw allow to any port 1813 proto udp
```
### **Créer la base donnée et utilisateur MySQL pour FreeRADIUS**

**Se connecter à la base de donnée :**
```
sudo mysql -u root -p
```
**Créer la base de donnée et utilisateur :**
```
CREATE DATABASE radius;
CREATE USER 'radius'@'localhost' IDENTIFIED by 'R@duisp@ssword123';
GRANT ALL PRIVILEGES ON radius.* TO 'radius'@'localhost';
FLUSH PRIVILEGES;
quit;
```
### Importer le schéma de la base donnée RADIUS MySQL

```
sudo su
```
**Importer le schéma :**
```
mysql -u root -p radius < /etc/freeradius/3.0/mods-config/sql/main/mysql/schema.sql
```
**Vérification de la base donnée :**
```
sudo mysql -u root -p -e "use radius;show tables;"
```

![[Pasted image 20250711133433.png]]

#### Créez un lien symbolique vers le module SQL vers /etc/freeradius/3.0/mods-enabled :

```
sudo ln -s /etc/freeradius/3.0/mods-available/sql /etc/freeradius/3.0/mods-enabled/
```
### Configurer FreeRADIUS
```
sudo nano /etc/freeradius/3.0/mods-enabled/sql
```
Remplacer **dialect = « sqlite »** par **dialect = « mysql »**

Remplacer **driver = « rlm_sql_null »** par **driver = « rlm_sql_${dialect} »**

Pour les besoins de ce tuto, nous n’utiliserons pas de certificats TLS.

Commenter la section TLS de MySQL en ajoutant un signe **#** au début de chaque ligne de la section **tls**.

Ça :
![[Pasted image 20250711133908.png]]

En ça :

![[Pasted image 20250711134010.png]]

Décommentez la section Informations de connexion :

![[Pasted image 20250711134516.png]]

Configurer le nom de la base de données :

![[Pasted image 20250711140229.png]]

Décommentez une ligne contenant read_clients = yes.

![[Pasted image 20250711135924.png]]

Modifiez maintenant les droits de groupe du fichier que nous venons de modifier :
```
sudo chgrp -h freerad /etc/freeradius/3.0/mods-available/sql
sudo chown -R freerad:freerad /etc/freeradius/3.0/mods-enabled/sql
```
Redémarrez le service FreeRADIUS :
```
sudo systemctl restart freeradius.service
```
## Installer daloRADIUS

Installer unzip :
```
sudo apt -y install wget unzip
```
Télécharger daloRADIUS :
```
wget https://github.com/lirantal/daloradius/archive/1.3.zip
```
Décompresser daloRADIUS :
```
unzip 1.3.zip
cd daloradius-1.3
```
Remplissez la base de données avec le schéma daloRADIUS :
```
sudo mysql -u root -p radius < contrib/db/fr2-mysql-daloradius-and-freeradius.sql
sudo mysql -u root -p radius < contrib/db/mysql-daloradius.sql
```
Déplacez le dossier dans la racine du document comme :
```
cd 
sudo mv daloradius-1.3 /var/www/html/daloradius
```
Changer le propriétaire et le groupe du dossier daloradius en www-data:www-data, qui sont l’utilisateur et le groupe sous lesquels le serveur Web Apache s’exécute.
```
sudo chown -R www-data:www-data /var/www/html/daloradius/
```
Créer le fichier de configuration daloRADIUS. Copier de cet exemple de fichier :
```
sudo cp /var/www/html/daloradius/library/daloradius.conf.php.sample /var/www/html/daloradius/library/daloradius.conf.php
```
Modifier également les autorisations pour le fichier de configuration daloRADIUS :
```
sudo chmod 664 /var/www/html/daloradius/library/daloradius.conf.php
```
#### Configurer les informations de base de données FreeRADIUS
```
sudo nano /var/www/html/daloradius/library/daloradius.conf.php
```
Après avoir modifié les détails de la base de données :

![[Pasted image 20250711142141.png]]
Redémarrer FreeRADIUS et Apache
```
sudo systemctl restart freeradius.service apache2
```
### Accéder à daloRADIUS

Pour accéder à daloRADIUS via un navigateur Web en visitant :



![[Pasted image 20250716050011.png]]

## Intégration de l'authentification pfSense avec FreeRADIUS, serveur RADIUS

Pour que pfsense utilise le serveur FreeRadius comme son portail captif, nous allons ajouter pfsense comme client NAS du serveur freeradius pour sécurisé l'accès au réseau locale.

Pour faire cela, on va visité le site de daloradius en cliquant sur le navigateur le
http://192.168.200.7/daloradius et on entre le nom de d'utilisateur et son mot de passe (par défaut le nom d'utilisateur est **administrator** et le mot de passe est **radius**)
![[Pasted image 20250716050158.png]]


Pour ajouter le client de freeradius, nous devons cliquer sur le barre de menu **Management > Nas**

cliquons ensiute **New NAS**

![[Pasted image 20250716050440.png]]
Et appliquer le configuration en cliquant sur le boutons **apply** et verifions en cliquant sur le barre de menu **List NAS**

![[Pasted image 20250716050534.png]]
#### création des groupes des utilisateurs
Pour que les utilisateurs soient classé sur chaque groupe qu'il conviennent, il faut créer des groupes et affecter les utilisateurs qu'il correspond.

pour créer nous allons sur **Management > Profiles > New Profile** et ajoutons le nom du profile et on va sélectionner **quickly Locate attribute with autocomplete input** en entrant **Filter-Id** et cliquons sur le boutons **Add Attribute**
![[Pasted image 20250716052052.png]]

Et ensuite, nous allons remplir les formulaire qui apparaît ci-dessous par :

**Value:** *USERS_BDD*

**Op:**  *:=*

**Target:** *reply*

et on clique sur le boutons **apply** ci-dessus

Grace à cette étapes nous pouvons créer plusieurs profiles

Voici, les listes des groupes que nous avons crée:

![[Pasted image 20250716053147.png]]
On voit qu'il y un groupe qui est crée par défaut dans daloradius et aussi les totales des utilisateurs qui sont dans chaque groupe sont nulle
#### création des utilisateurs pour le teste et affectation dans un groupe
Pour créer un utilisateur, nous allons cliqué sur le barre de menu  **Users > New User**  et remplissons les informations de l'utilisateur
![[Pasted image 20250716053604.png]]

D'après la figure montre qu'on a trois options pour s'authentifier que se soit par le nom d'utilisateur ou par adresse MAC ou Par Code PIN

Mais dans cette simulation, nous allons utilisé l'authentification par Username

![[Pasted image 20250716054124.png]]

pour l'ajouter l'utilisateur bob, nous devons cliqué sur le bouton **apply**

En suivant ces étapes, nous pouvons créée plus des utilisateurs
voici donc la listes des utilisateurs que nous avons crées:

![[Pasted image 20250716054410.png]]

Et maintenants, nous pouvons maintenant ajouté le serveur freeradius comme le serveur d'authentification de pfsense

#### Configurations sur pfsense

Pour faire cela, nous allons rendre sur **System > User Manager  >  Authentication Servers** et nous allons cliqué sur le bouton **+ add**

![[Pasted image 20250716054946.png]]

Ici le nom du serveur est nommé par RADIUS et évidement le type du serveur est RADIUS

![[Pasted image 20250716055050.png]]


On remplies les informations du serveur freeradius : le protocole utilisé, l'adresse IP du serveur, le mot de passe qui doit le même ce qu'on ajouter sur serveur freeradius Client NAS , le service que Radius doit offrir et l'adresse IP NAS que nous avons attribué dans le serveur. 

Cliquons sur le boutons save pour enregistrer

![[Pasted image 20250716055242.png]]



Et maintenant, nous allons créer une règle pour assurer la communication entre le serveur freeradius et Pfsense

Pour créer une règle sur pfsense, nous allons navigué sur **Firewall > Rules > DMZ

Cliquons sur le boutons **add**

![[Pasted image 20250716055537.png]]
![[Pasted image 20250716055646.png]]
![[Pasted image 20250716055740.png]]

Dans cette règle, nous allons autorisé le serveur freeradius de tous ls flux réseaus TCP/UDP avec l'autorisation des port 1812 pour l'authentification et 1813 pour la comptabilité

Enfin, nous devons appliquer le règle que nous avons créées en cliquant sur le boutons **Apply Changes** qui affiche au dessus lorsqu'on crée une nouvelle règle.

### Teste de la configuration de l'intégration du serveur Radius dans pfsense
 Pour tester de la configuration de freeradius sur pfsense, nous allons sur le barre de menu **Doagnostics > Authentication**

![[Pasted image 20250716060121.png]]
Résultat:

![[Pasted image 20250716060203.png]]

Alors, nous avons réussi la communication entre le serveur freeRadius externe avec pfsense
 