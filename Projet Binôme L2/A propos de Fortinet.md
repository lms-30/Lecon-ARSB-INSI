Fortinet est une entreprise de cybersécurité mondiale connue sur la protection des réseau, des données et des application, Créée en 2000 par Ken Xi, il se situe en Californie. Il est connue en tant que Leader de pare-feu nouvelle génération et des solution de sécurité unifiées.

Depuis 2019, Fortineta commencé à **intégrer des concepts de Zero Trust** ,avec l'évolution de sa plateforme **Fortinet Security Fabric**. Cependant, c’est à partir de **2020**–**2021** que Fortinet a **formellement consolidé** son approche **Zero Trust Network Access (ZTNA)** comme une **offre stratégique** à part entière, en réponse à l'évolution rapide des environnements de travail hybrides et à la nécessité de sécuriser les accès distants. c'est pourquoi qu'on a choisi que la solution de sécurité de Fortinet est l'un de meilleurs pour sécuriser nos réseaux avec une stratégie très stricte.

**Cependant, la solution ZTNA proposée par Fortinet s’adresse principalement aux entreprises, car son utilisation requiert l’acquisition de licences.**

**Pour déployer une infrastructure ZTNA avec Fortinet, il est nécessaire de disposer des composants présentés dans le tableau suivant :**


| Outils                             | Fonctionnalités                                                                   | Avantages                                                                                      | Rôle ZTNA                                | Ressources nécessaires                                                                                   |
| ---------------------------------- | --------------------------------------------------------------------------------- | ---------------------------------------------------------------------------------------------- | ---------------------------------------- | -------------------------------------------------------------------------------------------------------- |
| FortiGate                          | Pare-feu NGFW, inspection du trafic, segmentation du réseau                       | Simplifie la gestion réseau, réduit les risques, contrôle granularité des accès                | **Passerelle ZTNA**, segmentation réseau | - Appliance FortiGate physique ou virtuelle (VM)  <br>- Licences ZTNA  <br>- CPURAMmin. 2 vCPU, 4 Go RAM |
| E.M.S (Endpoint Management Server) | Gère les clients FortiClient, vérifie conformité, déploie politiques sécurité     | Centralise la gestion des terminaux, déploiement automatisé, visibilité                        | Contrôle de conformité (posture check)   |                                                                                                          |
| FortiNAC                           | Contrôle d’accès réseau basé sur les rôles et la conformité                       | Isole automatiquement les hôtes non conformes, visibilité sur tous les équipements             | Contrôle d'accès réseau (NAC)            |                                                                                                          |
| FortiClient                        | Agent installé sur les postes pour l’accès sécurisé, inspection, VPN, ZTNA agent  | Connexion sécurisée à distance, vérification de l'état du terminal                             | Agent ZTNA                               |                                                                                                          |
| FortiAuthenticator                 | Authentification forte (MFA, LDAP, SAML), gestion des identités                   | Authentifie les utilisateurs avant d'autoriser l'accès, intègre l’identité au contrôle d’accès | Identité et authentification             |                                                                                                          |
| FortiAnalyzer                      | Analyse des logs, détection d’anomalies, tableaux de bord                         | Permet une supervision centralisée, détection précoce des menaces                              | Supervision et audit                     |                                                                                                          |
| FortiSIEM                          | Agrégation et corrélation des logs de sécurité, alertes                           | Vue complète de la sécurité, corrélation temps réel                                            | Détection et réponse automatisée         |                                                                                                          |
| FortiSASE (Cloud ZTNA)             | Fournit ZTNA dans le cloud avec inspection du trafic et contrôle d'accès sans VPN | Adapté aux travailleurs mobiles, pas besoin de VPN permanent, scalable                         | ZTNA agentless & cloud-native            |                                                                                                          |
Ces outils sont suffisantes pour déployer une infrastructure réseau ZTNA 
1. Choix des outils open source:
 **OpenVPN**
 
- **Sécurité:**
    OpenVPN est connu pour sa sécurité robuste, utilisant le protocole OpenSSL et des algorithmes de chiffrement puissants comme AES-256. 
- **Flexibilité:**
    OpenVPN offre une grande flexibilité de configuration, permettant des connexions personnalisées et s'adaptant à divers environnements. 
- **Code source:**
    Le code d'OpenVPN est plus volumineux, ce qui peut rendre les audits de sécurité plus complexes. 
- **Vitesse:**
    OpenVPN peut être un peu plus lent que WireGuard en raison de sa complexité et de sa méthode de fonctionnement au niveau de l'utilisateur. 
- **Utilisation:**
    OpenVPN est largement utilisé et pris en charge, ce qui en fait un choix fiable pour de nombreuses situations.

**WireGuard**

- **Vitesse:**
    WireGuard est réputé pour sa rapidité et son efficacité, grâce à son code simplifié et à son fonctionnement au niveau du noyau. 
- **Simplicité:**
    WireGuard se distingue par sa simplicité, avec un code beaucoup plus court que celui d'OpenVPN, ce qui facilite les audits de sécurité et réduit les vulnérabilités potentielles. 
- **Sécurité:**
    WireGuard utilise des algorithmes de chiffrement modernes comme ChaCha20 et Poly1305, offrant un niveau de sécurité élevé. 
- **Configuration:**
    WireGuard est généralement plus facile à configurer et à mettre en œuvre que OpenVPN, notamment sur les appareils mobiles.
