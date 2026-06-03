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
![[image2.png]]
Lors de l’installation, on nous demanderons de choisir quelques options de configuration. Sélectionnons “Site Internet” et entrez le nom de domaine qui sera utilisé pour les adresses e-mail.
![[image1.png]]
#### Configuration de Postfix

Pour configurer Postfix, nous devons éditer le fichier de configuration de Postfix `/etc/postfix/main.cf` et vous assurer que les valeurs suivantes sont définies:
```
sudo nano /etc/postfix/main.cf
```
Ajoutez ou modifiez les lignes suivantes en fonction de votre domaine:
```
myhostname = lmsmail.local
mydomain = lmsmail.local
myorigin = $mydomain
mydestination = localhost
mynetworks = 127.0.0.0/8 [::1]/128

# Domaines virtuels
virtual_mailbox_domains = mysql:/etc/postfix/mysql-virtual-mailbox-domains.cf
virtual_mailbox_maps = mysql:/etc/postfix/mysql-virtual-mailbox-maps.cf
virtual_mailbox_base = /var/mail/vhosts
virtual_uid_maps = static:5000
virtual_gid_maps = static:5000

# Livraison via Dovecot LMTP
virtual_transport = lmtp:unix:private/dovecot-lmtp

# Authentification SMTP
smtpd_sasl_type = dovecot
smtpd_sasl_path = private/auth
smtpd_sasl_auth_enable = yes

# Sécurité
smtpd_recipient_restrictions =
    permit_mynetworks,
    permit_sasl_authenticated,
    reject_unauth_destination
```
![[image18.1.png]]
![[image18.2.png]]
![[image18.3.png]]
#### Redémarrage de Postfix

Pour que les modifications prennent effet, vous devez redémarrer Postfix en utilisant la commande suivante:
```
sudo systemctl restart postfix
```
# Installation de Dovecot

Dovecot est un serveur de courrier électronique IMAP et POP3 qui permet l’accès aux messages électroniques.

# 1. Installation des paquets Dovecot

Pour installer Dovecot, utilisez la commande suivante:
```
sudo apt install dovecot-core dovecot-imapd dovecot-mysql -y
```
#### Configuration de Dovecot
## **1. Configuration de l’authentification:**
Pour configurer Dovecot, nous devons éditer le fichier `/etc/dovecot/conf.d/10-auth.conf`:
```
sudo nano /etc/dovecot/conf.d/10-auth.conf
```
![[Admin sys avancé/Projet Serveur mail/captures/image8.png]]
![[image8.2.png]]
![[image8.3.png]]

## **2. Authentification via MySQL**

📄 Fichier : `/etc/dovecot/conf.d/auth-sql.conf.ext`
```
passdb {
  driver = sql
  args = /etc/dovecot/dovecot-sql.conf.ext
}

userdb {
  driver = static
  args = uid=vmail gid=vmail home=/var/mail/vhosts/%d/%n
}
```
![[Admin sys avancé/Projet Serveur mail/captures/image21.png]]
## **3. Stockage des emails (Maildir)**

📄 Fichier : `/etc/dovecot/conf.d/10-mail.conf`
```
mail_location = maildir:/var/mail/vhosts/%d/%n/Maildir
mail_uid = vmail
mail_gid = vmail
mail_privileged_group = vmail
first_valid_uid = 5000
last_valid_uid = 5000
first_valid_gid = 5000
last_valid_gid = 500
```
![[image19.1.png]]
![[image19.2.png]]
![[image19.3.png]]

## **4. Service LMTP et Auth (`10-master.conf`)**

📄 Fichier : `/etc/dovecot/conf.d/10-master.conf`
```
service lmtp {
  unix_listener /var/spool/postfix/private/dovecot-lmtp {
    mode = 0600
    user = postfix
    group = postfix
  }
}

service auth {

 unix_listener auth-userdb {
    mode = 0666
    user = vmail 
  }

  unix_listener /var/spool/postfix/private/auth {
    mode = 0660
    user = postfix
    group = postfix
  }
}
```
![[image20.1.png]]
![[image20.2.png]]

**Commande :**
```
ls -la /var/spool/postfix/private/
```

## **5. Configuration SQL**
Cette section configure l'authentification des utilisateurs via une base de données MySQL, permettant une gestion centralisée et sécurisée des comptes email.

**Fichier :`/etc/dovecot/conf.d/auth-sql.conf.ext`**
```
passdb {
 driver = sql
 args = /etc/dovecot/dovecot-sql.conf.ext
}
userdb {
 driver = static
 args = uid=vmail gid=vmail home=/var/mail/vhosts/%d/%n
}
```
![[image9.1.png]]
![[image9.2.png]]

**Description :** Le bloc **`passdb`** définit le pilote SQL pour l'authentification des mots de passe, tandis qu'il **`userdb`** utilise une configuration statique pour tous les utilisateurs virtuels avec l'UID/GID **`vmail`** et un répertoire maison standardisé.

 **Vérification et création de l'utilisateur système`vmail`**

L'utilisateur système `vmail`est essentiel pour gérer les boîtes de messagerie virtuelles. Il doit posséder les répertoires de stockage des emails avec les autorisations appropriées.

**Vérifier l'existence de l'utilisateur**

Commencez par vérifier si l'utilisateur `vmail`existe déjà sur le système :
```
id vmail
```
![[image12.png]]
**Description :** Cette commande affiche les informations sur l'utilisateur `vmail`(UID, GID, groupes). Si l'utilisateur n'existe pas, nous obtiendrons un message d'erreur.

 **Création de l'utilisateur (si inexistant)**
Si l'utilisateur `vmail`n'existe pas, créez-le avec les commandes suivantes :
```
sudo groupadd -g 5000 vmail
sudo useradd -g vmail -u 5000 vmail -d /var/mail -m
```
**Description :**
- La première commande crée le groupe **`vmail`** avec le GID 5000
- La seconde crée l'utilisateur **`vmail`** avec l'UID 5000, l'associe au groupe **`vmail`**, et définit **`/var/mail`** comme répertoire personnel

**Configuration des répertoires de stockage**
Créez l'arborescence des répertoires pour stocker les emails et attribuer les bonnes permissions :
```
sudo mkdir -p /var/mail/vhosts/lmsmail.local
sudo chown -R vmail:vmail /var/mail
```
**Description :** Ces commandes créent la structure de répertoires pour le domaine `lmsmail.local`et attribuent la propriété complète de `/var/mail`à l'utilisateur `vmail`, garantissant que Dovecot pourra lire et écrire les emails.

**Activer le DEBUG AUTH (clé)**
L'activation des logs de débogage pour l'authentification est cruciale lors de la configuration initiale. Elle permet d'identifier rapidement les problèmes d'authentification et de connexion à la base de données.

**Configuration du mode débogage**

Ouvrez le fichier de configuration des logs :
```
sudo nano /etc/dovecot/conf.d/10-logging.conf
```
Ajoutez ou modifiez les lignes suivantes :
```
auth_verbose = yes 
auth_debug = yes 
```
![[image11.png]]

**Description :**
- `auth_verbose = yes`: Activez les messages détaillés sur les tentatives d'authentification
- `auth_debug = yes`: Activer le mode débogage complet pour le processus d'authentification


Fichier : `/etc/dovecot/dovecot-sql.conf.ext`
```
driver = mysql
connect = host=localhost dbname=mailserver user=mailuser password=********
default_pass_scheme = SHA512-CRYPT
password_query = SELECT email as user, password FROM users WHERE email='%u';
```
![[image10.png]]

**Description :** Ce fichier établit la connexion à la base de données MySQL et définit la requête SQL pour récupérer les informations d'authentification. Le schéma SHA512-CRYPT assure un chiffrement robuste des mots de passe.

## 6. Création de la base de données et des utilisateurs mail

Cette section décrit la mise en place de la base de données MySQL qui servira à stocker et gérer les comptes email du serveur Dovecot. Une architecture SQL permet une gestion centralisée, évolutive et sécurisée des utilisateurs.
### 6.1 Connexion à MySQL

Connectez-vous au serveur MySQL avec les privilèges administrateur :
```
mysql -u root -p
```
### 6.2 Création de la base de données `mailserver`

Une fois connecté, créez la base de données dédiée au serveur de messagerie :
```
CREATE DATABASE mailserver;
```
Cette commande crée une base de données nommées `mailserver`qui contient toutes les tables nécessaires à la gestion des comptes email (utilisateurs, quotas, alias, etc.).

### 6.3 Création de l’utilisateur SQL `mailuser`

Pour des raisons de sécurité, créez un utilisateur SQL dédié avec des permissions limitées :
```
CREATE USER 'mailuser'@'localhost' IDENTIFIED BY 'lmscodeadmin';

GRANT SELECT ON mailserver.* TO 'mailuser'@'localhost';

FLUSH PRIVILEGES;
```
**Description :**

- La première ligne crée l'utilisateur `mailuser`avec le mot de passe`lmscodeadmin`
- `GRANT SELECT`accorde uniquement les droits de lecture sur la base `mailserver`(principe du moindre privilège)
- `FLUSH PRIVILEGES`appliquer immédiatement les modifications de permissions

**Sécurité :** Dovecot n'a besoin que de lire les informations d'authentification, d'où l'utilisation exclusive du privilège `SELECT`.
### 6.4 Création de la table des utilisateurs mail

Sélectionnez la base de données et créez la table qui stockera les comptes email :
```
USE mailserver;

CREATE TABLE users (
 email VARCHAR(128) NOT NULL,
 password VARCHAR(255) NOT NULL,
 quota BIGINT DEFAULT 10737418240,
 PRIMARY KEY(email)
);
```
**Description :** Cette table contient trois champs essentiels :

- `email`: L'adresse email complète (utilisateur@domaine), serviteur de clé primaire unique
- `password`: Le mot de passe chiffré au format SHA512-CRYPT
- `quota`: L'espace disque alloué en octets (par défaut 10 Go = 10 737 418 240 octets)

### 6.5 Ajout de 3 utilisateurs mail

Insérez les comptes email de test dans la base de données :
```
INSERT INTO users (email, password) VALUES

('alice@lmsmail.local', '{SHA512-CRYPT}$6$a/QxkkdnGSgQj.vi$fE8W3W.ylDHxStn2l5puwbxMtY40DLEQGXbjPJf0al3ecfigA08awJeTc7CI9gLm2pXxNdfDqWpmjiBKHpuxF1'),

('bob@lmsmail.local', '{SHA512-CRYPT}$6$hS45IGnUxrB4WxQE$JarnyVIlmEexjkEs87nlxDpl18EU.Q7HGm3IqaK2CMJLEQZqFFLBaal8Mw2oy51ZR56Ie.QRlNC0eju1uCr2/.'),

('carol@lmsmail.local', '{SHA512-CRYPT}$6$.A22x.yU05zM72BZ$kI3SzSNGV7sb6e5RAfckXD45GqRaxXYbY4oFc2hS0lmhnerJdkXWknQJ3DfVvIcVJ9MbfNCzVPg9M3SKyEF8e1');
```
**Description :** Cette commande insère trois comptes utilisateurs avec leurs mots de passe chiffrés en SHA512-CRYPT

Le quota par défaut de 10 Go s’applique automatiquement à chaque utilisateur.

Cette structure de base de données constitue le fondement de l'authentification SQL pour Dovecot et peut être facilement étendue avec d'autres fonctionnalités (alias, domaines virtuels, etc.).

## 7. Gestion des utilisateurs et test

Cette section explique comment créer et tester les comptes utilisateurs dans le système de messagerie.
### 7.1 Création d'un utilisateur mail

**Exemple :** `alice@lmsmail.local`

Pour vérifier que l'authentification fonctionne correctement, utilisez la commande de test suivante :
```
sudo doveadm auth test alice@lmsmail.local lmscodeadmin
```
**Résultat attendu :**
```
passdb: alice@lmsmail.local auth succeeded
```
![[image13.png]]

**Description :** Cette commande vérifie que les informations d'identification sont correctement stockées dans la base de données et que Dovecot peut authentifier l'utilisateur avec succès.

## 8. Redémarrage et vérification des services

Après avoir effectué les configurations, il est essentiel de redémarrer Dovecot pour appliquer les modifications et vérifier que le service fonctionne correctement.
```
sudo systemctl restart dovecot
sudo systemctl status dovecot
```
![[image14.png]]

**Description :** Le réexécution applique toutes les modifications de configuration. La commande `status`permet de confirmer que le service est actif et qu'aucune erreur n'est présente au démarrage.

## 9. Tests de fonctionnement

Cette section présente les tests essentiels pour valider le bon fonctionnement du serveur IMAP et l'authentification des utilisateurs.

### 9.1 Test IMAP via Telnet

Pour tester la connectivité IMAP de base, utilisez :
```
telnet localhost 143
```
**Résultat attendu :** 
```
OK Dovecot ready.
```
![[image15.png]]
**Description :** Cette commande établit une connexion brute au serveur IMAP. Le message de bienvenue confirme que Dovecot écoute sur le port 143 et accepte les connexions.
### 9.2 Connexion utilisateur
Une fois connecté via Telnet, authentifiez-vous avec :
```
a login alice@lmsmail.local lmscodeadmin
```
![[image16.png]]
**Description :** Cette commande IMAP authentifie l'utilisateur. Un retour positif (généralement `a OK Logged in`) confirme que l'authentification SQL fonctionne et que l'utilisateur peut accéder à sa boîte mail.

## **10. Journaux et dépannage**

La surveillance des logs est cruciale pour identifier et résoudre rapidement les problèmes de configuration ou d'authentification.
Commande :
```
sudo tail -f /var/log/mail.log
```
![[Admin sys avancé/Projet Serveur mail/captures/image17.png]]

**Description :** Cette commande affiche en temps réel les événements du serveur de messagerie. Elle permet de diagnostiquer les échecs d'authentification, les erreurs de configuration ou tout autre problème rencontré par Dovecot.


# 11. Installation de Roundcube

Roundcube est un client de messagerie Web qui offre une interface conviviale pour accéder à vos emails.

### 11.1 Installation de Roundcube

Pour installer Roundcube, utilisez la commande suivante:
```
sudo apt install roundcube-core rouncube-mysql
```
**11.1.1 Configuration de base des données roundcube : en cliquant sur Yes**

![[image5.png]]
**11.1.2 Saisir le mot de passe pour la bases des données de roundcube :**

![[image6.png]]
**11.1.3 Confirmation de mot de passe :**
![[image7.png]]
#### 11.2 Configuration du serveur Web pour Roundcube

Édite le fichier :
```
sudo nano /etc/roundcube/config.inc.php

```
**11.2.1 Configuration IMAP (Dovecot)**
```
$config['default_host'] = 'ssl://localhost';
$config['default_port'] = 993;

$config['imap_conn_options'] = [
  'ssl' => [
     'verify_peer'       => false,
     'verify_peer_name'  => false,
     'allow_self_signed' => true,
  ],
];
```
![[image22.png]]

**11.2.2 Configuration SMTP (Postfix)**
```
$config['smtp_server'] = 'tls://localhost';
$config['smtp_port'] = 587;

$config['smtp_conn_options'] = [
  'ssl' => [
     'verify_peer'  => false,
     'verify_peer_name' => false,
     'allow_self_signed' => true,
  ],
];

$config['smtp_user'] = '%u';
$config['smtp_pass'] = '%p';
```
![[image23.png]]
**11.2.3 Nom du produit**
```
$config['mail_domain'] = 'Roundcube Webmail - lmsmail';
```
![[image24.png]]

**11.2.4 Autre options important de Roundcube**
```
$config['des_key'] = '2kPBk4lt2oekcMBlFZZoOrvh';

$config['enable_installer'] = false;  // désactiver l'interface d'installation pour la sécurité

// Logging (pour debug)
$config['log_driver'] = 'syslog';
$config['syslog_facility'] = LOG_USER;
```
![[image25.png]]

**11.2.5 Étapes finales à vérifier**
Apache doit pointer vers le bon dossier Roundcube :
```
sudo a2enconf roundcube
sudo systemctl reload apache2
```
Permissions correctes (pour que Apache puisse lire) :
```
sudo chown -R www-data:www-data /var/lib/roundcube
sudo chmod -R 755 /var/lib/roundcube
```
Test dans navigateur : [[http://lmsmail.com/roundcube]]
![[image26.png]]
![[imeges27.png]]
