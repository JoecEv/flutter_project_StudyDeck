import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:study_deck/models/deckcard.dart';
import 'package:study_deck/provider/deck_provider.dart';
import 'package:study_deck/provider/theme_provider.dart';
import 'package:study_deck/theme/app_theme.dart';

class AddCards extends StatefulWidget {
  const AddCards({super.key});

  @override
  State<AddCards> createState() => _AddCardsState();
}

class _AddCardsState extends State<AddCards> {
  final TextEditingController frontController = TextEditingController();
  final TextEditingController backController = TextEditingController();
  final List<DeckCard> addedCards = [];

  @override
  void dispose() {
    frontController.dispose();
    backController.dispose();
    super.dispose();
  }

  void addCardToList() {
    final front = frontController.text.trim();
    final back = backController.text.trim();

    if (front.isEmpty || back.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Bitte Vorder- und Rückseite ausfüllen.")),
      );
      return;
    }

    setState(() {
      addedCards.insert(0, DeckCard(deckId: 0, front: front, back: back));
      frontController.clear();
      backController.clear();
    });
  }

  void removeCardFromList(int index) {
    setState(() {
      addedCards.removeAt(index);
    });
  }

  void completeAdding() {
    if (addedCards.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Bitte mindestens eine Karte hinzufügen.")),
      );
      return;
    }

    addAllCards();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          "Deck '${context.read<DeckProvider>().newDeckName}' erfolgreich erstellt!",
        ),
      ),
    );

    Navigator.of(context).popUntil(ModalRoute.withName('/home'));
  }

  Future<int> getDeckId() async {
    final response = await http.get(
      Uri.parse(
        'http://${context.read<DeckProvider>().ipAddress}:3000/deck/get-id?deckname=${context.read<DeckProvider>().newDeckName}',
      ),
    );
    final data = jsonDecode(response.body);
    return data['id'];
  }

  Future<void> addAllCards() async {
    final int deckId = await getDeckId();

    final response = await http.post(
      Uri.parse('http://${context.read<DeckProvider>().ipAddress}:3000/cards'),
      body: jsonEncode({'deckId': deckId, 'cards': addedCards}),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Deck erfolgreich hinzugefügt!")));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Fehler beim Hinzufügen des Decks!")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeMode = context.watch<ThemeProvider>().themeMode;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        iconTheme: IconThemeData(
          color: Theme.of(context).textTheme.titleLarge?.color,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(25)),
        ),
        flexibleSpace: ClipRRect(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(25)),
          child: Container(
            decoration: BoxDecoration(
              gradient: AppTheme.getAppBarGradient(themeMode),
            ),
          ),
        ),
        title: Text(
          context.read<DeckProvider>().newDeckName,
          style: TextStyle(
            color: Theme.of(context).textTheme.titleLarge?.color,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(16.0),
            child: Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.tertiary,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: 10,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                children: [
                  TextField(
                    controller: frontController,
                    style: TextStyle(
                      color: Theme.of(context).textTheme.bodySmall?.color,
                    ),
                    decoration: InputDecoration(
                      labelText: "Vorderseite (bzw. die Frage)",
                      labelStyle: TextStyle(
                        color: Theme.of(
                          context,
                        ).textTheme.bodySmall?.color?.withValues(alpha: 0.5),
                      ),
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                          color: Theme.of(context).colorScheme.primary,
                          width: 2,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 12),
                  TextField(
                    controller: backController,
                    style: TextStyle(
                      color: Theme.of(context).textTheme.bodySmall?.color,
                    ),
                    decoration: InputDecoration(
                      labelText: "Rückseite (bzw. die Antwort)",
                      labelStyle: TextStyle(
                        color: Theme.of(
                          context,
                        ).textTheme.bodySmall?.color?.withValues(alpha: 0.5),
                      ),
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                          color: Theme.of(context).colorScheme.primary,
                          width: 2,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  MaterialButton(
                    color: Theme.of(context).colorScheme.primary,
                    onPressed: addCardToList,
                    height: 40,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      "Karte Hinzufügen",
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).textTheme.bodyLarge?.color,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          Divider(
            height: 2,
            color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.2),
          ),
          Expanded(
            child: addedCards.isEmpty
                ? Center(
                    child: Text(
                      "Noch keine Karten hinzugefügt",
                      style: TextStyle(
                        color: Theme.of(
                          context,
                        ).textTheme.bodySmall?.color?.withValues(alpha: 0.6),
                      ),
                    ),
                  )
                : ListView.builder(
                    padding: EdgeInsets.symmetric(vertical: 8),
                    itemCount: addedCards.length,
                    itemBuilder: (context, index) {
                      final card = addedCards[index];
                      return Container(
                        margin: EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: Theme.of(context).cardColor,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: Theme.of(
                              context,
                            ).colorScheme.primary.withValues(alpha: 0.1),
                          ),
                        ),
                        child: ListTile(
                          title: Text(
                            card.front,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Theme.of(
                                context,
                              ).textTheme.bodySmall?.color,
                            ),
                          ),
                          subtitle: Text(
                            card.back,
                            style: TextStyle(
                              color: Theme.of(context)
                                  .textTheme
                                  .bodySmall
                                  ?.color
                                  ?.withValues(alpha: 0.7),
                            ),
                          ),
                          trailing: IconButton(
                            icon: Icon(Icons.delete, size: 20),
                            onPressed: () => removeCardFromList(index),
                            color: Theme.of(context).textTheme.bodySmall?.color
                                ?.withValues(alpha: 0.5),
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: completeAdding,
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
        icon: Icon(Icons.check),
        label: Text("Fertig", style: TextStyle(fontWeight: FontWeight.bold)),
      ),
    );
  }
}
