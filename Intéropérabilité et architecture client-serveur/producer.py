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
