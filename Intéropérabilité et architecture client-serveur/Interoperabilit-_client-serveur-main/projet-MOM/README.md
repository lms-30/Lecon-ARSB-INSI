# Système de Notifications d'Événements Sécurisés (MOM)

## Architecture
- RabbitMQ (broker)
- Publisher (Python) -> envoie des événements dans la queue `events`
- Processor (Node.js) -> consomme `events`, stocke en SQLite, publie `alerts`
- Notifier (Go) -> s'abonne à `alerts` et affiche

## Pré-requis
- Docker & Docker Compose
- Python 3.8+, pip
- Node.js 16+
- Go 1.18+
- (facultatif) Git

## Démarrage rapide

1. Lancer RabbitMQ :
```
docker-compose up -d
# vérifier interface management: http://localhost:15672 (guest/guest)
```
2. Lancer le serveur BDD
```
node indes.js
```
3. Lancer l'application responsable de la notification des utilisatuer
```
go run main.go
```
3. Lancer le client
```
python3 main.py
```
