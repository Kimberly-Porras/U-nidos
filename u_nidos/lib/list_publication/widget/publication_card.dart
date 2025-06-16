import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ServiceCard extends StatefulWidget {
  final String idPublicacion;
  final String name;
  final String description;
  final int fondo;
  final VoidCallback onPerfil;
  final VoidCallback onChat;
  final VoidCallback onCompartir;

  const ServiceCard({
    super.key,
    required this.idPublicacion,
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
  String? nombreActual;
  String? uidActual;

  @override
  void initState() {
    super.initState();
    cargarDatosUsuario();
  }

  Future<void> cargarDatosUsuario() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return;

    final doc =
        await FirebaseFirestore.instance.collection('usuarios').doc(uid).get();
    final data = doc.data();

    setState(() {
      uidActual = uid;
      nombreActual = data?['nombre']?.toString().trim();
    });

    await verificarSiYaAprendio(uid);
  }

  Future<void> verificarSiYaAprendio(String uid) async {
    final doc =
        await FirebaseFirestore.instance
            .collection('usuarios')
            .doc(uid)
            .collection('aprendi')
            .doc(widget.idPublicacion)
            .get();

    if (doc.exists) {
      setState(() => aprendido = true);
    }
  }

  Future<void> marcarComoAprendido() async {
    if (uidActual == null || aprendido) return;

    final userDoc =
        await FirebaseFirestore.instance
            .collection('usuarios')
            .doc(uidActual)
            .get();
    final userData = userDoc.data();
    final nombreUsuario = userData?['nombre'] ?? 'Sin nombre';

    // ✅ Guardar con ID único para evitar duplicados
    await FirebaseFirestore.instance
        .collection('usuarios')
        .doc(uidActual)
        .collection('aprendi')
        .doc(widget.idPublicacion)
        .set({
          'idPublicacion': widget.idPublicacion,
          'nombre': widget.name,
          'descripcion': widget.description,
          'fecha': Timestamp.now(),
          'calificacion': 5,
        });

    // Guardar en colección global de calificaciones
    await FirebaseFirestore.instance.collection('calificaciones').add({
      'idPublicacion': widget.idPublicacion,
      'autorId': widget.name, // ⚠️ mejor si pasás uid del autor real
      'usuarioId': uidActual,
      'nombreUsuario': nombreUsuario,
      'calificacion': 5,
      'timestamp': FieldValue.serverTimestamp(),
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
                if (nombreActual != null && nombreActual != widget.name)
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
                      SnackBar(
                        content: Text('$value servicio de ${widget.name}'),
                      ),
                    );
                  },
                  itemBuilder:
                      (context) => const [
                        PopupMenuItem(value: 'Editar', child: Text('Editar')),
                        PopupMenuItem(
                          value: 'Eliminar',
                          child: Text('Eliminar'),
                        ),
                        PopupMenuItem(
                          value: 'Reportar',
                          child: Text('Reportar'),
                        ),
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
                _botonAccion(
                  Icons.remove_red_eye,
                  'Perfil',
                  Colors.blueAccent,
                  widget.onPerfil,
                ),
                _botonAccion(
                  Icons.chat_bubble_outline,
                  'Chat',
                  Colors.green,
                  widget.onChat,
                ),
                _botonAccion(
                  Icons.share,
                  'Compartir',
                  Colors.deepPurple,
                  widget.onCompartir,
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
