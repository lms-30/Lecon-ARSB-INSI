Je vais vous expliquer comment implémenter cette solution avec une approche Zero Trust Network Access (ZTNA) en utilisant deux machines virtuelles dans VirtualBox.

## Architecture proposée

**VM1 - pfSense** (Firewall + Contrôleur d'accès):

- Interface WAN: NAT (accès internet)
    
- Interface LAN: Réseau interne (192.168.1.0/24)
    
- Interface OPT1: Réseau des serveurs (192.168.2.0/24)
    

**VM2 - Serveurs** (FreeRADIUS + Nginx + PostgreSQL):

- Interface LAN: Connectée au réseau des serveurs (192.168.2.0/24)
    

## Partie 1: Configuration VirtualBox

### 1. Création des réseaux dans VirtualBox

1. Allez dans **Fichier > Préférences > Réseau**
    
2. Créez deux réseaux NAT:
    
    - **NatNetwork1**: 192.168.1.0/24
        
    - **NatNetwork2**: 192.168.2.0/24
        

### 2. Configuration des VMs

**VM pfSense**:

- 2 interfaces réseau:
    
    - Interface 1: Accès par NAT pour WAN
        
    - Interface 2: Connectée à "NatNetwork1" (LAN)
        
    - Interface 3: Connectée à "NatNetwork2" (OPT1 - Serveurs)
        

**VM Serveurs**:

- 1 interface réseau:
    
    - Connectée à "NatNetwork2" (192.168.2.0/24)
        

## Partie 2: Installation et configuration de pfSense

### 1. Installation de base

1. Téléchargez l'image ISO pfSense
    
2. Installez pfSense sur la VM avec la configuration réseau:
    
    - WAN: DHCP ou IP statique
        
    - LAN: 192.168.1.1/24
        
    - OPT1: 192.168.2.1/24
        

### 2. Configuration ZTNA dans pfSense

1. **Activer le serveur RADIUS**:
    
    - Allez dans **System > User Manager > Authentication Servers**
        
    - Ajoutez FreeRADIUS:
        
        - IP: 192.168.2.10
            
        - Secret partagé: votre_secret_radius
            
        - Port: 1812
            
2. **Créer des règles de pare-feu Zero Trust**:
    
    - Allez dans **Firewall > Rules**
        
    - Pour chaque interface (LAN et OPT1):
        
        - Bloquer tout le trafic par défaut
            
        - Ajouter des règles spécifiques basées sur l'authentification
            
3. **Configurer Captive Portal**:
    
    - **Services > Captive Portal**
        
    - Activer pour l'interface LAN
        
    - Méthode: RADIUS
        
    - Forcer la ré-authentification régulièrement
        

## Partie 3: Configuration de la VM Serveurs

### 1. Installation de Docker et Docker Compose
```
sudo apt update && sudo apt install -y docker.io docker-compose
```
Et ensuite, nous allons activer docker
```
sudo systemctl enable --now docker
```
### 2. Fichier docker-compose.yml
```
version: '3.8'

networks:
  server-net:
    driver: bridge
    ipam:
      config:
        - subnet: 172.20.0.0/24

services:
  freeradius:
    image: freeradius/freeradius-server
    container_name: freeradius
    networks:
      server-net:
        ipv4_address: 172.20.0.10
    ports:
      - "1812-1813:1812-1813/udp"
    volumes:
      - ./freeradius/config:/etc/freeradius/3.0
    environment:
      RADIUS_CLIENTS: "192.168.2.1=pfSense_secret"
    restart: unless-stopped

  nginx:
    image: nginx:alpine
    container_name: nginx
    networks:
      server-net:
        ipv4_address: 172.20.0.20
    ports:
      - "80:80"
    volumes:
      - ./nginx/html:/usr/share/nginx/html
    restart: unless-stopped

  postgres:
    image: postgres:13
    container_name: postgres
    networks:
      server-net:
        ipv4_address: 172.20.0.30
    environment:
      POSTGRES_PASSWORD: secure_db_password
    volumes:
      - ./postgres/data:/var/lib/postgresql/data
    restart: unless-stopped
```
### 3. Configuration FreeRADIUS pour ZTNA
1. Éditez `/etc/freeradius/3.0/clients.conf`:
```
client pfsense {
    ipaddr = 192.168.2.1
    secret = pfSense_secret
}
```
2. Configurez la politique ZTNA dans `policy.conf`:
```
policy {
    default_authorize = accept
    default_authenticate = reject
    
    # Vérifier l'accès aux ressources
    if (Service-Type == "Login-User") {
        update control {
            Auth-Type := Accept
        }
        module = resource_check
    }
}
```
## Partie 4: Liaison des serveurs à pfSense

### 1. Configuration réseau de la VM Serveurs

- Adresse IP: 192.168.2.10
    
- Passerelle: 192.168.2.1 (pfSense)
    
- DNS: 8.8.8.8
    

### 2. Redirection des ports dans pfSense

1. Allez dans **Firewall > NAT > Port Forward**
    
2. Ajoutez des règles pour:
    
    - Rediriger le port 80 vers 172.20.0.20 (Nginx)
        
    - Rediriger le port 5432 vers 172.20.0.30 (PostgreSQL)
        

### 3. Politiques d'accès ZTNA

1. Créez des alias pour les serveurs:
    
    - **Firewall > Aliases**
        
    - Ajoutez "Web_Server" = 172.20.0.20
        
    - Ajoutez "DB_Server" = 172.20.0.30
        
2. Créez des règles de pare-feu:
    
    - **Firewall > Rules > LAN**
        
    - Ajoutez une règle avec:
        
        - Source: LAN subnet
            
        - Destination: Web_Server
            
        - Utilisateur/Groupe: Groupes RADIUS
            
        - Action: Pass (avec authentification)
            

## Partie 5: Validation et tests

### 1. Tester l'authentification RADIUS
```
docker exec freeradius radtest user password localhost 0 testing123
```
### 2. Vérifier l'accès aux ressources

1. Depuis un client sur le réseau LAN (192.168.1.0/24):
    
    - Essayez d'accéder à [http://192.168.1.1](http://192.168.1.1/) (portail captif pfSense)
        
    - Authentifiez-vous avec des identifiants RADIUS
        
    - Testez l'accès aux ressources selon vos droits
        

### 3. Surveillance

- Consultez les logs RADIUS:
    
    bash
    
    docker logs freeradius
    
- Vérifiez les connexions dans pfSense:
    
    - **Status > System Logs > Firewall**
        

## Approche Zero Trust mise en œuvre

1. **Authentification forte**:
    
    - Tous les utilisateurs doivent s'authentifier via RADIUS
        
    - Pas d'accès par défaut
        
2. **Micro-segmentation**:
    
    - Séparation nette entre réseau client et serveurs
        
    - Contrôle d'accès granulaire par ressource
        
3. **Contrôle continu**:
    
    - Ré-authentification régulière via Captive Portal
        
    - Surveillance des sessions
        
4. **Politique de moindre privilège**:
    
    - Accès uniquement aux ressources nécessaires
        
    - Droits spécifiques par utilisateur
        

Cette architecture fournit une solution complète ZTNA avec VirtualBox, pfSense et Docker, offrant un contrôle d'accès sécurisé à vos ressources tout en maintenant une séparation stricte des réseaux.