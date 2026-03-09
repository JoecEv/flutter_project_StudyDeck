import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:study_deck/pages/home.dart';
import 'package:study_deck/pages/login.dart';
import 'package:study_deck/provider/deck_provider.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => DeckProvider(),
      builder: (context, child) => MaterialApp(
        home: Scaffold(
          body: MaterialApp.router(title: 'Study Deck', routerConfig: _router),
        ),
      ),
    ),
  );
}

final GoRouter _router = GoRouter(
  initialLocation: '/login',
  routes: [
    GoRoute(path: '/login', builder: (context, state) => const LoginPage()),
    GoRoute(path: '/home', builder: (context, state) => const DeckOverview()),
  ],
);
