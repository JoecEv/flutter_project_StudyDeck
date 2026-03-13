import 'package:flutter/material.dart';
import 'package:study_deck/models/deck.dart';

class DeckProvider extends ChangeNotifier {
  late String _ipAddress = '192.168.178.57';
  late String _newDeckName;
  late Deck _selectedStudyDeck;

  String get ipAddress => _ipAddress;
  String get newDeckName => _newDeckName;
  Deck get selectedStudyDeck => _selectedStudyDeck;

  void setIpAddress(String ip) {
    _ipAddress = ip;
    notifyListeners();
  }

  void setNewDeckName(String name) {
    _newDeckName = name;
    notifyListeners();
  }

  void setActiveDeck(Deck deck) {
    _selectedStudyDeck = deck;
    notifyListeners();
  }
}
