import { Router, Request, Response } from 'express';
import { DataService } from '../services/dataService';
import { Deck } from '../models/deck';

const dataService = new DataService();
const router = Router();

router.get('/user/check-username', (req: Request, res: Response) => {
    if (!req.query.username) {
        return res.status(404).send({ error: 'Es wurde kein Benutzername eingegeben' });
    }

    dataService.checkUsername(req.query.username.toString(), (err: Error, isExisting: boolean) => {
        if (err) {
            return res.status(500).send({ error: 'Datenbankfehler' });
        }
        return res.status(200).send({ isExisting });
    });
});

router.get('/decks', (req: Request, res: Response) => {
    dataService.getAllDecks(function (err: Error, decks: Deck[]) {
        if (!decks) {
            return res.status(404).send({ error: 'Es wurde keine Decks gefunden' });
        }
        return res.send(decks);
    });
});

router.get('/decks{/:id}', (req: Request, res: Response) => {
    if (!req.params.id) {
        return res.status(404).send({ error: 'Keine Id mitgegeben' });
    }

    dataService.getDeckById(+req.params.id, function (err: Error, deck: Deck) {
        if (!deck) {
            return res.status(404).send({ error: 'Es wurde kein Deck gefunden' });
        }
        return res.send(deck);
    });
});

router.post('/decks', (req: Request, res: Response) => {
    if (!req.body.name) {
        return res.status(404).send({ error: 'Kein Deckname mitgegeben' });
    }
    dataService.addDeck(req.body.name);
    return res.status(200).send({ message: 'Deck hinzugefugt' });
});

router.post('/decks/:id/cards', (req: Request, res: Response) => {
    if (!req.params.id) {
        return res.status(404).send({ error: 'Kein Id mitgegeben' });
    }
    if (!req.body.cards || !Array.isArray(req.body.cards)) {
        return res.status(404).send({ error: 'Fehlende oder falsche Karten' });
    }
    dataService.addCards(req.body.cards, +req.params.id);
    return res.status(200).send({ message: 'Cards hinzugefügt' });
});

router.delete('/decks', (req: Request, res: Response) => {
    if (!req.query.id) {
        return res.status(404).send({ error: 'Kein Id mitgegeben' });
    }
    dataService.deleteDeck(+req.query.id!);
    return res.status(200).send({ message: 'Deck gelöscht' });
});

router.put('/decks', (req: Request, res: Response) => {
    if (!req.query.id) {
        return res.status(404).send({ error: 'Kein Id mitgegeben' });
    }

    if (req.body.progress === undefined || req.body.progress === null) {
        return res.status(404).send({ error: 'Keine Progress mitgegeben' });
    }

    dataService.updateProgress(+req.query.id!, req.body.progress);
    return res.status(200).send({ message: 'Progress geupdatet' });
});

export default router;