import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class HistorialPage extends StatelessWidget {
  const HistorialPage({super.key});

  @override
  Widget build(BuildContext context) {
    final colorUniversidad = Theme.of(context).primaryColor;

    return DefaultTabController(
      length: 1,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Historial mi aprendizaje'),
          backgroundColor: colorUniversidad,
          bottom: const TabBar(
            indicatorColor: Colors.transparent, // ✅ eliminamos la rayita
            tabs: [Tab(text: 'Aprendí')],
          ),
        ),
        body: const TabBarView(children: [_AprendiTab()]),
      ),
    );
  }
}

class _AprendiTab extends StatelessWidget {
  const _AprendiTab();

  @override
  Widget build(BuildContext context) {
    final uid = FirebaseAuth.instance.currentUser?.uid;

    if (uid == null) {
      return const Center(child: Text('Usuario no autenticado.'));
    }

    return StreamBuilder<QuerySnapshot>(
      stream:
          FirebaseFirestore.instance
              .collection('usuarios')
              .doc(uid)
              .collection('aprendi')
              .orderBy('fecha', descending: true)
              .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return const Center(child: Text('No hay elementos aún.'));
        }

        final docs = snapshot.data!.docs;

        return ListView.builder(
          itemCount: docs.length,
          itemBuilder: (context, index) {
            final doc = docs[index];
            final data = doc.data() as Map<String, dynamic>;
            final fecha = (data['fecha'] as Timestamp).toDate();
            final nombre = data['nombre'] ?? 'Sin nombre';
            final descripcion = data['descripcion'] ?? '';
            final calificacion = data['calificacion'] ?? 5;

            return Card(
              margin: const EdgeInsets.all(8),
              child: ListTile(
                title: Text(nombre),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Fecha: ${fecha.day.toString().padLeft(2, '0')}/'
                      '${fecha.month.toString().padLeft(2, '0')}/'
                      '${fecha.year}',
                    ),
                    const SizedBox(height: 4),
                    Text(descripcion),
                    const SizedBox(height: 4),
                    Row(
                      children: List.generate(5, (i) {
                        return IconButton(
                          icon: Icon(
                            i < calificacion ? Icons.star : Icons.star_border,
                            color: Colors.amber,
                            size: 24,
                          ),
                          onPressed: () async {
                            await doc.reference.update({'calificacion': i + 1});
                          },
                        );
                      }),
                    ),
                  ],
                ),
                trailing: IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  onPressed: () async {
                    final confirmar = await showDialog<bool>(
                      context: context,
                      builder:
                          (context) => AlertDialog(
                            title: const Text('¿Eliminar entrada?'),
                            content: const Text(
                              'Esta acción no se puede deshacer.',
                            ),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(context, false),
                                child: const Text('Cancelar'),
                              ),
                              TextButton(
                                onPressed: () => Navigator.pop(context, true),
                                child: const Text('Eliminar'),
                              ),
                            ],
                          ),
                    );

                    if (confirmar == true) {
                      await doc.reference.delete();
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Elemento eliminado')),
                      );
                    }
                  },
                ),
              ),
            );
          },
        );
      },
    );
  }
}
