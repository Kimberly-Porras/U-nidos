import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc message/message_bloc.dart';
import '../bloc message/message_event.dart';
import '../bloc message/message_state.dart';
import '../models/message.dart';
import 'package:u_nidos/shared_preferences.dart';

class ChatConversationPage extends StatefulWidget {
  final String nombreContacto;
  final String fotoUrl; // no se utiliza, pero mantenido por compatibilidad
  final String contactoId;
  final String usuarioActualId;

  const ChatConversationPage({
    super.key,
    required this.nombreContacto,
    required this.fotoUrl,
    required this.contactoId,
    required this.usuarioActualId,
  });

  @override
  State<ChatConversationPage> createState() => _ChatConversationPageState();
}

class _ChatConversationPageState extends State<ChatConversationPage> {
  final TextEditingController _messageCtrl = TextEditingController();
  late Color _colorPrincipal = Colors.blueAccent;

  final Map<String, Color> coloresUniversidades = {
    'UNA': Color(0xFFAD002E),
    'UCR': Color(0xFF007DC5),
    'TEC': Color(0xFF0C2340),
    'UNED': Color(0xFF003366),
    'UTN': Color(0xFF003865),
  };

  @override
  void initState() {
    super.initState();
    _cargarColorUniversidad();

    // Cargar mensajes
    context.read<MessageBloc>().add(
      LoadMessages(
        currentUserId: widget.usuarioActualId,
        otherUserId: widget.contactoId,
      ),
    );
  }

  Future<void> _cargarColorUniversidad() async {
    final uni = await SharedPrefsService.obtenerUniversidad();
    setState(() {
      _colorPrincipal = coloresUniversidades[uni] ?? Colors.blueAccent;
    });
  }

  void _enviarMensaje() {
    final texto = _messageCtrl.text.trim();
    if (texto.isEmpty) return;

    context.read<MessageBloc>().add(
      SendMessage(
        senderId: widget.usuarioActualId,
        receiverId: widget.contactoId,
        content: texto,
      ),
    );

    _messageCtrl.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: _colorPrincipal,
        title: Row(
          children: [
            const CircleAvatar(
              backgroundColor: Colors.white,
              child: Icon(Icons.person, color: Colors.grey),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                widget.nombreContacto,
                style: const TextStyle(fontSize: 18),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: BlocBuilder<MessageBloc, MessageState>(
              builder: (context, state) {
                if (state is MessageLoading) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state is MessageLoaded) {
                  final mensajes = state.messages;
                  return ListView.builder(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 10,
                    ),
                    itemCount: mensajes.length,
                    itemBuilder: (context, index) {
                      final msg = mensajes[index];
                      final esMio = msg.senderId == widget.usuarioActualId;

                      return Align(
                        alignment:
                            esMio
                                ? Alignment.centerRight
                                : Alignment.centerLeft,
                        child: Container(
                          margin: const EdgeInsets.symmetric(vertical: 4),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 14,
                            vertical: 10,
                          ),
                          decoration: BoxDecoration(
                            color:
                                esMio
                                    ? _colorPrincipal.withOpacity(0.15)
                                    : Colors.grey[200],
                            borderRadius: BorderRadius.circular(14),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                msg.message,
                                style: const TextStyle(fontSize: 16),
                              ),
                              Text(
                                TimeOfDay.fromDateTime(
                                  msg.timestamp,
                                ).format(context),
                                style: const TextStyle(
                                  fontSize: 10,
                                  color: Colors.black54,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                } else if (state is MessageError) {
                  return Center(child: Text('Error: ${state.error}'));
                } else {
                  return const Center(child: Text('No hay mensajes aún.'));
                }
              },
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            color: Colors.grey[100],
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _messageCtrl,
                    decoration: const InputDecoration(
                      hintText: 'Escribe un mensaje...',
                      border: InputBorder.none,
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.send, color: _colorPrincipal),
                  onPressed: _enviarMensaje,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
