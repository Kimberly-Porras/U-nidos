import 'package:flutter/material.dart';

class InicioPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Inicio'),
        backgroundColor: Colors.blueAccent,
      ),
      body: ListView(
        padding: EdgeInsets.all(16),
        children: [
          ServiceCard(
            name: 'Kimberly Porras Naranjo',
            service: 'Ofrezco tutorías sobre formato APA',
            color: Colors.pinkAccent,
          ),
          ServiceCard(
            name: 'Tamara Pérez Guillén',
            service: 'Ofrezco tutorías sobre mecanografía',
            color: Colors.blueAccent,
          ),
          ServiceCard(
            name: 'Alberto Torres Valverde',
            service: 'Ofrezco tutorías sobre JavaScript',
            color: Colors.tealAccent,
          ),
        ],
      ),
    );
  }
}

class ServiceCard extends StatelessWidget {
  final String name;
  final String service;
  final Color color;

  ServiceCard({required this.name, required this.service, required this.color});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.only(bottom: 20),
      child: Column(
        children: [
          ListTile(
            leading: CircleAvatar(child: Icon(Icons.person)),
            title: Text(name),
          ),
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [color.withOpacity(0.7), color],
              ),
            ),
            child: Text(
              service,
              style: TextStyle(color: Colors.white, fontSize: 16),
            ),
          ),
          ButtonBar(
            alignment: MainAxisAlignment.spaceAround,
            children: [
              TextButton.icon(
                onPressed: () {},
                icon: Icon(Icons.remove_red_eye),
                label: Text('Ver perfil'),
              ),
              TextButton.icon(
                onPressed: () {},
                icon: Icon(Icons.chat),
                label: Text('Chat'),
              ),
              TextButton.icon(
                onPressed: () {},
                icon: Icon(Icons.share),
                label: Text('Compartir'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
