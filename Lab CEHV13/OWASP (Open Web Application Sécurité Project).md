
Objectif : sensibilisation à la sécurité de système d'information




## OWASP Top 10 (2021)

- **A01: Broken Access Control**  
    👉 Contrôle d’accès défaillant  
    (Un utilisateur peut accéder à des ressources ou actions non autorisées)
    
- **A02: Cryptographic Failures**  
    👉 Défaillances cryptographiques  
    (Mauvais chiffrement, absence de chiffrement, mauvaise gestion des mots de passe, TLS mal configuré…)
    
- **A03: Injection**  
    👉 Injection (ex : SQL Injection, Command Injection, LDAP Injection…)  
    (Entrées utilisateur non filtrées exécutées par le système)
    
- **A04: Insecure Design**  
    👉 Conception non sécurisée  
    (Problèmes liés à l’architecture ou au design de sécurité)
    
- **A05: Security Misconfiguration**  
    👉 Mauvaise configuration de sécurité  
    (Services mal configurés, comptes par défaut, permissions excessives…)
    
- **A06: Vulnerable and Outdated Components**  
    👉 Composants vulnérables ou obsolètes  
    (Bibliothèques, frameworks non mis à jour)
    
- **A07: Identification and Authentication Failures**  
    👉 Défaillances d’identification et d’authentification  
    (Mauvaise gestion des sessions, mots de passe faibles…)
    
- **A08: Software and Data Integrity Failures**  
    👉 Défaillances d’intégrité logicielle et des données  
    (Mises à jour non vérifiées, CI/CD non sécurisé, dépendances non fiables)
    
- **A09: Security Logging and Monitoring Failures**  
    👉 Défaillances de journalisation et de surveillance  
    (Absence de logs ou monitoring insuffisant)
    
- **A10: Server-Side Request Forgery (SSRF)**  
    👉 Falsification de requêtes côté serveur  
    (Le serveur effectue une requête vers une ressource interne à cause d’une entrée utilisateur)


# Contre-mesures & Outils


## 🔴 A01 – Broken Access Control

### ✅ Contre-mesures

- Implémenter le principe du **moindre privilège**
    
- Contrôle d’accès basé sur les rôles (**RBAC**)
    
- Vérification côté serveur (jamais seulement côté client)
    
- Tests réguliers des permissions
    

### 🛠️ Outils d’attaque / test

- Burp Suite
    
- OWASP ZAP
    
- Postman (manipulation d’API)
    
- Kali Linux (manipulation de requêtes)
    

---

## 🔴 A02 – Cryptographic Failures

### ✅ Contre-mesures

- Utiliser HTTPS (TLS 1.2+)
    
- Hachage sécurisé : **bcrypt, Argon2**
    
- Ne jamais stocker les mots de passe en clair
    
- Désactiver les protocoles faibles (SSL, MD5, SHA1)
    

### 🛠️ Outils

- Wireshark
    
- SSLScan
    
- testssl.sh
    
- John the Ripper / Hashcat (audit de mots de passe)
    

---

## 🔴 A03 – Injection (SQL, Command, etc.)

### ✅ Contre-mesures

- Requêtes préparées (Prepared Statements)
    
- ORM sécurisé
    
- Validation des entrées
    
- Filtrage et échappement des caractères
    

### 🛠️ Outils

- SQLMap
    
- Burp Suite
    
- OWASP ZAP
    
- Havij
    

---

## 🔴 A04 – Insecure Design

### ✅ Contre-mesures

- Threat Modeling (modélisation des menaces)
    
- Secure SDLC
    
- Architecture Zero Trust
    
- Analyse de risques
    

### 🛠️ Outils

- Microsoft Threat Modeling Tool
    
- OWASP Threat Dragon
    

---

## 🔴 A05 – Security Misconfiguration

### ✅ Contre-mesures

- Désactiver services inutiles
    
- Supprimer comptes par défaut
    
- Configurer correctement serveurs (Nginx, Apache)
    
- Scanner régulièrement la configuration
    

### 🛠️ Outils

- Nmap
    
- Nikto
    
- OpenVAS
    
- Lynis
    

---

## 🔴 A06 – Vulnerable & Outdated Components

### ✅ Contre-mesures

- Mettre à jour régulièrement
    
- Scanner les dépendances
    
- Utiliser des versions LTS
    

### 🛠️ Outils

- OWASP Dependency Check
    
- Snyk
    
- Trivy (Docker)
    
- NPM audit
    

---

## 🔴 A07 – Authentication Failures

### ✅ Contre-mesures

- MFA (Multi-Factor Authentication)
    
- Politique de mot de passe forte
    
- Limitation des tentatives (anti-bruteforce)
    
- Gestion sécurisée des sessions
    

### 🛠️ Outils
- Hydra
- Burp Intruder
- Medusa
- credential stuffing
- session hijocking

---

## 🔴 A08 – Software & Data Integrity Failures

### ✅ Contre-mesures

- Vérification de signature numérique
    
- CI/CD sécurisé
    
- Protection contre les attaques Supply Chain
    

### 🛠️ Outils

- GitLeaks
    
- TruffleHog
    
- SonarQube
    

---

## 🔴 A09 – Logging & Monitoring Failures

### ✅ Contre-mesures

- Centralisation des logs (SIEM)
    
- Alertes en temps réel
    
- Conservation des journaux
    

### 🛠️ Outils

- Wazuh
    
- ELK Stack
    
- Splunk
    
- Graylog
    

---

## 🔴 A10 – SSRF

### ✅ Contre-mesures

- Validation stricte des URLs
    
- Bloquer les IP internes
    
- Firewall applicatif (WAF)
    
- Filtrage DNS
    

### 🛠️ Outils

- Burp Suite
    
- SSRFmap
    
- OWASP ZAP

Exploitation
Outils de Dev : 
- OWASP ZAP
- Web Goat, Juce shop