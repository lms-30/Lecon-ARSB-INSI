## NMAP

outil pour scanner une des ports ouverts, des informations, des services dans une machines (ordinateurs)
1. Détection du système d'exploitation
```
sudo nmap -O IP_CIBLE
```
2. Scan des ports ouverts
```
sudo nmap -sV IP_CIBLE
```
3. Scan de vulnérabilités (scripts NSE)
```
sudo nmap -sV --script vuln IP_CIBLE
```
4. Recherche de CVEs connues
```
sudo nmap -sV --script vulners IP_CIBLE
```
5. Scan services sensibles (FTP, SSH, SMB, HTTP)
```
sudo nmap -sV -p 21,22,80,139,445,443,3306,5432 IP_CIBLE
```

## NETDISCOVER

Netdiscover est un outils pour sacnner les réseaux entier, et fournirs toud les adresse IP de chaque appareil connecter dans un réseau ainsi leurs nom.
```
sudo netdiscover -i nom_interface_réseau
```

# Résumé rapide (mémo)

| Type de scan     | Outils                    | Descripions | Exemples de commandes |
| ---------------- | ------------------------- | ----------- | --------------------- |
| Ports & services | Nmap, Masscan             |             |                       |
| Vulnérabilités   | Nessus, OpenVAS           |             |                       |
| Web              | Burp, ZAP, Dirb, Gobuster |             |                       |
| Réseau interne   | Netdiscover, Responder    |             |                       |
| Versions         | WhatWeb, Wappalyzer       |             |                       |
| OS/serveurs      | Lynis                     |             |                       |
| Bases de données | SQLmap                    |             |                       |
| Cloud            | ScoutSuite, Trivy         |             |                       |
| Code (SAST/DAST) | SonarQube, Semgrep        |             |                       |
| Wi-Fi            | Aircrack-ng               |             |                       |
| OSINT            | Maltego, Shodan           |             |                       |
