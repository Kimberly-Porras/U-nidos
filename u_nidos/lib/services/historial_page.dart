import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HistorialPage extends StatefulWidget {
  const HistorialPage({super.key});

  @override
  State<HistorialPage> createState() => _HistorialPageState();
}

class _HistorialPageState extends State<HistorialPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  String universidad = 'UCR'; // valor por defecto

  final List<Map<String, dynamic>> servicios = [
    {'titulo': 'Tutorías de Python', 'fecha': '02/07/2024', 'calificacion': 2},
    {'titulo': 'Aprendí Canva', 'fecha': '14/04/2024', 'calificacion': 5},
  ];

  final List<Map<String, dynamic>> aprendizajes = [
    {'titulo': 'Diseñé mi logo', 'fecha': '10/04/2024', 'calificacion': 4},
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _cargarUniversidad();
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
        return const Color(0xFFD32F2F); // Rojo UNA
      case 'UCR':
        return const Color(0xFF03A9F4); // Celeste UCR
      case 'TEC':
        return const Color(0xFF1565C0); // Azul TEC
      case 'UNED':
        return const Color(0xFF0D47A1); // Azul UNED
      case 'UTN':
        return const Color(0xFF1976D2); // Azul UTN
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
          labelColor: Colors.white,            // Texto seleccionado blanco
          unselectedLabelColor: Colors.white,   // Texto no seleccionado blanco
          indicatorColor: Colors.white,         // Línea activa blanca
          tabs: const [
            Tab(text: 'Servicios'),
            Tab(text: 'Aprendí'),
          ],
        ),
      ),
      body: Container(
        color: Colors.white,
        child: TabBarView(
          controller: _tabController,
          children: [_buildLista(servicios), _buildLista(aprendizajes)],
        ),
      ),
    );
  }

  Widget _buildLista(List<Map<String, dynamic>> items) {
    return ListView.builder(
      itemCount: items.length,
      itemBuilder: (context, index) {
        final item = items[index];
        return Card(
          margin: const EdgeInsets.all(8),
          child: ListTile(
            title: Text(item['titulo']),
            subtitle: Text('Fecha: ${item['fecha']}'),
            trailing: Icon(Icons.star, color: Colors.amber, size: 20),
            leading: Text('⭐ ${item['calificacion']}'),
          ),
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
