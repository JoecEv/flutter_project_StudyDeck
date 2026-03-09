"use strict";
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
exports.DataService = void 0;
const sqlite3_1 = __importDefault(require("sqlite3"));
const fs_1 = __importDefault(require("fs"));
class DataService {
    constructor() {
        this._db = null;
        this._db = new sqlite3_1.default.Database('studyDeck.sqlite');
        if (!fs_1.default.existsSync('studyDeck.sqlite')) {
            this._db.serialize(() => this.initData());
        }
    }
    initData() {
        this._db.run('DROP TABLE IF EXISTS Users');
        this._db.run('DROP TABLE IF EXISTS Cards');
        this._db.run('DROP TABLE IF EXISTS Decks');
        this._db.run(`
        CREATE TABLE IF NOT EXISTS Users (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          name TEXT NOT NULL UNIQUE
        )`);
        this._db.run(`
        CREATE TABLE IF NOT EXISTS Decks (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          userId INTEGER NOT NULL,
          name TEXT NOT NULL,
          progress NUMBER DEFAULT 0,
          FOREIGN KEY (userId) REFERENCES Users(id)
        )`);
        this._db.run(`
        CREATE TABLE IF NOT EXISTS Cards (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          deckId INTEGER NOT NULL,
          front TEXT NOT NULL,
          back TEXT NOT NULL,
          FOREIGN KEY (deckId) REFERENCES Decks(id)
        )`);
        this._db.run(`INSERT INTO Users (name) VALUES ('Joec')`);
        this._db.run(`INSERT INTO Decks (userId, name) VALUES (1, 'English to German Basics')`);
        this._db.run(`INSERT INTO Decks (userId, name) VALUES (1, 'German to English Basics')`);
        this._db.run(`INSERT INTO Decks (userId, name) VALUES (1, 'Food & Drinks')`);
        this._db.run(`INSERT INTO Decks (userId, name) VALUES (1, 'Adjectives')`);
        this._db.run(`INSERT INTO Cards (deckId, front, back) VALUES (1, 'hello', 'hallo')`);
        this._db.run(`INSERT INTO Cards (deckId, front, back) VALUES (1, 'goodbye', 'auf Wiedersehen')`);
        this._db.run(`INSERT INTO Cards (deckId, front, back) VALUES (1, 'please', 'bitte')`);
        this._db.run(`INSERT INTO Cards (deckId, front, back) VALUES (1, 'thank you', 'danke')`);
        this._db.run(`INSERT INTO Cards (deckId, front, back) VALUES (1, 'yes', 'ja')`);
        this._db.run(`INSERT INTO Cards (deckId, front, back) VALUES (2, 'Haus', 'house')`);
        this._db.run(`INSERT INTO Cards (deckId, front, back) VALUES (2, 'Baum', 'tree')`);
        this._db.run(`INSERT INTO Cards (deckId, front, back) VALUES (2, 'Wasser', 'water')`);
        this._db.run(`INSERT INTO Cards (deckId, front, back) VALUES (2, 'Buch', 'book')`);
        this._db.run(`INSERT INTO Cards (deckId, front, back) VALUES (2, 'Schule', 'school')`);
        this._db.run(`INSERT INTO Cards (deckId, front, back) VALUES (3, 'bread', 'Brot')`);
        this._db.run(`INSERT INTO Cards (deckId, front, back) VALUES (3, 'apple', 'Apfel')`);
        this._db.run(`INSERT INTO Cards (deckId, front, back) VALUES (3, 'milk', 'Milch')`);
        this._db.run(`INSERT INTO Cards (deckId, front, back) VALUES (3, 'cheese', 'Käse')`);
        this._db.run(`INSERT INTO Cards (deckId, front, back) VALUES (3, 'water', 'Wasser')`);
        this._db.run(`INSERT INTO Cards (deckId, front, back) VALUES (4, 'big', 'groß')`);
        this._db.run(`INSERT INTO Cards (deckId, front, back) VALUES (4, 'small', 'klein')`);
        this._db.run(`INSERT INTO Cards (deckId, front, back) VALUES (4, 'fast', 'schnell')`);
        this._db.run(`INSERT INTO Cards (deckId, front, back) VALUES (4, 'slow', 'langsam')`);
        this._db.run(`INSERT INTO Cards (deckId, front, back) VALUES (4, 'beautiful', 'schön')`);
    }
    ;
    checkUsername(username, callback) {
        this._db.get('SELECT 1 FROM Users WHERE name = ?', [username], (err, user) => {
            if (err)
                return callback(err, null);
            let isExisting;
            if (!!user) {
                isExisting = true;
                callback(null, isExisting);
            }
            else {
                this._db.run('INSERT INTO Users (name) VALUES (?)', [username]);
                isExisting = false;
                callback(null, isExisting);
            }
        });
    }
    getAllDecks(callback) {
        this._db.all('SELECT * FROM Decks', (err, decks) => {
            callback(err, decks.sort((a, b) => a.name.localeCompare(b.name)));
        });
    }
    getDeckById(id, callback) {
        this._db.get('SELECT * FROM Decks WHERE id = ?', [id], (err, deck) => {
            callback(err, deck);
        });
    }
    addDeck(name) {
        this._db.run('INSERT INTO Decks (name) VALUES (?)', [name]);
    }
    addCards(cards, deckId) {
        cards.forEach(card => {
            this._db.run('INSERT INTO Decks (front, back) VALUES (?, ?)', [
                deckId,
                card.front,
                card.back
            ]);
        });
    }
    deleteDeck(id) {
        this._db.run('DELETE FROM Cards WHERE deckid = ?', [id]);
        this._db.run('DELETE FROM Decks WHERE id = ?', [id]);
    }
    updateProgress(id, progess) {
        this._db.run('UPDATE Decks SET progress = ? WHERE id = ?', [
            progess,
            id
        ]);
    }
}
exports.DataService = DataService;
