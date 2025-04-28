import 'package:flutter/material.dart';
import 'interests_screen.dart';

class Profile extends StatelessWidget {
  final String email;
  final String username;
  final String password;

  Profile({
    required this.email,
    required this.username,
    required this.password,
  });

  final TextEditingController nameCtrl = TextEditingController();
  final TextEditingController bioCtrl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Registro - Paso 2')),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: nameCtrl,
              decoration: InputDecoration(labelText: 'Nombre completo'),
            ),
            SizedBox(height: 16),
            TextField(
              controller: bioCtrl,
              decoration: InputDecoration(labelText: 'Biografía'),
            ),
            SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder:
                        (_) => Interests(
                          email: email,
                          username: username,
                          password: password,
                          name: nameCtrl.text,
                          bio: bioCtrl.text,
                        ),
                  ),
                );
              },
              child: Text('Siguiente'),
            ),
          ],
        ),
      ),
    );
  }
}
