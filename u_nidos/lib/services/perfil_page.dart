import 'package:flutter/material.dart';

class PerfilPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Perfil'),
        backgroundColor: Colors.blueAccent,
      ),
      body: Center(child: Text('Aquí irá la información del perfil')),
    );
  }
}
