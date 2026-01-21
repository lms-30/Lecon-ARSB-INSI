### I. C'est quoi SNMP


> [!NOTE] Commande pur vérifier si un service est installé
> Linux :Sudo systemctl status snmp
> PowerShell : get-windowsFeature snmp

- SNMP
    - crée en 1988
    - Norme standard Framework et protocole et indistrie
    - RFC 1065 - RFC 1066 - RFC 1067
    - SNMPv1
    
    **SNMP**  peut être utilisé pour visualiser les status des équipement, et les configurer
  Il y a deux types d'équipement en SNMP : 
     1. Equipement managés (Managed device)
		  - [ ] ces équipement sont gérés en utilisant SNMP
		  - [ ] EX: les équipement réseau et les switch
	2. NMS (Network Manager systèm)

Il y a trois Types d'opérations utilisé dans SNMP
1. Les équipement managé pourraient **notifier les NMS** sur les évènement
2. Les NMS pourraient **demander les équipement mnagés, sur les informations de ces statuts** courant
3. Les NMS pourraient dire aux équipement managés de **changer leur configuration**

**Les Composant de SNMP**

![[fad7d411-f443-4539-9d7b-7f8f2e893a81.jpeg]]

**SNMP Manager** : est un logiciel sur le SNMP, en interactif avec les équipements managés




**SNMP Agent** : est **un logiciel SNMP sur NMS** , en interactif avec les équipements managés 
- [ ] Cet interactif avec SNMP Manager Sur  NMS
- [ ] Envoie 

SNMP Version:
1.  **SNMPv1** (original version)
2. **SNMPv2c** :
    - Permettre à  **NMS** de récupérer plus d'information sur une seul requête, donc c'est très efface
    - il y avait de password sur **SNMPv1**, enlever sur **SNMPv2** est revenu sur **SNMPv2c**
3. **SNMPv3**
    - Plus sécurisé version, support l’encryptions et authentification

### SNMP Message
![[bc4100b1-4d3a-4ad4-ae22-b113187ce65d.jpeg]]

### SNMP Read Messages

