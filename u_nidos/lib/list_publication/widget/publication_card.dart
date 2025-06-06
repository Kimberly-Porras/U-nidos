import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ServiceCard extends StatefulWidget {
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
  State<ServiceCard> createState() => _ServiceCardState();
}

class _ServiceCardState extends State<ServiceCard> {
  bool aprendido = false;

  @override
  void initState() {
    super.initState();
    verificarSiYaAprendio();
  }

  Future<void> verificarSiYaAprendio() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return;

    final snap = await FirebaseFirestore.instance
        .collection('usuarios')
        .doc(uid)
        .collection('aprendi')
        .where('nombre', isEqualTo: widget.name)
        .limit(1)
        .get();

    if (snap.docs.isNotEmpty) {
      setState(() => aprendido = true);
    }
  }

  Future<void> marcarComoAprendido() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null || aprendido) return;

    await FirebaseFirestore.instance
        .collection('usuarios')
        .doc(uid)
        .collection('aprendi')
        .add({
      'nombre': widget.name,
      'descripcion': widget.description,
      'fecha': Timestamp.now(),
      'calificacion': 5,
    });

    setState(() => aprendido = true);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('✔ Agregado a la sección "Aprendí"')),
    );
  }

  @override
  Widget build(BuildContext context) {
    final color = Color(widget.fondo).withOpacity(1.0);

    return Card(
      margin: const EdgeInsets.only(bottom: 20),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 3,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ListTile(
            leading: const CircleAvatar(child: Icon(Icons.person)),
            title: Text(
              widget.name,
              style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: Icon(
                    Icons.check_circle,
                    color: aprendido ? Colors.green : Colors.grey,
                  ),
                  tooltip: 'Marcar como aprendido',
                  onPressed: marcarComoAprendido,
                ),
                PopupMenuButton<String>(
                  icon: const Icon(Icons.more_horiz),
                  onSelected: (value) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('$value servicio de ${widget.name}')),
                    );
                  },
                  itemBuilder: (context) => const [
                    PopupMenuItem(value: 'Editar', child: Text('Editar')),
                    PopupMenuItem(value: 'Eliminar', child: Text('Eliminar')),
                    PopupMenuItem(value: 'Reportar', child: Text('Reportar')),
                  ],
                ),
              ],
            ),
          ),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              gradient: LinearGradient(colors: [color.withOpacity(0.7), color]),
              borderRadius: const BorderRadius.vertical(bottom: Radius.zero),
            ),
            child: Text(
              widget.description,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 15,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _botonAccion(Icons.remove_red_eye, 'Perfil', Colors.blueAccent, widget.onPerfil),
                _botonAccion(Icons.chat_bubble_outline, 'Chat', Colors.green, widget.onChat),
                _botonAccion(Icons.share, 'Compartir', Colors.deepPurple, widget.onCompartir),
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
