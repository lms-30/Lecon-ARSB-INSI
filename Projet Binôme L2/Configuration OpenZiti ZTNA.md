
Voici la **configuration complète détaillée pour chaque VM** (VM1 à VM4) dans une **infrastructure ZTNA native avec OpenZiti**. Toutes les étapes sont adaptées pour Ubuntu Server 22.04 (sauf VM4 en desktop) dans VirtualBox ou tout autre hyperviseur.

---

# 🟢 VM1 : ZITI-CONTROLLER

**Nom** : `ziti-controller`  
**OS** : Ubuntu Server 22.04  
**Rôle** : Gérer le réseau Ziti (identités, services, policies)
**Objectif** : gérer toute la sécurité du réseau Ziti : identités, services, politiques d’accès, enregistrements.

---

### ✅ **A. Installation Docker & Docker Compose**

```
sudo apt update && sudo apt upgrade -y 
```
```
sudo apt install -y docker.io docker-compose 
```
![[Pasted image 20250621105453.png]]
```
sudo systemctl enable docker && sudo systemctl start docker
```
![[Pasted image 20250621105710.png]]
---

### ✅ **B. Déploiement Ziti avec Docker**

```
git clone https://github.com/openziti/ziti.git
```
![[Pasted image 20250621112650.png]]
```
cd ziti/quickstart/docker/
```

Puis démarrez :

```
docker-compose up -d

```

Les services suivants seront lancés :

- `ziti-controller`
    
- `ziti-edge-api`
    
- PKI généré automatiquement dans `./pki`
    

---

### ✅ **C. Accéder à l'interface CLI**


```
docker exec -it ziti-cli bash ziti edge login localhost:1280 -u admin -p admin
```

> Créez un alias pour simplifier l’appel :

```
alias ziti='docker exec -it ziti-cli ziti'

```
---

# 🟢 VM2 : ZITI-ROUTER

**Nom** : `ziti-router`  
**OS** : Ubuntu Server 22.04  
**Rôle** : Acheminement des flux Ziti (Router Edge + Fabric)

---

### ✅ **A. Installer Ziti Router**


```
curl -L https://github.com/openziti/ziti/releases/latest/download/ziti-linux-amd64 -o /usr/local/bin/ziti chmod +x /usr/local/bin/ziti
```

### ✅ **B. Créer une identité Router (sur VM1)**

Sur VM1 (ziti-controller CLI) :

```
ziti edge create identity router edge-router -o edge-router.jwt
```

Transférez `edge-router.jwt` vers VM2 :

```
scp edge-router.jwt user@<IP_VM2>:/home/user/
```

---

### ✅ **C. Initialiser le Router sur VM2**

```
ziti router enroll edge-router.jwt ziti router run /home/user/.ziti/edge-router.json
```

> Ajoutez au `crontab` ou en service `systemd` pour lancement automatique.

---

### ✅ **D. Ouvrir les ports dans le pare-feu**


```
sudo ufw allow 443 
```
```
sudo ufw allow 10080
```
```
sudo ufw enable
```

---

# 🔵 VM3 : WEB-SERVER

**Nom** : `web-server`  
**OS** : Ubuntu Server 22.04  
**Rôle** : Héberge l'application protégée (Apache/Nginx)

---

### ✅ **A. Installer Apache ou Nginx**

```
sudo apt install apache2 -y
```

Créez une page simple :

```
echo "<h1>ZTNA Web Page</h1>" | sudo tee /var/www/html/index.html
```

Test local :

```
curl http://127.0.0.1
```

---

### ✅ **B. Installer Ziti Edge Tunnel**

```
curl -L https://github.com/openziti/ziti-tunnel-sdk-c/releases/latest/download/ziti-edge-tunnel-linux.tar.gz -o tunnel.tar.gz 
```
```
tar -xzf tunnel.tar.gz 
```
```
cd ziti-edge-tunnel-*

```
### ✅ **C. Ajouter identité (depuis VM1)**

Sur VM1 :


```
ziti edge create identity service web-server -o web-server.jwt 
```
```
ziti edge create config web-config intercept.v1 '{"protocol":"tcp","addresses":["web.local"],"portRanges":[{"low":80,"high":80}]}' 
```
```
ziti edge create service web.local --configs web-config 
```
```
ziti edge create service-policy bind-web Bind web.local 'identity = "web-server"'
```

Copiez `web-server.jwt` sur VM3, puis :

```
./ziti-edge-tunnel run --identity web-server.jwt

```
---

### ✅ **D. Configuration persistante**

Ajoutez dans `/etc/systemd/system/ziti-web-tunnel.service` :


```
[Unit] 
Description=Ziti Tunnel for Web Server 
After=network.target 

[Service] 
ExecStart=/home/user/ziti-edge-tunnel run --identity /home/user/web-server.jwt Restart=always  

[Install] 
WantedBy=multi-user.target

```
```
sudo systemctl daemon-reexec 
```
```
sudo systemctl enable ziti-web-tunnel 
```
```
sudo systemctl start ziti-web-tunnel
```

---

# 🟠 VM4 : ZITI-CLIENT

**Nom** : `ziti-client`  
**OS** : Ubuntu Desktop 22.04  
**Rôle** : Machine utilisateur avec tunnel Ziti

---

### ✅ **A. Télécharger le Ziti Desktop Edge**


```
wget https://github.com/openziti/desktop-edge/releases/latest/download/ziti-desktop-edge-linux.deb 
```
```
sudo apt install ./ziti-desktop-edge-linux.deb
```

> Ou Windows : `.exe` disponible sur GitHub

---

### ✅ **B. Ajouter identité client (depuis VM1)**

Sur VM1 :

```
ziti edge create identity user client1 -o client1.jwt 
```
```
ziti edge create service-policy dial-web Dial web.local 'identity = "client1"'
```

Copiez `client1.jwt` sur VM4, puis importez depuis l'interface Ziti Desktop Edge.

---

### ✅ **C. Tester l'accès**

Une fois connecté, ouvrez un navigateur :

http://web.local

✅ Si tout est bien configuré, vous voyez la page Web **sans exposer le port 80 publicement**.

---

## 📌 Notes de sécurité :

- Tous les ports exposés doivent être uniquement sur les VMs internes
    
- Ajoutez `DNS web.local → 100.64.0.x` via `/etc/hosts` ou DNS interne
    
- Utilisez TLS si vous publiez un service en production (`https` avec certificat)


# CONFIGURATION OPENZiti AVEC DOCKER

Voici un **exemple d’application avec OpenZiti** répartie entre **deux sites (Site A et Site B)** utilisant **Docker Compose**, où la communication passe par **OpenVPN sécurisé avec un chiffrement basé sur SHA256/AES-256**. L'architecture est hybride : OpenVPN établit une connexion site-à-site, et OpenZiti permet d’implémenter du Zero Trust en overlay.

---

## 🧱 Objectif

- Site A : héberge le **Ziti Controller**, **Ziti Router**, et **OpenVPN Server**
    
- Site B : héberge un **client OpenVPN**, un **Ziti Edge Router**, et une **application consommatrice**
    
- La communication entre sites passe par **OpenVPN (TLS + SHA256 + AES-256)**
    
- OpenZiti sécurise la communication applicative (Zero Trust overlay)
    

---

## 🧬 Prérequis

- DNS interne ou IP publique pour joindre les services
    
- Clés et certificats OpenVPN générés via `easyrsa`
    
- Ziti bootstrappé côté Site A
    

---

## 📁 Arborescence simplifiée

css

CopierModifier

`openziti-project/ 
├── site-a/
│      ├── docker-compose.yml 
│      └── ziti-controller.env 
│ 
├── site-b/ 
│      ├── docker-compose.yml 
│      └── client.ovpn`

---

## 📄 `site-a/docker-compose.yml`

```
version: "3.9"
services:
  ziti-controller:
    image: openziti/ziti-controller:latest
    container_name: ziti-controller
    ports:
      - "1280:1280"     # API
      - "6262:6262"     # Controller
    volumes:
      - ./ziti-controller.env:/etc/ziti-controller.env
    environment:
      - ZITI_CTRL_NAME=ziti-controller
    command: ["run", "/etc/ziti-controller.env"]

  ziti-router:
    image: openziti/ziti-router:latest
    container_name: ziti-router
    depends_on:
      - ziti-controller
    ports:
      - "3022:3022"   # Ziti Edge Router
    environment:
      - ZITI_ROUTER_NAME=site-a-router
      - ZITI_CTRL_ADDRESS=ziti-controller:6262
    command: ["run", "--router", "edge"]

  openvpn-server:
    image: kylemanna/openvpn
    container_name: openvpn-server
    cap_add:
      - NET_ADMIN
    volumes:
      - ./ovpn-data:/etc/openvpn
    ports:
      - "1194:1194/udp"
    restart: always

```

---

## 📄 `site-b/docker-compose.yml`

```
version: "3.9"
services:
  openvpn-client:
    image: dperson/openvpn-client
    container_name: openvpn-client
    cap_add:
      - NET_ADMIN
    devices:
      - /dev/net/tun
    volumes:
      - ./client.ovpn:/vpn/client.ovpn
    command: "-f '' -r '' -a '-cipher AES-256-CBC -auth SHA256'"

  ziti-router:
    image: openziti/ziti-router:latest
    container_name: site-b-router
    depends_on:
      - openvpn-client
    network_mode: "service:openvpn-client"  # utilise réseau VPN
    environment:
      - ZITI_ROUTER_NAME=site-b-router
      - ZITI_CTRL_ADDRESS=10.8.0.1:6262  # IP VPN du contrôleur
    command: ["run", "--router", "edge"]

  app-client:
    image: curlimages/curl
    container_name: app-client
    depends_on:
      - ziti-router
    command: ["sleep", "infinity"]

```

---

## 📄 Exemple `client.ovpn` (site B)

conf

CopierModifier

`client dev tun proto udp remote IP_PUBLIQUE_SITE_A 1194 resolv-retry infinite nobind persist-key persist-tun cipher AES-256-CBC auth SHA256 remote-cert-tls server auth-user-pass <ca> # ... certificat CA ... </ca> <cert> # ... certificat client ... </cert> <key> # ... clé privée ... </key>`

---

## 🛡️ Sécurité OpenVPN

Dans ce setup, le **chiffrement AES-256-CBC** et l’**authentification SHA256** sont spécifiés dans :

- le fichier `.ovpn`
    
- la commande du conteneur client :
    
    bash
    
    CopierModifier
    
    `command: "-f '' -r '' -a '-cipher AES-256-CBC -auth SHA256'"`
    

---

## 🧪 Étapes de test

1. **Démarrer les services sur Site A :**
    
    bash
    
    CopierModifier
    
    `cd site-a && docker-compose up -d`
    
2. **Créer les identités et configs Ziti sur Site A :**
    
    bash
    
    CopierModifier
    
    `docker exec -it ziti-controller ziti edge create identity device site-b-router`
    
3. **Démarrer les services sur Site B :**
    
    bash
    
    CopierModifier
    
    `cd site-b && docker-compose up -d`
    
4. **Vérifier que le VPN fonctionne :**
    
    bash
    
    CopierModifier
    
    `docker exec -it openvpn-client ping 10.8.0.1`
    
5. **Vérifier que le routeur Ziti se connecte :**
    
    bash
    
    CopierModifier
    
    `docker logs site-b-router`

Voici la structure complète du projet avec les fichiers nécessaires pour déployer une architecture sécurisée **OpenZiti + OpenVPN** répartie entre deux sites, avec :

- Une application web (`Flask`) + une base de données PostgreSQL sur le Site A
    
- Des utilisateurs avec accès micro-segmenté
    
- Des scripts d’automatisation pour créer les identités, services et policies

```
project-openziti-openvpn/
├── site-a/
│   ├── docker-compose.yml           # Compose pour le site A
│   ├── ziti-controller.env          # Fichier d’environnement Ziti
│   ├── web-app/                     # Contient l’application web Flask
│   │   ├── Dockerfile
│   │   └── app.py
│   ├── db/                          # Base de données PostgreSQL
│   │   └── init.sql
│   └── ziti-init.sh                 # Script Ziti : identités, services, policies
├── site-b/
│   ├── docker-compose.yml           # Compose pour le site B
│   ├── client.ovpn                  # Config OpenVPN pour Site B
│   └── ziti-identities/             # Identités site B
│       ├── userB1.json
│       └── userB2.json
└── shared/
    └── identities/                  # Identités Ziti exportées
        ├── userA1.json
        ├── userA2.json
        └── services.sh              # Script d'automatisation (optionnel)

```
##### 1- site-a/docker-compose.yml
```
version: '3.9'
services:
  ziti-controller:
    image: openziti/ziti-controller
    container_name: ziti-controller
    volumes:
      - ./ziti-controller.env:/etc/ziti-controller.env
    ports:
      - "1280:1280"
      - "6262:6262"
    command: ["run", "/etc/ziti-controller.env"]

  ziti-router:
    image: openziti/ziti-router
    container_name: ziti-router
    depends_on:
      - ziti-controller
    ports:
      - "3022:3022"
    environment:
      - ZITI_ROUTER_NAME=site-a-router
      - ZITI_CTRL_ADDRESS=ziti-controller:6262
    command: ["run", "--router", "edge"]

  web-server:
    build: ./web-app
    container_name: web-server
    ports:
      - "5000:5000"

  postgres:
    image: postgres:14
    container_name: db-server
    environment:
      POSTGRES_USER: zitiuser
      POSTGRES_PASSWORD: zitipass
      POSTGRES_DB: zitidb
    volumes:
      - ./db/init.sql:/docker-entrypoint-initdb.d/init.sql
    ports:
      - "5432:5432"
```
##### 2- site-a/ziti-controller.env
```
ZITI_CTRL_NAME=ziti-controller
ZITI_CTRL_LISTENER_BIND=0.0.0.0:6262
ZITI_CTRL_EDGE_ADVERTISED_ADDRESS=ziti-controller
ZITI_CTRL_EDGE_BIND=0.0.0.0:1280
ZITI_CTRL_EDGE_API_ADDRESS=https://ziti-controller:1280
ZITI_CTRL_EDGE_TLS_CERT=/openziti/pki/tls.crt
ZITI_CTRL_EDGE_TLS_KEY=/openziti/pki/tls.key
ZITI_CTRL_EDGE_TLS_CAS=/openziti/pki/ca.crt
```
##### 3- site-a/web-app/Dockerfile
```
FROM python:3.10-slim
WORKDIR /app
COPY app.py .
RUN pip install flask
CMD ["python", "app.py"]
```
##### 4- site-a/web-app/app.py
```
from flask import Flask
app = Flask(__name__)

@app.route("/")
def home():
    return "Bienvenue sur le serveur Web sécurisé avec OpenZiti!"

if __name__ == "__main__":
    app.run(host='0.0.0.0', port=5000)
```
##### 5- site-a/db/init.sql
```
CREATE TABLE users (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100)
);
INSERT INTO users (name) VALUES ('Alice'), ('Bob');
```
##### site-a/ziti-init.sh
```
#!/bin/bash
ziti edge create identity user userA1 -o /shared/identities/userA1.json
ziti edge create identity user userA2 -o /shared/identities/userA2.json
ziti edge create identity user userB1 -o /site-b/ziti-identities/userB1.json
ziti edge create identity user userB2 -o /site-b/ziti-identities/userB2.json

ziti edge create service web-server --intercept-host web-server --intercept-port 5000
ziti edge create service db-server --intercept-host db-server --intercept-port 5432

ziti edge create service-policy web-allow Bind web-server
ziti edge create service-policy db-allow Bind db-server

ziti edge create service-policy userA1-access Dial web-server userA1
ziti edge create service-policy userA2-access Dial db-server userA2
ziti edge create service-policy userB1-access Dial web-server userB1
ziti edge create service-policy userB2-access Dial db-server userB2
```
##### 6- site-b/docker-compose.yml
```
version: '3.9'
services:
  openvpn-client:
    image: dperson/openvpn-client
    container_name: openvpn-client
    cap_add:
      - NET_ADMIN
    devices:
      - /dev/net/tun
    volumes:
      - ./client.ovpn:/vpn/client.ovpn
    command: "-f '' -r '' -a '-cipher AES-256-CBC -auth SHA256'"

  ziti-router:
    image: openziti/ziti-router
    container_name: site-b-router
    depends_on:
      - openvpn-client
    network_mode: "service:openvpn-client"
    environment:
      - ZITI_ROUTER_NAME=site-b-router
      - ZITI_CTRL_ADDRESS=10.8.0.1:6262
    command: ["run", "--router", "edge"]

```
##### 7- site-b/client.ovpn
```
client
dev tun
proto udp
remote YOUR_SITE_A_PUBLIC_IP 1194
resolv-retry infinite
nobind
persist-key
persist-tun
cipher AES-256-CBC
auth SHA256
remote-cert-tls server
auth-user-pass
<ca>
# CA CERT
</ca>
<cert>
# CLIENT CERT
</cert>
<key>
# CLIENT KEY
</key>
```
##### 8- shared/identities/userA1.json
```
{ "identity": "userA1", "token": "<TOKEN_A1>" }
```
##### 9- shared/identities/userA2.json
```
{ "identity": "userA2", "token": "<TOKEN_A2>" }
```
##### 10- site-b/ziti-identities/userB1.json
```
{ "identity": "userB1", "token": "<TOKEN_B1>" }

```
##### 11- site-b/ziti-identities/userB2.json
```
{ "identity": "userB2", "token": "<TOKEN_B2>" }
```
##### 12- shared/identities/services.sh
```
#!/bin/bash
ziti edge create service web-server --intercept-host web-server --intercept-port 5000
ziti edge create service db-server --intercept-host db-server --intercept-port 5432
```
Tous les fichiers de configuration ont été générés et intégrés, notamment :

- **Ziti Controller et Router (Site A et B)**
    
- **Application Web Flask**
    
- **Base de données PostgreSQL**
    
- **Script d’initialisation des identités, services et policies Ziti**
    
- **OpenVPN sécurisé avec AES-256-CBC + SHA256**
    
- **Micro-segmentation complète basée sur l’identité**