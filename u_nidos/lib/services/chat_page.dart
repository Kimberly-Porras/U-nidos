import 'package:flutter/material.dart';
import 'chat_conversation_page.dart';

class ChatPage extends StatelessWidget {
  const ChatPage({super.key});

  final List<Map<String, String>> chats = const [
    {
      'nombre': 'Ana Otarola Pérez',
      'mensaje': '¡Ana un gusto conocerte, gracias por todo!',
      'hora': '3:10',
      'foto': 'https://i.pravatar.cc/150?img=1',
    },
    {
      'nombre': 'Filiberto Madriz Prendas',
      'mensaje': '¿A qué hora sería la reunión el día de hoy?',
      'hora': '16:30',
      'foto': 'https://i.pravatar.cc/150?img=2',
    },
    {
      'nombre': 'Josefa Pradilla Mora',
      'mensaje': '¡Pura vida, un gusto!',
      'hora': '8:16',
      'foto': 'https://i.pravatar.cc/150?img=3',
    },
    {
      'nombre': 'Frank Ovares Olivares',
      'mensaje': '¡Si tienes alguna duda me escribes!',
      'hora': '13:22',
      'foto': 'https://i.pravatar.cc/150?img=4',
    },
    {
      'nombre': 'Delfina Novoa Parra',
      'mensaje': '¡Nos vemos pronto!',
      'hora': '10:53',
      'foto': 'https://i.pravatar.cc/150?img=5',
    },
    {
      'nombre': 'Hernán Villalobos Fuentes',
      'mensaje': '¡Excelente material!',
      'hora': '17:13',
      'foto': 'https://i.pravatar.cc/150?img=6',
    },
    {
      'nombre': 'Hazel Rodríguez Avilés',
      'mensaje': '¿Sos de Campus Coto?',
      'hora': '3:06',
      'foto': 'https://i.pravatar.cc/150?img=7',
    },
    {
      'nombre': 'Ronald Picado Cedeño',
      'mensaje': '¿En la soda está bien?',
      'hora': '22:47',
      'foto': 'https://i.pravatar.cc/150?img=8',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Chat')),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFE0F7FA), Color(0xFFB3E5FC), Color(0xFF81D4FA)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: ListView.separated(
          itemCount: chats.length,
          separatorBuilder: (_, __) => const Divider(height: 1),
          itemBuilder: (context, index) {
            final chat = chats[index];
            return ListTile(
              leading: CircleAvatar(
                backgroundImage: NetworkImage(chat['foto']!),
              ),
              title: Text(
                chat['nombre']!,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Text(chat['mensaje']!),
              trailing: Text(
                chat['hora']!,
                style: const TextStyle(fontSize: 12, color: Colors.grey),
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => ChatConversationPage(
                      nombreContacto: chat['nombre']!,
                      fotoUrl: chat['foto']!,
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
