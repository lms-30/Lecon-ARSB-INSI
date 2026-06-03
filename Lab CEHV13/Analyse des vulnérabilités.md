Procéssus et méthodologie pour identifier, classifier et prioriser 

Analyse  : visualisation + rapport (Prévention)
Analayse de vulnérabilité : identification automatique des vulnérabilités

### Vulnérabilité système
- Port ouvert mais unitil
- Mot de passe faible
- composant non-patcher, absence d'authentification

### Top 10 OWASP
- Injection SQL
- XSS
- C

### Étape d'analyse de vulnérabilités

1. identification de l'environnement : nombre de serveur, router, application, 
2. Scan vulnérabilité : NESSUS, OpenVas, NextPose,BurpSuit, Rapid7InSighVH, AWS inspector, Guard Duty, GCP Security, AZUR Defender, OWASP Zap, Nikto, Nmap, NSE Script.
3. Analyse et validation : vérifier les faut positives, cohére (ampiranarahana ny version système), validation manuel
4. Priorisation : 
		- 0 à 3.9 : Low
		- 4.0 à 6.9 : Medium
		- 7.0 - 8.9 : High
		- 9.0 - 10 : Critical
5. Remédiation : mise en conformité, sécurisation IAM, suppression des port unitils
6. Rapport des vulnérabilités : rapport exécutif, score CVESS, risque métier, corréctif récommander, time-line de remèdiation, preuve ()

### Guide Officiel d'analyses des vulnérabilités

- OWASP,
- MITRE, 
- CVE, 
- NIST 800 - 115