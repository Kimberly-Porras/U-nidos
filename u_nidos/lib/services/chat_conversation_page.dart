import 'package:flutter/material.dart';
import 'package:u_nidos/shared_preferences.dart';

class ChatConversationPage extends StatefulWidget {
  final String nombreContacto;
  final String fotoUrl;

  const ChatConversationPage({
    super.key,
    required this.nombreContacto,
    required this.fotoUrl,
  });

  @override
  State<ChatConversationPage> createState() => _ChatConversationPageState();
}

class _ChatConversationPageState extends State<ChatConversationPage> {
  final TextEditingController _messageCtrl = TextEditingController();
  final List<Map<String, dynamic>> _messages = [
    {'text': '¡Hola!', 'time': '3:10', 'sent': false},
  ];

  final Map<String, Color> coloresUniversidades = {
    'UNA': Color(0xFFAD002E),
    'UCR': Color(0xFF007DC5),
    'TEC': Color(0xFF0C2340),
    'UNED': Color(0xFF003366),
    'UTN': Color(0xFF003865),
  };

  Color _colorPrincipal = Colors.blueAccent;

  @override
  void initState() {
    super.initState();
    _cargarColorUniversidad();
  }

  Future<void> _cargarColorUniversidad() async {
    final uni = await SharedPrefsService.obtenerUniversidad();
    setState(() {
      _colorPrincipal = coloresUniversidades[uni] ?? Colors.blueAccent;
    });
  }

  void _sendMessage() {
    final text = _messageCtrl.text.trim();
    if (text.isNotEmpty) {
      setState(() {
        _messages.add({
          'text': text,
          'time': TimeOfDay.now().format(context),
          'sent': true,
        });
      });
      _messageCtrl.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            CircleAvatar(backgroundImage: NetworkImage(widget.fotoUrl)),
            const SizedBox(width: 10),
            Text(widget.nombreContacto),
          ],
        ),
        backgroundColor: _colorPrincipal,
      ),
      body: Container(
        color: Colors.white,
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 10,
                ),
                itemCount: _messages.length,
                itemBuilder: (context, index) {
                  final msg = _messages[index];
                  return Align(
                    alignment:
                        msg['sent']
                            ? Alignment.centerRight
                            : Alignment.centerLeft,
                    child: Container(
                      margin: const EdgeInsets.symmetric(vertical: 4),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 10,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            msg['text'],
                            style: const TextStyle(fontSize: 16),
                          ),
                          Text(
                            msg['time'],
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
                        hintText: 'Escribe un mensaje....',
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.send, color: _colorPrincipal),
                    onPressed: _sendMessage,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
