### **Stack WordPress + MySQL**

**Objectif :** Déployer WordPress et sa base de données.

**Exercice :**

- Crée un `docker-compose.yml` avec `wordpress` + `mysql`.
    
- Persister les données via des volumes.
    
- Expose WordPress sur le port 8080.

### SOLUTIONS

création d'un fichier docker-compose.yml
```
version: '3.8'

services:
  
  wordpress:
    image: wordpress
    restart: always
    container_name: wordpress
    ports:
      - 8080:80
    environment:
      WORDPRESS_DB_HOST: db
      WORDPRESS_DB_USER: testuser
      WORDPRESS_DB_PASSWORD: testpassword
      WORDPRESS_DB_NAME: testdb
    volumes:
      - wp_data:/var/www/html
    depends_on:
      - db
  
  db:
    image: mysql:8.0
    container_name: mysql
    restart: always
    environment:
      MYSQL_DATABASE: testdb
      MYSQL_USER: testuser
      MYSQL_PASSWORD: testpasword
    volumes:
      - data:/var/lib/mysql

volumes:
  wp_data:
  data:
```
