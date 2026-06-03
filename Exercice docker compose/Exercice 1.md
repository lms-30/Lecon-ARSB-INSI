### Lancer un conteneur Web avec Nginx

**Objectif :** Utiliser Docker Compose pour lancer un simple serveur web Nginx.

**Exercice :**

- Crée un `docker-compose.yml` pour lancer `nginx`.
    
- Monte un volume local pour la page d’accueil (`index.html`).



### Solutions
 création d'un fichier docker-compose.yml
```
version: '3.9'

services:
  my_app:
    image: nginx:latest
    container_name: serveur_nginx
    volumes:
      - ./index.html:/usr/share/nginx/html/index.html
    ports:
      - 8082:80
```
création d'un page a déployer:
```
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <title>Mon Exemplo de Page</title>
    <style>
        body {
            font-family: sans-serif;
            background-color: #f0f0f0;
            color: #333;
        }
        h1 {
            color: navy;
        }
    </style>
</head>
<body>
```
