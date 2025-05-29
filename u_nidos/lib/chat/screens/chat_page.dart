import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../bloc conversation list/conversation_list_bloc.dart';
import '../bloc conversation list/conversation_list_event.dart';
import '../bloc conversation list/conversation_list_state.dart';
import '../repository/chat_repository.dart';
import 'chat_conversation_page.dart';

class ChatPage extends StatefulWidget {
  final String usuarioActualId;

  const ChatPage({super.key, required this.usuarioActualId});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final ChatRepository _repository = ChatRepository();

  @override
  void initState() {
    super.initState();
    print('✅ Enviando evento para cargar conversaciones...');
    print('🔍 UID actual desde widget: ${widget.usuarioActualId}');
    context.read<ConversationListBloc>().add(
      LoadConversations(widget.usuarioActualId),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Mis chats')),
      body: BlocBuilder<ConversationListBloc, ConversationListState>(
        builder: (context, state) {
          if (state is ConversationListLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is ConversationListLoaded) {
            final chats = state.conversations;

            if (chats.isEmpty) {
              return const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.chat_bubble_outline,
                      size: 60,
                      color: Colors.grey,
                    ),
                    SizedBox(height: 12),
                    Text(
                      'Aún no tienes conversaciones activas',
                      style: TextStyle(color: Colors.grey, fontSize: 16),
                    ),
                  ],
                ),
              );
            }

            return ListView.builder(
              itemCount: chats.length,
              itemBuilder: (context, index) {
                final chat = chats[index];
                final data = chat.data() as Map<String, dynamic>;

                final participantes = List<String>.from(data['participants']);
                final contactoId = participantes.firstWhere(
                  (id) => id != widget.usuarioActualId,
                );

                return FutureBuilder<DocumentSnapshot>(
                  future:
                      FirebaseFirestore.instance
                          .collection('usuarios')
                          .doc(contactoId)
                          .get(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return const ListTile(
                        title: Text('Cargando contacto...'),
                      );
                    }

                    final contacto = snapshot.data!;
                    final nombre = contacto['nombre'];

                    return ListTile(
                      leading: const CircleAvatar(
                        child: Icon(Icons.person), // ✅ Ícono genérico
                      ),
                      title: Text(nombre),
                      subtitle: Text(data['lastMessage'] ?? ''),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder:
                                (_) => ChatConversationPage(
                                  nombreContacto: nombre,
                                  fotoUrl: '', // dejamos vacío
                                  contactoId: contactoId,
                                  usuarioActualId: widget.usuarioActualId,
                                ),
                          ),
                        );
                      },
                    );
                  },
                );
              },
            );
          } else if (state is ConversationListError) {
            return Center(child: Text('❌ ${state.error}'));
          } else {
            return const Center(child: Text('No hay datos.'));
          }
        },
      ),
    );
  }
}
