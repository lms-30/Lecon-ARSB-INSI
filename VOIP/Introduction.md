VOIP : est une technologie qui permet de passer des appels téléphoniques en utilisant une connexion Internet à haut débit au lieu des lignes téléphoniques traditionnelles.

### sécurité de communication avancée

La sécurité de la VoIP ==implique des mesures pour protéger les communications contre diverses menaces comme le piratage, l'écoute clandestine, le déni de service et le vol de données==. Pour sécuriser les systèmes VoIP, il est essentiel d'utiliser des protocoles de chiffrement (comme le chiffrement TLS + SRTP), de changer tous les mots de passe par défaut et de renforcer l'authentification.



#### La technologie VoIP

La technologie VoIP utilise ==le **protocole Internet (IP)** pour transmettre la voix numérisée sous forme de paquets de données sur Internet, au lieu des lignes téléphoniques traditionnelles==. Les éléments clés incluent les **CODECS** qui compressent et décompressent le signal vocal, le **Protocole de Session Initialisation (SIP)** pour gérer les appels, et le **Protocole RTP** pour transporter les données en temps réels.

mampiasa technologie **Asterisk**(Logiciel serveurs linux) ,SOFTPHONE (Client)

> [!NOTE] VOIP
> - CODECS


### Objectifs

L'objectif de la VoIP est de permettre les communications vocales (et d'autres données multimédias) via Internet, en utilisant des réseaux IP au lieu des lignes téléphoniques traditionnelles.
### Le point Clé de la VOIP

Le point clé de la VoIP est la **transformation de la voix en paquets de données numériques pour la transmettre via Internet**.


### Type de service VoIP

##### 1. L'utilisation de téléphone IP
Des téléphones normeaux mais au lieux d'un RJ11 contiennent un Ethernet RJ45.

 Il s'agit d'un appareil spécialement conçu pour la VoIP qui se connecte directement à un réseau IP (comme Internet) via un câble Ethernet. Il numérise les signaux vocaux en paquets de données pour la transmission.
##### 2. Computer to Computer
Cette méthode implique l'utilisation d'un logiciel ou d'une application (souvent appelée "softphone") installée sur un ordinateur, une tablette ou un smartphone. Le microphone et les haut-parleurs (ou un casque) de l'appareil sont utilisés pour la communication.

##### 3. Utlisation de l'ATA (Adapteur Téléphonique Analogique)
Cet adaptateur fait le pont entre un téléphone analogique traditionnel (non-IP) et un réseau IP. Il convertit le signal analogique de la voix en paquets de données numériques pour la transmission sur Internet.

### **Standards VoIP**

- **H323**
    - _le premier protocole développé pour permettre des communications multimédias_    
- **MGCP**
    - _un protocole permettant de contrôler les passerelles multimédia qui assurent la conversion de la voix et de la vidéo entre les réseaux IP_
- **RTP**
    - _un protocole de communication informatique accordé des fonctions temps réel_
- **SIP**
    - _un protocole standard ouvert de gestion de sessions multimédia_  
- **IAX**
    - _un protocole qui permet la communication entre serveurs asterisk uniquement_

### Serveurs VOIP
| **Logiciel**                      | **Environnement**                              | **Protocole**                           |
| --------------------------------- | ---------------------------------------------- | --------------------------------------- |
| **Asterisk**                      | Linux, Solaris, Windows, Mac OS X, BSD         | H323, SIP, IAX, ...                     |
| **Jitsi**                         | Linux, Solaris, Windows, Mac OS X              | SIP/SIMPLE, Jabber, ...                 |
| **Jingle Nodes (serveur Mumble)** | Windows, Linux                                 | Jingle                                  |
| **Mumble**                        | Windows, Linux, Mac OS                         | Mumble-protocole                        |
| **FreeSwitch**                    | Windows, Linux, Mac OS X                       | SIP, H323, Jingle, IAX, SIP/SIMPLE, ... |
| **VOCAL**                         | Linux, Solaris                                 | SIP, H.323, MGCP, RTP                   |
| **Microsoft Lync Server**         | Windows, Windows Phone, Android, Nokia Symbian | XMPP, SIP, SIP/SIMPLE, RTP, ...         |
**Note en bas :**

> Il existe un grand nombre de serveurs VOIP utilisant des protocoles différents. Pour notre projet on va utiliser le serveur Asterisk.

### Clients VOIP
|**Logiciel**|**Description**|
|---|---|
|**Windows Live Messenger**|logiciel client propriétaire (Microsoft) offre les services de VoIP et de visioconférence (utilise son protocole MSNP).|
|**Skype**|un logiciel propriétaire permettant la messagerie instantanée, transfert de fichiers et visioconférence, la téléphonie.|
|**X-Lite**|logiciel libre gère voix, vidéo et chat utilise les protocoles SIP, fonctionne très bien avec la Freebox.|
|**Ekiga**|Client libre offre chat, voix et vidéo. Compatible SIP, H.323.|
|**Zoiper**|génération SIP et IAX softphone compatible avec la plateforme Asterisk, permet l’appel téléphonique, audio, fax.|
|**SFLPhone**|une application libre de téléphonie sur Linux Compatible avec les protocoles de communication SIP et IAX2, RTP.|
|**Team Speak**|logiciel propriétaire d’audioconférence permet de discuter à plusieurs dans des canaux, avec d’autres utilisateurs.|

**Note en bas :**

> On va installer le Zoiper sur notre système.


### Installation Asterisk

• Tout d’abord, il faut installer les pilotes Zaptel pour ajouter des cartes analogiques :
```
sudo apt-get install gcc zaptel zaptel-source
sudo module-assistant auto-install zaptel
sudo reboot

```
**• On télécharge Asterisk du site**  : http://www.asterisk.org/downloads

• On passe à l’installation d’Asterisk :
```
sudo apt-get install asterisk
```
• Modifier les paramètres d’Asterisk pour qu’il démarre au démarrage du PC :
```
sudo vim /etc/default/asterisk
```
Puis mettre :
```
RUNASTERISK=yes
RUNASTSAFE=no
```
• (Optionnelle) Pour installer les paquets français de Asterisk, la commande est la suivante :
```
sudo apt-get install asterisk-prompt-fr
```
### Configuration Astérisk
On s'intéresse essentiellement aux 2 fichiers sip.conf et extensions.conf

**Terminal :**
```
chibeb@ubuntu:~$ sudo -i
[sudo] password for chibeb:
root@ubuntu:~# cd /etc/asterisk/
root@ubuntu:/etc/asterisk# gedit sip.conf
root@ubuntu:/etc/asterisk# gedit extensions.conf
```
**Fichier extensions.conf :**
```
*extensions.conf (/etc/asterisk)
File Edit View Search Tools Docum

Open - Save

*extensions.conf* x
[default]
exten => 200,1,Dial(SIP/100,10,tr)
exten => 100,1,Dial(SIP/200,10,tr)
exten => 300,1,Dial(SIP/300,10,tr)

;[VICTORIAT]
context=sip
callerid=100>
[100]
username=100
secret=100
type=friend
allowguest=
context=sip
callerid=100>
```
**Notes au tableau (en bas) :**
- GIEC
- Quelques annotations manuscrites difficiles à lire complètement
- VICTORIAT (visible)
- CBAM/SSM (partiellement visible)

### Installation de Zoiper

**Sur Ubuntu**

1. Téléchargez le package de [http://www.zoiper.com/download_list.php](http://www.zoiper.com/download_list.php)
2. Le décompresseur
3. Mettre l'exécutable zoiper sur bureau ou dans un autre dossier
4. Le lancer (si ça n'a pas marché, il faut faire chmod +x zoiper et relancer)

**Sur Windows**

1. Téléchargez le logiciel du [http://www.zoiper.com/download_list.php](http://www.zoiper.com/download_list.php)
2. Il suffit de suivre l'assistant d'installation : suivant, choix du dossier, installer...

**Notes au tableau (en bas) :**

- Annotations manuscrites partiellement visibles
- Quelques termes techniques difficiles à déchiffrer complètement

### **Outil d'écoute utilisé**

**WIRESHARK**

un logiciel libre d'analyse de protocole, ou « packet sniffer », utilisé dans l'analyse de réseaux informatiques, le développement de protocoles, l'éducation et la rétro-ingénierie, mais aussi le piratage.

**Notes au tableau (en bas) :**

- Annotations manuscrites partiellement visibles