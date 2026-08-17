# Comment expliquer tes projets à l'oral — Ingedata

Pour chaque projet : une **phrase d'accroche** (à dire spontanément si on te demande "parle-moi de ce projet"), le **pourquoi** (l'intérêt business/sécurité, pour montrer que tu comprends au-delà de la technique), puis des **questions de relance** probables avec la réponse courte à avoir en tête. Reste sur l'accroche + le pourquoi par défaut ; ne développe le reste que si on te pousse.

---

## 1. Architecture Zero Trust (pfSense, FreeRADIUS, OpenVPN)
**Accroche :** "J'ai monté une architecture réseau où aucun utilisateur ou appareil n'est considéré comme fiable par défaut, même s'il est déjà à l'intérieur du réseau — chaque accès est vérifié."

**Pourquoi c'est important :** Dans une architecture classique, une fois qu'on est "dans" le réseau, on a souvent trop d'accès. Le Zero Trust limite les dégâts si un poste est compromis.

**Relances probables :**
- *Comment tu identifies un utilisateur avant de lui donner accès ?* → FreeRADIUS fait l'authentification centralisée, couplée à un portail captif.
- *Rôle du pfSense ?* → Pare-feu + segmentation réseau (règles par groupe : Web, BDD, etc.) + VPN OpenVPN pour les connexions distantes chiffrées entre sites.
- *Comment tu contrôles qui accède à quoi ?* → Contrôle d'accès basé sur l'identité et le groupe de l'utilisateur, journalisation de toutes les connexions pour l'audit.

---

## 2. Pipeline CI/CD DevSecOps (Reservation + Harbor + Cosign)
**Accroche :** "J'ai construit un pipeline Jenkins qui automatise le build, la sécurisation et le déploiement d'une application, avec plus de 10 étapes de vérification avant que le code parte en production."

**Pourquoi c'est important :** Ça évite de découvrir une faille de sécurité une fois l'application déjà déployée — on la détecte automatiquement à chaque étape.

**Relances probables :**
- *Quels contrôles de sécurité ?* → Gitleaks (recherche de secrets/mots de passe oubliés dans le code), SonarQube (qualité et failles dans le code, avec un "Quality Gate" qui bloque le pipeline si le code n'est pas assez propre), OWASP Dependency-Check (vulnérabilités dans les librairies utilisées), Trivy (vulnérabilités dans l'image Docker finale).
- *Pourquoi signer l'image avec Cosign ?* → Pour garantir que l'image qui part en production est bien celle qui a été construite par le pipeline, et qu'elle n'a pas été modifiée entre-temps.
- *Rôle de Harbor ?* → C'est le registre privé (comme un "entrepôt" sécurisé en HTTPS) où sont stockées les images Docker validées.
- *Comment se fait le déploiement ?* → Automatisé avec Ansible + Docker Compose, avec des tests de fumée ("smoke tests") après déploiement pour vérifier que l'appli répond bien.

---

## 3. Pipeline CI/CD DevSecOps (Java/PostgreSQL sur Kubernetes)
**Accroche :** "Même logique que le premier pipeline, mais appliquée à une application Java Spring Boot déployée sur Kubernetes, avec du monitoring en plus."

**Pourquoi c'est important :** Montre que tu sais adapter les mêmes bonnes pratiques de sécurité à un environnement plus complexe (orchestration Kubernetes vs simple Docker Compose).

**Relances probables :**
- *Différence avec le premier pipeline ?* → Ici on cible les vulnérabilités Maven (dépendances Java) avec OWASP Dependency-Check, déploiement sur Kubernetes (namespace de production) au lieu de Docker Compose simple, et ajout de Prometheus + Grafana pour la supervision.
- *Pourquoi Harbor avec un "robot account" ?* → Un compte de service dédié pour que le pipeline pousse les images automatiquement, sans utiliser un compte personnel.

---

## 4. Serveur de messagerie (Postfix, Dovecot, Roundcube)
**Accroche :** "J'ai déployé une messagerie électronique complète : Postfix pour envoyer/recevoir les mails, Dovecot pour que les utilisateurs les consultent en IMAP, et Roundcube comme interface web."

**Relance probable :**
- *C'est quoi la différence entre Postfix et Dovecot ?* → Postfix transporte le mail (MTA), Dovecot le rend accessible à l'utilisateur (IMAP).

---

## 5. Sécurisation avec CrowdSec
**Accroche :** "J'ai mis en place CrowdSec sur un serveur Ubuntu pour détecter automatiquement les scans de ports et les tentatives de brute-force SSH, et bannir les IP malveillantes."

**Pourquoi c'est important :** Une détection automatique et communautaire (CrowdSec partage les IP malveillantes entre utilisateurs), plus réactive qu'une surveillance manuelle.

---

## 6. IDS/IPS avec Snort
**Accroche :** "J'ai installé Snort pour surveiller le trafic réseau en temps réel et créer des règles de détection personnalisées, avec export des logs en CSV pour analyse."

**Relance probable :**
- *Différence IDS/IPS ?* → IDS détecte et alerte, IPS peut aussi bloquer automatiquement le trafic suspect.

---

## 7. Tests d'intrusion (Pentesting)
**Accroche :** "J'ai réalisé des recherches de vulnérabilités sur des serveurs Linux et Windows dans un environnement contrôlé, puis rédigé un rapport avec des recommandations."

**Point d'attention :** Précise bien que c'était dans un **environnement de test/labo**, pas sur des systèmes réels sans autorisation — Ingedata pourrait vérifier ce point vu le côté sensible.

---

## 8. Active Directory
**Accroche :** "J'ai installé un contrôleur de domaine Windows, géré les GPO, intégré des postes au domaine et créé les utilisateurs/OU."

**Pourquoi c'est important :** C'est la base de la gestion centralisée des utilisateurs et des politiques de sécurité dans une entreprise — très probablement utilisé chez Ingedata en interne.

**Relance probable :**
- *C'est quoi une GPO ?* → Une politique appliquée automatiquement aux postes/utilisateurs du domaine (ex : verrouillage d'écran, restrictions, mises à jour).

---

## 9. Middleware RabbitMQ
**Accroche :** "J'ai utilisé RabbitMQ comme serveur central de messages entre applications : un producteur en Python qui envoie des messages, un consommateur en NodeJS qui les traite et les stocke dans SQLite, avec génération d'alertes automatiques."

**Pourquoi c'est important :** Ça découple les applications entre elles (l'une n'a pas besoin d'attendre l'autre) — utile pour des systèmes distribués.

---

## 10. Supervision réseau NtopNG
**Accroche :** "J'ai utilisé NtopNG pour surveiller le trafic réseau en temps réel, analyser la bande passante et définir des règles de blocage sur OPNSense."

---

## 11. Virtualisation KVM
**Accroche :** "J'ai configuré un serveur de virtualisation KVM pour simuler une infrastructure avec plusieurs VMs, avec différents modes réseau (bridge, NAT, host-only), et automatisé le déploiement avec des scripts."

---

## 12. Cisco Packet Tracer (routage inter-VLAN, OSPF/RIP/EIGRP, ACL)
**Accroche :** "J'ai simulé un réseau d'entreprise segmenté par département avec du routage inter-VLAN, redistribution entre protocoles OSPF/RIP/EIGRP, des ACL pour sécuriser les accès, et déploiement de serveurs Web/FTP/Mail."

**Relance probable :**
- *C'est quoi la redistribution de routes ?* → Permettre à des réseaux utilisant des protocoles de routage différents (ex : OSPF et RIP) de communiquer, en partageant leurs routes entre eux.

---

## 13. Expériences académiques récentes
- **Centralisation des logs (Grafana Loki) :** "J'ai centralisé les logs systèmes et applicatifs pour avoir une vue unique et faciliter le diagnostic et l'audit."
- **Audit avec Nessus Essentials :** "J'ai scanné un serveur pour identifier ses vulnérabilités et prioriser les correctifs."
- **CTF (CIRT/MNDPT, CCIO) :** "J'ai participé à des Capture The Flag pour m'entraîner sur des scénarios réels d'attaque/défense, en équipe et dans un contexte compétitif." → Bon exemple si on te demande comment tu apprends en continu.

---

## 14. Expériences professionnelles
- **ANTS-Tech :** "J'ai mis en place un poste de travail développeur sécurisé : chiffrement du disque avec LVM, et configuration sécurisée des navigateurs Chrome/Firefox."
- **Fondation Tany Meva :** "J'ai renouvelé le câblage réseau existant." → Reste honnête, c'est une mission courte et concrète, pas besoin de l'enjoliver.

---

## Conseil général pour l'oral
Utilise la structure **Contexte → Ce que j'ai fait → Résultat/ce que ça apporte** pour chaque projet, en une respiration (2-3 phrases max au départ). Si le recruteur est technique, il creusera lui-même avec des questions — laisse-le guider la profondeur plutôt que de tout déballer d'un coup.
