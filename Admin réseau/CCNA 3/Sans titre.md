# DOCUMENTATION DE CONFIGURATION - LAB CCNA 2 SITES (OSPF & BGP)

## 1. SITE A - ANTANANARIVO (OSPF Aire 0)

### 1.1 Switch Cœur Multicouche : SW1-A (Cisco 3560/3650)

Extrait de code

```
enable
configure terminal
hostname SW1-A

! Sécurité de base
enable secret class
no ip domain-lookup
banner motd # Accès restreint - Site A SW1-A #
line console 0
 password cisco
 login
line vty 0 15
 password cisco
 login
exit
service password-encryption

! Activer le routage IP L3
ip routing

! Création des VLANs
vlan 10
 name ADMIN
vlan 20
 name USERS
vlan 30
 name SERVEURS
vlan 40
 name WIFI
vlan 99
 name MGMT
exit

! Configuration des SVI (Passerelles Inter-VLAN)
interface Vlan10
 ip address 10.10.10.1 255.255.255.0
 no shutdown
!
interface Vlan20
 ip address 10.10.20.1 255.255.255.0
 ip access-group ACL_USERS_TO_SERVERS in
 no shutdown
!
interface Vlan30
 ip address 10.10.30.1 255.255.255.0
 no shutdown
!
interface Vlan40
 ip address 10.10.40.1 255.255.255.0
 ip access-group ACL_WIFI_RESTRICT in
 no shutdown
!
interface Vlan99
 ip address 10.10.99.1 255.255.255.0
 no shutdown

! Exclusion d'adresses DHCP
ip dhcp excluded-address 10.10.10.1 10.10.10.10
ip dhcp excluded-address 10.10.20.1 10.10.20.10
ip dhcp excluded-address 10.10.40.1 10.10.40.10

! Pools DHCP
ip dhcp pool POOL_ADMIN
 network 10.10.10.0 255.255.255.0
 default-router 10.10.10.1
 dns-server 8.8.8.8
!
ip dhcp pool POOL_USERS
 network 10.10.20.0 255.255.255.0
 default-router 10.10.20.1
 dns-server 8.8.8.8
!
ip dhcp pool POOL_WIFI
 network 10.10.40.0 255.255.255.0
 default-router 10.10.40.1
 dns-server 8.8.8.8

! Link EtherChannel LACP vers SW2-A
interface GigabitEthernet0/2
 switchport mode trunk
 channel-group 1 mode active
!
interface GigabitEthernet0/3
 switchport mode trunk
 channel-group 1 mode active
!
interface Port-channel1
 switchport mode trunk

! Port Serveur1-A (Accès VLAN 30)
interface GigabitEthernet0/4
 switchport mode access
 switchport access vlan 30
 no shutdown

! Port Trunk vers R1-A
interface GigabitEthernet0/1
 switchport mode trunk
 no shutdown

! ACL 1: Limitation Users vers Serveurs (Autorise Web HTTP/HTTPS uniquement)
ip access-list extended ACL_USERS_TO_SERVERS
 permit tcp 10.10.20.0 0.0.0.255 10.10.30.0 0.0.0.255 eq www
 permit tcp 10.10.20.0 0.0.0.255 10.10.30.0 0.0.0.255 eq 443
 deny ip 10.10.20.0 0.0.0.255 10.10.30.0 0.0.0.255
 permit ip any any

! ACL 2: Restriction WiFi vers Admin et Mgmt
ip access-list extended ACL_WIFI_RESTRICT
 deny ip 10.10.40.0 0.0.0.255 10.10.10.0 0.0.0.255
 deny ip 10.10.40.0 0.0.0.255 10.10.99.0 0.0.0.255
 permit ip any any

! ACL 3: Restriction VTY SSH/Telnet au seul VLAN MGMT
ip access-list standard ACL_MGMT_ONLY
 permit 10.10.99.0 0.0.0.255
line vty 0 15
 access-class ACL_MGMT_ONLY in

! Configuration OSPF Aire 0
router ospf 1
 router-id 1.1.1.1
 network 10.10.10.0 0.0.0.255 area 0
 network 10.10.20.0 0.0.0.255 area 0
 network 10.10.30.0 0.0.0.255 area 0
 network 10.10.40.0 0.0.0.255 area 0
 network 10.10.99.0 0.0.0.255 area 0
 passive-interface Vlan10
 passive-interface Vlan20
 passive-interface Vlan30
 passive-interface Vlan40
end
write memory
```

### 1.2 Routeur de Bordure Site A : R1-A (Cisco 2911)

Extrait de code

```
enable
configure terminal
hostname R1-A

enable secret class
no ip domain-lookup
service password-encryption

! Module Serie HWIC-2T requis
interface GigabitEthernet0/0
 no shutdown

! Sous-interface MGMT / Trunk vers SW1-A
interface GigabitEthernet0/0.99
 encapsulation dot1Q 99
 ip address 10.10.99.2 255.255.255.0
!
interface GigabitEthernet0/0.10
 encapsulation dot1Q 10
 ip address 10.10.10.2 255.255.255.0
!
interface GigabitEthernet0/0.20
 encapsulation dot1Q 20
 ip address 10.10.20.2 255.255.255.0
!
interface GigabitEthernet0/0.30
 encapsulation dot1Q 30
 ip address 10.10.30.2 255.255.255.0
!
interface GigabitEthernet0/0.40
 encapsulation dot1Q 40
 ip address 10.10.40.2 255.255.255.0

! Interface WAN vers Site B (eBGP)
interface Serial0/0/0
 ip address 172.16.0.1 255.255.255.252
 clock rate 64000
 no shutdown

! OSPF Site A
router ospf 1
 router-id 1.1.1.2
 network 10.10.0.0 0.0.255.255 area 0
 redistribute bgp 65010 subnets

! eBGP vers Site B (R1-B)
router bgp 65010
 bgp log-neighbor-changes
 neighbor 172.16.0.2 remote-as 65020
 redistribute ospf 1
end
write memory
```

### 1.3 Switch Distribution : SW2-A (Cisco 2960)

Extrait de code

```
enable
configure terminal
hostname SW2-A

enable secret class
no ip domain-lookup

vlan 10
 name ADMIN
vlan 20
 name USERS
vlan 30
 name SERVEURS
vlan 40
 name WIFI
vlan 99
 name MGMT
exit

! EtherChannel LACP vers SW1-A
interface GigabitEthernet0/2
 switchport mode trunk
 channel-group 1 mode active
!
interface GigabitEthernet0/3
 switchport mode trunk
 channel-group 1 mode active
!
interface Port-channel1
 switchport mode trunk

! Trunk vers SW3-A
interface FastEthernet0/1
 switchport mode trunk
 no shutdown
end
write memory
```

### 1.4 Switch Accès : SW3-A (Cisco 2960)

Extrait de code

```
enable
configure terminal
hostname SW3-A

enable secret class

vlan 10
 name ADMIN
vlan 20
 name USERS
vlan 30
 name SERVEURS
vlan 40
 name WIFI
vlan 99
 name MGMT
exit

! Trunk vers SW2-A
interface FastEthernet0/1
 switchport mode trunk
 no shutdown

! Port PC1-A (ADMIN)
interface FastEthernet0/2
 switchport mode access
 switchport access vlan 10
 switchport port-security
 switchport port-security maximum 1
 switchport port-security violation restrict
 switchport port-security mac-address sticky
 no shutdown

! Port PC2-A (USERS)
interface FastEthernet0/3
 switchport mode access
 switchport access vlan 20
 switchport port-security
 switchport port-security maximum 1
 switchport port-security violation restrict
 switchport port-security mac-address sticky
 no shutdown

! Port vers Point d'accès AP1-A
interface FastEthernet0/4
 switchport mode trunk
 no shutdown
end
write memory
```

## 2. SITE B - TOAMASINA (BGP AS 65020)

### 2.1 Routeur de Bordure Site B : R1-B (Cisco 2911)

Extrait de code

```
enable
configure terminal
hostname R1-B

enable secret class
no ip domain-lookup

! Interface WAN (eBGP vers R1-A)
interface Serial0/0/0
 ip address 172.16.0.2 255.255.255.252
 no shutdown

! Interface LAN Interne (iBGP vers R2-B)
interface GigabitEthernet0/0
 ip address 172.16.0.5 255.255.255.252
 no shutdown

! Configuration BGP (eBGP + iBGP avec next-hop-self)
router bgp 65020
 bgp log-neighbor-changes
 ! Neighbor eBGP
 neighbor 172.16.0.1 remote-as 65010
 ! Neighbor iBGP
 neighbor 172.16.0.6 remote-as 65020
 neighbor 172.16.0.6 next-hop-self
end
write memory
```

### 2.2 Routeur Interne : R2-B (Cisco 2911)

Extrait de code

```
enable
configure terminal
hostname R2-B

enable secret class
no ip domain-lookup

! Interface vers R1-B (iBGP)
interface GigabitEthernet0/0
 ip address 172.16.0.6 255.255.255.252
 no shutdown

! Interface vers SW1-B (Lien routé)
interface GigabitEthernet0/1
 ip address 172.16.0.9 255.255.255.252
 no shutdown

! Routes statiques vers les VLANs du Site B
ip route 10.20.20.0 255.255.255.0 172.16.0.10
ip route 10.20.30.0 255.255.255.0 172.16.0.10

! iBGP et Redistribution
router bgp 65020
 neighbor 172.16.0.5 remote-as 65020
 redistribute static
end
write memory
```

### 2.3 Switch L3 Site B : SW1-B (Cisco 3560)

Extrait de code

```
enable
configure terminal
hostname SW1-B

enable secret class
ip routing

vlan 20
 name USERS-B
vlan 30
 name SERVEURS-B
exit

! Interface de routage vers R2-B
interface GigabitEthernet0/1
 no switchport
 ip address 172.16.0.10 255.255.255.252
 no shutdown

! SVI VLANs
interface Vlan20
 ip address 10.20.20.1 255.255.255.0
 no shutdown
!
interface Vlan30
 ip address 10.20.30.1 255.255.255.0
 no shutdown

! Pool DHCP pour USERS-B
ip dhcp excluded-address 10.20.20.1 10.20.20.10
ip dhcp pool POOL_USERS_B
 network 10.20.20.0 255.255.255.0
 default-router 10.20.20.1
 dns-server 8.8.8.8

! Configuration des ports clients
interface FastEthernet0/1
 switchport mode access
 switchport access vlan 20
 no shutdown

interface FastEthernet0/2
 switchport mode access
 switchport access vlan 30
 no shutdown

! Route par défaut vers R2-B
ip route 0.0.0.0 0.0.0.0 172.16.0.9
end
write memory
```

## 3. COMMANDES DE VÉRIFICATION & DIAGNOSTIC

|**Équipement**|**Commande de vérification**|**Résultat Attendu**|
|---|---|---|
|**SW1-A / SW2-A**|`show etherchannel summary`|Port-Channel 1 doit être en état `(SU)` avec ports `(P)` (bundled LACP).|
|**SW1-A / R1-A**|`show ip ospf neighbor`|L'adjacence OSPF doit afficher un état `FULL/BDR` ou `FULL/DR`.|
|**R1-A / R1-B**|`show ip bgp summary`|La session eBGP (172.16.0.1 <-> 172.16.0.2) doit être en état `Established`.|
|**R1-B / R2-B**|`show ip bgp summary`|La session iBGP (172.16.0.5 <-> 172.16.0.6) doit être en état `Established`.|
|**PC1-A**|`ping 10.20.20.11`|Le ping inter-sites entre Site A (ADMIN) et Site B (USERS) doit fonctionner.|
|**PC2-A**|`ping 10.10.30.10`|Interdit par l'ACL (sauf si flux HTTP port 80).|