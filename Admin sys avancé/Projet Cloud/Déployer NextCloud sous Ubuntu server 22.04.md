## Introduction

**Nextcloud est une** **plateforme** open source de partage et de collaboration de fichiers auto-hébergée, conçue pour le stockage et la communication sécurisés des données. Elle offre une alternative performante aux services cloud commerciaux, vous permettant de contrôler entièrement vos données. Ce guide vous accompagnera pas à pas dans l'installation de Nextcloud sur Ubuntu 24.04/22.04, en veillant à ce que votre configuration soit sécurisée et optimisée.
## Prérequis

Avant de commencer, assurez-vous d'avoir les éléments suivants :

- Une instance de serveur Ubuntu 24.04, 22.04 ou 20.04.
- Un utilisateur non root disposant des privilèges sudo.
- Un nom de domaine pleinement qualifié (FQDN) pointait vers l'adresse IP de votre serveur.
- Connaissances de base des opérations en ligne de commande.

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
## Étape 3 : Installer PHP et les extensions nécessaires

Nextcloud étant basé sur PHP, nous devons installer PHP ainsi que plusieurs extensions requises par Nextcloud.
```
sudo apt install php libapache2-mod-php php-mysql php-gd php-json php-curl php-mbstring php-intl php-imagick php-xml php-zip -y
```
Vérifiez la version de PHP pour vous assurer qu'elle est correctement installée :
```
php -v
```
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
```
<VirtualHost *:80> 
ServerAdmin admin@example.com 
DocumentRoot /var/www/nextcloud 
ServerName your_domain 
	<Directory /var/www/nextcloud/> 
	Options +FollowSymlinks 
	AllowOverride All 
	<IfModule mod_dav.c> 
		Dav off 
	</IfModule> 
	SetEnv HOME /var/www/nextcloud 
	SetEnv HTTP_HOME /var/www/nextcloud 
	</Directory> 
	ErrorLog ${APACHE_LOG_DIR}/nextcloud_error.log 
	CustomLog ${APACHE_LOG_DIR}/nextcloud_access.log combined 
</VirtualHost>
```
Activez la nouvelle configuration et les modules Apache requis :
```
sudo a2ensite nextcloud.conf  
sudo a2enmod rewrite headers env dir mime
```
Redémarrez Apache pour appliquer les modifications :
```
sudo systemctl restart apache2
```
## Étape 8 : Installation et configuration SSL

Pour des raisons de sécurité, il est essentiel d'utiliser SSL/TLS pour chiffrer les échanges entre le serveur et les clients. Nous utiliserons Certbot pour obtenir un certificat SSL gratuit auprès de Let's Encrypt.

Installez Certbot et le plugin Apache :
```
sudo apt install certbot python3-certbot-apache -y
```
Obtenez et installez le certificat SSL :
```
sudo certbot --apache -d your_domain
```
Suivez les instructions pour terminer l'installation SSL. Certbot configurera automatiquement Apache pour utiliser le nouveau certificat.

## Étape 9 : Terminez la configuration de Nextcloud dans votre navigateur

Ouvrez votre navigateur web et accédez à votre domaine :
```
https://your_domain
```
Vous serez accueilli par la page de configuration de Nextcloud. Suivez les étapes suivantes :

1. **Créer un compte administrateur :**  Indiquez un nom d’utilisateur et un mot de passe pour le compte administrateur Nextcloud.
2. **Configuration de la base de données :**  Saisissez les informations de la base de données que vous avez créée précédemment :
    - **Utilisateur de la base de données :**  nextclouduser
    - **Mot de passe de la base de données :**  votre_mot_de_passe
    - **Nom de la base de données :**  nextcloud
3. **Terminer l'installation :**  Cliquez sur « Terminer l'installation » pour achever l'installation.

## Étape 10 : Sécurisez votre installation Nextcloud

### Configurer les domaines de confiance

Ouvrez le fichier de configuration Nextcloud :
```
sudo nano /var/www/nextcloud/config/config.php
```
Ajoutez votre domaine au tableau des domaines de confiance :
```
'trusted_domains' => 
array ( 
	0 => 'localhost', 
	1 => 'your_domain', 
),
```
### Configurer une tâche Cron pour les tâches en arrière-plan

Nextcloud nécessite l'exécution régulière de tâches en arrière-plan. Configurez une tâche cron pour gérer cela :
```
sudo crontab -u www-data -e
```
Ajoutez la ligne suivante pour exécuter la tâche cron toutes les 5 minutes :
```
*/5 * * * * php -f /var/www/nextcloud/cron.php
```
## Étape 11 : Optimiser les performances de Nextcloud

### Installer et configurer Opcache

Opcache est une extension PHP qui met en cache les scripts PHP compilés afin d'améliorer les performances.

Installer Opcache :
```
sudo apt install php-opcache -y
```
Configurez Opcache en modifiant le fichier de configuration PHP :
```
sudo nano /etc/php/8.1/apache2/php.ini
```
Ajoutez ou modifiez les lignes suivantes :
```
opcache.enable=1
opcache.interned_strings_buffer=8
opcache.max_accelerated_files=10000
opcache.memory_consumption=128
opcache.save_comments=1
opcache.revalidate_freq=1
```
Redémarrez Apache pour appliquer les modifications :
```
sudo systemctl restart apache2
```
## Étape 12 : Configurations supplémentaires

### Activer les URL conviviales

Pour activer les URL conviviales dans Nextcloud, modifiez le  `.htaccess` fichier :
```
sudo nano /var/www/nextcloud/.htaccess
```
Ajoutez les lignes suivantes à la fin :
```
<IfModule mod_rewrite.c> 
	RewriteEngine on RewriteRule .* - [env=HTTP_AUTHORIZATION:{HTTP:Authorization}] 
	RewriteRule ^\.well-known/carddav /remote.php/dav/ [R=301,L] 
	RewriteRule ^\.well-known/caldav /remote.php/dav/ [R=301,L] 
</IfModule>
```
Activer mod_rewrite dans Apache :
```
sudo a2enmod rewrite 
sudo systemctl restart apache2
```
### Augmenter la limite de mémoire PHP

Modifiez le fichier de configuration PHP pour augmenter la limite de mémoire et obtenir de meilleures performances :

```
sudo nano /etc/php/8.1/apache2/php.ini
```
Définissez la limite de mémoire à 512 Mo ou plus :
```
memory_limit = 512M
```
Redémarrez Apache :
```
sudo systemctl restart apache2
```
## Étape 13 : Utilisation de Nextcloud

L'installation de Nextcloud est maintenant terminée. Vous pouvez commencer à utiliser Nextcloud en y accédant via votre navigateur web. Explorez ses fonctionnalités telles que le partage de fichiers, le calendrier, les contacts et diverses applications qui enrichissent son fonctionnement.
## Conclusion

L'installation de Nextcloud sur Ubuntu 24.04/22.04 comprend plusieurs étapes, notamment la configuration d'un serveur web, de PHP et d'un serveur de base de données, suivie de la configuration du protocole SSL pour sécuriser les communications. En suivant ce guide, vous disposerez d'une instance Nextcloud pleinement fonctionnelle offrant une solution de stockage cloud robuste et auto-hébergée. N'oubliez pas de mettre à jour régulièrement votre instance Nextcloud et ses dépendances afin de garantir la sécurité et les performances.