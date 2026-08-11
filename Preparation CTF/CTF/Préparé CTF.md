### 10 commandes de Stéganographie (avec Steghide, Outguess, etc.)

- `steghide embed -ef secret.txt -cf image.jpg -p motdepasse` : Cache un fichier texte (`secret.txt`) dans une image (`image.jpg`) avec un mot de passe.

- `steghide extract -sf image.jpg -p motdepasse` : Extrait les données cachées dans une image.

- `steghide info image.jpg` : Affiche les informations sur d'éventuelles données cachées dans l'image.

- `stegseek image.jpg` : Tente de retrouver le mot de passe et d'extraire les données d'une image stéganographiée par force brute (dictionnaire).

- `outguess -k "motdepasse" -d secret.txt image.jpg output.jpg` : Cache un message dans une image en modifiant les bits de poids faible avec Outguess.

- `outguess -k "motdepasse" -r image.jpg extracted.txt` : Extrait un message caché via Outguess d'une image.

- `zsteg -a image.png` : Analyse une image PNG pour détecter des données cachées sur les canaux LSB (Least Significant Bit).

- `binwalk image.jpg` : Analyse un fichier pour y trouver des fichiers imbriqués ou cachés (comme une archive ZIP dans un JPG).

- `foremost -i image.jpg` : Extrait automatiquement les fichiers reconnus (en-têtes) cachés à l'intérieur d'un autre fichier.

- `cat secret.txt >> image.jpg` : Méthode basique (append) pour coller la fin d'un fichier à la suite d'une image.

### 10 commandes pour l'Analyse Forensique (Investigation numérique)

- `volatility -f memory.raw imageinfo` : Identifie le profil d'un dump mémoire RAM pour l'analyser.

- `volatility -f memory.raw --profile=Win7SP1x64 pslist` : Liste les processus actifs dans un fichier dump mémoire.

- `strings -a suspect_file` : Extrait toutes les chaînes de caractères lisibles d'un fichier binaire ou d'une image disque.

- `exiftool image.jpg` : Affiche toutes les métadonnées (date, appareil, géolocalisation) d'un fichier multimédia.

- `foremost -T -i disk.img` : Récupère (carve) des types de fichiers supprimés d'une image disque.

- `fls -r -d disk.img` : Liste les fichiers supprimés ou alloués d'une partition brute.

- `icat disk.img 1234 > recovered.dat` : Restaure un fichier à partir de son numéro d'inode (adresse sur le disque).

- `dd if=/dev/sdb of=/evidence/image.dd bs=64K conv=noerror,sync` : Crée une copie conforme (copie bit à bit) d'un support de stockage.

- `sha256sum fichier.bin` : Calcule l'empreinte cryptographique SHA-256 d'un fichier pour vérifier son intégrité.

- `mactime -b bodyfile.txt` : Génère une frise chronologique (timeline) des accès, modifications et créations de fichiers (MAC times).


### Énumération et découverte de fichiers

- `gobuster dir -u http://target.com -w wordlist.txt`: Trouve les dossiers et fichiers cachés sur un serveur web.

- `ffuf -u http://target.com -w list.txt`: Alternative rapide pour le fuzzing de chemins ou de paramètres.

- `nikto -h http://target.com`: Scanne un serveur web à la recherche de configurations faibles ou de fichiers obsolètes.

Analyse des requêtes et manipulation

- `curl -I http://target.com`: Affiche uniquement les en-têtes HTTP de la réponse du serveur.

- `sqlmap -u "http://target.com" --dbs`: Automatise la recherche et l'exploitation d'injections SQL.

- `nc -lvnp 4444`: Ouvre un écouteur Netcat pour réceptionner un reverse shell.

### Attaques ciblées et décodage

- `hydra -l admin -P passlist.txt http-post-form "/login.php:user=^USER^&pass=^PASS^:F=Invalid"`: Réalise une attaque par force brute sur un formulaire de connexion.

- `base64 -d`: Décode une chaîne encodée en Base64, très fréquent pour les flags ou cookies cachés.

- `python3 -c 'import pty; pty.spawn("/bash")'` : Améliore un shell basique en un shell interactif complet après une RCE.

- `proxychains burpsuite`: Force le trafic d'un outil à passer par un proxy ou un tunnel spécifique.