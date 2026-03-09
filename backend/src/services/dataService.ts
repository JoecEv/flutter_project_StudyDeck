import sqlite3, { Database } from 'sqlite3';
import fs from 'fs';
import { Deck } from '../models/deck';
import { User } from '../models/user';
import { DeckCard } from '../models/deckCard';

export class DataService {
  private _db: Database | null = null;

  constructor() {
    this._db = new sqlite3.Database('studyDeck.sqlite');
    if (!fs.existsSync('studyDeck.sqlite')) {
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
          progress NUMBER DEFAULT 0,
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

    this._db!.run(`INSERT INTO Users (name) VALUES ('Joec')`);

    this._db!.run(`INSERT INTO Decks (userId, name) VALUES (1, 'English to German Basics')`);
    this._db!.run(`INSERT INTO Decks (userId, name) VALUES (1, 'German to English Basics')`);
    this._db!.run(`INSERT INTO Decks (userId, name) VALUES (1, 'Food & Drinks')`);
    this._db!.run(`INSERT INTO Decks (userId, name) VALUES (1, 'Adjectives')`);

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

  checkUsername(username: string, callback: Function): void {
    this._db!.get('SELECT 1 FROM Users WHERE name = ?', [username], (err: Error, user: User) => {
      if (err) return callback(err, null);
      let isExisting;

      if (!!user) {
        isExisting = true;
        callback(null, isExisting);
      } else {
        this._db!.run(
          'INSERT INTO Users (name) VALUES (?)',
          [username]
        );
        isExisting = false
        callback(null, isExisting);
      }

    });
  }

  getAllDecks(callback: Function): void {
    this._db!.all('SELECT * FROM Decks', (err: Error, decks: Deck[]) => {
      callback(err, decks.sort((a, b) => a.name.localeCompare(b.name)));
    });
  }

  getDeckById(id: number, callback: Function): void {
    this._db!.get('SELECT * FROM Decks WHERE id = ?', [id], (err: Error, deck: Deck) => {
      callback(err, deck);
    });
  }

  addDeck(name: string) {
    this._db!.run(
      'INSERT INTO Decks (name) VALUES (?)',
      [name]
    );
  }

  addCards(cards: DeckCard[], deckId: number) {
    cards.forEach(card => {
      this._db!.run('INSERT INTO Decks (front, back) VALUES (?, ?)',
        [
          deckId,
          card.front,
          card.back
        ]
      );
    });
  }

  deleteDeck(id: number) {
    this._db!.run('DELETE FROM Cards WHERE deckid = ?', [id]);
    this._db!.run('DELETE FROM Decks WHERE id = ?', [id]);
  }

  updateProgress(id: number, progess: number) {
    this._db!.run(
      'UPDATE Decks SET progress = ? WHERE id = ?',
      [
        progess,
        id
      ]
    );
  }

}
