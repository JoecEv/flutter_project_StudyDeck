import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

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
      final response = await http.get(
        Uri.parse(
          'http://10.0.2.2:3000/user/check-username?username=$username',
        ),
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
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.bottomCenter,
              end: Alignment.topCenter,
              colors: [
                Color.fromARGB(255, 25, 43, 194),
                Color.fromARGB(255, 21, 5, 120),
              ],
            ),
          ),
        ),
        leading: Padding(
          padding: EdgeInsets.all(8),
          child: Image.asset('assets/studydeck_logo.png'),
        ),
        title: Text(
          "StudyDeck",
          style: TextStyle(fontSize: 14, color: Color(0xffffffff)),
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
                  color: Color(0xff000000),
                ),
              ),
            ),

            Padding(
              padding: EdgeInsets.fromLTRB(0, 0, 0, 80),
              child: Image(
                image: AssetImage("assets/studydeck_logo.png"),
                height: 150,
                width: 150,
                fit: BoxFit.cover,
              ),
            ),

            Padding(
              padding: EdgeInsets.fromLTRB(20, 0, 20, 10),
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
                    color: Color(0xff000000),
                  ),
                  decoration: InputDecoration(
                    hintText: "Unique Playername",
                    hintStyle: TextStyle(
                      fontWeight: FontWeight.w400,
                      fontStyle: FontStyle.normal,
                      fontSize: 14,
                      color: Color(0xff000000),
                    ),
                  ),
                ),
              ),
            ),

            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Color.fromARGB(255, 25, 43, 194),
                    Color.fromARGB(255, 21, 5, 120),
                  ],
                ),
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
