import 'dart:convert';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_card_swiper/flutter_card_swiper.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:study_deck/models/deck.dart';
import 'package:study_deck/models/deckcard.dart';
import 'package:study_deck/provider/deck_provider.dart';
import 'package:study_deck/provider/theme_provider.dart';
import 'package:study_deck/theme/app_theme.dart';
import 'package:study_deck/pages/widgets/lerncard_item.dart';
import 'package:study_deck/pages/widgets/progress_item.dart';

class StudyView extends StatefulWidget {
  const StudyView({super.key});

  @override
  State<StudyView> createState() => _StudyViewState();
}

class _StudyViewState extends State<StudyView> {
  final CardSwiperController swiperController = CardSwiperController();
  final AudioPlayer audioPlayer = AudioPlayer();

  int currentIndex = 0;
  int correctCount = 0;
  bool isFinished = false;

  List<DeckCard> cardsToStudy = [];
  final Map<int, bool> flippedStates = {};

  @override
  void initState() {
    super.initState();
    getStudyCards();
  }

  Future<void> getStudyCards() async {
    var deck = context.read<DeckProvider>().selectedStudyDeck;
    final response = await http.get(
      Uri.parse(
        'http://${context.read<DeckProvider>().ipAddress}:3000/deck/get-by-id?id=${deck.id}',
      ),
    );

    if (response.statusCode == 200) {
      deck = Deck.fromJson(jsonDecode(response.body));
      setState(() {
        cardsToStudy = List.from(deck.deckCards);
        for (int i = 0; i < cardsToStudy.length; i++) {
          flippedStates[i] = false;
        }
      });
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Fehler beim Laden der Karten')));
    }
  }

  @override
  void dispose() {
    swiperController.dispose();
    audioPlayer.dispose();
    super.dispose();
  }

  Future<void> _playSound(bool correct) async {
    if (correct) {
      await audioPlayer.play(AssetSource('right.wav'));
    } else {
      await audioPlayer.play(AssetSource('error.wav'));
    }
  }

  bool _onSwipe(
    int previousIndex,
    int? currentIndex,
    CardSwiperDirection direction,
  ) {
    if (direction == CardSwiperDirection.right) {
      correctCount++;
      _playSound(true);
    } else if (direction == CardSwiperDirection.left) {
      _playSound(false);
    }

    setState(() {
      this.currentIndex = currentIndex ?? cardsToStudy.length;
    });

    return true;
  }

  Future<void> _saveProgress() async {
    if (cardsToStudy.isEmpty) return;

    final activeDeck = context.read<DeckProvider>().selectedStudyDeck;
    final double progress = correctCount / cardsToStudy.length;

    final url = Uri.parse(
      'http://${context.read<DeckProvider>().ipAddress}:3000/decks/${activeDeck.id}',
    );

    await http.put(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'progress': progress}),
    );
  }

  void _onEnd() {
    setState(() {
      isFinished = true;
    });
    _saveProgress();
  }

  void _flipCard(int index) {
    setState(() {
      flippedStates[index] = !(flippedStates[index] ?? false);
    });
  }

  @override
  Widget build(BuildContext context) {
    final themeMode = context.watch<ThemeProvider>().themeMode;
    final textColor =
        Theme.of(context).textTheme.bodyMedium?.color ?? Colors.black;
    final activeDeck = context.watch<DeckProvider>().selectedStudyDeck;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        iconTheme: IconThemeData(color: Colors.white),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(20)),
        ),
        flexibleSpace: ClipRRect(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(20)),
          child: Container(
            decoration: BoxDecoration(
              gradient: AppTheme.getAppBarGradient(themeMode),
            ),
          ),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              activeDeck.name,
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            if (!isFinished && cardsToStudy.isNotEmpty)
              Text(
                "Karte ${currentIndex + 1} von ${cardsToStudy.length}",
                style: TextStyle(color: Colors.white70, fontSize: 12),
              ),
          ],
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(20.0),
          child: isFinished || cardsToStudy.isEmpty
              ? ProgressViewItem(
                  correctCount: correctCount,
                  totalCards: cardsToStudy.length,
                )
              : Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Swipe Links = Nicht Gewusst",
                          style: TextStyle(
                            color: Colors.red[400],
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                        Text(
                          "Swipe Rechts = Gewusst",
                          style: TextStyle(
                            color: Colors.green[400],
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 20),
                    Expanded(
                      child: CardSwiper(
                        controller: swiperController,
                        cardsCount: cardsToStudy.length,
                        onSwipe: _onSwipe,
                        onEnd: _onEnd,
                        allowedSwipeDirection: AllowedSwipeDirection.symmetric(
                          horizontal: true,
                          vertical: false,
                        ),
                        padding: EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 20,
                        ),
                        cardBuilder:
                            (
                              context,
                              index,
                              percentThresholdX,
                              percentThresholdY,
                            ) {
                              return LerncardItem(
                                card: cardsToStudy[index],
                                isFlipped: flippedStates[index] ?? false,
                                onTap: () => _flipCard(index),
                              );
                            },
                      ),
                    ),
                    SizedBox(height: 20),
                    Text(
                      "Tippe auf die Karte, um die Lösung zu sehen",
                      style: TextStyle(
                        color: textColor.withValues(alpha: 0.5),
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}
