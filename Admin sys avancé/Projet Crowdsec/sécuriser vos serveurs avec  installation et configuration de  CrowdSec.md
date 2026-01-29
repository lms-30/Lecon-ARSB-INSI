## Présentation de Crowdsec

crowdsec est un outil Open source qui permet de « sécuriser » ou plutôt d’ajouter une couche de sécurité à vos serveurs Linux (bientôt Windows aussi) en détectant les attaques réseaux (scan de ports, brute force SSH, scan de contenu web …) et de bannir les adresses IP.

Si vous connaissez fail2ban, Crowdsec fait la même chose mains mieux :

- Consomme très peu de ressources
- Mutualisation des adresses IP avec une base de données partagées entre tous les utilisateurs Crowndsec
- Facile à utiliser

Pour faciliter l’échange de configuration entrer les utilisateurs, il existe un [hub](https://hub.crowdsec.net/) (sorte de marketplace) où vous trouverez des configurations pour sécuriser votre serveur.

## Prérequis afin de pouvoir utiliser Crowdsec

Un des prérequis nécessaire à l’utilisation de Crowdsec, c’est d’avoir un firewall (IPTABLE) d’actif sur votre serveur.

S’il n’y a pas de firewall, Crowdsec ne pourra pas ajouter une règle pour bloquer le trafic.

Avant d’activer votre firewall, il faut s’assurer que le trafic entrant 80, 443 et 22 sont autorisés.

Commencer par vérifier si le firewall est active avec la commande ci-dessous :
```
sudo ufw status
```
Si celui-ci est désactivé, on va commencer par ajouter les règles de base pour le trafic entrant : 22, 80 et 443 :
```
sudo ufw allow 22 
sudo ufw allow 80 
sudo ufw allow 443
```
Pour chaque règle (commande), un message de confirmation s’affiche pour indiquer que la règle est ajoutée.

Maintenant que les règles sont créées, activer ufw :
```
sudo ufw enable
```
Maintenant que ufw est activé, entrer la commande ci-dessous pour afficher le statut et la liste des règles :
```
sudo ufw status verbose
```
Une dernière chose à faire avant d’installer Crowdsec, c’est d’activer les logs du firewall, car ils seront analysés afin de détecter les attaques.

Entrer la commande ci-dessous pour activer les logs :
```
sudo ufw logging on
```
La commande retourne : `Logging enabled`.

Les logs s’enregistrent dans le fichier `/var/log/syslog`.

Pour s’assurer que les logs sont bien enregistrés, depuis un autre serveur, on peut lancer un telnet sur un port non ouvert :
```
telnet ip 514
```
Notre serveur est prêt, nous allons passer à l’installation de Crowdsec.

## Crowdsec installation

L’installation de Crowdsec est très simple, pendant l’installation, il va aussi détecter les différents composants (Nginx, Apache2, MySQL …) qu’il peut surveiller et se configurer « automatiquement ».

1. Ajouter le dépôt à votre serveur en utilisant le script ci-dessous :
```
curl -s https://packagecloud.io/install/repositories/crowdsec/crowdsec/script.deb.sh | sudo bash
```
2. Mettre à jour la liste des paquets :
```
sudo apt update
```
3. Installer Crowdsec :
```
sudo apt install crowdsec
```
Sur la capture ci-dessous, le processus d’installation où l’on peut voir la découverte et l’installation et la configuration automatiquement pour sshd et nginx.



Crowdsec est maintenant installé et « fonctionnel ».

Avant de passer à la configuration et à l’installation d’un Bouncer, je vais vous montrer comment interagir avec le client cscli.

## Utilisation du client cscli – Crowdsec

Un client en ligne de commande est disponible pour Crowdsec afin de pouvoir la configurer et le superviser.

Pour afficher la liste des commandes de disponible utiliser la commande :
```
cscli
```
La commande metric permet d’afficher divers statistiques liés au service crowdsec :
```
cscli metrics
```
Comme on peut le voir sur la capture, on voit les fichiers sources utilisés et leurs statistiques et aussi les différents parsers utilisés qui permettent de détecter

Pour afficher les logs qui ont matché avec une règle :
```
cscli alerts list
```
Pour avoir le détail d’une alerte :
```
cscli alerts inspect ID
```
Pour afficher la liste des bannissements (blocage) :
```
cscli decisions list
```
Afficher la liste des parsers :
```
cscli parsers list
```
Afficher la liste des scenarios :
```
cscli scenarios list
```
Le dernier éléments que l’on peut avoir est aussi les postoverflows :
```
cscli postoverflows list
```
postoverflows sont des fichiers de configuration qui contiennent des whitelists pour éviter des blocages de certains services comme CloudFlare, les bots d’indexation …

## Installer un bouncer

Maintenant, on va voir comment installer un Bouncer, qui va nous permettre de bloquer les attaques.

La liste des Bouncer est disponible sur le [Hub Crowdsec](https://hub.crowdsec.net/browse/#bouncers). Il y a plusieurs bloqueurs disponibles que vous pouvez mettre :

- Firewall / iptable, qui permet de mettre un blocage avec le firewall du serveur
- WordPress qui a l’aide d’un plugin va empêcher l’accès site
- Nginx
- [Cloudflare](https://github.com/crowdsecurity/cs-cloudflare-bouncer)
- …

> Dans le tutoriel, je vais vous expliquer comment mettre en place le bouncer : [cs-firewall-bouncer](https://hub.crowdsec.net/author/crowdsecurity/bouncers/cs-firewall-bouncer).

### Installation automatique depuis le dépôt

Il est maintenant possible d’installer automatiquement certain bouncer disponible sur le dépôt et c’est notamment le cas du bouncer : cs-firewall-bouncer-iptables.

Entrer la commande ci-dessous pour installer le bouncer :
```
sudo apt install crowdsec-firewall-bouncer-iptables
```
### Installation manuel du bouncer firewall iptable

Aller sur la page au niveau du hub Crowdsec ou Github :

- [CrowdSec Hub](https://hub.crowdsec.net/author/crowdsecurity/bouncers/cs-firewall-bouncer)
- [crowdsecurity/cs-firewall-bouncer: Crowdsec bouncer written in golang for firewalls (github.com)](https://github.com/crowdsecurity/cs-firewall-bouncer)

> Les instructions qui vont suivre sont valides au moment de la rédaction de ce tutoriel, le bouncer peut avoir évolué.

1. Télécharger les sources :
```
wget https://github.com/crowdsecurity/cs-firewall-bouncer/releases/download/v0.0.12/cs-firewall-bouncer.tgz
```
2. Décompresser l’archive :
```
tar xzvf cs-firewall-bouncer.tgz
```
3. Aller dans le dossier décompressé (adapter à la version de l’archive) :
```
cd cs-firewall-bouncer-vX.Y.ZZ/
```
4. Lancer le script d’installation :
```
sudo ./install.sh
```
Lors de l’installation, vous serez invité à installer `ipset` si celui-ci n’est pas présent.




La configuration du Bouncer se trouve dans le fichier : `/etc/crowdsec/cs-firewall-bouncer/cs-firewall-bouncer.yaml`.

Afficher le fichier et vérifier qu’il est en mode iptables :
```
cat /etc/crowdsec/cs-firewall-bouncer/cs-firewall-bouncer.yaml
```




Utiliser la commande ci-après pour voir le Bouncer :
```
sudo cscli bouncers list
```
Vérifier le statut du Bouncer :
```
sudo systemctl status cs-firewall-bouncer
```
À partir de maintenant, les attaques seront bloquées par le firewall Linux en fonction des scénarios.

## Installer un composant avec cscli et le hub

Dans cette partie, je vais vous expliquer comment installer un composant du hub en utilisant le client (cscli).

Comme j’ai installé Crowdsec sur un serveur Web, on va installer la liste blanche pour les robots d’indexation.

Sur la page de la configuration [CrowdSec Hub](https://hub.crowdsec.net/author/crowdsecurity/configurations/seo-bots-whitelist) on trouve la ligne à exécuter.
```
sudo cscli postoverflows install crowdsecurity/seo-bots-whitelist
```




Recharger la configuration pour la prise en compte :
```
sudo systemctl reload crowdsec
```
Vous savez maintenant installer une configuration avec le client.

Il existe d’autre commande qui permettent la mise à jour et la désinstallation.

Mise à jour :
```
cscli hub update
```
Désinstallation :
```
cscli {composant} remove {nom_du/composant}
```
## Agir sur les decisions

Il est possible d’agir sur les decisions manuellement pour bannir une adresse IP ou débannir.

Bannir une adresse IP :
```
sudo cscli decisions add --ip 172.69.32.87
```
L’adresse IP 172.69.32.87 sera bloqué pour une durée de 4 heures.

Bannir une adresse IP 24 heures :
```
sudo cscli decisions add --ip 172.69.32.87 --duration 24h
```
Bannir une plage d’adresse IP :
```
sudo cscli decesions add --range 172.69.0.0/16
```
Pour supprimer un bannissement, il faut remplacer add par delete :
```
sudo cscli decisions delete --ip 172.69.32.87 sudo cscli decesions delete --range 172.69.0.0/16
```
## Pour conclure

À travers ce tutoriel, vous avez maintenant toutes les informations nécessaires pour installer, configurer et administrer Crowdsec afin de sécuriser votre serveur Linux.

Personnellement depuis j’ai découvert ce logiciel, je l’installe à la place de fail2ban, car j’aime beaucoup son côté communautaire et sa simplicité d’utilisation.
