Iptables est une interface en ligne de commande permettant de configurer **Netfilter**. En plus de Iptables, depuis la version 8.04, Ubuntu est installé avec la surcouche UFW qui permet de contrôler simplement Netfilter, UFW est toutefois moins complet que iptables.

Cette documentation est une introduction à Iptables, elle est destinée à ceux qui souhaitent mettre en place un pare-feu et/ou un partage de connexion, sur une machine Linux, sans passer par une interface graphique. Seule la table par défaut (Filter) d'Iptables est présentée ici et seules les chaînes utilisées par Filter (Input, Forward et Output) y sont exposées.

**iptables** existe aussi pour **ipv6**, pour cela il suffit d'utiliser la commande **ip6tables** au lieu de iptables.


## Configuration du pare-feu
Nous allons configurer notre pare-feu de la manière suivante :

- On bloque tout le trafic entrant par défaut.
- On autorise au cas par cas : le trafic appartenant ou lié à des connexions déjà établies et le trafic à destination des serveurs (web, ssh, etc.) que nous souhaitons mettre à disposition.
- 
Afin de ne pas avoir de problème au moment où on crée ces règles, nous allons d'abord créer les autorisations, puis nous enverrons le reste en enfer.

En tapant : 
```
sudo iptables -L
```
Une liste de nos règles actuelles est affichée.

Si vous avez déjà modifié la configuration et que vous voulez la réinitialiser, tapez :
```
sudo iptables -F
sudo iptables -X
```
#### Autoriser le trafic entrant d'une connexion déjà établie
Pour permettre à une connexion déjà ouverte de recevoir du trafic :
```
sudo iptables -A INPUT -m conntrack --ctstate ESTABLISHED -j ACCEPT
```
#### Permettre le trafic entrant sur un port spécifique
Pour permettre le trafic entrant sur le port 22 (traditionnellement utilisé par SSH, vous devrez indiquer à iptables tout le trafic TCP sur le port 22 de votre adaptateur réseau.
```
sudo iptables -A INPUT -p tcp -i eth0 --dport ssh -j ACCEPT
```
Cette commande ajoute une règle (`-A`) à la chaîne contrôlant le trafic entrant _INPUT_, pour autoriser le trafic (`-j ACCEPT`), vers l'interface (`-i`) _eth0_ et à destination du port (`--dport`) _SSH_ (on aurait pu mettre 22).

Acceptons tout le trafic web (`www`) entrant :
```
sudo iptables -A INPUT -p tcp -i eth0 --dport 80 -j ACCEPT
```
#### Bloquer le trafic
Pour la raison de sécurité, il faut donné une autorisation sur le port spécifique, et bloquez reste enfin de reduire la surface d'attaque.

Nous allons en fait modifier la « politique par défaut » (_policy_) de la chaîne _INPUT_ : cette décision (_DROP_) s'applique lorsque aucune règle n'a été appliquée à un paquet. Donc, si la tentative de connexion n'est permise par aucune des règles précédentes, elle sera rejetée.
```
sudo iptables -P INPUT DROP
```

> [!NOTE] warning
>  a ne pas utiliser sur un serveur distant !
##### Autre méthode, par exemple pour les server
**Un autre moyen de procéder** est l'ajout en fin de chaîne d'une règle supprimant les paquets (les paquets autorisés par les règles précédentes n'atteindraient pas celle-ci), _via_ `iptables -A INPUT -j DROP`, mais il faudrait alors faire attention à la position des futures règles.

#### Autoriser le trafic local

 Ajouter une règle pour _loopback_. Par exemple, nous pourrions l'insérer en 2e position :

```
sudo iptables -I INPUT 2 -i lo -j ACCEPT
```
lister les règles plus en détail.
```
sudo iptables -L -v -n
```
#### Autoriser les requêtes ICMP (ping)
Il peut-être utile de valider les réponses aux requêtes "ping", ne serait-ce que pour s'assurer que le poste est toujours en activité.

- On autorise le PC a faire des pings sur des IP externes et à répondre aux requêtes "ping"
```
sudo iptables -A OUTPUT -p icmp -m conntrack --ctstate NEW,ESTABLISHED,RELATED -j ACCEPT
```
- On autorise les pings
```
sudo iptables -A INPUT -p icmp -j ACCEPT
```
#### Supprimer une règle
Si nous nous étions trompé dans la création d'une règle et que cela nous bloque une connexion, nous pouvons supprimer une seule entrée plutôt que de tout réinitialiser.

Tout d'abord vous listez l'ensemble de vos règles avec l'affichage des lignes :
```
sudo iptables -L --line-numbers
```
#### Sauvegarder vos règles
Passer en mode superutilisateur
```
sudo -s iptables-save -c
```



## Script iptables
Ce script est un exemple, il est à adapter à vos besoins. Il peut toutefois être utilisé pour une utilisation courante, il offre une plutôt bonne "protection" pour un usage desktop.
```
#!/bin/bash
 
iptables-restore < /etc/iptables.test.rules
 
## Script iptables by BeAvEr.
 
## Règles iptables.
 
## On flush iptables.
 
iptables -F
iptables -X
iptables -t nat -F
iptables -t nat -X
iptables -t mangle -F
iptables -t mangle -X
 
## On drop les requêtes ICMP (votre machine ne répondra plus aux requêtes ping sur votre réseau local).
 
iptables -A INPUT -p icmp --icmp-type echo-request -j DROP
 
## On accepte le Multicast.
 
iptables -A INPUT -m pkttype --pkt-type multicast -j ACCEPT
 
## On drop tout le trafic entrant.
 
iptables -P INPUT DROP
 
## On drop tout le trafic sortant.
 
iptables -P OUTPUT DROP
 
## On drop le forward.
 
iptables -P FORWARD DROP
 
## On drop les scans XMAS et NULL.
 
iptables -A INPUT -m conntrack --ctstate INVALID -p tcp --tcp-flags FIN,URG,PSH FIN,URG,PSH -j DROP
 
iptables -A INPUT -m conntrack --ctstate INVALID -p tcp --tcp-flags ALL ALL -j DROP
 
iptables -A INPUT -m conntrack --ctstate INVALID -p tcp --tcp-flags ALL NONE -j DROP
 
iptables -A INPUT -m conntrack --ctstate INVALID -p tcp --tcp-flags SYN,RST SYN,RST -j DROP
 
## Dropper silencieusement tous les paquets broadcastés.
 
iptables -A INPUT -m pkttype --pkt-type broadcast -j DROP
 
## Permettre à une connexion ouverte de recevoir du trafic en entrée.
 
iptables -A INPUT -m conntrack --ctstate ESTABLISHED -j ACCEPT
 
## Permettre à une connexion ouverte de recevoir du trafic en sortie.
 
iptables -A OUTPUT -m conntrack ! --ctstate INVALID -j ACCEPT
 
## On accepte la boucle locale en entrée.
 
iptables -I INPUT -i lo -j ACCEPT
 
## On log les paquets en entrée.
 
iptables -A INPUT -j LOG
 
## On log les paquets forward.
 
iptables -A FORWARD -j LOG 
 
exit 0
```
