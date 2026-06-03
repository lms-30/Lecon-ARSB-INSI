## 📡 I. C’est quoi SNMP ?

### 🔹 Définition

**SNMP (Simple Network Management Protocol)** est un protocole utilisé pour :

- 📊 **Surveiller** les équipements réseau
- ⚙️ **Configurer** certains paramètres
- 🚨 **Recevoir des alertes** en cas de problème

👉 Exemple :  
Surveiller un switch, un routeur ou un serveur (CPU, mémoire, trafic…)

---

### 🕰️ Historique

- Créé en **1988**
- Basé sur des standards :
    - RFC 1065
    - RFC 1066
    - RFC 1067
- Première version : **SNMPv1**

---

### 🔧 Commandes pour vérifier SNMP

- **Linux :**

sudo systemctl status snmp

- **PowerShell (Windows) :**

Get-WindowsFeature SNMP

---

## 🧩 Types d’équipements SNMP

### 1️⃣ Équipements managés (Managed Devices)

👉 Ce sont les équipements **surveillés par SNMP**

- Routeurs
- Switchs
- Serveurs
- Imprimantes réseau

✔ Ils contiennent un **SNMP Agent**

---

### 2️⃣ NMS (Network Management System)

👉 C’est le système qui **contrôle et surveille**

- Exemple :
    - Zabbix
    - Nagios
    - PRTG

✔ Il contient le **SNMP Manager**

---

## 🔄 Les 3 types d’opérations SNMP

1. 📢 **Notification (Trap / Inform)**  
    👉 Les équipements envoient une alerte au NMS  
    ✔ Exemple : panne, surcharge CPU

---

2. 🔍 **Lecture (Read)**  
    👉 Le NMS demande des informations  
    ✔ Exemple : état du CPU, mémoire, trafic

---

3. ⚙️ **Écriture (Write)**  
    👉 Le NMS modifie la configuration  
    ✔ Exemple : changer un paramètre réseau

---

## 🧠 Les composants SNMP

### 🔹 SNMP Manager

👉 Logiciel situé sur le **NMS**

- Envoie des requêtes
- Reçoit les réponses
- Analyse les données

---

### 🔹 SNMP Agent

👉 Logiciel installé sur les **équipements managés**

- Collecte les informations
- Répond aux requêtes du Manager
- Envoie des alertes (Trap)

---

### 🔹 MIB (Management Information Base)

👉 Base de données contenant les informations

- Organisée sous forme d’arbres (OID)
- Exemple :
    - CPU
    - RAM
    - Interfaces réseau

---

## 🔐 Versions de SNMP

### 1️⃣ SNMPv1

- Version initiale
- Simple mais **peu sécurisée**
- Utilise une "community string" (mot de passe simple)

---

### 2️⃣ SNMPv2c

- Amélioration de SNMPv1
- ✔ Plus rapide (Bulk request)
- ✔ Toujours basé sur "community string"
- ❌ Sécurité faible

---

### 3️⃣ SNMPv3

- ✔ Version la plus **sécurisée**
- ✔ Authentification
- ✔ Chiffrement (encryption)
- ✔ Contrôle d’accès

👉 C’est la version recommandée aujourd’hui

---

## 📩 SNMP Message

Les messages SNMP sont les échanges entre :  
👉 **Manager ↔ Agent**

---

## 📥 SNMP Read Messages (Lecture)

### 1️⃣ GET

👉 Demander une information précise

✔ Exemple :

- Demander l’état du CPU

---

### 2️⃣ GET-NEXT

👉 Obtenir la valeur suivante dans la MIB

✔ Utilisé pour parcourir les données

---

### 3️⃣ GET-BULK (SNMPv2c et v3)

👉 Récupérer **plusieurs informations en une seule requête**

✔ Plus rapide et efficace

---

## 📤 (Bonus) SNMP Write & Notification

### ✏️ SET

👉 Modifier une valeur sur un équipement

---

### 🚨 TRAP

👉 Message envoyé automatiquement par l’agent

✔ Exemple :

- Interface down
- Erreur système

---

## ✅ Résumé simple

- **SNMP = surveiller + gérer un réseau**
- **Manager (NMS)** → contrôle
- **Agent** → répond et envoie des infos
- **MIB** → base de données
- **v1/v2c** → simples mais peu sécurisés
- **v3** → sécurisé ✅
