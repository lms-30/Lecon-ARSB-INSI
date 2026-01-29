Dans cet projet, nous allons nous concentrer sur la mise en place d’un serveur de messagerie Web sur Ubuntu 22.04, ce qui vous permettra d’accéder à vos emails via une interface de navigateur Web. C’est une méthode de communication flexible et accessible. Nous allons utiliser Postfix comme agent de transfert de courrier (MTA), Dovecot comme serveur IMAP et Roundcube comme client de messagerie Web.

#### Préparation du système

Avant de commencer l’installation des différents éléments nécessaires pour votre serveur de messagerie Web, vous devez vous assurer que votre système est à jour. Pour cela, ouvrez un terminal et exécutez les commandes suivantes:
```
sudo apt update
sudo apt upgrade
```
#### Installation de Postfix

Postfix est un agent de transfert de courrier (MTA) largement utilisé qui permet l’envoi et la réception d’e-mails.

#### Installation de Postfix

Pour installer Postfix, utilisez la commande suivante:
```
sudo apt install postfix
```
Lors de l’installation, on nous demanderons de choisir quelques options de configuration. Sélectionnons “Site Internet” et entrez le nom de domaine qui sera utilisé pour les adresses e-mail.

#### Configuration de Postfix

Pour configurer Postfix, nous devons éditer le fichier de configuration de Postfix `/etc/postfix/main.cf` et vous assurer que les valeurs suivantes sont définies:
```
sudo nano /etc/postfix/main.cf
```
Ajoutez ou modifiez les lignes suivantes en fonction de votre domaine:
```
myhostname = mail.example.com
mydomain = example.com
myorigin = $mydomain
inet_interfaces = all
mydestination = $myhostname, localhost.$mydomain, localhost, $mydomain
```
#### Redémarrage de Postfix

Pour que les modifications prennent effet, vous devez redémarrer Postfix en utilisant la commande suivante:
```
sudo systemctl restart postfix
```
#### Installation de Dovecot

Dovecot est un serveur de courrier électronique IMAP et POP3 qui permet l’accès aux messages électroniques.

#### Installation de Dovecot

Pour installer Dovecot, utilisez la commande suivante:
```
sudo apt install dovecot-core dovecot-imapd
```
#### Configuration de Dovecot

Pour configurer Dovecot, vous devez éditer le fichier `/etc/dovecot/conf.d/10-mail.conf`:
```
sudo nano /etc/dovecot/conf.d/10-mail.conf
```
Assurez-vous que l’emplacement du courrier est correctement défini:
```
mail_location = maildir:~/Maildir
```
#### Autoriser l’accès IMAP

Pour autoriser l’accès IMAP, vous devez éditer le fichier`/etc/dovecot/conf.d/10-auth.conf`:
```
sudo nano/etc/dovecot/conf.d/10-auth.conf
```
Assurez-vous que la ligne suivante n’est pas commentée:
```
disable_plaintext_auth = no
```
#### Redémarrage de Dovecot

Pour que les modifications prennent effet, vous devez redémarrer Dovecot en utilisant la commande suivante:
```
sudo systemctl restart dovecot
```
#### Installation de Roundcube

Roundcube est un client de messagerie Web qui offre une interface conviviale pour accéder à vos emails.

#### Installation de Roundcube

Pour installer Roundcube, utilisez la commande suivante:
```
sudo apt install roundcube
```
Lors de l’installation, on vous demandera de fournir des détails sur la base de données. Choisissez la base de données souhaitée (MySQL est recommandé) et suivez les instructions pour configurer Roundcube.

#### Configuration du serveur Web pour Roundcube

En fonction de votre serveur Web (Apache ou Nginx), vous devrez créer une configuration appropriée pour accéder à Roundcube. Pour Apache, cela pourrait impliquer la création d’une nouvelle configuration de site sous `/etc/apache2/sites-available/roundcube.con`
