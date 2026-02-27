import { DeckCards } from './deckCard';

export interface Deck {
    id: number;
    userId: number
    name: string;
    cards: DeckCards[];
    progess: number
}
