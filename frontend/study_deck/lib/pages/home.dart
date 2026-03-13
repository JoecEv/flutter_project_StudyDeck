import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:study_deck/models/deck.dart';
import 'package:study_deck/pages/add_deck.dart';
import 'package:study_deck/provider/deck_provider.dart';
import 'package:study_deck/provider/theme_provider.dart';
import 'package:study_deck/theme/app_theme.dart';
import 'widgets/deck_view_card.dart';

class DeckOverview extends StatefulWidget {
  const DeckOverview({super.key});

  @override
  State<DeckOverview> createState() => _DeckOverviewState();
}

class _DeckOverviewState extends State<DeckOverview> {
  List<Deck> decks = [];

  @override
  void initState() {
    super.initState();
    getAllDecks();
  }

  void getAllDecks() async {
    final response = await http.get(
      Uri.parse('http://${context.read<DeckProvider>().ipAddress}:3000/decks'),
      headers: {'Content-Type': 'application/json'},
    );
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      setState(() {
        decks = data.map((json) => Deck.fromJson(json)).toList();
      });
    }
  }

  void openDeck(Deck deck) {
    context.read<DeckProvider>().setActiveDeck(deck);
    context.push('/study_view');

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('Öffne ${deck.name}')));
  }

  Future<void> deleteDeck(Deck deck) async {
    final response = await http.delete(
      Uri.parse(
        'http://${context.read<DeckProvider>().ipAddress}:3000/decks/${deck.id}',
      ),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      getAllDecks();
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('${deck.name} wurde gelöscht')));
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Fehler beim Löschen vom Deck')));
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeMode = context.watch<ThemeProvider>().themeMode;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(14)),
        ),
        flexibleSpace: ClipRRect(
          borderRadius: const BorderRadius.vertical(
            bottom: Radius.circular(14),
          ),
          child: Container(
            decoration: BoxDecoration(
              gradient: AppTheme.getAppBarGradient(themeMode),
            ),
          ),
        ),
        leading: Padding(
          padding: EdgeInsets.fromLTRB(8, 0, 0, 0),
          child: Image.asset('assets/studydeck_logo_light.png'),
        ),
        title: Text(
          "Übersicht",
          style: TextStyle(
            fontSize: 20,
            color: Theme.of(context).textTheme.titleLarge?.color,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.settings, color: Colors.white),
            onPressed: () => context.go('/home/settings'),
          ),
        ],
      ),
      body: Consumer<DeckProvider>(
        builder: (context, deckProvider, child) {
          return decks.isEmpty
              ? Center(
                  child: Text(
                    "Keine Decks gefunden. Erstelle ein neues!",
                    style: TextStyle(
                      color: Theme.of(
                        context,
                      ).textTheme.bodyMedium?.color?.withValues(alpha: 0.7),
                    ),
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.only(top: 16.0, bottom: 80.0),
                  itemCount: decks.length,
                  itemBuilder: (context, index) {
                    final deck = decks[index];
                    return DeckViewCard(
                      title: deck.name,
                      progress: deck.progress,
                      onDelete: () => deleteDeck(deck),
                      onTap: () => openDeck(deck),
                    );
                  },
                );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddDeckPage()),
          );
        },
        foregroundColor: Colors.white,
        child: Container(
          width: 60,
          height: 60,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(16.0)),
            gradient: AppTheme.getAppBarGradient(themeMode),
          ),
          child: Icon(Icons.add, size: 28),
        ),
      ),
    );
  }
}
