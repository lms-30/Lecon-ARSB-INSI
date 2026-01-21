### Conteneur Web + Base de Données

**Objectif :** Déployer une application PHP qui communique avec une base MySQL/PostgreSQL.

**Exercice :**

- Lancer deux services : `web` (php-apache) et `db` (MySQL).
    
- Configurer les variables d’environnement pour connecter les deux.
    
- Tester avec une page PHP connectée à MySQL.


### SOLUTIONS

structure du projet :
```
exercice2/
├── docker-compose.yml
├── web/
│   ├── Dockerfile
│   └── index.php

```
création du fichier dockerfile pour installer la dépendances de php connection au base de données mysql
```
FROM php:8.2-apache

RUN docker-php-ext-install pdo pdo_mysql
```
Création d'un fichier docker compose (docker-compose.yml)
```
versions: '3.8'

services:
  web:
    build:
      context: ./web
      dockerfile: Dockerfile
    ports:
      - 8080:80
    volumes:
      - ./web/index.php:/var/www/html/index.php
    depend_on:
      - db
  db:
    image: mysql:5.7
    container_name: mysql
    restart: always
    environment:
      MYSQL_ROOT_PASSWORD: rootpassword
      MYSQL_DATABASE: testdb
      MYSQL_USER: testuser
      MYSQL_PASSWORD: testpassord
    volumes:
      - db_data:/var/lib/mysql
	ports:
	  - 3306:3306

volumes:
  - db_data:

```

Création du fichier web/index.php
```
<?php
$host = 'db';
$dbname = 'testdb';
$username = 'testuser';
$password = 'testpass';

try {
    $pdo = new PDO("mysql:host=$host;dbname=$dbname", $username, $password);
    echo "<h2>Connexion réussie à la base de données !</h2>";

	} catch (PDOException $e) {
    echo "Erreur de connexion : " . $e->getMessage();
}
?>

```