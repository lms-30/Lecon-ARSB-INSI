// index.js - consumer qui lit la queue 'events', analyse, stocke et publie des alerts dans 'alerts' queue
const amqp = require('amqplib');
const { initDb } = require('./db');
const { v4: uuidv4 } = require('uuid');

const RABBIT_URL = "amqp://guest:guest@127.0.0.1:5672";
const EVENTS_QUEUE = 'events';
const ALERTS_QUEUE = 'alerts';

// simple in-memory counter pour démonstration (compteur d'échecs par source)
const failCounters = {};

async function processEvent(msgObj, ch) {
  // msgObj is parsed JSON
  console.log('[PROCESS] ', msgObj);

  // store event in sqlite
  const db = global.__DB;
  db.run(`INSERT OR IGNORE INTO events (id,source,type,timestamp,details) VALUES (?,?,?,?,?)`,
    [msgObj.id, msgObj.source, msgObj.type, msgObj.timestamp, msgObj.details]);

  // simple detection: si > 3 auth_fail depuis même source => alert
  if (msgObj.type === 'auth_fail') {
    failCounters[msgObj.source] = (failCounters[msgObj.source] || 0) + 1;
    if (failCounters[msgObj.source] >= 3) {
      const alert = {
        id: uuidv4(),
        event_id: msgObj.id,
        severity: 'high',
        message: `Multiple auth failures from ${msgObj.source} (${failCounters[msgObj.source]})`,
        timestamp: new Date().toISOString()
      };
      // insert alert into db
      db.run(`INSERT INTO alerts (id,event_id,severity,message,timestamp) VALUES (?,?,?,?,?)`,
        [alert.id, alert.event_id, alert.severity, alert.message, alert.timestamp]);
      // publish alert
      await ch.assertQueue(ALERTS_QUEUE, { durable: true });
      ch.sendToQueue(ALERTS_QUEUE, Buffer.from(JSON.stringify(alert)), { persistent: true, contentType: 'application/json' });
      console.log('[ALERT PUBLISHED]', alert);
      // reset counter (for demo)
      failCounters[msgObj.source] = 0;
    }
  } else {
    // for other event types we might do other checks
    // Ex: cpu_temp > 80 => medium alert
    if (msgObj.type === 'cpu_temp') {
      const num = parseInt(msgObj.details.match(/\d+/));
      if (num && num >= 80) {
        const alert = {
          id: uuidv4(),
          event_id: msgObj.id,
          severity: 'medium',
          message: `High CPU temp ${num}C on ${msgObj.source}`,
          timestamp: new Date().toISOString()
        };
        db.run(`INSERT INTO alerts (id,event_id,severity,message,timestamp) VALUES (?,?,?,?,?)`,
          [alert.id, alert.event_id, alert.severity, alert.message, alert.timestamp]);
        await ch.assertQueue(ALERTS_QUEUE, { durable: true });
        ch.sendToQueue(ALERTS_QUEUE, Buffer.from(JSON.stringify(alert)), { persistent: true, contentType: 'application/json' });
        console.log('[ALERT PUBLISHED]', alert);
      }
    }
  }
}

async function start() {
  const conn = await amqp.connect(RABBIT_URL);
  const ch = await conn.createChannel();
  await ch.assertQueue(EVENTS_QUEUE, { durable: true });
  await ch.assertQueue(ALERTS_QUEUE, { durable: true });

  console.log(`Connected to Rabbit: ${RABBIT_URL}. Waiting for messages in '${EVENTS_QUEUE}'...`);

  ch.consume(EVENTS_QUEUE, async (msg) => {
    if (msg !== null) {
      try {
        const body = msg.content.toString();
        const obj = JSON.parse(body);
        await processEvent(obj, ch);
        ch.ack(msg);
      } catch (err) {
        console.error('Processing error', err);
        // NACK with requeue = false to avoid tight loop; in production, use DLQ.
        ch.nack(msg, false, false);
      }
    }
  }, { noAck: false });

  // close handler
  process.on('SIGINT', async () => {
    console.log('Shutting down...');
    await ch.close();
    await conn.close();
    process.exit(0);
  });
}

async function init() {
  // init DB
  const db = initDb();
  global.__DB = db;
  await start();
}

init().catch(err => {
  console.error(err);
  process.exit(1);
});
