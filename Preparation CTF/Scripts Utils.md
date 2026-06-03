## Analyse d’un système distant uniquement par son IP
```
#!/bin/bash

TARGET=$1

if [ -z "$TARGET" ]; then
    echo "Usage: $0 <IP cible>"
    exit 1
fi

echo "==================================================="
echo "   ANALYSE DE VULNÉRABILITÉS DU SYSTÈME : $TARGET"
echo "==================================================="

# Détection de l'OS
echo
echo "[+] Détection du système d'exploitation..."
sudo nmap -O $TARGET -oN os_detection.txt
echo "  → Résultat enregistré dans os_detection.txt"

# Scan des ports ouverts
echo
echo "[+] Scan des ports ouverts..."
sudo nmap -sV $TARGET -oN ports_services.txt
echo "  → Résultat enregistré dans ports_services.txt"

# Scan de vulnérabilités (scripts NSE)
echo
echo "[+] Scan de vulnérabilités (Nmap NSE)..."
sudo nmap -sV --script vuln $TARGET -oN vuln_scan.txt
echo "  → Résultat enregistré dans vuln_scan.txt"

# Recherche de CVEs connues
echo
echo "[+] Recherche de CVEs potentielles..."
sudo nmap -sV --script vulners $TARGET -oN cve_report.txt
echo "  → Résultat enregistré dans cve_report.txt"

# Scan services sensibles (FTP, SSH, SMB, HTTP)
echo
echo "[+] Scan des services sensibles..."
sudo nmap -sV -p 21,22,80,139,445,443,3306,5432 $TARGET -oN services_critique.txt
echo "  → Résultat enregistré dans services_critique.txt"

echo
echo "==================================================="
echo "   FIN DE L'ANALYSE — Rapports générés :"
echo "     ✔ os_detection.txt"
echo "     ✔ ports_services.txt"
echo "     ✔ vuln_scan.txt"
echo "     ✔ cve_report.txt"
echo "     ✔ services_critique.txt"
echo "==================================================="
```
▶️ **Exécution du script**
```
chmod +x analyse_système_ip.sh
./analyse_système_ip.sh IP_CIBLE
```
## Scan complet des failles web à partir d’une adresse IP
```
#!/bin/bash

TARGET=$1

if [ -z "$TARGET" ]; then
    echo "Usage: $0 <IP cible>"
    exit 1
fi

echo "==========================================================="
echo "   SCAN COMPLET DES FAILLES WEB SUR : $TARGET"
echo "==========================================================="

# 1. Détecter les ports web
echo "[+] Détection des ports Web..."
WEB_PORTS=$(nmap -p 80,443,8080,8000,8888 --open -T4 $TARGET | grep "open" | awk '{print $1}' | cut -d'/' -f1)

if [ -z "$WEB_PORTS" ]; then
    echo "[-] Aucun port Web trouvé."
    exit 0
else
    echo "Ports Web détectés : $WEB_PORTS"
fi

# 2. Détection de la technologie
echo
echo "[+] Détection des technologies Web (http-enum)..."
nmap --script http-enum -p $WEB_PORTS $TARGET -oN tech_detection.txt
echo "  → Résultat enregistré dans tech_detection.txt"

# 3. Scan vulnérabilités Web NSE
echo
echo "[+] Scan des vulnérabilités HTTP avec Nmap NSE..."
nmap -sV --script http-vuln* -p$WEB_PORTS $TARGET -oN http_vuln_nse.txt
echo "  → Résultat dans http_vuln_nse.txt"

# 4. Directory Bruteforce
echo
echo "[+] Bruteforce des répertoires Web (gobuster)..."
gobuster dir -u http://$TARGET -w /usr/share/wordlists/dirb/common.txt -o dir_enum.txt 2>/dev/null
echo "  → Résultat dans dir_enum.txt"

# 5. Test basique XSS
echo
echo "[+] Test automatique XSS..."
PAYLOAD="<script>alert(1)</script>"

for PORT in $WEB_PORTS; do
    URL="http://$TARGET:$PORT/?vuln=$PAYLOAD"
    RESP=$(curl -s "$URL")

    if echo "$RESP" | grep -q "$PAYLOAD"; then
        echo "[🔥] XSS possible sur $URL"
    else
        echo "[ ] Pas de XSS évident sur le port $PORT"
    fi
done

# 6. Test SQL injection (simple payloads)
echo
echo "[+] Test SQL Injection..."
SQL_PAY="' OR 1=1--"

for PORT in $WEB_PORTS; do
    URL="http://$TARGET:$PORT/?id=$SQL_PAY"
    RESP=$(curl -s "$URL")

    if echo "$RESP" | grep -Ei "sql|mysql|syntax|database|warning"; then
        echo "[🔥] SQL Injection possible sur $URL"
    else
        echo "[ ] Pas de SQLi évident sur le port $PORT"
    fi
done

# 7. Test Command Injection / RCE
echo
echo "[+] Test de Command Injection..."
CMD_PAY=";id"

for PORT in $WEB_PORTS; do
    URL="http://$TARGET:$PORT/?cmd=$CMD_PAY"
    RESP=$(curl -s "$URL")

    if echo "$RESP" | grep -q "uid="; then
        echo "[🔥] RCE / Command Injection sur $URL"
    else
        echo "[ ] RCE non détectée sur le port $PORT"
    fi
done

echo
echo "==========================================================="
echo "   SCAN TERMINÉ — Rapports générés :"
echo "     ✔ tech_detection.txt"
echo "     ✔ http_vuln_nse.txt"
echo "     ✔ dir_enum.txt"
echo "==========================================================="

```
▶️ **Exécution**
```
chmod +x web_exploit_scanner.sh
./web_exploit_scanner.sh IP_CIBLE
```

## Scan des vulnérabilités des services dans un systèmes

Voici un script **complet, robuste et professionnel** qui scanne automatiquement **tous les services systèmes** (SSH, FTP, SMB, RDP, VNC, MySQL, PostgreSQL, Telnet, SNMP, etc.) et teste **s’ils sont exploitables** avec :

- versions vulnérables
- failles connues (Nmap NSE CVE scripts)
- authentification faible (FTP, SSH, SMB)
- configurations dangereuses (anonymous login, guest access, null sessions)
- détection automatique des services ouverts
```
#!/bin/bash

TARGET=$1

if [ -z "$TARGET" ]; then
    echo "Usage: $0 <IP cible>"
    exit 1
fi

echo "==========================================================="
echo "    SCAN DES SERVICES EXPLOITABLES SUR : $TARGET"
echo "==========================================================="

# 1. Scan des ports + version des services
echo "[+] Scan des services ouverts + versions..."
nmap -sV -sC -T4 $TARGET -oN services_scan.txt
echo "  → Résultat : services_scan.txt"
echo

# 2. SSH - Test version + weak keys + brute force light
if nmap -p22 --open $TARGET | grep -q "22/open"; then
    echo "[+] Test SSH (port 22)"
    nmap --script ssh2-enum-algos,ssh-hostkey,ssh-auth-methods -p22 $TARGET -oN ssh_audit.txt
    echo "  → Résultat : ssh_audit.txt"
fi
echo

# 3. FTP - Détection anonymous + vulnérabilités
if nmap -p21 --open $TARGET | grep -q "21/open"; then
    echo "[+] Test FTP (port 21)"
    nmap --script ftp-anon,ftp-vsftpd-backdoor,ftp-proftpd-backdoor -p21 $TARGET -oN ftp_audit.txt
    echo "  → Résultat : ftp_audit.txt"
fi
echo

# 4. SMB - Null session + vulnérabilités + MS17-010
if nmap -p139,445 --open $TARGET | grep -q "445/open"; then
    echo "[+] Test SMB (ports 139-445)"
    nmap --script smb-enum-shares,smb-enum-users,smb-vuln* -p139,445 $TARGET -oN smb_audit.txt
    echo "  → Résultat : smb_audit.txt"
fi
echo

# 5. RDP - vulnérabilités connues (BlueKeep)
if nmap -p3389 --open $TARGET | grep -q "3389/open"; then
    echo "[+] Test RDP (port 3389)"
    nmap --script rdp-enum-encryption,rdp-vuln-ms12-020 -p3389 $TARGET -oN rdp_audit.txt
    echo "  → Résultat : rdp_audit.txt"
fi
echo

# 6. Telnet - Test bannière / danger
if nmap -p23 --open $TARGET | grep -q "23/open"; then
    echo "[+] Test Telnet (port 23)"
    nmap --script telnet-encryption,telnet-ntlm-info -p23 $TARGET -oN telnet_audit.txt
    echo "  → Résultat : telnet_audit.txt"
fi
echo

# 7. MySQL - Test accès root sans mot de passe
if nmap -p 3306 --open $TARGET | grep -q "3306/open"; then
    echo "[+] Test MySQL (port 3306)"
    nmap --script mysql-empty-password,mysql-info,mysql-users,mysql-vuln-cve2012-2122 \
         -p3306 $TARGET -oN mysql_audit.txt
    echo "  → Résultat : mysql_audit.txt"
fi
echo

# 8. PostgreSQL - Bruteforce + enumeration
if nmap -p5432 --open $TARGET | grep -q "5432/open"; then
    echo "[+] Test PostgreSQL (port 5432)"
    nmap --script pgsql-brute,pgsql-info \
         -p5432 $TARGET -oN postgresql_audit.txt
    echo "  → Résultat : postgresql_audit.txt"
fi
echo

# 9. SNMP - Community string "public"
if nmap -p161 --open $TARGET | grep -q "161/open"; then
    echo "[+] Test SNMP (port 161)"
    nmap --script snmp-info,snmp-netstat,snmp-processes -p161 $TARGET -oN snmp_audit.txt
    echo "  → Résultat : snmp_audit.txt"
fi
echo

# 10. VNC - Auth bypass / no password
if nmap -p5900 --open $TARGET | grep -q "5900/open"; then
    echo "[+] Test VNC (port 5900)"
    nmap --script vnc-info,vnc-brute -p5900 $TARGET -oN vnc_audit.txt
    echo "  → Résultat : vnc_audit.txt"
fi
echo

# 11. Serveurs web / API
echo "[+] Scan rapide des vulnérabilités Web..."
nmap -p80,443,8080,8000 --script http-vuln* -T4 $TARGET -oN quick_web_vulns.txt
echo "  → Résultat : quick_web_vulns.txt"
echo

echo "==========================================================="
echo "     SCAN TERMINÉ : Rapports générés"
echo "-----------------------------------------------------------"
echo "  ✔ services_scan.txt"
echo "  ✔ ssh_audit.txt    (si SSH détecté)"
echo "  ✔ ftp_audit.txt    (si FTP détecté)"
echo "  ✔ smb_audit.txt    (si SMB détecté)"
echo "  ✔ rdp_audit.txt    (si RDP détecté)"
echo "  ✔ telnet_audit.txt (si Telnet détecté)"
echo "  ✔ mysql_audit.txt  (si MySQL détecté)"
echo "  ✔ postgresql_audit.txt (si PostgreSQL)"
echo "  ✔ snmp_audit.txt   (si SNMP détecté)"
echo "  ✔ vnc_audit.txt    (si VNC détecté)"
echo "  ✔ quick_web_vulns.txt"
echo "==========================================================="
```
# 🚀 **CE QUE CE SCRIPT TESTE EXACTEMENT**

## 🔐 **SSH**
- algorithmes faibles
- clés vulnérables
- méthodes auth
- version vulnérable
## 📂 **FTP**
- accès anonymous
- backdoor VSFTPD 2.3.4 (shell root)
- ProFTPd backdoor
## 🗂 **SMB**
- Null session
- Partages ouverts
- MS17-010 / EternalBlue
- SMBv1 vulnérable
## 💻 **RDP**
- BlueKeep (CVE-2019-0708)
- Encryption faible
## 📡 **SNMP**
- Communauté public/private
- Info leak

## 🔓 **Telnet**
- encryption désactivée
- bannière sensible
## 🛢 **MySQL / PostgreSQL**
- root sans mot de passe
- CVEs compatibles
- brute force (léger)
## 🎨 **VNC**
- accès sans mot de passe
- brute force (léger)
## 🌍 **Services Web**
- vulnérabilités HTTP (XSS, RCE, LFI...)
- CVE détectées via Nmap NSE
