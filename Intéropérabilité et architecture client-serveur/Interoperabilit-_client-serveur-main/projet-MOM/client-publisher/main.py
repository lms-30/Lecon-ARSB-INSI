#!/usr/bin/env python3
"""
Publisher simple : envoie des événements JSON dans la queue 'events'.
Usage: python3 main.py
"""

import pika
import json
import time
import uuid
from datetime import datetime
import argparse
import random

def get_connection_params(host='localhost', port=5672, user='guest', password='guest'):
    creds = pika.PlainCredentials(user, password)
    return pika.ConnectionParameters(host=host, port=port, credentials=creds)

def publish_event(conn_params, queue='events', event=None):
    conn = pika.BlockingConnection(conn_params)
    ch = conn.channel()
    # durable queue
    ch.queue_declare(queue=queue, durable=True)
    body = json.dumps(event)
    ch.basic_publish(
        exchange='',
        routing_key=queue,
        body=body,
        properties=pika.BasicProperties(
            delivery_mode=2,  # make message persistent
            content_type='application/json'
        )
    )
    print(f"[PUBLISHED] {body}")
    conn.close()

def gen_sample_event(source='client-1'):
    etype = random.choice(['auth_success', 'auth_fail', 'cpu_temp', 'service_ping'])
    details = ''
    if etype == 'auth_fail':
        details = f"Wrong password for user {random.choice(['admin','root','guest'])}"
    elif etype == 'auth_success':
        details = f"User {random.choice(['alice','bob','charlie'])} logged in"
    elif etype == 'cpu_temp':
        details = f"CPU {random.randint(30,95)}C"
    else:
        details = f"{random.choice(['db','web','cache'])} responded in {random.randint(10,300)}ms"

    return {
        "id": str(uuid.uuid4()),
        "source": source,
        "type": etype,
        "timestamp": datetime.utcnow().isoformat() + "Z",
        "details": details
    }

def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("--host", default="localhost")
    parser.add_argument("--queue", default="events")
    parser.add_argument("--source", default="client-1")
    parser.add_argument("--rate", type=float, default=1.0, help="events per second")
    args = parser.parse_args()

    conn_params = get_connection_params(host=args.host)
    try:
        print("Publishing events (CTRL+C to stop)...")
        while True:
            ev = gen_sample_event(source=args.source)
            publish_event(conn_params, queue=args.queue, event=ev)
            time.sleep(1.0 / args.rate)
    except KeyboardInterrupt:
        print("Stopped.")

if __name__ == "__main__":
    main()
