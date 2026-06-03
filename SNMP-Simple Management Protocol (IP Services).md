## C'est quoi SNMP?

> [!NOTE] Commande pour vérifier SNMP
> - **Linux**: sudo systemctl status snmtp
> - **Powershell**: get -windowsfeature SNMTP

**SNMP** peut être utilisé pour visualiser les statuts des équipements, et de les configurer.

Il y a deux types d'équipements SNMP:
- **Equipement managés (Managed Device)**
	Equipements gérés en utilisant SNMP (equipement réseau et switch)
- **NMS (Network Management Station)**:
	Equipements gérés par les équipement managés (SNMP Server)

Il y a 3 types d'opérations utilisées dans SNMP
- Les équipements managés pourraient **notifier le NMS** sur les events
- Les NMS pourraient **demander les équipements managés** sur les infos de ces statuts courant
- Le NMS pourraient dire aux équipements managés de **changer leur configuration**

Les composants de SNMP:
![[composantsSNMP.jpeg]]



**SNMP Manager**: c'est un logiciel sur le NMS, en interactif avec les équipements managés
	- Ils reçoivent les notifications
	- Envoie des requêtes pour infos
	- Envoie les configs changé
**SNMP Application**: assure ne interface pour l'admin réseau pour interconnecter
	- Affiche les alertes, statistiques, diagrammes
**SNMP Agent**: logiciel SNMP sur le NMS en interaction avec les équipements managé. Envoie les notifs ou recevoir les messages venant du NMS
**MIB**: structure qui contient les variables sur le NMS

## Les Versions de SNMP
Il y a trois versions
- **SNMPv1**: l'originale version
- **SNMPv2**: 
	- permet à NMS de récupérer plus d'infos sur une seule requête
	- Il y avait un mdp sur v1, enlever sur v2, mais revenu sur v2c
- **SNMPv3**: version plus sécurisé, supporte l'encryption et authentification 

## SNMP Messages

![[SNMP messages.jpeg]]


- **SNMP Agent = UDP 161**
- **SNMP Manager = UDP 162** 

## Résumé
![[resume SNMP.jpeg]]
