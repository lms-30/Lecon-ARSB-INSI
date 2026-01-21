#### La virtualisation

Définition:
La virtualisation est une technologie qui permet de créer plusieurs environnements virtuels a partir d'un seule matérielles physiques. C'est à dire, elle permet de diviser un seule machine physique en plusieurs machines virtuelles appelé VM (Virtual Machine)

Chaque machine virtuelle dispose ses propre ressources virtuelle définies dans sa configuration : Mémoire vive, stockage , réseau et autre périphérique virtuelles. Les machines virtuelles sont isolé les une des autre, mais il peuvent communiquez entre elles par l'intermédiaire du réseau

La virtualisation s'appuis ce qu'on appelle un Hyper-viseur.Nous pouvons dire que l'Hyper-viser agit comme une Chef d'Orchestre, car il contrôle les matériels et assure la répartition des ressources entre les machine virtuelles.Il existe des hyper-viseurs de type 1 et 2

La virtualisation est omni-présente dans un entreprise, et elle est devenue une technologie clé pour le Cloud Computing.
Il est bien de noter qu'un autre technologie a émergé de Container. Il offre une alternative à la virtualisation, sauf que l'approche est différente car le système d’exploitation hôte est partagé avec le container, contrairement à la machine virtuelle

#### Avantages et Inconvénient
##### Avantage
1. Optimisation des ressources
2. Réduction des coûts(matérielle,espace,Electricité)
3. Isolation
4. Flexibilité et évolutivité
##### Inconvénient
La virtualisation présente des nombreux avantages, mais elle comporte aussi des inconvénient important qu'il faut bien comprendre avant de se lancé.

Par exemple : Passé d'un ensemble des serveurs Physique a un architecture virtualisé est un projet complexe et coûteux au départ.

Voici quelques inconvénient majeurs à prendre à comptes :
1. Coût initial élevé : il faut investir dans un serveur physique puissant, capable de supporter plusieurs machines virtuelles ainsi que dans des licences logiciels 
2. Ressources partagées : Même si plusieurs VMs peuvent tourner sur un même hôte, chaque VM a besoin de ses propre ressources, ce qui demande une configuration matérielle bien dimensionner.
3. Dépendance à un seul point de défaillance : Si le serveur physique ou l'hyperviseur tombé en panne, toute les VMs hébergé peuvent être affectés.
4. Complexité des gestions: La virtualisation ajoute une couche d'abstraction supplémentaire qui peut rendre la gestion, le dépannage et la sécurité plus complexe

Exemple des virtualisations open-source :
- KVM (Kernel Virtual Machine)
- Xen
- Proxmox VE
- VirtualBox (Oracle )
- QEMU
Exemple des virtualisations proprétaire : 
- VMWare ESX
- Microsoft Hyper-V
- Oracle VM Server
- Nutanix
- Parallèls Desktop

#### Prérequis de la virtualisation

pour mettre en place une serveur de virtualisation, certaine prérequis matérielle et logicielles sont indispensable :
 - Un matérielle compatible : la machine physique doit avoir un processeur compatible avec la virtualisation, cela concerne la plupart des processeur Intel récent (VT-x et VT-d) et AMD (AMD-V et IOMMU). Ces options doit être activer dans le BIOS.
 - Ressources suffisantes : Il faut prévoir assez de RAM et de stockage pour le système hôte, l'Hyperviseur et toute les VMs
 - Logicielle d'hyperviseur : C'est le logicielle qui permet de créer et gérer des VMs
	Le choix dépendra de votre besoin et de votre techniques.

#### Hyperviseur type 1 et 2

Un hyperviseur de type 1 correspond a un système qui s'installe directement sur la couche matérielle du serveur. On parle d'une Hyperviseur **native** .Lorsqu'un Hyperviseur de type 1 est installer sur une machine, la machine ne peut pas servir à autre qu'a faire tourné l'hyperviseur, elle est dédié a cette usage.  

Un hyperviseur de type 2 est un logicielle qui s'installe et s'exécute sur une système d'exploitation qui est déjà en place.On parle un Hyperviseur **hébergé**.

