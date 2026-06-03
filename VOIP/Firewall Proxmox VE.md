## 🔍 Définition

Le **Firewall Proxmox VE** est un pare-feu **intégré nativement** dans Proxmox Virtual Environment. Il permet de **filtrer et contrôler le trafic réseau** à plusieurs niveaux de l'infrastructure de virtualisation, sans avoir besoin d'un outil externe.

> 💡 C'est un firewall **basé sur iptables/nftables**, géré directement depuis l'interface web de Proxmox.

---

## 🏗️ Architecture du Firewall Proxmox — 3 Niveaux

Le firewall Proxmox fonctionne sur **3 niveaux distincts** :
```
┌─────────────────────────────────────────────┐
│            NIVEAU 1 : DATACENTER            │
│     Règles globales pour tous les nœuds     │
├─────────────────────────────────────────────┤
│             NIVEAU 2 : NŒUD (Node)          │
│    Règles spécifiques à un serveur physique │
├─────────────────────────────────────────────┤
│          NIVEAU 3 : VM / CT (Container)     │
│   Règles spécifiques à chaque VM ou LXC     │
└─────────────────────────────────────────────┘
```

| Niveau     | Portée                                  | Fichier de config            |
| ---------- | --------------------------------------- | ---------------------------- |
| Datacenter | S'applique à **toute** l'infrastructure | /etc/pve/firewall/cluster.fw |
| Node       | S'applique à **un nœud physique**       | /etc/pve/nodes/<nom>/host.fw |
| VM / CT    | S'applique à **une VM ou un conteneur** | /etc/pve/firewall/<VMID>.fw  |


> 💡 Les règles s'appliquent **du plus général au plus spécifique**. Une règle Datacenter s'applique partout, une règle VM ne s'applique qu'à cette VM.

---

## ⚙️ Activation du Firewall

Par défaut, le firewall est **désactivé**. Il faut l'activer à chaque niveau.

### Activer au niveau Datacenter
```
Datacenter → Firewall → Options → Firewall : ON
```
### Activer au niveau Node
```
Node → Firewall → Options → Firewall : ON
```
### Activer au niveau VM/CT
```
VM → Firewall → Options → Firewall : ON
```

> ⚠️ Si le firewall est activé au niveau Datacenter mais **pas** au niveau VM, la VM n'est **pas protégée**. Chaque niveau doit être activé indépendamment.

---

## 📋 Structure d'une Règle Firewall

Chaque règle est composée des éléments suivants :

| Champ           | Description                      | Exemple                          |
| --------------- | -------------------------------- | -------------------------------- |
| **Direction**   | Sens du trafic                   | `IN` (entrant) / `OUT` (sortant) |
| **Action**      | Ce qu'on fait du paquet          | `ACCEPT` / `DROP` / `REJECT`     |
| **Protocole**   | Protocole réseau                 | `TCP`, `UDP`, `ICMP`             |
| **Source**      | Adresse IP ou groupe source      | `192.168.1.0/24`                 |
| **Destination** | Adresse IP ou groupe destination | `10.0.0.5`                       |
| **Port**        | Port(s) concerné(s)              | `22`, `80`, `443`, `5060`        |
| **Commentaire** | Description de la règle          | `"Autoriser SSH admin"`          |
| **Activée**     | La règle est-elle active ?       | ✅ / ❌                            |

## 📁 Les Security Groups (Groupes de Sécurité)

Les **Security Groups** permettent de **regrouper des règles** et de les **réutiliser** sur plusieurs VMs.

> 💡 Au lieu de recréer les mêmes règles sur 10 VMs, on crée un groupe et on l'applique partout.

### Créer un Security Group
```
Datacenter → Firewall → Security Groups → Add
```
### Exemple — Groupe "web-servers"
```
IN  ACCEPT  TCP  any  any  80   # HTTP
IN  ACCEPT  TCP  any  any  443  # HTTPS
IN  DROP    any  any  any  any  # Tout bloquer par défaut
```
### Appliquer le groupe à une VM
```
# Dans le fichier /etc/pve/firewall/100.fw
[RULES]
GROUP web-servers
```

---

## 🏷️ Les IPSet (Groupes d'adresses IP)

Un **IPSet** est une **liste nommée d'adresses IP** qu'on peut utiliser dans les règles.

> 💡 Au lieu de répéter `192.168.1.10`, `192.168.1.11`, `192.168.1.12` dans chaque règle, on crée un IPSet `admins` et on l'utilise directement.

### Créer un IPSet
```
Datacenter → Firewall → IPSet → Create
Nom : admins
Ajouter : 192.168.1.10, 192.168.1.11, 192.168.1.12
```

### Utiliser l'IPSet dans une règle
```
IN  ACCEPT  TCP  +admins  any  22  # Autoriser SSH depuis les admins
```

> `+admins` = référence à l'IPSet nommé `admins`

---

## 🔌 Firewall au niveau de l'Interface Réseau (vNIC)

On peut appliquer le firewall **directement sur l'interface réseau** d'une VM.
```
VM → Hardware → Network Device → Firewall : ✅ coché
```

> ⚠️ Si l'option **Firewall** n'est pas cochée sur l'interface réseau de la VM, les règles ne s'appliquent **pas** même si elles sont définies. C'est un point souvent oublié !

---

## 📜 Politique par défaut (Default Policy)

Quand aucune règle ne correspond à un paquet, la **politique par défaut** s'applique.

| Direction | Politique | Effet |
|---|---|---|
| `IN` | `ACCEPT` | Tout trafic entrant autorisé |
| `IN` | `DROP` | Tout trafic entrant bloqué silencieusement |
| `IN` | `REJECT` | Tout trafic entrant bloqué avec notification |
| `OUT` | `ACCEPT` | Tout trafic sortant autorisé (recommandé) |
```
Datacenter → Firewall → Options
→ Input Policy  : DROP   (recommandé)
→ Output Policy : ACCEPT (recommandé)
```

> 💡 Bonne pratique : **DROP par défaut en entrée**, puis on ajoute uniquement les règles ACCEPT nécessaires. C'est le principe du **moindre privilège**.

---

## 🛡️ Options avancées du Firewall

### Protection NDP / ARP
```
Datacenter → Firewall → Options
→ NDP : ON     # Protection NDP (IPv6)
→ SMURFS : ON  # Filtre les attaques SMURF
→ tcp_flags : ON  # Validation des flags TCP
```

| Option | Description |
|---|---|
| **NDP** | Protège contre les attaques NDP (IPv6) |
| **SMURFS** | Bloque les paquets ICMP de broadcast (attaque Smurf) |
| **tcp_flags** | Vérifie la validité des flags TCP (bloque SYN/FIN invalides) |
| **log_level** | Niveau de journalisation (`nolog`, `alert`, `debug`...) |
| **ebtables** | Active le filtrage au niveau Ethernet (couche 2) |

---

## 📝 Macros prédéfinies

Proxmox propose des **macros** (raccourcis) pour les services courants — plus besoin de se souvenir des numéros de ports.

| Macro | Équivalent |
|---|---|
| `SSH` | TCP port 22 |
| `HTTP` | TCP port 80 |
| `HTTPS` | TCP port 443 |
| `DNS` | UDP/TCP port 53 |
| `SMTP` | TCP port 25 |
| `IMAP` | TCP port 143 |
| `Ping` | ICMP echo-request |
| `RDP` | TCP port 3389 |
| `VNC` | TCP port 5900 |
| `SIP` | UDP port 5060 |
| `MySQL` | TCP port 3306 |
| `PostgreSQL` | TCP port 5432 |

### Exemple d'utilisation d'une macro
```
IN  ACCEPT  Macro:SSH   +admins  any   # Autoriser SSH depuis admins
IN  ACCEPT  Macro:HTTPS  any     any   # Autoriser HTTPS depuis partout
IN  DROP    any          any     any   # Bloquer tout le reste
```


---

## 📂 Fichiers de configuration

Proxmox stocke les règles en fichiers texte lisibles et modifiables manuellement.

### Structure du fichier `.fw`
```
[OPTIONS]
enable: 1              # Firewall activé
policy_in: DROP        # Politique entrante
policy_out: ACCEPT     # Politique sortante
log_level_in: info     # Niveau de log entrant

[RULES]
# Direction Action Protocole Source Destination Port Commentaire
IN ACCEPT TCP +admins 0.0.0.0/0 22     # SSH admins
IN ACCEPT TCP 0.0.0.0/0 0.0.0.0/0 80   # HTTP public
IN ACCEPT TCP 0.0.0.0/0 0.0.0.0/0 443  # HTTPS public
IN ACCEPT ICMP 0.0.0.0/0 0.0.0.0/0     # Ping

[IPSET admins]
192.168.1.10
192.168.1.11
192.168.1.20/28        # Sous-réseau admins

[group web-servers]
IN ACCEPT TCP 0.0.0.0/0 0.0.0.0/0 80
IN ACCEPT TCP 0.0.0.0/0 0.0.0.0/0 443
```
---

## 🔥 Exemples pratiques

### Exemple 1 — Sécuriser un serveur Web (VM 100)
```
[OPTIONS]
enable: 1
policy_in: DROP
policy_out: ACCEPT

[RULES]
IN ACCEPT Macro:HTTPS  any  any      # HTTPS public
IN ACCEPT Macro:HTTP   any  any      # HTTP public
IN ACCEPT Macro:SSH    +admins  any  # SSH admins uniquement
IN ACCEPT Macro:Ping   any  any      # Autoriser les pings
```
---

## 🔍 Journalisation (Logs)

Les logs du firewall Proxmox sont consultables dans :
```
# Logs en temps réel
journalctl -f | grep -i firewall

# Logs Proxmox
tail -f /var/log/pve-firewall.log

# Depuis l'interface web
Node → Firewall → Log
```

| Niveau de log | Description                     |
| ------------- | ------------------------------- |
| nolog         | Aucun log                       |
| alert         | Alertes critiques seulement     |
| critical      | Événements critiques            |
| error         | Erreurs uniquement              |
| warning       | Avertissements                  |
| notice        | Événements notables             |
| info          | Informations générales          |
| debug         | Tout enregistrer (très verbeux) |


---

## ✅ Bonnes pratiques

|Bonne pratique|Pourquoi|
|---|---|
|**Activer le firewall à tous les niveaux**|Un niveau non activé = faille de sécurité|
|**Cocher Firewall sur chaque vNIC**|Sans ça, les règles ne s'appliquent pas|
|**Politique par défaut DROP en entrée**|Principe du moindre privilège|
|**Utiliser les IPSet pour les admins**|Centralise la gestion des IPs autorisées|
|**Utiliser les Security Groups**|Évite la duplication des règles|
|**Logger les paquets DROP**|Permet de détecter les tentatives d'intrusion|
|**Ne jamais bloquer le port 8006**|C'est l'interface web de Proxmox — risque de lockout|
|**Tester avant d'appliquer en production**|Une mauvaise règle peut couper tous les accès|

> ⚠️ **Attention au lockout** : si vous bloquez le port **22 (SSH)** ou **8006 (Web UI)** sans avoir d'accès console physique, vous perdez le contrôle du serveur !