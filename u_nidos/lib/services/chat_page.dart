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
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Chat')),
      body: Container(
        color: Colors.white, // ✅ Fondo blanco
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
                    builder:
                        (_) => ChatConversationPage(
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
