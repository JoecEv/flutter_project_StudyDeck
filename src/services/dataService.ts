import sqlite3, { Database } from 'sqlite3';
import fs from 'fs';

export class DataService {
  private _db: Database | null = null;

  constructor() {
    if (!fs.existsSync('studyDeck.sqlite')) {
      this._db = new sqlite3.Database('studyDeck.sqlite');
      this._db!.serialize(() => this.initData());
    }

  }

  private initData() {
    this._db!.run('DROP TABLE IF EXISTS Users');
    this._db!.run('DROP TABLE IF EXISTS Cards');
    this._db!.run('DROP TABLE IF EXISTS Decks');

    this._db!.run(`
        CREATE TABLE IF NOT EXISTS Users (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          name TEXT NOT NULL UNIQUE
        )`);

    this._db!.run(`
        CREATE TABLE IF NOT EXISTS Decks (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          userId INTEGER NOT NULL,
          name TEXT NOT NULL,
          progress NUMBER,
          FOREIGN KEY (userId) REFERENCES Users(id)
        )`);

    this._db!.run(`
        CREATE TABLE IF NOT EXISTS Cards (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          deckId INTEGER NOT NULL,
          front TEXT NOT NULL,
          back TEXT NOT NULL,
          FOREIGN KEY (deckId) REFERENCES Decks(id)
        )`);

    this._db!.run(`INSERT INTO Users (id, name) VALUES (1, 'Joec')`);

    this._db!.run(`INSERT INTO Decks (id, userId, name) VALUES (1, 1, 'English to German Basics')`);
    this._db!.run(`INSERT INTO Decks (id, userId, name) VALUES (2, 1, 'German to English Basics')`);
    this._db!.run(`INSERT INTO Decks (id, userId, name) VALUES (3, 1, 'Food & Drinks')`);
    this._db!.run(`INSERT INTO Decks (id, userId, name) VALUES (4, 1, 'Adjectives')`);

    this._db!.run(`INSERT INTO Cards (deckId, front, back) VALUES (1, 'hello', 'hallo')`);
    this._db!.run(`INSERT INTO Cards (deckId, front, back) VALUES (1, 'goodbye', 'auf Wiedersehen')`);
    this._db!.run(`INSERT INTO Cards (deckId, front, back) VALUES (1, 'please', 'bitte')`);
    this._db!.run(`INSERT INTO Cards (deckId, front, back) VALUES (1, 'thank you', 'danke')`);
    this._db!.run(`INSERT INTO Cards (deckId, front, back) VALUES (1, 'yes', 'ja')`);


    this._db!.run(`INSERT INTO Cards (deckId, front, back) VALUES (2, 'Haus', 'house')`);
    this._db!.run(`INSERT INTO Cards (deckId, front, back) VALUES (2, 'Baum', 'tree')`);
    this._db!.run(`INSERT INTO Cards (deckId, front, back) VALUES (2, 'Wasser', 'water')`);
    this._db!.run(`INSERT INTO Cards (deckId, front, back) VALUES (2, 'Buch', 'book')`);
    this._db!.run(`INSERT INTO Cards (deckId, front, back) VALUES (2, 'Schule', 'school')`);

    this._db!.run(`INSERT INTO Cards (deckId, front, back) VALUES (3, 'bread', 'Brot')`);
    this._db!.run(`INSERT INTO Cards (deckId, front, back) VALUES (3, 'apple', 'Apfel')`);
    this._db!.run(`INSERT INTO Cards (deckId, front, back) VALUES (3, 'milk', 'Milch')`);
    this._db!.run(`INSERT INTO Cards (deckId, front, back) VALUES (3, 'cheese', 'Käse')`);
    this._db!.run(`INSERT INTO Cards (deckId, front, back) VALUES (3, 'water', 'Wasser')`);

    this._db!.run(`INSERT INTO Cards (deckId, front, back) VALUES (4, 'big', 'groß')`);
    this._db!.run(`INSERT INTO Cards (deckId, front, back) VALUES (4, 'small', 'klein')`);
    this._db!.run(`INSERT INTO Cards (deckId, front, back) VALUES (4, 'fast', 'schnell')`);
    this._db!.run(`INSERT INTO Cards (deckId, front, back) VALUES (4, 'slow', 'langsam')`);
    this._db!.run(`INSERT INTO Cards (deckId, front, back) VALUES (4, 'beautiful', 'schön')`);
  };
}
