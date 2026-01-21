
## PARTIE 1

## Étape 1 - Installer Suricata

Suricata est disponible dans les dépôts officiels de Debian. Installez-le en utilisant la commande suivante.
```
sudo apt install suricata
```
Après l'installation vérifions la version de Suricata 
```
suricata -v
```
![[Pasted image 20250820110831.png]]

Le service Suricata est activé et démarré automatiquement. Avant de continuer, arrêtez le service Suricata car nous devons d'abord le configurer.

```
sudo systemctl stop suricata
```
## Étape 2 - Configurer Suricata

Suricata stocke sa configuration dans le fichier `/etc/suricata/suricata.yaml`. Le mode par défaut de Suricata est le mode IDS (Système de Détection d'Intrusions), où le trafic est uniquement enregistré et non bloqué. Si vous êtes nouveau sur Suricata, vous devriez laisser le mode inchangé. Une fois que vous l'avez configuré et que vous en avez appris davantage, vous pouvez activer le mode IPS (Système de Prévention d'Intrusions).

### Activer l'identifiant de la communauté

Le champ Community ID facilite la corrélation des données entre les enregistrements générés par différents outils de surveillance. Puisque nous allons utiliser Suricata avec Elasticsearch, activer le Community ID peut être utile.

Ouvrez le fichier `/etc/suricata/suricata.yaml` pour le modifier.
```
sudo nano /etc/suricata/suricata.yaml
```
Localisez la ligne `# Community Flow ID` et définissez la valeur de la variable `community-id` sur `true`.

![[Pasted image 20250820111139.png]]

## PARTIE 2

Nous avons terminé la première partie du tutoriel, où nous avons installé Suricata et l'avons testé. La prochaine partie consiste à installer la pile ELK et à la configurer pour visualiser Suricata et ses journaux. La deuxième partie du tutoriel doit être réalisée sur le deuxième serveur, sauf indication contraire.

Étape 7 - Installer Elasticsearch
La première étape de l'installation d'Elasticsearch consiste à ajouter la clé GPG d'Elastic à votre serveur.