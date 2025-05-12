import 'package:flutter/material.dart';
import 'package:u_nidos/auth/bloc/auth_bloc.dart';
import '../register/access_screen.dart';
import '../auth/bloc/auth_event.dart';
import '../auth/bloc/auth_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  void _login(BuildContext context) {
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Por favor, complete ambos campos')),
      );
      return;
    }

    context.read<AuthBloc>().add(AuthLoginRequested(email, password));
  }

  @override
  Widget build(BuildContext context) {
    final colorUni = Theme.of(context).primaryColor;

    return Scaffold(
      backgroundColor: Colors.grey[300],
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Text(
                'U-NIDOS',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: colorUni,
                ),
              ),
              const SizedBox(height: 30),
              CircleAvatar(
                radius: 40,
                backgroundColor: colorUni,
                child: const Icon(Icons.person, size: 40, color: Colors.white),
              ),
              const SizedBox(height: 20),
              BlocListener<AuthBloc, AuthState>(
                listener: (context, state) {
                  if (state is AuthLoading) {
                    showDialog(
                      context: context,
                      barrierDismissible: false,
                      builder:
                          (_) =>
                              const Center(child: CircularProgressIndicator()),
                    );
                  } else if (state is AuthFailure) {
                    Navigator.pop(context); // Cierra el diálogo si hay error
                    ScaffoldMessenger.of(
                      context,
                    ).showSnackBar(SnackBar(content: Text(state.message)));
                  } else if (state is AuthSuccess) {
                    Navigator.pop(context); // Cierra el diálogo
                  }
                },
                child: Container(
                  padding: const EdgeInsets.all(20),
                  margin: const EdgeInsets.symmetric(horizontal: 30),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Column(
                    children: [
                      TextField(
                        controller: _emailController,
                        decoration: InputDecoration(
                          hintText: 'Usuario',
                          prefixIcon: const Icon(Icons.person),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                      const SizedBox(height: 15),
                      TextField(
                        controller: _passwordController,
                        obscureText: true,
                        decoration: InputDecoration(
                          hintText: 'Contraseña',
                          prefixIcon: const Icon(Icons.lock),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: () => _login(context),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: colorUni,
                          minimumSize: const Size(double.infinity, 50),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: const Text('INICIAR SESIÓN'),
                      ),
                      const SizedBox(height: 10),
                      TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (_) => Access()),
                          );
                        },
                        child: Text.rich(
                          TextSpan(
                            text: '¿No tienes cuenta? ',
                            children: [
                              TextSpan(
                                text: 'Regístrate',
                                style: TextStyle(color: colorUni),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
