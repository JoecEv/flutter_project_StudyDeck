class DeckCard {
  final int deckId;
  final String front;
  final String back;

  DeckCard({required this.deckId, required this.front, required this.back});

  factory DeckCard.fromJson(Map<String, dynamic> json) {
    return switch (json) {
      {'deckId': int deckId, 'front': String front, 'back': String back} =>
        DeckCard(deckId: deckId, front: front, back: back),
      _ => throw const FormatException('Fehler beim Laden der Deck Card'),
    };
  }

  Map<String, dynamic> toJson() {
    return {'deckId': deckId, 'front': front, 'back': back};
  }
}
