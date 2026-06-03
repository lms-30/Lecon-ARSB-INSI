## Configuration du machine

![[Lab CEHV13/Write up machines vulnérables/captures/im1.png]]

Réseau : Accès par pont

### Interface web de cette machine :

http://192.168.100.128
![[Lab CEHV13/Write up machines vulnérables/captures/im2.png]]
## ÉTAPE 1 – Scan des ports (Nmap)
```
sudo nmap -sC -sV -A 192.168.100.128
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

J'aisseyer de trouver une chemin pour exploite l'Usermin, mais enfin, j'ai fait une inspection sur la page de du web du serveur:
![[im11.png]]
```
don't worry one will get here, it's to share with you my access. It's encrypted :

++++++++++[>+>+++>+++++++>++++++++++<<<<-]>>++++++++++++++++.++++.>>+++++++++++++++++.----.<++++++++++.-----------.>-----------.++++.<<+.>-.--------.++++++++++++++++++++.<------------.>>---------.<<++++++.++++++.
```
Donc c'est claire le texte a dit: le mot de passe de l'utilisateur cyber est chiffré comme le commentaire montre 

Alors, on va décrypter le message pour vour le mot de passe en utilisant l'outil beef:
```
echo '++++++++++[>+>+++>+++++++>++++++++++<<<<-]>>++++++++++++++++.++++.>>+++++++++++++++++.----.<++++++++++.-----------.>-----------.++++.<<+.>-.--------.++++++++++++++++++++.<------------.>>---------.<<++++++.++++++.' > brainfuck.bf
```
et exécutons le commade suivant :
```
beef brainfuck.bf
```
Résultat :
![[im12.png]]
donc le mode passe de l'tilisateur cyber est : 
```
.2uqPEfj3D<P'a-3
```
## Connection sur le page de Usermin
![[im13.png]]

utilisateur : cyber
mot de passe : .2uqPEfj3D<P'a-3
![[im14.png]]

## Prochaines étapes sur Usermin :

#### Obtenir un reverse shell
Depuis l'interface Usermin, Nous devrions avoir accès à plusieurs fonctionnalités. comme : 

Terminal / Command Shell :
![[im15.png]]
![[im23.png]]

### Vérification et Exploration

##### Vérifie  l'accès
```
whoami
id
pwd
```
![[im22.png]]

##### Liste les fichiers et Récupère le flag user :
```
ls
cat user.txt
```
![[im16.png]]
Et maintenent, on a le le flag user :`3mp!r3{You_Manage_To_Break_To_My_Secure_Access}`


##### Escalade de Privilèges

Analyse le binaire tar :
```
file tar
```
![[im17.png]]

le fichier tar est exécutable par 