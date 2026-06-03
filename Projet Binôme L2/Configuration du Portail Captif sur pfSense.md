
1. **Mise à jour du système et installation des paquets**
```
sudo apt update && sudo apt upgrade -y
```
> Met à jour la liste des paquets disponibles.

```
sudo apt install freeradius freeradius-mysql mariadb-server -y

```
> Installe :

- `freeradius` : le serveur RADIUS principal,
    
- `freeradius-mysql` : le module d’authentification via MySQL,
    
- `mariadb-server` : le serveur de base de données utilisé par FreeRADIUS.

2. **Démarrage de FreeRADIUS (pour test initial)**

Vérifie si le service freeradius est en cours d’exécution.
```
sudo systemctl status freeradius

```
![[Pasted image 20250710051700.png]]


Ici FreeRadius est en cours d'exécution, il faut stoper pour tester la configuration initial
```
sudo systemctl stop freeradius
```
Et apres, on lance cette commande de débogage

Lance FreeRADIUS en **mode débogage** (très utile pour repérer les erreurs dans les fichiers `.conf`)
```
sudo freeradius -X

```

![[Pasted image 20250710052022.png]]

3. **Configurer MySQL pour FreeRADIUS**
a. Lancer MySQL en root :

Ouvre un shell MySQL avec droits administrateur.
```
sudo mysql -u root -p
```

b. Créer la base de données et l'utilisateur :

- Crée une base `radius` pour stocker les utilisateurs.
```
CREATE DATABASE radius;
```
- Crée l’utilisateur MySQL `radius` avec le mot de passe sécurisé et lui donne tous les droits sur la base `radius`.
```
CREATE USER IF NOT EXISTS 'radius'@'localhost' IDENTIFIED BY 'FreeR@dius2025!';
GRANT ALL PRIVILEGES ON radius.* TO 'radius'@'localhost';
GRANT ALL PRIVILEGES ON radius.* TO 'radius'@'%';
FLUSH PRIVILEGES;
```
Les deux hôtes (localhost et %) permettent la connexion locale et réseau.

4. **Créer les tables nécessaires**
```
USE radius;
```
- Table `radcheck` (authentification) :
```
CREATE TABLE radcheck (
  id INT AUTO_INCREMENT PRIMARY KEY,
  username VARCHAR(64) NOT NULL,
  attribute VARCHAR(64) NOT NULL DEFAULT 'Cleartext-Password',
  op CHAR(2) NOT NULL DEFAULT ':=',
  value VARCHAR(253) NOT NULL
);
```
cette table est utilisée par FreeRADIUS pour vérifier les identifiants.
- Table `access_control` (ZTNA) :
```
CREATE TABLE access_control (
  id INT AUTO_INCREMENT PRIMARY KEY,
  username VARCHAR(64) NOT NULL,
  resource VARCHAR(128) NOT NULL,
  access_type ENUM('vpn', 'local') NOT NULL,
  allowed BOOLEAN NOT NULL DEFAULT FALSE
);
```
Cette table permet de contrôler l’accès aux ressources selon le **nom**, le **type d’accès (vpn/local)** et si l’accès est **autorisé (TRUE/FALSE)**.

- ajoutons deux utilisateurs test :
```
INSERT INTO radcheck (username, attribute, op, value)
VALUES ('client1', 'Cleartext-Password', ':=', 'client1password'), ('clien2', 'Cleartext-Password', ':=', 'client2password');
```
Nous avons donc crée deux clients,
Et maintenants, on va leurs ajouters dans le table access_control pour donner un droit d'acces sur une ressources spécifique

```
INSERT INTO access_control (username, resource, access_type, allowed)
VALUES ('client1', 'web.local', 'vpn', TRUE),
       ('client1', 'db.local', 'vpn', FALSE),
       ('client2', 'web.local', 'vpn', FALSE),
       ('client2', 'db.local', 'vpn', TRUE);
```
Dans cette requête, on ajouter que le client1 on un droit d'accéder au serveur web mais pas à la Base de données et c'est tous le contraire pour le client2

5. **Activer le module SQL dans FreeRADIUS**
Pour activer le module SQL dans FreeRadius, il faut créée un lien symbolique dans mods-enabled.
```
sudo ln -s /etc/freeradius/3.0/mods-available/sql /etc/freeradius/3.0/mods-enabled/

```
6. **Configurer le module SQL (accès à MySQL)**
Pour que FreeRadius puissent accédé au base de données de mysql, il est très important de modifier les fichier dans le repertoire suivante:
```
sudo nano /etc/freeradius/3.0/mods-available/sql
```
Et modifions les lignes suivantes:
```
driver = "rlm_sql_mysql"
port = 3306
server = "localhost"
login = "radius"
password = "FreeR@dius2025!"
radius_db = "radius"

```
Ces paramètres indiquent à FreeRADIUS comment se connecter à la base de données `radius`.

N.B: ces paramètres doivent ressemblé au utilisateur dans le base se données radius et le mot de passe. Si non le serveur FreeRadius retourne une erreur de connexion à la base de données.

Il faut aussi commenté le sous section **TLS** dans la section mysql parce qu'on a pas de certificat de TLS

Dans cette simulation, on n'a pas besoin mais il est il très utile pour les entreprise pour une raison de sécurité.

7. **Ajouter la logique ZTNA (filtrage par ressource)**

Pour ajouter la logique de ZTNA dans la FreeRadius pour qu'il puissent segmenté d'accées aux ressources dans notre réseaux, on va édité le fichier suivant:

```
sudo nano /etc/freeradius/3.0/sites-enabled/default

```
Et on cherche, la section authorize et ajoutons-y le script suivant:
```
sql

if ("%{sql:SELECT allowed FROM access_control WHERE username='%{User-Name}' AND resource='web.local' AND access_type='vpn'}" != "1") {
    reject
}

```
Cela rejette la connexion si l'utilisateur **n'est pas autorisé** à accéder à `web.local` via VPN.

8. **Déclarer les clients RADIUS autorisés (pfSense, VPN)**
Dans cette simulation, on a que deux clients Radius qui va avoir une autorisation d'utilisé le serveur Radius

Pour ajouter les clients Radius, il suffit de rendre dans le répertoire du fichier clients.conf et l'édité
```
sudo nano /etc/freeradius/3.0/clients.conf

```
Ajouter les clients :
```
client pfsense {
    ipaddr = 192.168.100.1
    secret = pfSensesecretpartager123
    require_message_authenticator = no
}

client vpn {
    ipaddr = 10.0.0.254
    secret = vpnsecretpartager123
    require_message_authenticator = no
}

```

Cela autorise les requêtes RADIUS depuis ces IPs avec un "mot de passe partagé".

9. **Redémarrer FreeRADIUS**
Pour appliquez les changements, il redémarrer FreeRadius
```
sudo systemctl restart freeradius

```
10. **Tester la configuration**

**a. Avec radtest en local :**
```
radtest client1 client1password 127.0.0.1 0 testing123

```
Envoie une requête d’authentification à localhost.
![[Pasted image 20250710063715.png]]

Si le mot de passe ou le nom de l'utilisateur ou bien le mot de pase partagé de freeradius est incorrecte, on nous allons une accès rejeter