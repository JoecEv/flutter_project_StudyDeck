import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:study_deck/provider/theme_provider.dart';
import 'package:study_deck/theme/app_theme.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _usernameController = TextEditingController();

  Future<void> _loginUser() async {
    final username = _usernameController.text.trim();
    if (username.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Bitte gib einen Spielernamen ein.")),
      );
      return;
    }

    try {
      final response = await http.post(
        Uri.parse('http://10.229.156.254:3000/user/check-username'),
        body: jsonEncode({'username': username}),
        headers: {'Content-Type': 'application/json'},
      );

      final data = jsonDecode(response.body);

      if (data['isExisting'] == false) {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('username', username);

        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text("Erfolgreich eingeloggt!")));
        context.go('/home');
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Diesen Benutzernamen gibt es bereits: $username"),
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Es ist ein Fehler aufgetreten: $e")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeMode = context.watch<ThemeProvider>().themeMode;
    final colorScheme = Theme.of(context).colorScheme;

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
          padding: EdgeInsets.all(8),
          child: Image.asset('assets/studydeck_logo_light.png'),
        ),
        title: const Text(
          "StudyDeck",
          style: TextStyle(fontSize: 14, color: Colors.white),
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: EdgeInsets.fromLTRB(20, 0, 20, 50),
              child: Text(
                "Herzlich Willkommen zu StudyDeck!",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 20,
                  color: Theme.of(context).textTheme.bodySmall?.color,
                ),
              ),
            ),

            Padding(
              padding: EdgeInsets.fromLTRB(0, 0, 0, 80),
              child: Image(
                image: AssetImage(
                  (themeMode == MyThemeMode.dark ||
                          themeMode == MyThemeMode.purple)
                      ? "assets/studydeck_logo_light.png"
                      : "assets/studydeck_logo.png",
                ),
                height: 150,
                width: 150,
                fit: BoxFit.cover,
              ),
            ),

            Padding(
              padding: EdgeInsets.fromLTRB(20, 0, 20, 20),
              child: SizedBox(
                width: 300,
                child: TextField(
                  controller: _usernameController,
                  textAlign: TextAlign.start,
                  maxLines: 1,
                  style: TextStyle(
                    fontWeight: FontWeight.w400,
                    fontStyle: FontStyle.normal,
                    fontSize: 14,
                    color: Theme.of(context).textTheme.bodySmall?.color,
                  ),
                  decoration: InputDecoration(
                    hintText: "Unique Playername",
                    hintStyle: TextStyle(
                      fontWeight: FontWeight.w400,
                      fontStyle: FontStyle.normal,
                      fontSize: 14,
                      color: Theme.of(context).textTheme.bodySmall?.color,
                    ),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: colorScheme.primary),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                        color: colorScheme.primary,
                        width: 2,
                      ),
                    ),
                  ),
                ),
              ),
            ),

            Container(
              decoration: BoxDecoration(
                gradient: AppTheme.getAppBarGradient(themeMode),
                borderRadius: BorderRadius.circular(12),
              ),
              child: MaterialButton(
                onPressed: () => _loginUser(),
                textColor: Color.fromARGB(255, 255, 255, 255),
                height: 40,
                minWidth: 140,
                padding: EdgeInsets.all(16),
                child: Text(
                  "Los gehts!",
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    fontStyle: FontStyle.normal,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
