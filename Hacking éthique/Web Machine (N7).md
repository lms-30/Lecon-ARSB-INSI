
1. Analyse du réseau
```
sudo netdiscover -i wlo1
```

![[Pasted image 20250706165636.png]]
l'address IP du machine vulnérable est 192.168.193.160

Alors, il est temps de la scanner les port ouvert de la machine cible

```
sudo nmap -sS -sV -p- 192.168.193.160 -vv
```
Ça va  donné de ça :

![[Pasted image 20250706170114.png]]

Nous voyons rapidement dans la capture d'écran ci-dessus qu'un seul port est ouvert... Le port **80**, qui exécute un serveur **Web Apache httpd 2.4.46**


Je vais utilisé **Dirbuster** pour trouvez les fichiers cachées enfin de trouver les informations sur les utilisateurs dur serveur Web

```
dirbuster
```
![[Pasted image 20250706173032.png]]

voici le résultat: 

![[Pasted image 20250706174041.png]]

D'après le résultat, on voit qu'il y a une page très intéressant qui apparaît: /exploit.html

On va jeté un œil sur cette page pour voir ce qu'il donne

![[Pasted image 20250706174013.png]]
Lorsque j’inspecte les codes sources de cette page il y a une requête qui se lance lorsqu'on clique sur le bouton  **envoyer**. Mais lorsque j'essaie de téléchargé un fichier sur mon PC hôte et j'ai cliqué sur le bouton **envoyer**, j'ai reçue une message d'erreur. 

Après, j'inspecte les codes sources de cette page, et ça donne comme ça :


![[Pasted image 20250706175806.png]]

Et c'est dans ce moment là qui j'ai réalisé qu'il faut changé  **localhost** par l'ip du machine Cible parce que cette machine n'est pas hébergé localement sur Mon PC mais à distance sur VirtualBox. 

Lorsque j'essaie cette méthode, Il affiche ça:

![[Pasted image 20250706181250.png]]
Grâce à cette méthode que nous avons la première partie du drapeau pour Webmachine (N7)

Et Maintenant, On va identifier le deuxième partie du FLAG 

J'ai passé beaucoup de temps à chercher un point d'ancrage pour explorer l'autre partie du drapeau.La liste de mots que j'avais utilisée s'est épuisée, sans résultat.Je suis finalement tombé sur la vidéo de démonstration produite par le YouTubeur « Technix », où il a identifié le répertoire nécessaire comme étant « /enter_network ». Une fois l'emplacement exact identifié, j'ai essayé de reconstituer le cheminement pour arriver à cette conclusion en consultant plusieurs listes de mots. Cependant, l'entrée « /enter_network » n'apparaissait dans aucune des listes.







