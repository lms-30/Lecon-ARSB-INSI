## 1. Installation de Suricata sur Debian 12

### Prérequis
```
sudo apt update
sudo apt upgrade -y
sudo apt install -y wget build-essential libpcre3 libpcre3-dev libyaml-0-2 libyaml-dev pkg-config zlib1g zlib1g-dev libcap-ng-dev libcap-ng0 libmagic-dev libjansson-dev libnss3-dev libgeoip-dev libnet1-dev libnetfilter-queue-dev libnetfilter-queue1 libnfnetlink-dev libnfnetlink0
```
### Installation de Suricata

```
wget https://www.openinfosecfoundation.org/download/suricata-7.0.0.tar.gz
tar -xvzf suricata-7.0.0.tar.gz
cd suricata-7.0.0
./configure --enable-nfqueue --prefix=/usr --sysconfdir=/etc --localstatedir=/var
make
sudo make install
sudo make install-full
```
### Configuration de Suricata

Éditez le fichier de configuration principal:
```
sudo nano /etc/suricata/suricata.yaml
```
Modifiez les sections importantes:
```
# Interface de surveillance
af-packet:
  - interface: eth0  # Remplacez par votre interface réseau

# Règles
default-rule-path: /var/lib/suricata/rules
rule-files:
  - suricata.rules

# Logging
outputs:
  - eve-log:
      enabled: yes
      filetype: regular
      filename: eve.json
      types:
        - alert
        - http
        - dns
        - tls
```
### Téléchargement des règles
```
sudo suricata-update
```
### Service systemd

Créez un fichier de service:
```
sudo nano /etc/systemd/system/suricata.service
```
Avec ce contenu:
```
[Unit]
Description=Suricata Intrusion Detection System
After=network.target

[Service]
ExecStart=/usr/bin/suricata -c /etc/suricata/suricata.yaml --af-packet
Restart=always
RestartSec=5

[Install]
WantedBy=multi-user.target
```
Activez et démarrez le service:
```
sudo systemctl daemon-reload
sudo systemctl enable suricata
sudo systemctl start suricata
```
## 2. Intégration avec OPNsense

### Installation du plugin Suricata sur OPNsense

1. Allez dans "System" > "Firmware" > "Plugins"
    
2. Installez le plugin "os-suricata"

### Configuration de Suricata dans OPNsense

1. Allez dans "Services" > "Intrusion Detection" > "Administration"
    
2. Activez Suricata et configurez les interfaces appropriées
    
3. Configurez les règles sous l'onglet "Rules"
    
4. Activez la gestion des règles automatiques si désiré
    

### Configuration pour surveiller le serveur Debian

1. Dans OPNsense, configurez un forwarder syslog:
    
    - Allez dans "Services" > "Intrusion Detection" > "Settings"
        
    - Activez "Remote Logging" et configurez l'IP de votre serveur Debian
        
2. Sur Debian, installez et configurez syslog-ng:

```
sudo apt install -y syslog-ng
sudo nano /etc/syslog-ng/syslog-ng.conf
```
Ajoutez:
```
source s_suricata {
    file("/var/log/suricata/eve.json" flags(no-parse));
};

destination d_opnsense {
    udp("IP_OPNSENSE" port(514));
};

log {
    source(s_suricata);
    destination(d_opnsense);
};
```
Redémarrez syslog-ng:
```
sudo systemctl restart syslog-ng
```
## 3. Surveillance et maintenance

### Commandes utiles sur Debian

- Vérifier les alertes:
```
  tail -f /var/log/suricata/fast.log
```
- Tester les performances:
```
  suricata -T -c /etc/suricata/suricata.yaml -v
```
- Mettre à jour les règles:
```
sudo suricata-update
sudo systemctl restart suricata
```
### Surveillance dans OPNsense

1. Allez dans "Services" > "Intrusion Detection" > "Alerts" pour voir les alertes
    
2. Consultez les graphiques sous "Reporting" > "Intrusion Detection"
    

## 4. Optimisations possibles

- Configurer le mode IPS avec NFQUEUE
    
- Activer les règles spécifiques à votre environnement
    
- Configurer des listes blanches pour réduire les faux positifs
    
- Mettre en place des alertes par email
    

Cette configuration vous fournit un système IDS/IPS robuste avec Suricata sur Debian 12, surveillé et géré centralement via OPNsense.
