class DeckCard {
  final int id;
  final int deckId;
  final String front;
  final String back;

  DeckCard({
    required this.id,
    required this.deckId,
    required this.front,
    required this.back,
  });

  factory DeckCard.fromJson(Map<String, dynamic> json) {
    return switch (json) {
      {
        'id': int id,
        'deckId': int deckId,
        'front': String front,
        'back': String back,
      } =>
        DeckCard(id: id, deckId: deckId, front: front, back: back),
      _ => throw const FormatException('Fehler beim Laden der Deck Card'),
    };
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'deckId': deckId, 'front': front, 'back': back};
  }
}
