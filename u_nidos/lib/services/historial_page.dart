import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class HistorialPage extends StatefulWidget {
  const HistorialPage({super.key});

  @override
  State<HistorialPage> createState() => _HistorialPageState();
}

class _HistorialPageState extends State<HistorialPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  String universidad = 'UCR';
  String? uid;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _cargarUniversidad();
    uid = FirebaseAuth.instance.currentUser?.uid;
  }

  Future<void> _cargarUniversidad() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      universidad = prefs.getString('universidad') ?? 'UCR';
    });
  }

  Color getColorUniversidad(String universidad) {
    switch (universidad) {
      case 'UNA':
        return const Color(0xFFD32F2F);
      case 'UCR':
        return const Color(0xFF03A9F4);
      case 'TEC':
        return const Color(0xFF1565C0);
      case 'UNED':
        return const Color(0xFF0D47A1);
      case 'UTN':
        return const Color(0xFF1976D2);
      default:
        return Colors.blue;
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorUniversidad = getColorUniversidad(universidad);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Historial'),
        backgroundColor: colorUniversidad,
        bottom: TabBar(
          controller: _tabController,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white,
          indicatorColor: Colors.white,
          tabs: const [
            Tab(text: 'Servicios'),
            Tab(text: 'Aprendí'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildPublicacionesPropias(),
          _buildAprendi(),
        ],
      ),
    );
  }

  Widget _buildPublicacionesPropias() {
    if (uid == null) {
      return const Center(child: Text('Usuario no autenticado.'));
    }

    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('publicaciones')
          .where('uid', isEqualTo: uid)
          .orderBy('timestamp', descending: true)
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
            final data = docs[index].data() as Map<String, dynamic>;
            final fecha = (data['timestamp'] as Timestamp).toDate();
            final nombre = data['nombre'] ?? 'Sin nombre';
            final descripcion = data['descripcion'] ?? '';
            final calificacion = data['calificacion'] ?? 5;

            return Card(
              margin: const EdgeInsets.all(8),
              color: const Color(0xFFFFEBEE),
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
                        return Icon(
                          i < calificacion ? Icons.star : Icons.star_border,
                          color: Colors.amber,
                          size: 20,
                        );
                      }),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildAprendi() {
    if (uid == null) {
      return const Center(child: Text('Usuario no autenticado.'));
    }

    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
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
              color: const Color(0xFFFFEBEE),
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
                            await doc.reference.update({
                              'calificacion': i + 1,
                            });
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
                      builder: (context) => AlertDialog(
                        title: const Text('¿Eliminar entrada?'),
                        content: const Text('Esta acción no se puede deshacer.'),
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

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }
}
