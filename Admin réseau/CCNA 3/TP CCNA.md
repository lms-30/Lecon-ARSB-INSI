Voici la configuration complète pour la topologie réseau affichée dans Cisco Packet Tracer.

  

### 1. Configuration du Switch 3650 (SW1)

Le switch 3650 agit comme un switch Layer 3 ou Layer 2 d'accès. Voici la configuration pour créer les VLANs, configurer le Trunking vers le WLC et les Lightweight APs, et assigner l'accès au PC1.

```
enable
configure terminal

! Création des VLANs
vlan 10
 name Management
vlan 100
 name Internal
vlan 200
 name Guest
exit

! Interface SVI pour la gestion (optionnel si le switch sert de passerelle)
interface vlan 10
 ip address 172.16.1.1 255.255.255.0
 no shutdown
exit

! Interface G1/0/1 connectée au WLC1 (Trunk obligatoire pour acheminer tous les VLANs)
interface GigabitEthernet1/0/1
 switchport mode trunk
 switchport trunk native vlan 10
 switchport trunk allowed vlan 10,100,200
 no shutdown
exit

! Interfaces G1/0/2 et G1/0/3 connectées aux AP1 et AP2 (Trunk ou Access selon le mode de déploiement)
! En mode Lightweight classique (CAPWAP), les APs sont dans le VLAN de Management :
interface range GigabitEthernet1/0/2 - 3
 switchport mode access
 switchport access vlan 10
 spanning-tree portfast
 no shutdown
exit

! Interface G1/0/4 connectée au PC1 (Accès dans le VLAN Internal ou Management)
interface GigabitEthernet1/0/4
 switchport mode access
 switchport access vlan 100
 spanning-tree portfast
 no shutdown
exit
```

### 2. Configuration des Pools DHCP (Sur le Switch ou un Serveur dédié)

Le document indique **"DHCP à chaque VLAN"**. Si le switch 3650 est le serveur DHCP :

```
configure terminal

! Pool DHCP pour VLAN 10 (Management)
ip dhcp pool VLAN10_MGMT
 network 172.16.1.0 255.255.255.0
 default-router 172.16.1.1
 dns-server 8.8.8.8
 ! Option 43 obligatoire pour que les APs trouvent l'adresse IP du WLC (172.16.1.10)
 option 43 ip 172.16.1.10
exit

! Pool DHCP pour VLAN 100 (Internal)
ip dhcp pool VLAN100_INTERNAL
 network 10.0.0.0 255.255.255.0
 default-router 10.0.0.1
 dns-server 8.8.8.8
exit

! Pool DHCP pour VLAN 200 (Guest)
ip dhcp pool VLAN200_GUEST
 network 10.1.0.0 255.255.255.0
 default-router 10.1.0.1
 dns-server 8.8.8.8
exit
```

### 3. Configuration du WLC 3504 via l'interface Web (GUI)

Accédez à l'interface graphique du WLC via le navigateur d'un PC connecté au réseau (ex: `[https://172.16.1.10](https://172.16.1.10)`) :

1. **Interfaces Dynamiques :**  
    - Aller dans **Controller** > **Interfaces**.
    - Créer l'interface **vlan100** : ID `100`, adresse IP `10.0.0.254/24`, gateway `10.0.0.1`, DHCP Server `172.16.1.1`.
    - Créer l'interface **vlan200** : ID `200`, adresse IP `10.1.0.254/24`, gateway `10.1.0.1`, DHCP Server `172.16.1.1`.
2. **WLAN 1 (Internal) :**
    - Aller dans **WLANs** > **Create New**.
    - Profile Name : `Internal_WLAN` | SSID : `Internal` | ID : `1`.
    - Dans l'onglet **General** : Interface/Interface Group = `vlan100`.
    - Dans l'onglet **Security** : Layer 2 Security = `WPA2-PSK` (ou WPA3/802.1X selon vos besoins) et définir la clé d'accès.
    - Cocher **Status: Enabled**.
3. **WLAN 2 (Guest) :** 
    - Profile Name : `Guest_WLAN` | SSID : `Guest` | ID : `2`.
    - Dans l'onglet **General** : Interface/Interface Group = `vlan200`.
    - Dans l'onglet **Security** : Sélectionner `WPA2-PSK` ou `Open` avec Web Auth / Captive Portal.
    - Cocher **Status: Enabled**.
4. **Association des APs :**
    - Une fois AP1 et AP2 alimentés et ayant reçu une IP du VLAN 10 via DHCP, ils découvriront le WLC et apparaîtront sous l'onglet **Wireless** > **All APs**.