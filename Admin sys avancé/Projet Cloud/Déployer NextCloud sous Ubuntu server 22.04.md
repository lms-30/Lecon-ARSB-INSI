## Introduction

**Nextcloud est une** **plateforme** open source de partage et de collaboration de fichiers auto-hébergée, conçue pour le stockage et la communication sécurisés des données. Elle offre une alternative performante aux services cloud commerciaux, vous permettant de contrôler entièrement vos données. Ce guide vous accompagnera pas à pas dans l'installation de Nextcloud sur Ubuntu 24.04/22.04, en veillant à ce que votre configuration soit sécurisée et optimisée.
## Prérequis

Avant de commencer, assurez-vous d'avoir les éléments suivants :

- Une instance de serveur Ubuntu 24.04, 22.04 ou 20.04.
- Un utilisateur non root disposant des privilèges sudo.
- Connaissances de base- Un nom de domaine pleinement qualifié (FQDN) pointait vers l'adresse IP de votre serveur.
 des opérations en ligne de commande.

## Étape 1 : Mettez à jour votre système

Tout d'abord, assurez-vous que votre système est à jour. Exécutez les commandes suivantes :
```
sudo apt update 
sudo apt upgrade -y
```
## Étape 2 : Installer le serveur Web Apache

Nextcloud nécessite un serveur web pour son interface web. Nous utiliserons Apache à cet effet.
```
sudo apt install apache2 -y
```
Activer et démarrer Apache :
```
sudo systemctl enable apache2 
sudo systemctl start apache2
```

Vérifiez l'état pour vous assurer qu'Apache est en cours d'exécution :
```
sudo systemctl status apache2
```
![[Pasted image 20260107084556.png]]
## Étape 3 : Installer PHP et les extensions nécessaires

Nextcloud étant basé sur PHP, nous devons installer PHP ainsi que plusieurs extensions requises par Nextcloud.
```
sudo apt install php libapache2-mod-php php-mysql php-gd php-json php-curl php-mbstring php-intl php-imagick php-xml php-zip -y
```
Vérifiez la version de PHP pour vous assurer qu'elle est correctement installée :
```
php -v
```
![[Pasted image 20260107085248.png]]
## Étape 4 : Installation du serveur de base de données MariaDB

Nextcloud nécessite une base de données pour stocker ses données. Nous utiliserons MariaDB, une version dérivée et populaire de MySQL.
```
sudo apt install mariadb-server -y
```
Sécurisez l'installation de MariaDB :
```
sudo mysql_secure_installation
```
Suivez les instructions pour définir le mot de passe root et supprimer les utilisateurs et bases de données inutiles.

## Étape 5 : Créer une base de données pour Nextcloud

Connectez-vous à l'interface MariaDB en tant qu'utilisateur root :
```
sudo mysql -u root -p
```
Créer une base de données et un utilisateur pour Nextcloud :
```
CREATE DATABASE nextcloud; CREATE USER 'nextclouduser'@'localhost' IDENTIFIED BY 'lmscodeadmin'; GRANT ALL PRIVILEGES ON nextcloud.* TO 'nextclouduser'@'localhost'; FLUSH PRIVILEGES; EXIT;
```
## Étape 6 : Télécharger et configurer Nextcloud

Accédez au répertoire /var/www et téléchargez la dernière version de Nextcloud :
```
cd /var/www  
sudo wget https://download.nextcloud.com/server/releases/latest.zip
```
Extraire l'archive téléchargée :
```
sudo apt install unzip -y 
sudo unzip latest.zip
```
Définissez les autorisations appropriées :
```
sudo chown -R www-data:www-data nextcloud  
sudo chmod -R 755 nextcloud
```
## Étape 7 : Configurer Apache pour Nextcloud

Créez un nouveau fichier de configuration Apache pour Nextcloud :
```
sudo nano /etc/apache2/sites-available/nextcloud.conf
```
Ajoutez la configuration suivante :
![[Pasted image 20260107100825.png]]
Activez la nouvelle configuration et les modules Apache requis :
```
sudo a2ensite nextcloud.conf  
sudo a2enmod rewrite headers env dir mime
```
Redémarrez Apache pour appliquer les modifications :
```
sudo systemctl restart apache2
```
## Étape 9 : Terminez la configuration de Nextcloud dans votre navigateur

Ouvrez votre navigateur web et accédez à votre domaine :
```
https://192.168.88.211
```
Vous serez accueilli par la page de configuration de Nextcloud. Suivez les étapes suivantes :

1. **Créer un compte administrateur :**  Indiquez un nom d’utilisateur et un mot de passe pour le compte administrateur Nextcloud.
2. **Configuration de la base de données :**  Saisissez les informations de la base de données que vous avez créée précédemment :
    - **Utilisateur de la base de données :**  nextclouduser
    - **Mot de passe de la base de données :**  votre_mot_de_passe
    - **Nom de la base de données :**  nextcloud
3. **Terminer l'installation :**  Cliquez sur « Terminer l'installation » pour achever l'installation.
![[Pasted image 20260107103718.png]]
![[Pasted image 20260107103821.png]]

### Tableau de bord dr nextcloud

![[Pasted image 20260107110033.png]]
