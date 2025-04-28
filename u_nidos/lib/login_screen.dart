// login_screen.dart
import 'package:flutter/material.dart';
import 'register/access_screen.dart';

class LoginScreen extends StatelessWidget {
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
              SizedBox(height: 30),
              CircleAvatar(
                radius: 40,
                backgroundColor: colorUni,
                child: Icon(Icons.person, size: 40, color: Colors.white),
              ),
              SizedBox(height: 20),
              Container(
                padding: EdgeInsets.all(20),
                margin: EdgeInsets.symmetric(horizontal: 30),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Column(
                  children: [
                    TextField(
                      decoration: InputDecoration(
                        hintText: 'Usuario',
                        prefixIcon: Icon(Icons.person),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                    SizedBox(height: 15),
                    TextField(
                      obscureText: true,
                      decoration: InputDecoration(
                        hintText: 'Contraseña',
                        prefixIcon: Icon(Icons.lock),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () {
                        // Aquí iría la lógica de iniciar sesión
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: colorUni, // ✅ Botón con color dinámico
                        minimumSize: Size(double.infinity, 50),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: Text('INICIAR SESIÓN'),
                    ),
                    SizedBox(height: 10),
                    TextButton(
                      onPressed: () {
                        // Aquí redireccionamos al registro
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
                              style: TextStyle(
                                color: colorUni,
                              ), // ✅ Color dinámico en texto
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
