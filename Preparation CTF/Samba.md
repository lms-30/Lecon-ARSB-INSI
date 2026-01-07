Vulnérabilité trouvées 

warning[]=GEN-0010|This version 16.04 is marked end-of-life as of 2021-05-01|-|-|
warning[]=PKGS-7392|Found one or more vulnerable packages.|-|-|
warning[]=LOGG-2138|klogd is not running, which could lead to missing kernel messages in log files|-|-|

suggestion[]=BOOT-5180|Determine runlevel and services at startup|-|-|
suggestion[]=KRNL-5788|Determine why /vmlinuz or /boot/vmlinuz is missing on this Debian/Ubuntu system.|/vmlinuz or /boot/vmlinuz|-|
suggestion[]=KRNL-5820|If not required, consider explicit disabling of core dump in /etc/security/limits.conf file|-|-|
suggestion[]=AUTH-9230|Configure password hashing rounds in /etc/login.defs|-|-|
suggestion[]=AUTH-9262|Install a PAM module for password strength testing like pam_cracklib or pam_passwdqc or libpam-passwdqc|-|-|
suggestion[]=AUTH-9286|Configure minimum password age in /etc/login.defs|-|-|
suggestion[]=AUTH-9286|Configure maximum password age in /etc/login.defs|-|-|
suggestion[]=AUTH-9328|Default umask in /etc/login.defs could be more strict like 027|-|-|
suggestion[]=AUTH-9328|Default umask in /etc/init.d/rc could be more strict like 027|-|-|
suggestion[]=FILE-6310|To decrease the impact of a full /home file system, place /home on a separate partition|-|-|
suggestion[]=FILE-6310|To decrease the impact of a full /tmp file system, place /tmp on a separate partition|-|-|
suggestion[]=FILE-6310|To decrease the impact of a full /var file system, place /var on a separate partition|-|-|
suggestion[]=USB-1000|Disable drivers like USB storage when not used, to prevent unauthorized storage or data theft|-|-|
suggestion[]=STRG-1846|Disable drivers like firewire storage when not used, to prevent unauthorized storage or data theft|-|-|
suggestion[]=NAME-4028|Check DNS configuration for the dns domain name|-|-|
suggestion[]=PKGS-7370|Install debsums utility for the verification of packages with known good database.|-|-|
suggestion[]=PKGS-7392|Update your system with apt-get update, apt-get upgrade, apt-get dist-upgrade and/or unattended-upgrades|-|-|
suggestion[]=PKGS-7394|Install package apt-show-versions for patch management purposes|-|-|
suggestion[]=PKGS-7420|Consider using a tool to automatically apply upgrades|-|-|
suggestion[]=NETW-3200|Determine if protocol 'dccp' is really needed on this system|-|-|
suggestion[]=NETW-3200|Determine if protocol 'sctp' is really needed on this system|-|-|
suggestion[]=NETW-3200|Determine if protocol 'rds' is really needed on this system|-|-|
suggestion[]=NETW-3200|Determine if protocol 'tipc' is really needed on this system|-|-|
suggestion[]=LOGG-2130|Check if any syslog daemon is running and correctly configured.|-|-|
suggestion[]=BANN-7126|Add a legal banner to /etc/issue, to warn unauthorized users|-|-|
suggestion[]=BANN-7130|Add legal banner to /etc/issue.net, to warn unauthorized users|-|-|
suggestion[]=ACCT-9622|Enable process accounting|-|-|
suggestion[]=ACCT-9626|Enable sysstat to collect accounting (no results)|-|-|
suggestion[]=ACCT-9628|Enable auditd to collect audit information|-|-|
suggestion[]=TIME-3104|Use NTP daemon or NTP client to prevent time issues.|-|-|
suggestion[]=FINT-4350|Install a file integrity tool to monitor changes to critical and sensitive files|-|-|
suggestion[]=TOOL-5002|Determine if automation tools are present for system management|-|-|
suggestion[]=FILE-7524|Consider restricting file permissions|See screen output or log file|text:Use chmod to change file permissions|
suggestion[]=KRNL-6000|One or more sysctl values differ from the scan profile and could be tweaked||Change sysctl value or disable test (skip-test=KRNL-6000:<sysctl-key>)|
suggestion[]=HRDN-7222|Harden compilers like restricting access to root user only|-|-|
suggestion[]=HRDN-7230|Harden the system by installing at least one malware scanner, to perform periodic file system scans|-|Install a tool like rkhunter, chkrootkit, OSSEC, Wazuh|
