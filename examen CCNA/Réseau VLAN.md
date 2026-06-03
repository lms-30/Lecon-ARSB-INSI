
**Objectif** : chaque département doit avoir son propre VLAN et pouvoir communiquez entre eux via un routeur

**1-TOPOLOGIE**

![[Pasted image 20250519113014.png]]

 **2-Adresse IP et sous réseau:**
addresse IP des machines  chaque VLAN:
VLAN 10 : PC0:192.168.10.10/24
		  PC1:192.168.10.20/24
VLAN 20 :PC2:192.168.20.10/24
		  PC3:192.168.20.20/24
VLAN 30 :PC4:192.168.30.10/24
		  PC5:192.168.30.20/24


**3-configuration VLANs et port:**
on doit créer 3 vlans
VLAN 10 : admin
VLAN 20 : tech
Vlan 30 : comm
