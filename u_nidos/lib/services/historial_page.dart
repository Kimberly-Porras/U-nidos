import 'package:flutter/material.dart';

class HistorialPage extends StatelessWidget {
  const HistorialPage({super.key});

  final List<Map<String, dynamic>> servicios = const [
    {
      'titulo': 'Formato de normas APA',
      'fecha': '02/02/2025',
      'calificacion': 3,
    },
    {
      'titulo': 'Tutorías de Python',
      'fecha': '02/07/2024',
      'calificacion': 2,
    },
    {
      'titulo': 'Cocinar postres sencillos',
      'fecha': '16/05/2024',
      'calificacion': 4,
    },
  ];

  final List<Map<String, dynamic>> aprendizajes = const [
    {
      'titulo': 'Aprendí Canva',
      'fecha': '14/04/2024',
      'calificacion': 5,
    },
    {
      'titulo': 'Curso básico de HTML',
      'fecha': '12/03/2024',
      'calificacion': 3,
    },
    {
      'titulo': 'Edición de video con CapCut',
      'fecha': '25/01/2024',
      'calificacion': 4,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Historial'),
          backgroundColor: Colors.blueAccent,
          bottom: const TabBar(
            labelColor: Colors.red,
            unselectedLabelColor: Colors.black87,
            indicatorColor: Colors.red,
            tabs: [
              Tab(text: 'Mis servicios'),
              Tab(text: 'Mi aprendizaje'),
            ],
          ),
        ),
        body: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFFE0F7FA), Color(0xFF81D4FA)],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          child: TabBarView(
            children: [
              // Tab 1: Mis servicios
              _buildLista(servicios),

              // Tab 2: Mi aprendizaje
              _buildLista(aprendizajes),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLista(List<Map<String, dynamic>> lista) {
    return ListView.builder(
      itemCount: lista.length,
      padding: const EdgeInsets.all(12),
      itemBuilder: (context, index) {
        final item = lista[index];
        return Container(
          margin: const EdgeInsets.symmetric(vertical: 8),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.5),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      item['titulo'],
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ),
                  Text(
                    item['fecha'],
                    style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              const Text(
                'Calificación',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 4),
              Row(
                children: List.generate(5, (i) {
                  return Icon(
                    i < item['calificacion'] ? Icons.star : Icons.star_border,
                    color: Colors.amber,
                    size: 20,
                  );
                }),
              )
            ],
          ),
        );
      },
    );
  }
}
