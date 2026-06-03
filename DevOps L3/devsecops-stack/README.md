# 🔐 DevSecOps Stack — Jenkins + SonarQube + HashiCorp Vault

Architecture CI/CD complète avec gestion des secrets et analyse de sécurité du code, entièrement sous Docker.

---

## 📁 Structure du Projet

```
devsecops/
├── start-all.sh                    # 🚀 Script de démarrage global
│
├── network/
│   └── docker-compose.yml          # 🌐 Réseau Docker partagé
│
├── jenkins/
│   ├── docker-compose.yml          # 🤖 Jenkins CI/CD
│   ├── Dockerfile                  # Image personnalisée avec plugins
│   ├── plugins.txt                 # Liste des plugins Jenkins
│   ├── .env.example                # Variables d'environnement (template)
│   ├── Jenkinsfile.example         # Pipeline DevSecOps complet
│   └── casc/
│       └── jenkins.yaml            # Configuration as Code (JCasC)
│
├── sonarqube/
│   ├── docker-compose.yml          # 🔍 SonarQube + PostgreSQL
│   ├── .env.example                # Variables d'environnement (template)
│   └── config/
│       ├── sonar.properties        # Configuration SonarQube
│       └── init-db.sql             # Initialisation PostgreSQL
│
└── vault/
    ├── docker-compose.yml          # 🔑 HashiCorp Vault
    ├── .env.example                # Variables d'environnement (template)
    ├── config/
    │   └── vault.hcl               # Configuration Vault
    ├── policies/
    │   └── jenkins-policy.hcl      # Politique de sécurité Jenkins
    └── scripts/
        └── init-vault.sh           # Script d'initialisation Vault
```

---

## 🌐 Architecture Réseau

```
┌─────────────────────────────────────────────────────────┐
│              Réseau Docker: devsecops-network            │
│                    (172.20.0.0/16)                       │
│                                                          │
│  ┌──────────────┐    ┌──────────────┐    ┌───────────┐  │
│  │   Jenkins    │───▶│  SonarQube   │    │   Vault   │  │
│  │  :8080/:50000│    │    :9000     │    │   :8200   │  │
│  └──────┬───────┘    └──────┬───────┘    └─────┬─────┘  │
│         │                  │                   │        │
│         │ AppRole          │ Webhook           │        │
│         │◀─────────────────┼───────────────────┘        │
│         │                  │                            │
│         │            ┌─────▼──────┐                     │
│         │            │ PostgreSQL │                     │
│         │            │ (SQ DB)   │                     │
│         │            └────────────┘                     │
└─────────────────────────────────────────────────────────┘

HOST: localhost
  → Jenkins    : http://localhost:8080
  → SonarQube  : http://localhost:9000
  → Vault UI   : http://localhost:8200
```

---

## 🚀 Installation & Démarrage

### Prérequis

- Docker Engine ≥ 24.0
- Docker Compose ≥ 2.0
- 8 Go RAM minimum (recommandé: 16 Go)
- 20 Go d'espace disque

### Étape 1 — Cloner et configurer

```bash
git clone <votre-repo> devsecops
cd devsecops

# Copier les fichiers .env pour chaque service
cp jenkins/.env.example   jenkins/.env
cp sonarqube/.env.example sonarqube/.env
cp vault/.env.example     vault/.env
```

### Étape 2 — Prérequis système (Linux obligatoire)

```bash
# Requis par Elasticsearch (utilisé par SonarQube)
sudo sysctl -w vm.max_map_count=262144
sudo sysctl -w fs.file-max=65536

# Rendre permanent
echo "vm.max_map_count=262144" | sudo tee -a /etc/sysctl.conf
echo "fs.file-max=65536"       | sudo tee -a /etc/sysctl.conf
```

### Étape 3 — Démarrer la stack

```bash
chmod +x start-all.sh
./start-all.sh

# Avec rebuild des images:
./start-all.sh --build
```

Ou service par service:

```bash
# 1. Réseau partagé (TOUJOURS EN PREMIER)
cd network && docker compose up -d && cd ..

# 2. Vault
cd vault && docker compose up -d && cd ..

# 3. SonarQube
cd sonarqube && docker compose up -d && cd ..

# 4. Jenkins (en dernier car dépend des autres)
cd jenkins && docker compose up -d && cd ..
```

---

## 🔑 Initialisation de HashiCorp Vault

> ⚠️ Cette étape est obligatoire au premier démarrage.

```bash
cd vault/scripts
chmod +x init-vault.sh
./init-vault.sh
```

Le script va :
1. **Initialiser** Vault (génère 5 clés de déchiffrement, seuil: 3)
2. **Unseal** Vault automatiquement
3. Activer les **moteurs KV v2** (`secret/` et `infra/`)
4. Créer les **politiques** Jenkins (lecture seule)
5. Configurer **AppRole** pour Jenkins
6. Activer l'**audit logging**

> 📁 Les credentials générés sont dans `vault/scripts/vault-init.json`  
> **GARDEZ CE FICHIER EN SÉCURITÉ — ne le commitez JAMAIS !**

Après l'init, copiez les credentials dans `jenkins/.env` :
```bash
# Depuis la sortie du script init-vault.sh
VAULT_ROLE_ID=<role-id-généré>
VAULT_SECRET_ID=<secret-id-généré>
```

Puis redémarrez Jenkins :
```bash
cd jenkins && docker compose restart
```

---

## 🔍 Configuration de SonarQube

### 1. Accéder à SonarQube

```
URL: http://localhost:9000
Login: admin
Mot de passe: admin  (changer dès le premier login !)
```

### 2. Générer un token Jenkins

1. `Mon Compte` → `Sécurité` → `Générer un token`
2. Nom : `jenkins-token`, Type : `Global Analysis Token`
3. Copier le token généré

### 3. Stocker le token dans Vault

```bash
# Via CLI Vault
export VAULT_ADDR=http://localhost:8200
export VAULT_TOKEN=<root-token>

vault kv put secret/jenkins/sonarqube \
  token="<votre-sonar-token>" \
  url="http://sonarqube:9000"
```

### 4. Configurer le Quality Gate

Dans SonarQube : `Administration` → `Quality Gates`  
Configurez vos seuils (coverage, bugs, vulnérabilités, code smells).

---

## 🤖 Configuration de Jenkins

### Accès

```
URL: http://localhost:8080
Login: admin
Mot de passe: voir jenkins/.env → JENKINS_ADMIN_PASSWORD
```

### Vérifier l'intégration

1. **SonarQube**: `Administrer` → `Configurer le système` → `SonarQube servers`
2. **Vault**: `Administrer` → `Configurer le système` → `HashiCorp Vault`
3. **Credentials**: `Credentials` → `System` → `Global credentials`

### Créer un Pipeline

1. `Nouveau Item` → `Pipeline`
2. `Pipeline script from SCM` → pointer votre dépôt avec le `Jenkinsfile.example`

---

## 📊 Volumes Docker

| Volume | Service | Contenu |
|--------|---------|---------|
| `jenkins_home` | Jenkins | Jobs, configs, workspace |
| `jenkins_maven_cache` | Jenkins | Cache Maven |
| `sonarqube_data` | SonarQube | Données d'analyse |
| `sonarqube_logs` | SonarQube | Logs applicatifs |
| `sonarqube_extensions` | SonarQube | Plugins additionnels |
| `sonarqube_db_data` | PostgreSQL | Base de données SQ |
| `vault_data` | Vault | Secrets chiffrés |
| `vault_audit` | Vault | Logs d'audit |

Lister les volumes :
```bash
docker volume ls --filter "label=com.devsecops.volume"
```

---

## 🛑 Commandes Utiles

```bash
# État de la stack
./start-all.sh --status

# Arrêter tout
./start-all.sh --stop

# Logs d'un service
docker compose -f jenkins/docker-compose.yml logs -f
docker compose -f sonarqube/docker-compose.yml logs -f sonarqube
docker compose -f vault/docker-compose.yml logs -f vault

# Redémarrer un service
docker compose -f jenkins/docker-compose.yml restart

# Entrer dans un conteneur
docker exec -it jenkins bash
docker exec -it vault vault status

# Unseal Vault après un redémarrage
docker exec -it vault vault operator unseal <unseal-key-1>
docker exec -it vault vault operator unseal <unseal-key-2>
docker exec -it vault vault operator unseal <unseal-key-3>

# Backup des volumes
docker run --rm \
  -v jenkins_home:/data \
  -v $(pwd):/backup \
  alpine tar czf /backup/jenkins-backup.tar.gz /data
```

---

## 🔒 Sécurité en Production

- [ ] Changer **tous les mots de passe** par défaut dans les `.env`
- [ ] Activer **TLS** dans `vault/config/vault.hcl`
- [ ] Utiliser **Consul ou Raft** comme backend Vault (au lieu de `file`)
- [ ] Configurer un **reverse proxy** (Nginx/Traefik) avec HTTPS
- [ ] Activer l'**authentification LDAP/SAML** dans Jenkins et SonarQube
- [ ] Mettre en place la **rotation automatique** des secrets Vault
- [ ] Configurer des **alertes** sur les Quality Gates SonarQube
- [ ] Sauvegarder régulièrement les **volumes Docker**
- [ ] Restreindre l'accès réseau avec des **règles firewall**
- [ ] Ne **jamais exposer** les ports directement en production

---

## 🐛 Dépannage

### SonarQube ne démarre pas
```bash
# Vérifier vm.max_map_count
cat /proc/sys/vm/max_map_count
# Doit être ≥ 262144
sudo sysctl -w vm.max_map_count=262144
```

### Vault en mode Sealed
```bash
# Après chaque redémarrage, Vault doit être déchiffré
docker exec -it vault vault status
docker exec -it vault vault operator unseal <key>
```

### Jenkins ne se connecte pas à SonarQube
```bash
# Vérifier la connectivité réseau
docker exec -it jenkins curl http://sonarqube:9000/api/system/status
```

### Jenkins ne lit pas les secrets Vault
```bash
# Vérifier le statut Vault
docker exec -it vault vault status
# Vérifier l'AppRole
docker exec -it vault vault auth list
```
