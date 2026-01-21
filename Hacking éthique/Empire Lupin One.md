L'Empire : LupinOne fait partie de la série « Empire » de machines vulnérables disponibles sur VulnHub. La VM présente un niveau de difficulté moyen, et l'objectif est d'obtenir un accès root et de capturer le drapeau final.

# A. Reconnaissance

Tout d’abord, je vais trouver l’adresse IP cible à l’aide de l’ `netdiscover`outil.

```
sudo netdiscover -i wlo1
```
![[Pasted image 20250706201656.png]]

J'ai trouvé que l'adresse IP cible est 192.168.56.123.

Après cela, j'ai effectué une analyse pour voir les services en cours d'exécution et les ports ouverts.

```
sudo nmap -A -p- 192.168.93.216 -o nmap.txt
```

![[Pasted image 20250706201420.png]]

## Les résultats sont :

- 22 SSH
- 80 HTTP
- répertoire /robots.txt
- répertoire /~myfiles
# B. Dénombrement

Le premier est le port 80.

[[http://192.168.193.216]]

![[Pasted image 20250706202120.png]]

Il n'y a qu'une photo d'Arsène Lupin sur la page web. Vérifions la source.

![[Pasted image 20250706202633.png]]

Il y a quelques informations, mais ce n'est pas un indice. Vérifions le `/robots.txt`fichier que j'ai trouvé plus tôt.

![[Pasted image 20250706202819.png]]
Et vérifions-les `/~myfiles`aussi.

![[Pasted image 20250706202926.png]]
Une erreur 404 s'affiche sur la page web

Dans ce cas, je vais utilisé une analyse de répertoires pour trouvez plus d'information


```
ffuf -w /usr/share/dirbuster/wordlists/directory-list-2.3-medium.txt -u http://192.168.193.216/~FUZZ
```
![[Pasted image 20250706205242.png]]

Oui, j'ai trouvé un autre répertoire nommé `secret`. Regardons son contenu.

[[http://192.168.193.216/~secret]]

![[Pasted image 20250706205526.png]]
## Les résultats sont :

- Un utilisateur nommé icex64
- Il existe un fichier de clé privée SSH caché
- Il peut être déchiffré en utilisant la liste de mots accélérée

Je vais effectuer à nouveau un fuzzing pour rechercher ce fichier caché

Pour trouver cette clé ssh privée secrète, nous utilisons à nouveau le fuzzing avec l'aide de ffuf une fois de plus et trouvons le fichier texte ( **mysecret.txt** ).

```
ffuf -c -ic -w /usr/share/dirbuster/wordlists/directory-list-2.3-medium.txt -u 'http://192.168.193.216/~secret/.FUZZ' -fc 403 -e .txt,.html
```

![[Pasted image 20250709191802.png]]

Nous explorons le fichier mysecret.txt avec un navigateur web. Il semble s'agir d'une **clé SSH privée** , mais elle est chiffrée. Nous l'avons examinée minutieusement et avons découvert qu'elle était chiffrée en **base 58** .

[[http://192.168.193.216/~secret/.mysecret.txt]]

![[Pasted image 20250709192426.png]]

Nous avons cherché un décodeur base 58 en ligne et avons trouvé [Browserling](https://www.browserling.com/tools/base58-decode) . Il s'agit du décodeur base 58 en ligne le plus basique pour les développeurs et programmeurs web.

Saisissez simplement vos données dans le formulaire ci-dessous, cliquez sur le bouton « Décoder en base 58 » et le système vous fournira une chaîne codée en base 58. Nous avons obtenu notre **clé SSH** après l'avoir décodée.

![[Pasted image 20250709200321.png]]

### Exploitation

Étant donné que l'auteur a partagé quelques conseils liés à la phrase secrète de la clé SSH, nous utilisons donc ssh2john pour obtenir la valeur de hachage de la clé ssh.

Créer une fichier nommé shhkey et copions la de dans les fichier decoder par base 58 decoder
```
nano shhkey
```

![[Pasted image 20250709200532.png]]

et apres on va essayé de decoder cette clé avec le scripte de ssh2jhon 

```
locate ssh2john
/usr/share/john/ssh2john.py sshkey > hash
```
Maintenant, utilisez John pour déchiffrer la valeur de hachage.
```
john --wordlist=/usr/share/wordlists/fastrack.txt hash
```
En quelques secondes, Bingo ! Nous avons obtenu le mot de passe de la clé SSH ( **P@55w0rd!** ).

![[Pasted image 20250709204409.png]]
Nous avons toutes les conditions requises pour la connexion SSH. Utilisez notre nom d'utilisateur icex64, notre clé SSH et notre mot de passe cracké ( **P@55w0rd!** ).


