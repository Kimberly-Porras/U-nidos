import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../auth/bloc/register/register_bloc.dart';
import '../auth/bloc/register/register_event.dart';
import '../auth/bloc/register/register_state.dart';
import '../services/home_screen.dart';// o la pantalla a la que quieras navegar

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
      body: BlocListener<RegisterBloc, RegisterState>(
        listener: (context, state) {
          if (state is RegisterLoading) {
            showDialog(
              context: context,
              barrierDismissible: false,
              builder: (_) => const Center(child: CircularProgressIndicator()),
            );
          } else if (state is RegisterError) {
            Navigator.pop(context); // cierra diálogo
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
          } else if (state is RegisterConfirmationCompleted) {
            Navigator.pop(context); // cierra diálogo
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => HomeScreen()), // cambiar si querés otro destino
            );
          }
        },
        child: Center(
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
                    // Simula confirmar el paso final
                    context.read<RegisterBloc>().add(
                      ConfirmationCodeEntered("mock-code"),
                    );
                  },
                  child: Text('Comenzar'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
