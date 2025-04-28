import 'package:flutter/material.dart';

class HistorialPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Historial'),
        backgroundColor: Colors.blueAccent,
      ),
      body: Center(child: Text('Aquí irá el historial de servicios')),
    );
  }
}
