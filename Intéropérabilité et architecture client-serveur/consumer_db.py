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
