import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../register/register_bloc.dart';
import '../register/register_event.dart';
import '../register/register_state.dart';
import '../../../services/home_screen.dart'; // Pantalla de destino

class ConfirmationScreen extends StatelessWidget {
  final String email;
  final String username;
  final String password;
  final String name;
  final String bio;
  final List<String> interests;

  const ConfirmationScreen({
    super.key,
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
      appBar: AppBar(title: const Text('¡Bienvenido!')),
      body: BlocListener<RegisterBloc, RegisterState>(
        listener: (context, state) async {
          if (state is RegisterLoading) {
            showDialog(
              context: context,
              barrierDismissible: false,
              builder: (_) => const Center(child: CircularProgressIndicator()),
            );
          } else if (state is RegisterError) {
            Navigator.pop(context); // Cierra diálogo de carga
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
          } else if (state is RegisterConfirmationCompleted) {
            Navigator.pop(context); // Cierra diálogo de carga
            final uid = FirebaseAuth.instance.currentUser?.uid;

            if (uid != null) {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (_) => HomeScreen(uid: uid),
                ),
              );
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('No se pudo obtener el UID.')),
              );
            }
          }
        },
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  '¡Gracias por registrarte, $name!',
                  style: const TextStyle(fontSize: 20),
                ),
                const SizedBox(height: 10),
                Text('Tus intereses son: ${interests.join(", ")}'),
                const SizedBox(height: 30),
                ElevatedButton(
                  onPressed: () {
                    // Simula confirmar el paso final
                    context.read<RegisterBloc>().add(
                          ConfirmationCodeEntered("mock-code"),
                        );
                  },
                  child: const Text('Comenzar'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
