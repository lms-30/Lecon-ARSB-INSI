# **1. Qu’est-ce que ELK Stack ?**

**ELK Stack** est un ensemble de trois outils open source utilisés pour **collecter, analyser, stocker et visualiser des logs** et données en temps réel :

| Acronyme | Outil         | Rôle                                         |
| -------- | ------------- | -------------------------------------------- |
| E        | Elasticsearch | Stockage et recherche rapide                 |
| L        | Logstash      | Collecte, transformation, ingestion des logs |
| K        | Kibana        | Visualisation, tableaux de bord, monitoring  |
Il existe aussi une version étendue appelée **Elastic Stack (ELK + Beats)**.

# **2. Objectif principal de ELK Stack**

ELK sert à :
### ✔ Centraliser les logs provenant :
- de serveurs Linux/Windows,
- d’applications web,
- de firewalls, IDS/IPS (Snort, Suricata),
- de conteneurs Docker,
- de services cloud.
### ✔ Analyser et rechercher les logs rapidement
Grâce à Elasticsearch, les recherches sont instantanées même sur des millions de lignes.
### ✔ Visualiser et monitorer en temps réel
Avec Kibana (graphes, alertes, dashboards).
### ✔ Détecter les anomalies et incidents
Très utilisé en **cybersécurité**, **SIEM**, **observabilité**.
### ✔ Aider au diagnostic en cas de panne
Suivre les erreurs, performances, comportements du réseau et des applications.

# **3. Fonctionnement global**
ELK fonctionne en 4 étapes :
## **1️⃣ Collecte (Beats / Logstash)**
- **Beats** : petits agents installés sur les machines (Filebeat, Metricbeat, Packetbeat…)
- **Logstash** : récupère les logs, les normalise, les transforme.
## **2️⃣ Transformation (Logstash pipelines)**
Logstash applique :
- filtres,
- parsing (grok),
- enrichissement (GeoIP, DNS…),
- suppression de champs inutiles.
## **3️⃣ Indexation et stockage (Elasticsearch)**
Les données sont stockées en **index**, réparties sur un cluster.
## **4️⃣ Visualisation (Kibana)**
Kibana permet :
- Dashboard interactifs,
- Cartes de chaleur,
- Courbes, métriques, statistiques,
- SIEM (Security Information & Event Management),
- Alerting (mail, webhook, Slack…).

# **4. Caractéristiques principales**

### ✔ **Recherche puissante (full-text search)**
Grâce au moteur Lucene.
### ✔ **Scalabilité horizontale**
Ajout de nœuds Elasticsearch pour gérer plus de données.
### ✔ **Visualisation avancée**
Graphes, cartes, métriques, timeline, alertes.
### ✔ **Ingestion flexible**
Logstash accepte :
- fichiers log,
- syslog,
- JSON,
- Kafka,
- cloud providers…
### ✔ **Support en temps réel**
Analyse de flux continus.
### ✔ **Sécurité (API Keys, TLS, utilisateurs, rôles)**
Elastic Stack offre une sécurité robuste.

# **5. Bagages nécessaires pour installer et configurer ELK**

## 📌 **A. Compétences techniques**
Pour installer ELK, il faut connaître :
### Système :
- Linux (Debian/Ubuntu/CentOS)
- gestion des services (systemctl)
- permissions (chown, chmod)
### Réseau :
- Ports TCP (5601, 9200, 5044…)
- TLS/SSL
- reverse-proxy (optionnel)
### Elasticsearch :
- clusters, index, shards, heap memory
### Logstash :
- syntaxe des pipelines
- filtres grok
- ingestion multi-input
### Kibana :
- création de dashboards
- sécurité Elastic
### Autres :
- Docker (optionnel mais recommandé)
# **B. Configuration matérielle recommandée**
Pour un petit environnement :

|Composant|Recommandation|
|---|---|
|CPU|4 vCPU|
|RAM|8–16 Go|
|Stockage|50–200 Go SSD|
|OS|Ubuntu/Debian|

Pour un cluster production :  
➡ 3 nœuds Elasticsearch minimum (haute disponibilité).
#  **C. Prérequis logiciels**
- Java (pour Logstash)
- apt / yum
- Docker si installation containerisée
- OpenSSL pour certificats TLS
- Firewall configuré

# **6. Domaines d’utilisation de ELK Stack**

ELK est utilisé dans plusieurs domaines :
## 🔐 **1. Cybersécurité (SIEM léger)**
ELK est utilisé comme alternative open source à Splunk / QRadar :
- Surveillance du réseau
- Analyse de logs d’IDS/IPS (Snort, Suricata, Zeek)
- Recherche d’intrusions
- Détection d'anomalies
- Analyse forensic après attaque
## **2. Administration systèmes et réseaux**
ELK permet de suivre :
- CPU, RAM, disque (Metricbeat)
- logs systemd, journald
- erreurs d'applications
- accès SSH
- panne de machines
##  **3. Développement / DevOps**
- monitoring applicatif (APM)
- logs Docker / Kubernetes
- traçage des requêtes
## **4. Business Intelligence**
- Analyse des ventes
- Analyse des utilisateurs
- Tableaux de bord métier interactifs
##  **5. Observabilité**
Avec Beats + Kibana :
- logs,
- métriques,
- traces,
- uptime monitoring.
#  **7. Résumé simple**

|Élément|Explication|
|---|---|
|**Objectif**|Centraliser, analyser, visualiser les logs|
|**Fonctionnement**|Collecte → Ingestion → Indexation → Visualisation|
|**Caractéristiques**|rapide, scalable, puissant, visuel|
|**Bagages nécessaires**|Linux, réseau, JSON, pipelines Logstash|
|**Domaines**|sécurité, IT, DevOps, observabilité|