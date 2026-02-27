
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

- Serveur machine virtuelle
    
- 2 Go de RAM minimum
    
- 1 à 2 vCPU
    
- Disque dur : 20 Go
    
- Connexion Internet
    
- Adresse IP locale fixe recommandée
    
### **1.2 Logiciels**

- Système d’exploitation : **CentOS Stream 8 ou plus**
    
- Serveur de téléphonie : **Asterisk 20**
    
- Téléphone : Linphone / téléphone SIP fixe
    
- VMware (en environnement de test)
    
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


# **Chapitre 2 : Configuration des appels vidéo sur le serveur Asterisk**

---

## **2.1 Introduction**

Avec l’évolution des technologies de communication, la téléphonie IP ne se limite plus aux appels vocaux. L’intégration de la **vidéo** dans les systèmes VoIP permet d’améliorer la qualité des échanges et de rapprocher les utilisateurs distants.  
Dans ce chapitre, nous présentons les différentes étapes de **mise en place et de configuration des appels vidéo** sur un serveur **Asterisk installé sous CentOS**, en utilisant le protocole **SIP via PJSIP** et le client **Linphone**.

---

## **2.2 Objectifs de la configuration vidéo**

Les objectifs de cette configuration sont :

- Activer la prise en charge des **appels vidéo SIP**
    
- Configurer les **codecs audio et vidéo**
    
- Assurer la compatibilité avec le **NAT et les réseaux multiples**
    
- Permettre la communication vidéo entre plusieurs extensions internes
    
- Tester et valider le bon fonctionnement du service
    

---

## **2.3 Prérequis matériels et logiciels**

### **2.3.1 Prérequis matériels**

- Serveur avec **2 Go de RAM minimum**
    
- Processeur compatible multimédia
    
- Caméra et microphone sur les postes clients
    
- Connexion réseau stable
    

### **2.3.2 Prérequis logiciels**

- Système d’exploitation : **CentOS**
    
- Serveur VoIP : **Asterisk**
    
- Protocole : **SIP (PJSIP)**
    
- Client SIP : **Linphone**
    
- Codecs vidéo : **H.264, VP8**
    

---

## **2.4 Principe de fonctionnement des appels vidéo**

Les appels vidéo reposent sur :

- **SIP** pour la signalisation des appels
    
- **RTP** pour le transport des flux audio et vidéo
    
- **Négociation des codecs** entre les terminaux
    
- **Asterisk** comme serveur central assurant la gestion des appels
    

---

## **2.5 Configuration du protocole PJSIP pour la vidéo**

### **2.5.1 Configuration du transport SIP**

Le transport SIP est configuré pour supporter plusieurs réseaux et gérer le NAT.

**Fichier :** `/etc/asterisk/pjsip.conf`
```
[transport-udp]
type=transport
protocol=udp
bind=0.0.0.0:5060
local_net=192.168.210.0/24
local_net=192.168.88.0/24
```
---

### **2.5.2 Configuration des extensions SIP avec support vidéo**

Chaque extension est configurée pour supporter à la fois l’audio et la vidéo.

**Exemple : Extension 100**
```
[100]
type=endpoint
context=internal
disallow=all

; Codecs audio
allow=ulaw
allow=alaw
allow=opus

; Codecs vidéo
allow=h264
allow=vp8

aors=100
auth=auth100
direct_media=no
rtp_symmetric=yes
force_rport=yes
rewrite_contact=yes
ice_support=yes
use_avpf=yes
max_audio_streams=1
max_video_streams=1
```
## **2.6 Configuration de l’authentification et des AOR**

L’authentification garantit l’accès sécurisé des utilisateurs au serveur.
```
[auth100]
type=auth
auth_type=userpass
username=100
password=pass100

[100]
type=aor
max_contacts=1
remove_existing=yes
```
---

## **2.7 Configuration du protocole RTP**

Le protocole RTP assure le transport des flux multimédias.

**Fichier :** `/etc/asterisk/rtp.conf`
```
[general]
rtpstart=10000
rtpend=20000
icesupport=yes
strictrtp=yes
```
## **2.8 Configuration du plan de numérotation (Dialplan)**

Le plan de numérotation permet d’établir les appels vidéo entre extensions.

**Fichier :** `/etc/asterisk/extensions.conf`
```
[internal]
exten => 100,1,NoOp(Appel vidéo vers 100)
exten => 100,2,Set(CHANNEL(videosupport)=yes)
exten => 100,3,Dial(PJSIP/100,30)
exten => 100,4,Hangup()

exten => 101,1,NoOp(Appel vidéo vers 101)
exten => 101,2,Set(CHANNEL(videosupport)=yes)
exten => 101,3,Dial(PJSIP/101,30)
exten => 101,4,Hangup()
```
## **2.9 Configuration du client Linphone**

### **2.9.1 Paramètres du compte SIP**

Sur Linphone, les paramètres suivants sont utilisés :


### **2.10.2 Activation de la vidéo**

- Activation de l’option **appel vidéo**
    
- Sélection de la caméra
    
- Activation du codec **H.264**

---

## **2.11 Tests et validation**

### **2.11.1 Test d’enregistrement SIP**
```
pjsip show contacts
```
### **2.11.2 Test d’appel vidéo**

- L’extension **100** appelle l’extension **101**
    
- L’appel est établi avec succès
    
- La vidéo est transmise dans les deux sens

### 2.11.3 Supervision des appels
```
pjsip show channels
core show channels verbose
```
---

## **2.12 Problèmes rencontrés et solutions**
| Problème       | Solution                                   |
| -------------- | ------------------------------------------ |
| Pas de vidéo   | Activation des codecs vidéo                |
| Problème NAT   | Configuration `local_net` et `ice_support` |
| Absence de son | Vérification RTP et pare-feu               |
## **2.13 Conclusion**

Ce chapitre a permis de mettre en place avec succès une **solution de téléphonie IP intégrant les appels vidéo** à l’aide d’Asterisk. Les tests réalisés ont confirmé la stabilité, la compatibilité multi-réseaux et la qualité des communications vidéo.

## 🔚 Transition vers le chapitre suivant

> _Le chapitre suivant sera consacré à la sécurisation du serveur Asterisk et à l’optimisation des performances._

