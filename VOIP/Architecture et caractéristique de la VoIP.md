## 🔍 Définition de la VoIP

La **VoIP** (Voice over Internet Protocol) est une technologie qui permet de **transmettre la voix humaine sous forme de données numériques** à travers un réseau IP (Internet ou réseau local LAN/WAN), au lieu d'utiliser le réseau téléphonique classique (RTC).

> 💡 En clair : au lieu d'appeler via une ligne téléphonique traditionnelle, la voix est **découpée en paquets de données** et envoyée comme un email ou une page web.

---

## 🆚 VoIP vs Téléphonie Classique (RTC)

| Critère        | RTC (Réseau Téléphonique Commuté) | VoIP                       |
| -------------- | --------------------------------- | -------------------------- |
| Support        | Ligne cuivre dédiée               | Réseau IP (Internet/LAN)   |
| Circuit        | **Commuté** (canal réservé)       | **Par paquets** (partagé)  |
| Coût           | Élevé (surtout international)     | Faible voire gratuit       |
| Flexibilité    | Limitée                           | Très flexible              |
| Qualité        | Stable et garantie                | Dépend du réseau           |
| Infrastructure | Centraux téléphoniques            | Serveurs IP (ex: Asterisk) |
| Mobilité       | Fixe                              | Nomade (n'importe où)      |

---

## Principe de fonctionnement de la VoIP

La VoIP fonctionne en **4 grandes étapes** :
```
1. CAPTURE      →   Le microphone capte la voix (signal analogique)
2. NUMÉRISATION →   Le codec convertit la voix en données numériques
3. ENCAPSULATION→   Les données sont découpées en paquets IP
4. TRANSMISSION →   Les paquets voyagent sur le réseau IP
5. RECONSTITUTION→  Côté destinataire, les paquets sont réassemblés
6. LECTURE      →   Le signal est converti en son audible
```
> 💡 Ce processus se fait en **temps réel** (moins de 150ms idéalement) pour que la conversation soit naturelle.

---

## 🏗️ Architecture de la VoIP

L'architecture VoIP repose sur **4 composants principaux** :

---

### 1️⃣ Les Terminaux (Endpoints)

Ce sont les **équipements utilisés pour passer/recevoir des appels**.

| Type                               | Description                                                    | Exemple                    |
| ---------------------------------- | -------------------------------------------------------------- | -------------------------- |
| **Téléphone IP (Hard Phone)**      | Téléphone physique connecté en RJ45/WiFi                       | Cisco 7960, Yealink T46    |
| **Softphone**                      | Logiciel installé sur PC/smartphone                            | Zoiper, Linphone, MicroSIP |
| **ATA (Analog Telephone Adapter)** | Adaptateur pour brancher un téléphone analogique sur réseau IP | Grandstream HT802          |
| **Téléphone WiFi**                 | Téléphone IP sans fil                                          | Yealink W56H               |

### 2️⃣ Le Serveur VoIP (IPBX / Softswitch)

C'est le **cerveau de l'infrastructure VoIP**. Il gère tous les appels, les extensions, les règles de routage.

|Serveur|Rôle|
|---|---|
|**Asterisk**|IPBX open source le plus utilisé|
|**FreePBX**|Interface graphique basée sur Asterisk|
|**3CX**|Solution commerciale complète|
|**Kamailio**|SIP Proxy haute performance|
|**OpenSIPS**|SIP Proxy pour très grande échelle|

> 💡 Le serveur IPBX remplace l'ancien **PABX** (autocommutateur téléphonique physique) des entreprises.

---

### Les Passerelles (Gateways)

Elles servent de **pont entre le réseau VoIP et le réseau téléphonique classique (RTC/PSTN)**.

```
Réseau IP  ←──→  GATEWAY  ←──→  Réseau RTC/PSTN
(paquets)                        (signal analogique)
```

|Type de Gateway|Rôle|
|---|---|
|**VoIP Gateway**|Convertit SIP ↔ RTC|
|**GSM Gateway**|Convertit SIP ↔ réseau mobile GSM|
|**E1/T1 Gateway**|Connecte les lignes numériques ISDN/PRI|

### 4️⃣ Le Réseau IP (Infrastructure)

La qualité de la VoIP dépend **directement** du réseau IP sous-jacent.

|Équipement|Rôle|
|---|---|
|**Routeur QoS**|Priorise les paquets voix sur le réseau|
|**Switch PoE**|Alimente les téléphones IP via le câble réseau|
|**VLAN Voix**|Sépare le trafic voix du trafic données|
|**Firewall**|Protège et filtre le trafic SIP|
|**Serveur DHCP**|Attribue automatiquement les IPs aux phones|

## 📡 Protocoles utilisés en VoIP

La VoIP utilise **deux catégories** de protocoles :

---

### Protocoles de Signalisation

> Gèrent l'**établissement, la modification et la fin** des appels.

|Protocole|Description|
|---|---|
|**SIP** (Session Initiation Protocol)|Le plus utilisé. Gère les appels VoIP (RFC 3261)|
|**H.323**|Ancien standard ITU-T, encore présent en entreprise|
|**IAX2** (Inter-Asterisk eXchange)|Protocole natif d'Asterisk, traverse facilement les NAT|
|**MGCP**|Contrôle des passerelles multimédia|
|**SCCP (Skinny)**|Protocole propriétaire Cisco|

### 🟢 Protocoles de Transport (Media)

> Transportent **les données audio/vidéo** en temps réel.

|Protocole|Description|
|---|---|
|**RTP** (Real-time Transport Protocol)|Transporte les flux audio/vidéo|
|**RTCP** (RTP Control Protocol)|Surveille la qualité du flux RTP|
|**SRTP** (Secure RTP)|Version **chiffrée** de RTP (sécurité)|
|**UDP**|Transport sous-jacent de RTP (rapide, sans garantie)|

```
Appel SIP :
  SIGNALISATION : SIP  (port 5060 UDP/TCP)
  MEDIA         : RTP  (ports 10000-20000 UDP)
```

---

## 🎵 Les Codecs VoIP

Un **codec** (codeur/décodeur) compresse et décompresse la voix. Il détermine la **qualité audio** et la **bande passante** consommée.

|Codec|Bande passante|Qualité|Utilisation|
|---|---|---|---|
|**G.711 µ-law / A-law**|64 Kbps|⭐⭐⭐⭐⭐ Excellente|LAN, appels locaux|
|**G.729**|8 Kbps|⭐⭐⭐⭐ Bonne|WAN, liaisons faible débit|
|**G.722**|64 Kbps|⭐⭐⭐⭐⭐ HD Voice|Conférences, qualité HD|
|**G.723.1**|5.3 / 6.3 Kbps|⭐⭐⭐ Acceptable|Connexions très lentes|
|**Opus**|6-510 Kbps (adaptatif)|⭐⭐⭐⭐⭐ Moderne|WebRTC, applications modernes|
|**iLBC**|15 Kbps|⭐⭐⭐ Acceptable|Pertes de paquets élevées|
|**GSM**|13 Kbps|⭐⭐⭐ Acceptable|Compatibilité mobile|

> 💡 **G.711** = qualité maximale mais consomme plus. **G.729** = économique en bande passante mais nécessite une licence.

---

## 📊 Paramètres de Qualité (QoS)

La qualité d'un appel VoIP est mesurée par **4 indicateurs** :

|Paramètre|Définition|Seuil acceptable|
|---|---|---|
|**Latence**|Délai de bout en bout|< **150 ms** (idéal < 80ms)|
|**Gigue (Jitter)**|Variation du délai entre paquets|< **30 ms**|
|**Perte de paquets**|% de paquets non reçus|< **1%**|
|**MOS** (Mean Opinion Score)|Note de qualité globale (1 à 5)|> **3.5**|

```
Mauvaise latence  → Décalage dans la conversation (écho, chevauchement)
Mauvaise gigue    → Voix hachée, saccadée
Perte de paquets  → Mots coupés, silences
```

---

## 🔒 Sécurité en VoIP

|Menace|Description|Solution|
|---|---|---|
|**Écoute clandestine**|Interception des flux RTP|Chiffrement **SRTP + TLS**|
|**Fraude SIP (Toll Fraud)**|Appels non autorisés via le trunk|Authentification SIP, **fail2ban**|
|**DoS / DDoS**|Saturation du serveur SIP|**Firewall**, rate limiting|
|**SPIT** (Spam over IP Telephony)|Appels indésirables automatisés|Filtrage, blacklist|
|**Spoofing CallerID**|Usurpation du numéro appelant|**STIR/SHAKEN**, vérification|

ini

````ini
; Exemple Asterisk — Bloquer les connexions SIP non autorisées
; Dans sip.conf
[general]
allowguest=no          ; Interdire les appels sans authentification
alwaysauthreject=yes   ; Ne pas révéler si un utilisateur existe
```

---

## 🗺️ Schéma d'Architecture VoIP Complète
```
┌─────────────────────────────────────────────────────────┐
│                   RÉSEAU ENTREPRISE                      │
│                                                          │
│  ┌──────────┐    ┌──────────┐    ┌──────────┐           │
│  │ Phone IP │    │ Phone IP │    │Softphone │           │
│  │ (SIP)    │    │ (SIP)    │    │ (SIP)    │           │
│  └────┬─────┘    └────┬─────┘    └────┬─────┘           │
│       │               │               │                  │
│  ─────┴───────────────┴───────────────┴────              │
│              SWITCH PoE / VLAN VOIX                      │
│  ─────────────────────────┬────────────────              │
│                           │                              │
│                    ┌──────┴──────┐                       │
│                    │  ASTERISK   │  ← IPBX               │
│                    │  (IPBX)     │                       │
│                    └──────┬──────┘                       │
│                           │                              │
│                    ┌──────┴──────┐                       │
│                    │  ROUTEUR    │  ← QoS / NAT          │
│                    │   QoS       │                       │
│                    └──────┬──────┘                       │
└───────────────────────────┼─────────────────────────────┘
                            │
              ┌─────────────┼─────────────┐
              │             │             │
       ┌──────┴────┐  ┌─────┴────┐  ┌────┴──────┐
       │  Trunk SIP│  │ GATEWAY  │  │  Internet │
       │  (FAI)    │  │ GSM/RTC  │  │  (WebRTC) │
       └──────┬────┘  └─────┬────┘  └───────────┘
              │             │
         ┌────┴─────────────┴────┐
         │    PSTN / RTC / GSM   │
         │  (Réseau téléphonique │
         │      classique)       │
         └───────────────────────┘
````

---

## ✅ Avantages et Inconvénients de la VoIP

### ✅ Avantages

- **Coût réduit** : appels locaux et internationaux peu chers ou gratuits
- **Flexibilité** : un seul réseau pour voix + données
- **Mobilité** : appeler depuis n'importe où avec une connexion Internet
- **Fonctionnalités avancées** : messagerie vocale, IVR, conférence, enregistrement
- **Scalabilité** : ajouter des postes sans câblage supplémentaire
- **Intégration** : connexion avec CRM, helpdesk, applications métier

### ❌ Inconvénients

- **Dépend du réseau** : coupure Internet = plus de téléphone
- **Qualité variable** : sensible à la latence, gigue, pertes de paquets
- **Alimentation électrique** : les phones IP nécessitent du courant (PoE ou adaptateur)
- **Sécurité** : plus exposé aux attaques que le RTC classique
- **Urgences (15/18)** : localisation difficile contrairement au RTC