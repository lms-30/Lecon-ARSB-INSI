Objectif : disponibilité des réseau (pas de coupure réseau) en appliquant un système de redondance

Pour l'architecture, on utilise 2 tiers et 3 tiers :
- Cœur (C)
- Distribution (D)
- Access (A)

« Dans l'architecture réseau (à 2 ou 3 niveaux), les équipements sont identifiés par des abréviations indiquant leur rôle : **C** pour le Cœur (_Core_), **D** pour la Distribution et **A** pour l'Accès. Par exemple, un commutateur de distribution sera nommé **DSW** (_Distribution Switch_). »


## 1. PAgP (_Port Aggregation Protocol_)

C'est le protocole propriétaire **Cisco**. Il ne fonctionne qu'entre des commutateurs Cisco.

- **Mode `desirable`** : Le switch prend l'initiative et **demande activement** à monter l'EtherChannel.
- **Mode `auto`** : Le switch **attend passivement** d'être sollicité pour négocier.

>  **Règle :** Au moins un des deux côtés doit être en mode `desirable` pour que la négociation réussisse. Deux ports en mode `auto` ne formeront **jamais** de lien.

## 2. LACP (_Link Aggregation Control Protocol_)

C'est le **standard international (IEEE 802.3ad)**. C'est la solution recommandée aujourd'hui car elle fonctionne entre des équipements de marques différentes (Cisco, HP, Dell, etc.).

- **Mode `active`** : Le switch **demande activement** à monter l'EtherChannel (équivalent de _desirable_).
- **Mode `passive`** : Le switch **attend les messages** LACP sans prendre l'initiative (équivalent de _auto_).

>  **Règle :** Au moins un des deux côtés doit être en mode `active`. Deux ports en mode `passive` resteront des liens isolés.

## 3. Mode `On` (Inconditionnel)

Il s'agit d'une **configuration forcée** sans aucun protocole de négociation (ni PAgP, ni LACP).

- Les interfaces sont regroupées de manière statique.
- **Attention :** Les deux côtés doivent impérativement être configurés en mode `On`. Si un côté est en mode `On` et l'autre tente de négocier (LACP/PAgP), cela crée une boucle réseau ou une perte de connectivité.

**Tableau récapitulatif des compatibilités**

|**Côté Local**|**Côté Distant**|**Protocole utilisé**|**Résultat**|
|---|---|---|---|
|**desirable**|**desirable** ou **auto**|PAgP|**EtherChannel OK**|
|**auto**|**auto**|PAgP|❌ Échec (pas d'initiative)|
|**active**|**active** or **passive**|LACP|**EtherChannel OK**|
|**passive**|**passive**|LACP|❌ Échec (pas d'initiative)|
|**On**|**On**|Aucun (Statique)|**EtherChannel OK**|
|**On**|**active / desirable**|Incompatible|❌ Erreur de configuration|

### Condition pour créer un EtherChennel


### Commandes principales Cisco

- Vérification :
```
show etherchannel summary
```
- Voir les interfaces :
```
show interfaces etherchannel
```
- Voir LACP :
```
show lacp neighbor
```


## Partie 1: Configuration SW1

Commandes à appliquer sur SW1
```
Switch> enable
Switch# configure terminal
Switch(config)# hostname SW1
SW1(config)# interface range fa0/7 - 9
SW1(config-if-range)# switchport mode trunk
SW1(config-if-range)# channel-group 1 mode active
SW1(config-if-range)# exit
SW1(config)# interface port-channel 1
SW1(config-if)# switchport mode trunk
SW1(config-if)# end
```

## Explication étape par étape

### Étape 1 : Accès au mode de configuration globale

- `enable` : Passe en mode privilège (privilege EXEC).
    
- `configure terminal` : Entre dans le mode de configuration globale du switch.
    
### Étape 2 : Nommage du switch

- `hostname SW1` : Renomme le switch en **SW1** pour bien l'identifier dans votre réseau.
    

### Étape 3 : Sélection des interfaces physiques

- `interface range fa0/7 - 9` : Sélectionne en une seule fois les 3 ports physiques (`FastEthernet 0/7`, `0/8` et `0/9`) qui seront agrégés.
    

### Étape 4 : Passage des ports en Trunk et activation de LACP

- `switchport mode trunk` : Configure les trois liaisons en mode Trunk (pour laisser passer plusieurs VLANs).
    
- `channel-group 1 mode active` : Associe les interfaces au groupe EtherChannel n°1 en utilisant le protocole **LACP** en mode `active` (il va négocier le lien avec SW2).
    

>  **Ce qui va se passer à ce moment précis :** Sur **SW2**, vous aviez le message d'erreur `%EC-5-L3DONTBNDL2: Fa0/7 suspended: LACP currently not enabled on the remote port`. Dès que vous validez cette commande sur **SW1**, les messages d'erreur sur **SW2** vont disparaître et les interfaces passeront de l'état `suspended` à l'état `up`.

### Étape 5 : Configuration de l'interface logique (Port-Channel)

- `interface port-channel 1` : Permet de rentrer dans le port virtuel qui regroupe les 3 liaisons physiques.
    
- `switchport mode trunk` : S'assure que le Port-Channel complet hérite de la configuration Trunk.
	

## Partie 2: Configuration SW2

Commandes à saisir sur SW2
```
Switch> enable
Switch# configure terminal
Switch(config)# hostname SW2
SW2(config)# interface range fa0/7 - 9
SW2(config-if-range)# switchport mode trunk
SW2(config-if-range)# channel-group 1 mode active
SW2(config-if-range)# exit
SW2(config)# interface port-channel 1
SW2(config-if)# switchport mode trunk
SW2(config-if)# end
```

## Explication du rôle des commandes

### 1. Sélection des interfaces physiques

- `interface range fa0/7 - 9`
    
    > On applique la configuration en simultané sur les trois liaisons physiques (`Fa0/7`, `Fa0/8` et `Fa0/9`).
    

### 2. Mode Trunk & Création du groupe LACP

- `switchport mode trunk`
    
    > Maintient les ports en mode Trunk pour transporter le trafic des VLANs.
    
- `channel-group 1 mode active`
    
    > Crée le groupe d'agrégation n°1 et active le protocole **LACP** en mode dynamique (`active`).
    

>  **Comprendre le message d'erreur aperçu :**
> 
> L'alerte `%EC-5-L3DONTBNDL2: Fa0/7 suspended...` est **tout à fait normale** à cette étape. Elle indique simplement que SW2 cherche à négocier en LACP, mais que SW1 ne lui répond pas encore (car SW1 n'est pas encore configuré).

### 3. Application du Trunk sur le Port-Channel

- `interface port-channel 1`
    
- `switchport mode trunk`
    
    > Applique la règle de Trunking sur l'interface virtuelle globale (`Po1`). Cela garantit que toute la bande passante combinée des 3 ports physiques fonctionne comme un seul gros tuyau Trunk.
    

## Partie 3: vérification

À exécuter en mode privilège (`SW1#` ou `SW2#`) :

 - Vérifier l'état global de l'EtherChannel
```
show etherchannel summary
```
 - Vérifier l'état du Trunk sur le Port-Channel
```
show interfaces trunk
```
 - Vérifier le protocole LACP en détail
```
show lacp neighbor
```

## Load-Balancing

Le **Load-Balancing** (répartition de charge) est le mécanisme clé d'EtherChannel. Une fois les liens interfaces rassemblés dans le `Po1`, le switch doit décider **par quel port physique envoyer chaque trame**.

Il ne s'agit pas de distribuer les paquets un par un en tournant (Round-Robin), car cela mélangerait l'ordre des paquets d'une même session TCP. À la place, le switch utilise un **algorithme de hachage** (_Hash_).

## Comment fonctionne le hachage ?

Le switch prend une information de la trame (ex: l'adresse MAC source), lui applique un calcul rapide (un XOR) et obtient un résultat qui désigne le port physique à emprunter (`Fa0/7`, `Fa0/8` ou `Fa0/9`).

> **Règle d'or :** Tous les paquets d'un même flux (même source, même destination) emprunteront **toujours la même interface physique**. Cela évite la désynchronisation des paquets.

## Les méthodes de Load-Balancing disponibles

Selon tes besoins, on peut configurer le switch pour qu'il calcule son hachage sur différents critères :

|**Méthode**|**Commande de configuration**|**Utilisation idéale**|
|---|---|---|
|**MAC Source**|`src-mac`|Plusieurs serveurs émettent vers une seule destination.|
|**MAC Destination**|`dst-mac`|Un seul serveur émet vers beaucoup de clients.|
|**MAC Source & Dest.**|`src-dst-mac`|Trafic local varié (mélange de sources et destinations).|
|**IP Source & Dest.**|`src-dst-ip`|**(Recommandé)** Trafic passant par des routeurs.|
|**Port L4 (TCP/UDP)**|`src-dst-port`|Pour répartir même si c'est la même machine (ex: web + ssh).|

## 🛠️ Commandes pour vérifier et modifier la répartition

### 1. Voir la méthode actuellement activée

En mode privilège (`SW1#`)
```
SW1# show etherchannel load-balance
```

_Par défaut sur la plupart des switchs Cisco, la méthode est `src-mac` ou `src-dst-ip`._

### 2. Changer la méthode de Load-Balancing

En mode de configuration globale (`SW1(config)#`) :
```
SW1(config)# port-channel load-balance src-dst-ip
```

### 3. Tester quelle interface un flux va emprunter

Tu peux simuler l'envoi d'une trame pour savoir quel port du `Port-channel 1` sera choisi par l'algorithme :
```
SW1# test etherchannel load-balance interface port-channel 1 mac 0011.2233.4455 00aa.bbcc.ddee
```

