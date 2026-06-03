// db.js - wrapper sqlite simple
const sqlite3 = require('sqlite3').verbose();
const path = require('path');

const DB_PATH = path.join(__dirname, 'events.db');

function initDb() {
  const db = new sqlite3.Database(DB_PATH);
  db.serialize(() => {
    db.run(`CREATE TABLE IF NOT EXISTS events (
      id TEXT PRIMARY KEY,
      source TEXT,
      type TEXT,
      timestamp TEXT,
      details TEXT
    )`);
    db.run(`CREATE TABLE IF NOT EXISTS alerts (
      id TEXT PRIMARY KEY,
      event_id TEXT,
      severity TEXT,
      message TEXT,
      timestamp TEXT
    )`);
  });
  return db;
}

module.exports = {
  initDb,
};
