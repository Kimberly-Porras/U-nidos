import 'package:flutter/material.dart';

class ConfirmationScreen extends StatelessWidget {
  final String email;
  final String username;
  final String password;
  final String name;
  final String bio;
  final List<String> interests;

  ConfirmationScreen({
    required this.email,
    required this.username,
    required this.password,
    required this.name,
    required this.bio,
    required this.interests,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('¡Bienvenido!')),
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                '¡Gracias por registrarte, $name!',
                style: TextStyle(fontSize: 20),
              ),
              SizedBox(height: 10),
              Text('Tus intereses son: ${interests.join(", ")}'),
              SizedBox(height: 30),
              ElevatedButton(
                onPressed: () {
                  // Aquí podrías ir al Home o Dashboard
                },
                child: Text('Comenzar'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
