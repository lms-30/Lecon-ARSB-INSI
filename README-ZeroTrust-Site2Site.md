# 🛡️ Simulation Zero Trust Réseau Site-à-Site avec pfSense, FreeRADIUS, VLAN, OpenVPN (AES-256)

## 📘 Objectif

Simuler un réseau **Zero Trust** entre deux sites :
- **Site A** : pare-feu **pfSense**, segmentation en **VLAN**, serveur **FreeRADIUS (EMS)**, services internes
- **Site B** : pare-feu secondaire (ex : UFW/IPTables), accès restreint aux ressources de Site A
- Connexion chiffrée via **OpenVPN site-à-site** avec **AES-256**
- Authentification des utilisateurs via **FreeRADIUS** (EMS)
- Contrôle d’accès par VLAN et identité

---

## 🏗️ Architecture

```
     ┌────────────┐       🔐 Tunnel VPN AES-256       ┌────────────┐
     │  pfSense A │══════════════════════════════════▶│ Site B FW  │
     │ (Site A)   │                                  │ (iptables) │
     └─────┬──────┘                                  └─────┬──────┘
           │ VLANs                                           │ VLANs
           │                                                Users
     ┌─────▼──────┐                                 ┌────────▼───────┐
     │ FreeRADIUS │                                 │ Clients Linux   │
     │ (EMS)      │                                 └─────────────────┘
     └────────────┘
```

---

## 🔧 Étape 1 : Déploiement de FreeRADIUS (EMS)

Créer un répertoire : `freeradius/config` contenant :
- `users`
- `clients.conf`

### `docker-compose.yml`
```yaml
version: '3.8'
services:
  freeradius:
    image: freeradius/freeradius-server:latest
    container_name: freeradius
    ports:
      - "1812:1812/udp"
      - "1813:1813/udp"
    volumes:
      - ./config:/etc/raddb
    networks:
      vlan_ems:
        ipv4_address: 10.10.40.10

networks:
  vlan_ems:
    driver: bridge
    ipam:
      config:
        - subnet: 10.10.40.0/24
```

### `config/clients.conf`
```conf
client pfsense {
    ipaddr = 10.10.40.1
    secret = radiussecret
}
```

### `config/users`
```conf
employee1 Cleartext-Password := "password123"
```

Lancer :
```bash
docker-compose up -d
```

---

## 🔧 Étape 2 : Configuration pfSense (Site A)

### Interfaces réseau
- `LAN` : 10.10.10.1/24 (VLAN Serveurs)
- `OPT1` : 10.10.20.1/24 (VLAN Employés)
- `DMZ` : 10.10.30.1/24 (FreeRADIUS / EMS)

### Services à activer
- **FreeRADIUS Auth** : `System > User Manager > Authentication Servers`
- **OpenVPN Server** :
  - Type : Peer to Peer (Shared Key)
  - Interface : WAN
  - Crypto : AES-256-CBC, SHA256
  - Tunnel : 172.16.10.0/24
  - Advanced: `tls-auth`, `client-to-client`, `comp-lzo no`

### Exporter la clé :
```bash
cat /var/etc/openvpn/server1.secret
```

Copier cette clé dans Site B.

---

## 🔧 Étape 3 : Configuration Site B (Linux avec iptables ou UFW)

### Installer OpenVPN
```bash
sudo apt install openvpn
```

### `client.conf`
```conf
client
dev tun
proto udp
remote <IP_PFSENSE_SITE_A> 1194
ifconfig 172.16.10.2 172.16.10.1
secret static.key
cipher AES-256-CBC
auth SHA256
nobind
persist-key
persist-tun
```

Placer la clé dans `static.key`.

Lancer :
```bash
sudo openvpn --config client.conf
```

### Pare-feu UFW (ou iptables)
```bash
sudo ufw enable
sudo ufw allow from 172.16.10.0/24 to any port 80,443 proto tcp
```

---

## 🧩 Étape 4 : Attribution des accès (Zero Trust)

### Sur pfSense > Firewall > Rules

#### VLAN_EMPLOYE
Autoriser uniquement les IP validées par FreeRADIUS :
```pf
Source: 10.10.20.11 (employee1)
Destination: VLAN_SERVEUR (ex: 10.10.10.10)
Ports: HTTP/HTTPS
```
Bloquer le reste.

#### VLAN_DMZ (FreeRADIUS)
Autoriser seulement les communications vers pfSense (UDP 1812/1813)

---

## 🧪 Étape 5 : Tests et surveillance

- Tester l'accès de employee1 (authentifié) → serveur
- Tester l'accès VPN depuis Site B
- Ajouter Suricata ou Snort sur pfSense pour analyse

---

## 🧠 Conclusion

Cette simulation fournit une base Zero Trust complète :
- Contrôle d'accès par **identité (FreeRADIUS)**
- Isolation par **VLAN**
- Tunnel sécurisé **OpenVPN (AES-256)**
- Application d’ACL strictes dans **pfSense** et **pare-feu Linux**

➡️ Cette architecture est extensible avec : SIEM, NAC, Agents ZTNA, Reverse Proxy, etc.