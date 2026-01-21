
- **Technologie réseau**: Routing, STP, EtherChanel, FHRPs, switch security features, Switching, OSPF, ...

## Network Design

- **Topologie STAR**: touts les matériels sont connectés au matériel central switch

- **Full Mesh**: chaque matériel est connecté à chaque matériel

- **Partial Mesh**: quand certains matériels sont connectés à chaque matériel mais pas tous

## Le 2-Tiers LAN Campus LAN Design

Aussi appelé **collapsed Core** design car la couche **core layer** n'existe pas dans det design, pourtant existe dans la conception **3 tiers design**
- **Access Layer**:
	- Là où les **end host** son connectés
	- Utilisation du **Qos**
	- Service de sécrité
	- Switchports peuvent être **PoE** pour les wireless APs, IP Phone

> [!NOTE] Couche daccés
> - Ao no i-sécuriser-na ny port 
> - Gestion QOS

- **Distribution Layer**:
	- Frontière entre Couche 3 et couche 2
	- Connecté aux services tels que **WAN** ou **Internet**
	- Connexion agrégée venant des **Access Layer Switches**


> [!NOTE] Switch L3
>- nouvelle gen
>- manana fonctionnalité router
>- ampiasaina ao am couche de distribution (Tsy maintsy)

$$
Cisco recommande d'ajouter un core layer s'il y a plus de 3 distribution
$$
## 3 tiers hierarchisé Campus LAN design

Le 3 tiers est principalement utilisé dans les **Data Center** 
- Access Layer
- Distribution
- **Core layer**:
	connections couche 3, dorsale du réseau, pas de **STP**, peut augmenter la bande passante.

### Avantages:
- **Sécurité**
- **Modularité**: na manampy na manala équipement d tsisy problème
- **Facilité de maintenance**
- **Fiabilité**


> [!NOTE] Sécurité réseau
> Pour sécurisé un réseau, il faut le segmenté (mampiasa VLAN)

## SOHO network (Small Office Home Office)

- Comme les connexions à la maison
- Les fonctionnalités du réseau sont assurées par un seul équipement
- Le periphrique fonctionne comme routeur, switch, pare-feu, point d'accès et modem

