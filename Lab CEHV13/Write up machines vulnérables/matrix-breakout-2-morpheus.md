### Identification de l'adresse IP du cible
![[Pasted image 20260621100400.png]]
### Scannage de port
J'ai commencé l'évaluation en effectuant une analyse de port complète pour identifier les ports ouverts, les services en cours d'exécution et les points d'entrée potentiels sur la machine cible. J'ai utilisé ma commande standard
Nmap:
```
sudo nmap -sC -sV -O -p- -T4 192.168.43.134
```
- sC active les scripts NSE par défaut pour l’énumération de base 
- sV Effectue la detection de version de service
- O tente la detection de OS
- p- Analyse tous 65,535 ports TCP
- T4 accélère le scan

Après avoir identifier l'adresse IP de la cible (192.168.43.134) et exécuté une analyse complète du port TCP à l'aide de Nmap pour énumérer les ports ouverts et découvrir les services exécutant sur la machine. La sortie ci-dessous m'a donné une vue claire des services exposés du système et m'a aidé à commencer à foçonner la surface d'attaque pour une exploitation plus poussée.
![[Pasted image 20260621101630.png]]

- Cela m'a dit que l'hôte était vivant et réactif, avec trois ports TCP ouverts : 22, 80 et 81. La majorité des autres ports on fermés ou filtrés, indiquant un pare-feu ou une configuration de service raisonnablement bien entretenu.
- Le port 22 était ouvert. Ce port est utilisé pour accès à domicile. La version utilisé est OpenSSH 8.4p1, qui est standard pour les distributions basées sur Debian. Bien qu'aucune vulnérabilité immédiate n'ai été absorvée à partir de la seule version, ce service peut devenir une cible clé plus tard si je découvre des informations d'identification (via la force brute, les creds par défaut ou la réutilisation du mot de passe) ou trouver un moyen de pivoter à partir d'une vulnérabilité Web.
- Port 80 - HTTP (apache 2.4.51 sur Debian). Il s'agit d'un serveur web  exécutant Apache 2.4.51. Le htt-title révélé le nom "Morpheus:1", qui peut être le nom de défi ou de la boite elle-même; potentiellement un indice de pointe ou de marque. Apache 2.4.51 a des vulnérabilités connues, surtout si mzl configurées ou si certains modules sont activés. Comme les serveurs web sont souvent le premier point d'entrée, cela est devenue un domaine d'intérêt immédiat pour moi.
- j'ai utilisé la commande de bouclesuivant pour télécharger l'image pour une examen ultérieur; dans le cas où elle contenait des indices cachées ou des données intégrées:
![[Pasted image 20260621103653.png]]
- Cela m'a permis de récupérer le fichier directement à partier du serveur Web local de la cible et de l'enregistrer sur ma machine pour une analyse hors ligne ultérieurs
- J'avais prévu de faire tourner des outils tels que exiftool, steghide, stegseek, ou stecracker sur l'image pour verifier les anomalies de métadonnées ou le conenu stéganographique qui pourraient aider à l'escalader de privilège ou à l'énumération de l'utilisateur.
![[Pasted image 20260621104306.png]]

- L port 81- HTTP (nginx 1.18.0); Avec Auth de Base. Ce secode Service Web fonctionne sur une port HTTP non standard (81) et utilise nginx 1.18.0 La réponse 401 indique que l'authentification de base HTTP est activée, le rayaume étant étiqueté "Meeting Place". Cela peut indiquer un portail de connexion, une page intranet ou une zone restreinte destinée uniquement à certains utilisateurs.

