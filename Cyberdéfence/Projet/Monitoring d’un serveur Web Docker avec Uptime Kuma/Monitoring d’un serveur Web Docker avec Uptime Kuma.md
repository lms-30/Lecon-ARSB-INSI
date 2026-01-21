
## 1. Introduction

Avec l’essor des architectures conteneurisées, la disponibilité des services Web est devenue un enjeu majeur en cybersécurité et en administration systèmes. Une panne non détectée peut entraîner une interruption de service, une perte de données ou un impact financier important.

Ce projet a pour objectif de mettre en place une **solution de monitoring open source** afin de surveiller la disponibilité d’un **serveur Web Nginx conteneurisé avec Docker**, en utilisant l’outil **Uptime Kuma**.

---

## 2. Objectifs du projet

- Surveiller la disponibilité d’un serveur Web
- Détecter automatiquement les pannes
- Générer des alertes en cas d’indisponibilité
- Comprendre le fonctionnement du réseau Docker
- Mettre en œuvre de bonnes pratiques DevOps
    
---
## 3. Environnement de travail

### 3.1 Système
- OS : Linux (Parrot OS)
- Virtualisation : Machine virtuelle
### 3.2 Outils utilisés
- Docker
- Docker Compose
- Uptime Kuma (open source)
- Nginx
- Navigateur Web

---

## 4. Concepts théoriques

### 4.1 Docker

Docker est une plateforme de conteneurisation permettant d’exécuter des applications de manière isolée et reproductible.

### 4.2 Monitoring

Le monitoring consiste à surveiller l’état et la disponibilité des services informatiques afin de détecter rapidement les incidents.

### 4.3 Uptime Kuma

Uptime Kuma est un outil open source de monitoring permettant de surveiller des services via HTTP, TCP, Ping, HTTPS, etc.

---

## 5. Architecture du projet

![[Cyberdéfence/Projet/Monitoring d’un serveur Web Docker avec Uptime Kuma/architecture.png]]


---

## 6. Implémentation pas à pas

### 6.1 Création du fichier Docker Compose

```yaml
services:
  uptime-kuma:
    image: louislam/uptime-kuma:latest
    container_name: uptime-kuma
    ports:
      - "3001:3001"
    volumes:
      - kuma-data:/app/data
    restart: always
    networks:
      - monitoring

  web-nginx:
    image: nginx:latest
    container_name: web-nginx
    ports:
      - "8080:80"
    restart: always
    networks:
      - monitoring

networks:
  monitoring:
    driver: bridge

volumes:
  kuma-data:
```
![[Capture du 2026-01-12 13-27-00.png]]


---

### 6.3 Lancement des conteneurs

```bash
docker compose up -d
```
![[docker_compose_ps.png]]

---

### 6.4 Accès au serveur Web

Dans le navigateur :

```
http://localhost:8080
```
![[serveur_web.png]]

---

### 6.5 Accès à Uptime Kuma

Dans le navigateur :

```
http://localhost:3001
```
![[dashboard_uptime_kima.png]]

---

## 7. Configuration du monitoring
### 7.1 Ajout d’une sonde HTTP

Paramètres :
- Type : HTTP
- URL : `http://web-nginx:80`
- Intervalle : 60 secondes
- Code attendu : 200

![[Pasted image 20260112133848.png]]

---

### 7.2 Vérification du statut

- Statut : 🟢 En ligne
- Temps de réponse affiché

![[statuts_du_serveur_web.png]]

---

## 8. Tests et simulations

### 8.1 Simulation de panne

```bash
docker compose stop web-nginx
```

Résultat :
- Serveur détecté hors ligne
- Alerte générée

![[mise_en_hors_ligne.png]]

---

### 8.2 Rétablissement du service

```bash
docker compose start web-nginx
```
![[mise_en_service_du_serveur.png]]

---

## 9. Analyse des résultats

Uptime Kuma a permis de détecter instantanément l’arrêt du serveur Web. Le monitoring basé sur le réseau Docker interne assure une communication fiable entre les conteneurs.

---

## 10. Apport en cybersécurité

- Surveillance de la disponibilité (CIA)
- Détection d’incident post-attaque
- Amélioration de la résilience
- Support à une démarche SOC

---

## 11. Limites du projet

- Pas de surveillance CPU/RAM
- Pas de détection d’attaque avancée
- Dépendance au réseau Docker
---

## 12. Perspectives d’amélioration

- Intégration de Wazuh
- Alertes Telegram
- HTTPS
- Monitoring multi-services
---

## 13. Conclusion

Ce projet a permis de mettre en place une solution de monitoring fiable et open source pour un serveur Web conteneurisé. L’utilisation de Docker Compose et d’Uptime Kuma garantit une supervision continue et professionnelle adaptée à un niveau Licence 3.

---

## 14. Références

- Documentation Docker
- Documentation Uptime Kuma : 
- Documentation Nginx