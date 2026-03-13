import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:study_deck/pages/add_cards.dart';
import 'package:study_deck/provider/deck_provider.dart';
import 'package:study_deck/provider/theme_provider.dart';
import 'package:study_deck/theme/app_theme.dart';

class AddDeckPage extends StatefulWidget {
  const AddDeckPage({super.key});

  @override
  State<AddDeckPage> createState() => _AddDeckPageState();
}

class _AddDeckPageState extends State<AddDeckPage> {
  final TextEditingController deckNameController = TextEditingController();

  @override
  void dispose() {
    deckNameController.dispose();
    super.dispose();
  }

  Future<void> addDeck() async {
    final deckName = deckNameController.text.trim();
    if (deckName.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Bitte gib einen Decknamen ein!")),
      );
    }

    final userId = await SharedPreferences.getInstance().then(
      (prefs) => prefs.getInt('userId'),
    );

    await http.post(
      Uri.parse('http://${context.read<DeckProvider>().ipAddress}:3000/decks'),
      body: jsonEncode({'name': deckName, 'userId': userId}),
      headers: {'Content-Type': 'application/json'},
    );
  }

  void goToAddCards() async {
    final deckName = deckNameController.text.trim();
    await addDeck();
    context.read<DeckProvider>().setNewDeckName(deckName);
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const AddCards()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final themeMode = context.watch<ThemeProvider>().themeMode;

    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Theme.of(context).textTheme.titleLarge?.color,
        ),
        backgroundColor: Colors.transparent,
        flexibleSpace: ClipRRect(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(25)),
          child: Container(
            decoration: BoxDecoration(
              gradient: AppTheme.getAppBarGradient(themeMode),
            ),
          ),
        ),
        title: Text(
          "Neues Deck erstellen",
          style: TextStyle(
            color: Theme.of(context).textTheme.titleLarge?.color,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                child: Text(
                  "Wie soll dein neues Deck heißen?",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 20,
                    color: Theme.of(context).textTheme.bodySmall?.color,
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(20, 0, 20, 40),
                child: SizedBox(
                  width: 300,
                  child: TextField(
                    controller: deckNameController,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontWeight: FontWeight.w400,
                      fontSize: 16,
                      color: Theme.of(context).textTheme.bodySmall?.color,
                    ),
                    decoration: InputDecoration(
                      hintText: "Deck Name",
                      hintStyle: TextStyle(
                        fontWeight: FontWeight.w400,
                        fontSize: 16,
                        color: Theme.of(
                          context,
                        ).textTheme.bodySmall!.color?.withValues(alpha: 0.6),
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
                    onSubmitted: (_) => goToAddCards(),
                  ),
                ),
              ),
              MaterialButton(
                onPressed: goToAddCards,
                color: Theme.of(context).colorScheme.primary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 40,
                  vertical: 14,
                ),
                child: Text(
                  "Weiter",
                  style: TextStyle(
                    color: Theme.of(context).textTheme.bodyLarge?.color,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
