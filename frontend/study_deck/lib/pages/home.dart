import 'package:flutter/material.dart';

class DeckOverview extends StatelessWidget {
  const DeckOverview({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Study Deck')),
      body: const Center(child: Text('Study Deck')),
    );
  }
}
