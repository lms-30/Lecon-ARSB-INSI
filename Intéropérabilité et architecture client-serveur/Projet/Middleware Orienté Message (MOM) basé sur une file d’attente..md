1. Installer RabbitMQ
```
sudo apt update
sudo apt install rabbitmq-server -y
```
2. Démarrer le service
```
sudo systemctl enable rabbitmq-server
sudo systemctl start rabbitmq-server
sudo systemctl status rabbitmq-server
```
![[Pasted image 20251209090736.png]]

3. Installer la librairie “pika”
```
pip install pika
```
![[Pasted image 20251209091044.png]]

4. Code du Producteur (Service A)
```
import pika
import json

def send_notification(event, payload):
    connection = pika.BlockingConnection(
        pika.ConnectionParameters('localhost')
    )
    channel = connection.channel()

    channel.queue_declare(queue='notifications')

    message = {
        "event": event,
        "payload": payload
    }

    channel.basic_publish(
        exchange='',
        routing_key='notifications',
        body=json.dumps(message)
    )

    print(f"[Producteur] Message envoyé : {message}")
    connection.close()


if __name__ == "__main__":
    send_notification(
        "user_registered",
        {"user_id": 44, "name": "Sylvain"}
    )

```
4. Consommateur B – Enregistrer en base SQLite

```
import pika
import json
import sqlite3

conn = sqlite3.connect("events.db")
cursor = conn.cursor()

cursor.execute("""
CREATE TABLE IF NOT EXISTS logs (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    event TEXT,
    payload TEXT
)
""")

def callback(ch, method, properties, body):
    data = json.loads(body)
    print(f"[DB] Message reçu : {data}")

    cursor.execute(
        "INSERT INTO logs(event, payload) VALUES (?, ?)",
        (data["event"], json.dumps(data["payload"]))
    )
    conn.commit()

connection = pika.BlockingConnection(
    pika.ConnectionParameters('localhost')
)
channel = connection.channel()
channel.queue_declare(queue='notifications')

channel.basic_consume(
    queue='notifications',
    on_message_callback=callback,
    auto_ack=True
)

print("[DB] En attente de messages...")
channel.start_consuming()
```
5. Consommateur C – Simuler un envoi d’e-mail
