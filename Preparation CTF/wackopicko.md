Vulnérabilité trouvées 

warning[]=PHP-2368|PHP option register_globals option is turned on, which can be a risk for variable value overwriting|
warning[]=PHP-2372|PHP option expose_php is possibly turned on, which can reveal useful information for attackers.|
warning[]=LOGG-2130|No syslog daemon found|
warning[]=LOGG-2138|klogd is not running, which could lead to missing kernel messages in log files|
warning[]=CRYP-7902|Found SSL certificate expiration (/etc/ssl/certs/ca-certificates.crt)|


suggestion[]=KRNL-5788|Please check the output of apt-cache policy manually to determine why output is empty|
suggestion[]=AUTH-9262|Install a PAM module for password strength testing like pam_cracklib or pam_passwdqc|
suggestion[]=AUTH-9286|Configure password aging limits to enforce password changing on a regular base|
suggestion[]=AUTH-9328|Default umask in /etc/login.defs could be more strict like 027|
suggestion[]=AUTH-9328|Default umask in /etc/init.d/rc could be more strict like 027|
suggestion[]=FILE-6310|To decrease the impact of a full /home file system, place /home on a separated partition|
suggestion[]=FILE-6310|To decrease the impact of a full /tmp file system, place /tmp on a separated partition|
suggestion[]=FILE-6410|The database required for 'locate' could not be found. Run 'updatedb' or 'locate.updatedb' to create this file.|
suggestion[]=STRG-1840|Disable drivers like USB storage when not used, to prevent unauthorized storage or data theft|
suggestion[]=PKGS-7394|Install package apt-show-versions for patch management purposes|
suggestion[]=PKGS-7398|Install a package audit tool to determine vulnerable packages|
suggestion[]=HTTP-6640|Install Apache mod_evasive to guard webserver against DoS/brute force attempts|
suggestion[]=HTTP-6641|Install Apache mod_qos to guard webserver against Slowloris attacks|
suggestion[]=HTTP-6642|Install Apache mod_spamhaus to guard webserver against spammers|
suggestion[]=HTTP-6643|Install Apache modsecurity to guard webserver against web application attacks|
suggestion[]=PHP-2320|Harden PHP by disabling riskful functions (functions of interest: chown, diskfreespace, disk_free_space, disk_total_space, dl, exec, escapeshellarg, escapeshellcmd, fileinode, highlight_file(), max_execution_time, passthru, pclose, phpinfo, popen, proc_close, proc_open, proc_get_status, proc_nice, proc_open, proc_terminate, set_time_limit(), shell_exec, show_source(), system)|
suggestion[]=PHP-2368|Change the register_globals line to: register_globals = Off|
suggestion[]=PHP-2372|Change the expose_php line to: expose_php = Off|
suggestion[]=PHP-2376|Change the allow_url_fopen line to: allow_url_fopen = Off, to disable downloads via PHP|
suggestion[]=LOGG-2130|Check if any syslog daemon is running and correctly configured.|
suggestion[]=LOGG-2138|Check why klogd is not running|
suggestion[]=BANN-7126|Add a legal banner to /etc/issue, to warn unauthorized users|
suggestion[]=BANN-7130|Add legal banner to /etc/issue.net, to warn unauthorized users|
suggestion[]=ACCT-9628|Enable auditd to collect audit information|
suggestion[]=CRYP-7902|Renew SSL expired certificates.|
suggestion[]=FINT-4350|Install a file integrity tool|
suggestion[]=KRNL-6000|One or more sysctl values differ from the scan profile and could be tweaked|
suggestion[]=HRDN-7220|Harden the system by removing unneeded compilers. This can decrease the chance of customized trojans, backdoors and rootkits to be compiled and installed|
suggestion[]=HRDN-7222|Harden compilers and restrict access to world|
suggestion[]=HRDN-7230|Harden the system by installing one or malware scanners to perform periodic file system scans|


