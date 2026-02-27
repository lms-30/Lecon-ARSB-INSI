
## 1. SQL Injection

#####  Identification
Nous allons sur la page loggin de **OWASP Juice Shop** et tester le Payload avec le code ==' OR 1=1-- == 

Et tapez n'importe quel mot de passe:

![[loggin.png]]

Résultat :

![[loggin_reussi.png]]

L'image montre qu'on a réussi de d'entre dans le site web et on peut faire tout ce qu'un utilisateur peut faire.

Donc, on peut faire une Injection SQL sur cette site

##### Impact

- Contournement authentification → accès admin
    
- Dump potentiel de la base utilisateur
    
- Compromission totale si exploitation avancée
    
##### Contre-mesures

- Requêtes préparées / ORM sécurisé
    
- Validation stricte des inputs côté serveur
    
- Limiter privilèges des comptes DB
    
- WAF (ModSecurity) pour filtrer payloads

## 2. XSS (Cross-Site Scripting)

##### Identification
Pour identifier la vulnérabilité XSS, nous allons sur le page **Customer Feedback** et on va testé le scripte suivant '''<script>alert("XSS")</script>''' 

![[Pasted image 20260219104628.png]]
