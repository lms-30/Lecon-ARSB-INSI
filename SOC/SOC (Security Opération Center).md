### Cybersécurité : 
ensemble de méthode, processus, technologie pour protégé les actifs dans une organisation (Data, system, utilisateurs)

#### Triade de CIA
- Confidentialité
- Intégrité
- Disponibilité


SOC Analyste :
Rôles principales dans le domaines SOC:

        Visualisation
        Alerte
        Escalade
        Bloquer menace

#### SOC

**Définition :**
est une équipe qui surveille et protège le SI dans une entreprise contre les CyberAttaque ou violation potentiels. Son rôle principales est de garentir la protection continue des SI et des données sensible dans une oraganisation contre les menaces.

Type de menace : interne(ex : employé mal intentionné) et externe(DDos, phising)

**Fonctionnement SOC:**
Le SOC opère en collectant et analysant des données provenant d'un large éventuel de sources.
 1. détection proactive des menaces
 En utilisant des outils tels que des systèmes SIEM, le SOC agrège des logs et événement pour identifier des activités suspects.
 2. réponse aux incidents
 une fois qu'une menace est détectée, l'équipe du SOC met en oeuvre des procédures pour contenir, éradiquer et récupérer des attaques. Cela implique l'analyse des causes profondes et la prise de mesure correctives pour prévenir les futures occurrences.
 3. surveillance continue
 Le SOC est souvent actif 24/7 pour assurer une vigilance constante, réduisant ainsi les fenêtres d'opportunité pour les attaques.
 4. gestion des vulnérabilités
 Le SOC effectue régulièrement des scan pour identifier les faiblesses potentielles dans les systèmes, et coordonne des actions correctives.
 
**Composants SOC en entreprise**
- Équipe SOC
les ingénieurs, les gestionnaires SOC qui apportent leur expertise pour identifier les anomalies et coordonner les réponses aux incidents.

Niveau d'expertise :
L1 : Réception et la qualification des alertes, escalade vers les niveau 2
L2 : Analyse approfondie des incidents de sécurité
L3 : Gestion des incidents complexes, recherches des menaces (threat hunting) et création des règles SIEM
- Processus
Des procédures bien définies sont mises en place pour détecter et répondre aux incidents pour garantir une réponse rapide et efficace.
- technologie
Il s'appuie sur un ensemble de technologie pour automatiser la surveillance, la détection, et réduire les temps de réponse.

SIEM
EDR
XDR
PARE_FEU

**Modèle SOC**
- Modèle Externe : MSSP (Managed Security Service Provider)
- Modèle Interne : SOC réalisé en interne, rattaché à la département du DSI

### Structure Oraganisationnelles

**SOC Analystes (L1) :** Opérateur de surveillance
- Surveillance alertes
- Triage des tickets incidents
- Escalade au niveau 2 pour les incidents complexes
Compétences utiles : 
- Utilisation de SIEM
- Gestion des système de ticketing
- Différentes type protocole: TCP/IP, DNS, DHCP
- Analyse et lecture des logs : syslog, Events log

**Analystes (L2) :** Investigateur
- Analyse approfondie des incidents complexes
- Analyse malware: signature, comportementale, statique (Registre, statique(IDA,Glidia))
- Modèle TTPs, Cyber Kill Chain
- Investigation approfondie

> [!NOTE] TTPs (Tactique, Technique, Procedures)
> T : Objectifs
> T : Technique utilisé pour atteindre l'objectif tactiques
> 	Ex : Phishing, exploit vulnérabilité, Malware
> P : Différentes étapes utilisé pendant la technique

SOC L3 : Chasseur de menace
- Reverse Engenering: IDA, GHidra, Hexdoap
- Connaissance des APTs: Advanced Persistance Threat

**Ingénieur SOC:** Architecture SOC | Intégration SOC
- Déploiement outil SOC (EDR, SIEM)
- Règle de détection
- Installation

**SOC Manager:** Management
- Gestion Equipe
- Conformité
- Gestion Budget
- Rapport


### Architecture SOC

**Source de logs**

Terminaux: PC, Mobile, etc
	Système d'exploitation:
	Windows: Win Event log
	Linux: syslog
	MacOS: Unified leggings
Application: 
	Application métier: APIs, Webhook, syslog, Messagerie
Identité:
	Annuaire AD
	LDAP
	SSO
	IAM
Serveur:
	Web: Nginx, Apache2
	Database
Infrastructure Réseau: syslog, Netflow, SNMP
	- VPN
	- Firewall
	- Switch
	- Proxy

### 1) Couche de Collection
	EDR
	Syslog
	IDS/IPS
### 2) Couche de transport et agrégation
	UDP/TCP + TLS
	gRPC
	APIs
### 3) Couche d'analyse et de stockage
	Fondexation
	Sauvegarde
### 4) Couche de Visualisation
	Segmentation
	Gestion d'accès
	Sécurisation
