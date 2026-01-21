
## **Introduction Générale**

Avec l’évolution des technologies de communication, la téléphonie sur IP (VoIP) est devenue une solution incontournable pour les entreprises modernes. Asterisk est une plateforme open source permettant de mettre en place un serveur de téléphonie IP flexible et performant.

Ce projet a pour objectif d’installer, configurer et tester un serveur **Asterisk** sous **CentOS**, en utilisant le protocole **SIP/PJSIP**, afin de permettre des communications téléphoniques internes via des téléphones logiciels et matériels.

## **Objectifs du Projet**

- Installer un serveur Asterisk sous CentOS
    
- Comprendre l’architecture VoIP
    
- Configurer des extensions internes
    
- Mettre en place un plan de numérotation
    
- Tester les appels avec des téléphones fixes et softphones
    
- Acquérir des compétences pratiques en téléphonie IP
    
## **1. Préparation et Prérequis**

### **1.1 Matériel et Infrastructure**

- Serveur physique ou machine virtuelle
    
- 2 Go de RAM minimum
    
- 1 à 2 vCPU
    
- Disque dur : 20 Go
    
- Connexion Internet
    
- Adresse IP locale fixe recommandée
    
### **1.2 Logiciels**

- Système d’exploitation : **CentOS Stream**
    
- Serveur de téléphonie : **Asterisk 20**
    
- Téléphone : Linphone / téléphone SIP fixe
    
- VirtualBox ou VMware (en environnement de test)
    
### **1.3 Compétences Requises**

- Bases Linux
    
- Notions réseau (IP, ports, NAT)
    
- Bases de la VoIP (SIP, RTP)
    
## **2. Architecture du Projet**

Le serveur Asterisk joue le rôle de **PBX IP**, permettant :

- L’enregistrement des téléphones SIP
    
- La gestion des appels internes
    
- Le routage des appels via un dialplan
    
- La gestion de services VoIP (écho, IVR, messagerie)

**Architecture Logique**
```
Téléphone SIP 100  ----\
                         ---> Serveur Asterisk ----> Téléphone SIP 101
Téléphone SIP 101  ----/

```
## **3. Installation du Système**

### **3.1 Mise à Jour du Système**
```
sudo yum update -y

```
### **3.2 Installation des Dépendances**
```
sudo yum install -y epel-release
sudo yum groupinstall -y "Development Tools"
sudo yum install -y wget vim net-tools libuuid-devel libxml2-devel \
sqlite-devel ncurses-devel libedit-devel gcc gcc-c++ make \
libtool autoconf automake bzip2

```
## **4. Installation d’Asterisk depuis les Sources**

### **4.1 Téléchargement d’Asterisk**
```
cd /usr/src
sudo wget http://downloads.asterisk.org/pub/telephony/asterisk/asterisk-20-current.tar.gz
sudo tar -xvzf asterisk-20-current.tar.gz
cd asterisk-20*

```
### **4.2 Installation Automatique des Prérequis**
```
sudo contrib/scripts/install_prereq install

```
Ce script détecte automatiquement la distribution et installe ou compile les dépendances manquantes.

### **4.3 Configuration et Compilation**
```
sudo ./configure --with-jansson-bundled --with-pjproject-bundled
sudo make
sudo make install
sudo make samples
```
## **5. Configuration du Service Asterisk**

### **5.1 Création de l’Utilisateur Asterisk**
```
sudo groupadd asterisk
sudo useradd -r -d /var/lib/asterisk -g asterisk asterisk
sudo chown -R asterisk:asterisk /etc/asterisk
sudo chown -R asterisk:asterisk /var/{lib,log,spool}/asterisk
```
### **5.2 Configuration du Service Systemd**

Fichier `/etc/systemd/system/asterisk.service` :
```
[Unit]
Description=Asterisk PBX
After=network.target

[Service]
Type=simple
User=asterisk
Group=asterisk
ExecStart=/usr/sbin/asterisk -f
Restart=always

[Install]
WantedBy=multi-user.target
```
![[Pasted image 20260121162132.png]]

Et puis :
```
sudo systemctl daemon-reload
sudo systemctl start asterisk
```
## **6. Configuration SIP avec PJSIP**

### **6.1 Configuration des Extensions**

Fichier `/etc/asterisk/pjsip.conf` :
```
[transport-udp]
type=transport
protocol=udp
bind=0.0.0.0:5060

[100]
type=endpoint
context=internal
disallow=all
allow=ulaw
auth=auth100
aors=100

[auth100]
type=auth
auth_type=userpass
username=100
password=pass100

[100]
type=aor
max_contacts=1
```
![[Pasted image 20260121161426.png]]

## **7. Plan de Numérotation (Dialplan)**

Fichier `/etc/asterisk/extensions.conf` :
```
[internal]
; Appeler l'extension 100
exten => 100,1,NoOp(Appel vers 100)
exten => 100,2,Dial(PJSIP/100,30)
exten => 100,3,Hangup()

; Appeler l'extension 101
exten => 101,1,NoOp(Appel vers 101)
exten => 101,2,Dial(PJSIP/101,30)
exten => 101,3,Hangup()

; Test echo
exten => 600,1,Answer()
exten => 600,2,Echo()
exten => 600,3,Hangup()

```
![[Pasted image 20260121161708.png]]
## **8. Tests et Validation**

### **8.1 Connexion à la Console Asterisk**
```
sudo asterisk -rvvv
```
Et puis :
```
pjsip show endpoints
```
![[Pasted image 20260121161954.png]]
### **8.2 Test d’Appel**

- Appel du numéro **600** → test écho
![[Pasted image 20260121162453.png]]

- Appel entre extensions **100 ↔ 101**
    

## **9. Sécurité de Base**

- Mots de passe forts
    
- Restriction des ports SIP/RTP
    
- Pare-feu activé
    
- Accès SSH sécurisé
```
sudo firewall-cmd --permanent --add-port=5060/udp
sudo firewall-cmd --permanent --add-port=10000-20000/udp
sudo firewall-cmd --reload
```
## **Conclusion**

Ce projet a permis de mettre en œuvre un serveur de téléphonie IP fonctionnel basé sur Asterisk. Il a offert une compréhension approfondie des concepts VoIP, de la configuration SIP/PJSIP, ainsi que de la gestion des appels internes.

Les compétences acquises peuvent être étendues vers :

- IVR
    
- Messagerie vocale
    
- Trunks SIP
    
- Centres d’appels
    
## **Perspectives**

- Intégration avec FreePBX
    
- Sécurisation avancée (TLS, SRTP)
    
- Interconnexion avec le réseau public
    
- Supervision et enregistrement des appels