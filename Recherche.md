# I. Incident (en réseau)
Un **incident** est un **événement imprévu** qui perturbe le fonctionnement normal du réseau ou d’un service.

### Exemples :
- Une panne de switch,
- Une coupure de lien Internet,
- Une attaque DDoS,
- Une adresse IP dupliquée,
- Un serveur qui ne répond plus.
### Objectif en gestion d’incidents :
- Détecter
- Diagnostiquer
- Résoudre rapidement pour restaurer le service.

#    II. KPI et SLA

🟦 **KPI (Key Performance Indicator)**
Les **indicateurs de performance** qui permettent de mesurer l’efficacité du réseau ou du service.
### Exemple de KPI réseau :
- Latence moyenne (ms)
- Disponibilité du réseau (%)
- Débit réel par rapport au débit théorique
- Taux de perte de paquets
- Temps moyen de réparation (MTTR)
###### 👉 Ils servent à évaluer la qualité et aider à décider des améliorations
### 🟩 **SLA (Service Level Agreement)**
Le **contrat de niveau de service** entre un fournisseur (ou équipe IT) et un client (ou utilisateur).  
Il définit les **engagements mesurables**.
### Exemple de SLA :
- Disponibilité 99,9%
- Temps maximum d'interruption : 1 h par mois
- Support disponible 24/7
- Temps de réponse pour intervention : 30 minutes

👉 Les KPI servent souvent à **vérifier si les SLA sont respectés**.

# III. Vulnérabilité
Une **faiblesse** dans un système, un protocole ou une configuration qui peut être exploitée par un attaquant.
### Exemples :
- Mot de passe faible,
- Port ouvert non sécurisé,
- Version logicielle obsolète,
- Faible segmentation réseau (pas de VLAN),
- Absence de correctifs (patch management).
###### 👉 Une vulnérabilité **n’est pas encore une attaque**, mais **peut devenir un incident** si exploitée.

# IV. Anomalie
Une **activité ou un comportement anormal** dans le réseau, qui ne respecte pas le fonctionnement habituel.
### Exemples :
- Un pic de trafic inhabituel
- Un utilisateur qui se connecte à une heure inhabituelle
- Beaucoup d’erreurs sur un port de switch
- Des scans réseau détectés par l’IDS.

👉 Une anomalie **peut révéler** :
- une mauvaise configuration,
- une future panne,
- ou une attaque en cours.

C’est ce que Suricata, Zeek, Snort ou Wazuh cherchent à détecter.

# V. Proactivité
La **proactivité** consiste à **agir avant que le problème n’arrive**, pour prévenir les incidents.
### Comportements proactifs 
- Faire des mises à jour régulières
- Surveiller le réseau (monitoring) avec Zabbix, Grafana, Wazuh
- Auditer les règles de pare-feu
- Tester les sauvegardes
- Vérifier l’état des disques, CPU, ports
- Scanner les vulnérabilités (Nessus, OpenVAS).

👉 La proactivité permet de _réduire les incidents_, améliorer les SLA et renforcer la cybersécurité.

# VI. FIABILITÉ

Lorsqu’on dit **qu’un réseau ou qu’un appareil est fiable**, cela signifie qu’il répond à plusieurs critères essentiels en matière de **performance, sécurité et disponibilité**. Voici une explication claire et complète :
# **Qu’est-ce qu’un réseau fiable ?**
Un réseau est considéré comme **fiable** lorsqu’il offre :
### **1. Disponibilité élevée (High Availability)**
- Le réseau fonctionne **sans interruption** ou avec des interruptions très faibles.
- Utilisation de mécanismes de redondance :
    - Deux routeurs/switchs
    - Liens redondants
### **2. Performance stable**
- Débit constant
- Latence faible
- Peu ou pas de perte de paquets
- Bonne qualité de service (QoS)
### **3. Sécurité forte**
- Protection contre les attaques (DoS, intrusions, malwares)
- Pare-feu, IDS/IPS (comme Snort, Suricata, Zeek)
- Contrôle d’accès (ACLs, 802.1X, VLANs)
- Mise à jour régulière des équipements.
### **4. Résilience**
- Capacité à **continuer à fonctionner même en cas de panne** d’un composant.
- Possibilité d’auto-récupération (self-healing).
### **5. Gestion et supervision**
- Surveillance via SNMP, Zabbix, Grafana, Wazuh, Graylog.
- Alertes en cas de dysfonctionnement.

---

# **Qu’est-ce qu’un appareil fiable ?**

Un appareil (ordinateur, serveur, routeur, pare-feu) est fiable s’il possède :

### **1. Stabilité du système**
- Fonctionne longtemps sans crasher.
- OS régulièrement mis à jour.
### **2. Sécurité**
- Protégé contre virus, rootkits, intrusions.
- Mot de passe fort, authentification à deux facteurs (2FA).
### **3. Performances constantes**
- Ne ralentit pas
- Gère bien les charges élevées,
- Bonne gestion de la RAM, CPU et stockage.
### **4. Résistance aux pannes**
- Matériel durable (disques SSD, alimentation protégée),
- Sauvegardes régulières.
### **5. Support et maintenance**
- Possibilité d’être supervisé, diagnostiqué et réparé rapidement.


