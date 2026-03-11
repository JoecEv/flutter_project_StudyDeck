import { DeckCard } from './deckCard';

export interface Deck {
    id: number;
    userId: number;
    name: string;
    cards: DeckCard[];
    progress: number;
}
