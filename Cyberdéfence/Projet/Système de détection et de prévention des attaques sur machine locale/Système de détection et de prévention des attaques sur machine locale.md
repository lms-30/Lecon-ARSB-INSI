## **Objectif :**

1. Surveiller une machine (Linux ou Windows) pour détecter des activités suspectes (malware, intrusions, anomalies système).
    
2. Prévenir automatiquement certaines attaques simples (ex : blocage d’IP, fermeture de processus malveillants).
    
3. Générer des logs et alertes pour analyse.
    
4. Fournir un rapport ou une interface simple pour visualiser les incidents.

## **Architecture proposée :**

![[Cyberdéfence/Projet/Système de détection et de prévention des attaques sur machine locale/architecture.png]]

## **Outils et technologies :**

### **Système cible :**

- Linux (Ubuntu/Debian)
### **Outils de détection :**

1. **OSSEC** – audit de sécurité et détection de vulnérabilités.
2. **Suricata** – IDS pour détecter le trafic réseau suspect.
3. **Fail2ban** – bloque les IP après tentatives d’intrusion répétées.
    

### **Analyse comportementale locale :**

- Python pour écrire un **script de surveillance** qui :
    
    - Surveille les processus (`psutil` en Python)
        
    - Surveille les logs systèmes (/var/log/auth.log, /var/log/syslog)
        
    - Détecte des anomalies simples (ex: utilisation CPU anormale, tentatives de login échouées)
        
### **Prévention :**

- Scripts automatiques pour :
    
    - Bloquer IP suspectes via `iptables`
        
    - Stopper processus malveillants (`kill`)
        
    - Envoyer notifications ou alertes par mail
        
### **Visualisation / Interface :**

- Python + Flask (dashboard simple) ou terminal avec logs en temps réel
    

---

## **Étapes de réalisation :**

### **Étape 1 : Préparer l’environnement**

- Installer Linux (machine virtuelle ubuntu server)
- Installer Python + bibliothèques (`psutil`, `Flask`)
- Installer Suricata
- Installer Fail2ban
    

---

### **Étape 2 : Détection**

- Configurer Suricata pour surveiller le trafic réseau local
    
- Configurer OSSEC pour auditer la machine
    
- Écrire un script Python pour :
    
    - Surveiller les processus
        
    - Surveiller les logs
        
    - Détecter les anomalies (ex : tentatives de connexion échouées, changement de fichier système)
        

---

### **Étape 3 : Prévention**

- Configurer Fail2ban pour bloquer les IP après 3 tentatives échouées
    
- Script Python pour tuer un processus suspect si son comportement est anormal
    
- Ajouter alertes via mail ou affichage console
    

---

### **Étape 4 : Visualisation / Reporting**

- Créer un mini dashboard avec Flask :
    
    - Afficher les IP bloquées
        
    - Afficher les alertes critiques
        
    - Historique des incidents
        

---

### **Étape 5 : Tests et validation**

- Simuler des attaques simples :
    
    - Tentative SSH brute-force
        
    - Téléchargement d’un script malveillant (sur machine test)
        
    - Ouverture de port suspect
        
- Vérifier si le système détecte et prévient correctement