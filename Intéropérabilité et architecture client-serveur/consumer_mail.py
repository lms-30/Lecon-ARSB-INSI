import pika
import json

def callback(ch, method, properties, body):
    data = json.loads(body)
    print(f"[MAIL] Email envoyé pour l'événement : {data}")


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

print("[MAIL] En attente de messages...")
channel.start_consuming()
