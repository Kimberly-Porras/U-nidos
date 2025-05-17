import 'package:flutter/material.dart';

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
    {'text': '¡Hola!', 'time': '3:12', 'sent': true},
    {'text': '¿Nos vemos en la soda?', 'time': '3:20', 'sent': false},
    {'text': 'Sí, claro. ¿A qué hora?', 'time': '3:25', 'sent': true},
  ];

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
            const Spacer(),
            const Icon(Icons.search),
          ],
        ),
        backgroundColor: Colors.lightBlue,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFE0F7FA), Color(0xFF81D4FA)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                itemCount: _messages.length,
                itemBuilder: (context, index) {
                  final msg = _messages[index];
                  return Align(
                    alignment: msg['sent'] ? Alignment.centerRight : Alignment.centerLeft,
                    child: Container(
                      margin: const EdgeInsets.symmetric(vertical: 4),
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.9),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(msg['text'], style: const TextStyle(fontSize: 16)),
                          Text(
                            msg['time'],
                            style: const TextStyle(fontSize: 10, color: Colors.black54),
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
              color: Colors.white.withOpacity(0.3),
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
                    icon: const Icon(Icons.send),
                    onPressed: _sendMessage,
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
