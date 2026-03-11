"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
const express_1 = require("express");
const dataService_1 = require("../services/dataService");
const dataService = new dataService_1.DataService();
const router = (0, express_1.Router)();
router.post('/user/check-username', (req, res) => {
    if (!req.query.username) {
        return res.status(404).send({ error: 'Es wurde kein Benutzername eingegeben' });
    }
    dataService.checkUsername(req.query.username.toString(), (err, isExisting) => {
        if (err) {
            return res.status(500);
        }
        return res.status(200).send({ isExisting });
    });
});
router.get('/decks', (req, res) => {
    dataService.getAllDecks(function (err, decks) {
        if (!decks) {
            return res.status(404).send({ error: 'Es wurde keine Decks gefunden' });
        }
        return res.send(decks);
    });
});
router.get('/decks{/:id}', (req, res) => {
    if (!req.params.id) {
        return res.status(404).send({ error: 'Keine Id mitgegeben' });
    }
    dataService.getDeckById(+req.params.id, function (err, deck) {
        if (!deck) {
            return res.status(404).send({ error: 'Es wurde kein Deck gefunden' });
        }
        return res.send(deck);
    });
});
router.post('/decks', (req, res) => {
    if (!req.body.name) {
        return res.status(404).send({ error: 'Kein Deckname mitgegeben' });
    }
    dataService.addDeck(req.body.name);
    return res.status(200).send({ message: 'Deck hinzugefugt' });
});
router.post('/decks{/:id}/cards', (req, res) => {
    if (!req.params.id) {
        return res.status(404).send({ error: 'Kein Id mitgegeben' });
    }
    if (!req.body.cards || !Array.isArray(req.body.cards)) {
        return res.status(404).send({ error: 'Fehlende oder falsche Karten' });
    }
    dataService.addCards(req.body.cards, +req.params.id);
    return res.status(200).send({ message: 'Cards hinzugefügt' });
});
router.delete('/decks{/:id}', (req, res) => {
    if (!req.params.id) {
        return res.status(404).send({ error: 'Kein Id mitgegeben' });
    }
    dataService.deleteDeck(+req.params.id);
    return res.status(200).send({ message: 'Deck gelöscht' });
});
router.put('/decks{/:id}', (req, res) => {
    if (!req.params.id) {
        return res.status(404).send({ error: 'Kein Id mitgegeben' });
    }
    if (req.body.progress === undefined || req.body.progress === null) {
        return res.status(404).send({ error: 'Keine Progress mitgegeben' });
    }
    dataService.updateProgress(+req.params.id, req.body.progress);
    return res.status(200).send({ message: 'Progress geupdatet' });
});
exports.default = router;
