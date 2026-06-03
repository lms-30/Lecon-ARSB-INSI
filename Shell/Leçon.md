## Objectif final

À la fin, tu sauras :

- Automatiser des tâches Linux
    
- Écrire des scripts pros (admin & cyber)
    
- Créer des scripts de **sécurité, surveillance, sauvegarde**
    
- Utiliser tes scripts dans des projets académiques & professionnels
    

---

# PLAN D’APPRENTISSAGE (progressif)

### **Niveau 1 – Bases du Shell**

1. Qu’est-ce que le Shell (bash)
    
2. Créer et exécuter un script
    
3. Commentaires & permissions
    
4. Variables
    
5. Entrées utilisateur (`read`)
    
6. Conditions (`if / else`)
    
7. Boucles (`for`, `while`)
    

---

### **Niveau 2 – Automatisation**

8. Fonctions
    
9. Scripts avec paramètres (`$1 $2`)
    
10. Gestion des fichiers & dossiers
    
11. Vérification de services
    
12. Scripts planifiés avec `cron`
    
13. Logs & journalisation
    

---

### **Niveau 3 – Cybersécurité & Admin**

14. Scanner réseau automatique
    
15. Détection de services suspects
    
16. Surveillance CPU / RAM / DISQUE
    
17. Sauvegarde automatique
    
18. Script IDS simple
    
19. Script de durcissement système
    

---

##  NIVEAU 1 – COMMENÇONS MAINTENANT

### 1. Créer ton premier script
```
nano hello.sh
```
Contenu :
```
#!/bin/bash

echo "Bonjour, bienvenue dans le Shell Script 🚀"

```
Rendre exécutable :
```
chmod -x hello.sh
```
Exécuter :
```
./hello.sh
```

### 2. Variables
```
#!/bin/bash

nom = "sylvain"

echo "Bonjours $nom"
```
