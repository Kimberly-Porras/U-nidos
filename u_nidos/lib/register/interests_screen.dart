import 'package:flutter/material.dart';
import 'package:u_nidos/services/home_screen.dart'; 

class Interests extends StatefulWidget {
  final String email;
  final String username;
  final String password;
  final String name;
  final String bio;

  Interests({
    required this.email,
    required this.username,
    required this.password,
    required this.name,
    required this.bio,
  });

  @override
  _InterestsState createState() => _InterestsState();
}

class _InterestsState extends State<Interests> {
  List<String> categories = [
    'Arte', 'Música', 'Deportes', 'Gaming', 'Moda', 'Cocina',
  ];
  List<String> selected = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Registro - Paso 3')),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Selecciona tus intereses:'),
            SizedBox(height: 12),
            Wrap(
              spacing: 8,
              children: categories.map((cat) {
                return FilterChip(
                  label: Text(cat),
                  selected: selected.contains(cat),
                  onSelected: (bool value) {
                    setState(() {
                      value ? selected.add(cat) : selected.remove(cat);
                    });
                  },
                );
              }).toList(),
            ),
            Spacer(),
            ElevatedButton(
              onPressed: selected.isEmpty
                  ? null
                  : () {
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(builder: (_) => HomeScreen()), // ✅ Aquí
                        (route) => false,
                      );
                    },
              child: Text('Finalizar Registro'),
            ),
          ],
        ),
      ),
    );
  }
}
