import 'package:flutter/material.dart';
import 'package:study_deck/models/deck.dart';

class StudyView extends StatelessWidget {
  final Deck deck;

  const StudyView({super.key, required this.deck});

  @override
  Widget build(BuildContext context) {
    return Text("Lernansicht");
  }
}
