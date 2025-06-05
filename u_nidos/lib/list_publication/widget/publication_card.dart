import 'package:flutter/material.dart';

class ServiceCard extends StatelessWidget {
  final String name;
  final String description;
  final int fondo;
  final VoidCallback onPerfil;
  final VoidCallback onChat;
  final VoidCallback onCompartir;

  const ServiceCard({
    super.key,
    required this.name,
    required this.description,
    required this.fondo,
    required this.onPerfil,
    required this.onChat,
    required this.onCompartir,
  });

  @override
  Widget build(BuildContext context) {
    final color = Color(fondo).withOpacity(1.0);

    return Card(
      margin: const EdgeInsets.only(bottom: 20),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 3,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Nombre y menú
          ListTile(
            leading: const CircleAvatar(child: Icon(Icons.person)),
            title: Text(
              name,
              style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
            ),
            trailing: PopupMenuButton<String>(
              icon: const Icon(Icons.more_horiz),
              onSelected: (value) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('$value servicio de $name')),
                );
              },
              itemBuilder:
                  (context) => const [
                    PopupMenuItem(value: 'Editar', child: Text('Editar')),
                    PopupMenuItem(value: 'Eliminar', child: Text('Eliminar')),
                    PopupMenuItem(value: 'Reportar', child: Text('Reportar')),
                  ],
            ),
          ),

          // Descripción con fondo
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              gradient: LinearGradient(colors: [color.withOpacity(0.7), color]),
              borderRadius: const BorderRadius.vertical(bottom: Radius.zero),
            ),
            child: Text(
              description,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 15,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),

          // Botones
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _botonAccion(
                  Icons.remove_red_eye,
                  'Perfil',
                  Colors.blueAccent,
                  onPerfil,
                ),
                _botonAccion(
                  Icons.chat_bubble_outline,
                  'Chat',
                  Colors.green,
                  onChat,
                ),
                _botonAccion(
                  Icons.share,
                  'Compartir',
                  Colors.deepPurple,
                  onCompartir,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _botonAccion(
    IconData icono,
    String texto,
    Color color,
    VoidCallback onPressed,
  ) {
    return TextButton.icon(
      onPressed: onPressed,
      icon: Icon(icono, size: 18, color: color),
      label: Text(
        texto,
        style: const TextStyle(fontSize: 13, color: Colors.black87),
      ),
    );
  }
}
