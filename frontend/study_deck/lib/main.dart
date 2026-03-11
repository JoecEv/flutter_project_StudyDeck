import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:study_deck/pages/add_deck.dart';
import 'package:study_deck/pages/home.dart';
import 'package:study_deck/pages/login.dart';
import 'package:study_deck/pages/settings.dart';
import 'package:study_deck/provider/deck_provider.dart';

late SharedPreferences prefs;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  prefs = await SharedPreferences.getInstance();

  runApp(
    ChangeNotifierProvider(
      create: (context) => DeckProvider(),
      builder: (context, child) {
        return MaterialApp(
          home: Scaffold(
            body: MaterialApp.router(
              title: 'Study Deck',
              routerConfig: _router,
            ),
          ),
        );
      },
    ),
  );
}

final GoRouter _router = GoRouter(
  initialLocation:
      '/home', //prefs.getString('username') != null ? '/home' : '/login',
  routes: [
    GoRoute(path: '/login', builder: (context, state) => const LoginPage()),
    GoRoute(
      path: '/home',
      builder: (context, state) => const DeckOverview(),
      routes: [
        GoRoute(
          path: '/settings',
          builder: (context, state) => const SettingsPage(),
        ),
        GoRoute(
          path: '/add_deck',
          builder: (context, state) => const AddDeckPage(),
        ),
      ],
    ),
  ],
);
