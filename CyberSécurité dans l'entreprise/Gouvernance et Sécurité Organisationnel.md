La Gouvernance et Sécurité Organisationnel est le façon dont une entreprise organise les règle, les rôles et les action pour protéger les SI et assurer une bonne gestions des sécurités informatiques
#### Politique
document principale qui définie les règles globales de sécurités dans l'entreprise (ex: politique de mot de passe, politiques de sauvegardes).
### Procédure

Une **procédure** est un étape détailler a suivre pour applique la politiques.

Ny zavatra arahana mba ahafahana mi-respect an'le politique

ex: procédure de création de compte d'utilisateur
### Standard (Norme)

Règle technique précise et obligatoire

En cybersécurité, une **norme** (ou standard) est un ensemble de bonnes pratiques, de règles et de procédures validées par des experts.




# Politique de sécurité MySQL

#### Objectif
Assurer la sécurité de la BDD MySQL en protégeant les données contres les accès non-autorisé, les perte et le modification malveillant.

- gestion des utilisateur
chaque utilisateur doit avoir un compte
- authentification
le mot de passe doivent être fort et complexe, les mot de passe par défaut être change, l'accès sans mot de passe est interdit.
- contrôle d'accès
l'accès a la BDD doit être limité au machine autorisé, les droit doivent être régulièrement vérifie
- sécurité des données
les données sensible doivent être sécurisé, les sauvegarde doivent être réalise régulièrement
- journalisation et surveillance
les connexion et requête important doivent être enregistrer, les logs doivent être analyser régulièrement


##### Bonne Pratique:
Mettre a jour régulièrement le MySQL, supprimer les utilisateur inutile, n'est pas exposée directement le MySQL sur internet.