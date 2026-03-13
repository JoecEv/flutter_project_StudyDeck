import 'package:study_deck/models/deckcard.dart';

class Deck {
  final int id;
  final int userId;
  final String name;
  final List<DeckCard> deckCards;
  final double progress;

  Deck({
    required this.id,
    required this.userId,
    required this.name,
    required this.deckCards,
    required this.progress,
  });

  factory Deck.fromJson(Map<String, dynamic> json) {
    return Deck(
      id: json['id'],
      userId: json['userId'],
      name: json['name'],
      deckCards:
          (json['cards'] as List<dynamic>?)
              ?.map((e) => DeckCard.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      progress: (json['progress'] as num?)?.toDouble() ?? 0.0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'name': name,
      'deckCards': deckCards.map((card) => card.toJson()).toList(),
      'progress': progress,
    };
  }
}
