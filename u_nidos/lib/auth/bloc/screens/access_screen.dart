import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../register/register_bloc.dart';
import '../register/register_event.dart';
import '../register/register_state.dart';
import 'profile_screen.dart';

class Access extends StatefulWidget {
  const Access({super.key});

  @override
  State<Access> createState() => _AccessState();
}

class _AccessState extends State<Access> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController emailCtrl = TextEditingController();
  final TextEditingController usernameCtrl = TextEditingController();
  final TextEditingController passwordCtrl = TextEditingController();

  bool usernameError = false;
  bool emailError = false;
  String? usernameErrorMessage;
  String? emailErrorMessage;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Registro - Paso 1')),
      body: BlocListener<RegisterBloc, RegisterState>(
        listener: (context, state) {
          if (state is RegisterLoading) {
            showDialog(
              context: context,
              barrierDismissible: false,
              builder: (_) => const Center(child: CircularProgressIndicator()),
            );
          } else if (state is RegisterError) {
            Navigator.pop(context); // Cierra diálogo de carga

            final msg = state.message.toLowerCase();

            setState(() {
              usernameError = false;
              emailError = false;
              usernameErrorMessage = null;
              emailErrorMessage = null;
            });

            if (msg.contains("usuario") && msg.contains("ya está en uso")) {
              setState(() {
                usernameError = true;
                usernameErrorMessage = "Este nombre de usuario ya existe.";
              });
            } else if (msg.contains("correo") && msg.contains("ya está en uso")) {
              setState(() {
                emailError = true;
                emailErrorMessage = "Este correo ya está registrado.";
              });
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.message)),
              );
            }
          } else if (state is RegisterAccessCompleted) {
            Navigator.pop(context); // Cierra diálogo
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => Profile(
                  email: emailCtrl.text.trim(),
                  username: usernameCtrl.text.trim(),
                  password: passwordCtrl.text.trim(),
                ),
              ),
            );
          }
        },
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TextFormField(
                  controller: emailCtrl,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    labelText: 'Correo electrónico',
                    errorText: emailError ? emailErrorMessage : null,
                  ),
                  validator: (value) =>
                      value!.contains('@') ? null : 'Correo inválido',
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: usernameCtrl,
                  decoration: InputDecoration(
                    labelText: 'Nombre de usuario',
                    errorText: usernameError ? usernameErrorMessage : null,
                  ),
                  onChanged: (_) {
                    if (usernameError) {
                      setState(() {
                        usernameError = false;
                        usernameErrorMessage = null;
                      });
                    }
                  },
                  validator: (value) =>
                      value!.isEmpty ? 'Campo obligatorio' : null,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: passwordCtrl,
                  obscureText: true,
                  decoration: const InputDecoration(labelText: 'Contraseña'),
                  validator: (value) =>
                      value!.length >= 6 ? null : 'Mínimo 6 caracteres',
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      final email = emailCtrl.text.trim();
                      final password = passwordCtrl.text.trim();
                      final username = usernameCtrl.text.trim();

                      if (username.contains(' ')) {
                        setState(() {
                          usernameError = true;
                          usernameErrorMessage =
                              'El nombre de usuario no debe tener espacios.';
                        });
                        return;
                      }

                      if (username.isEmpty) {
                        setState(() {
                          usernameError = true;
                          usernameErrorMessage =
                              'El nombre de usuario no puede estar vacío.';
                        });
                        return;
                      }

                      context.read<RegisterBloc>().add(
                            AccessCompleted(
                              correo: email,
                              password: password,
                              nombre: username,
                            ),
                          );
                    }
                  },
                  child: const Text('Siguiente'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
