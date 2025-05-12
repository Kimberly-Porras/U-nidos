import 'package:flutter/material.dart';
import 'interests_screen.dart';

class Profile extends StatefulWidget {
  final String email;
  final String username;
  final String password;

  const Profile({
    super.key,
    required this.email,
    required this.username,
    required this.password,
  });

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  final TextEditingController nameCtrl = TextEditingController();
  final TextEditingController bioCtrl = TextEditingController();

  @override
  void dispose() {
    nameCtrl.dispose();
    bioCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Registro - Paso 2')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: nameCtrl,
              decoration: const InputDecoration(labelText: 'Nombre completo'),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: bioCtrl,
              decoration: const InputDecoration(labelText: 'Biografía'),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => Interests(
                      email: widget.email,
                      username: widget.username,
                      password: widget.password,
                      name: nameCtrl.text,
                      bio: bioCtrl.text,
                    ),
                  ),
                );
              },
              child: const Text('Siguiente'),
            ),
          ],
        ),
      ),
    );
  }
}
