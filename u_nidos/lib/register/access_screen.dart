import 'package:flutter/material.dart';
import 'profile_screen.dart';

class Access extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController emailCtrl = TextEditingController();
  final TextEditingController usernameCtrl = TextEditingController();
  final TextEditingController passwordCtrl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Registro - Paso 1')),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: emailCtrl,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(labelText: 'Correo electrónico'),
                validator:
                    (value) => value!.contains('@') ? null : 'Correo inválido',
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: usernameCtrl,
                decoration: InputDecoration(labelText: 'Nombre de usuario'),
                validator:
                    (value) => value!.isEmpty ? 'Campo obligatorio' : null,
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: passwordCtrl,
                obscureText: true,
                decoration: InputDecoration(labelText: 'Contraseña'),
                validator:
                    (value) =>
                        value!.length >= 6 ? null : 'Mínimo 6 caracteres',
              ),
              SizedBox(height: 24),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder:
                            (_) => Profile(
                              email: emailCtrl.text,
                              username: usernameCtrl.text,
                              password: passwordCtrl.text,
                            ),
                      ),
                    );
                  }
                },
                child: Text('Siguiente'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
