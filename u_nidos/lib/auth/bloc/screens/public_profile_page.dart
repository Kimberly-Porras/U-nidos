import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class PublicProfilePage extends StatelessWidget {
  final String uid;

  const PublicProfilePage({Key? key, required this.uid}) : super(key: key);

  Future<Map<String, dynamic>?> _getUserData() async {
    final doc = await FirebaseFirestore.instance.collection('usuarios').doc(uid).get();
    return doc.exists ? doc.data() : null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Perfil público'),
        backgroundColor: const Color(0xFFAD002E),
      ),
      body: FutureBuilder<Map<String, dynamic>?>(
        future: _getUserData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data == null) {
            return const Center(child: Text('Usuario no encontrado'));
          }

          final data = snapshot.data!;
          final fechaNacimiento = (data['fechaNacimiento'] as Timestamp?)?.toDate();

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Card(
              elevation: 4,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Center(
                      child: CircleAvatar(
                        radius: 40,
                        backgroundColor: Colors.redAccent,
                        child: Icon(Icons.person, size: 40, color: Colors.white),
                      ),
                    ),
                    const SizedBox(height: 20),
                    _campo('Nombre', data['nombre']),
                    _campo('Carrera', data['carrera']),
                    _campo('Campus', data['campus']),
                    _campo('Año de ingreso', data['anioIngreso']?.toString()),
                    _campo(
                      'Fecha de nacimiento',
                      fechaNacimiento != null
                          ? '${fechaNacimiento.day}/${fechaNacimiento.month}/${fechaNacimiento.year}'
                          : '',
                    ),
                    _campo('Correo', data['email']),
                    _campo('Habilidades', data['habilidades']),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _campo(String titulo, String? valor) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(titulo, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Colors.grey)),
          const SizedBox(height: 4),
          Text(valor ?? '', style: const TextStyle(fontSize: 16)),
        ],
      ),
    );
  }
}
