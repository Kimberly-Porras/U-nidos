import 'package:flutter/material.dart';
import '../publication/screens/publicar_servicio_page.dart';
import '../shared_preferences.dart';

class InicioPage extends StatefulWidget {
  const InicioPage({super.key});

  @override
  State<InicioPage> createState() => _InicioPageState();
}

class _InicioPageState extends State<InicioPage> {
  final TextEditingController _busquedaCtrl = TextEditingController();
  Color _colorPrincipal = Colors.blueAccent;

  final List<Map<String, dynamic>> _servicios = [
    {
      'name': 'Kimberly Porras Naranjo',
      'service': 'Ofrezco tutorías sobre formato APA',
      'color': Colors.pinkAccent,
    },
    {
      'name': 'Tamara Pérez Guillén',
      'service': 'Ofrezco tutorías sobre mecanografía',
      'color': Colors.blueAccent,
    },
    {
      'name': 'Alberto Torres Valverde',
      'service': 'Ofrezco tutorías sobre JavaScript',
      'color': Colors.tealAccent,
    },
  ];

  final Map<String, Color> coloresUniversidades = {
    'UNA': Color(0xFFAD002E),
    'UCR': Color(0xFF007DC5),
    'TEC': Color(0xFF0C2340),
    'UNED': Color(0xFF003366),
    'UTN': Color(0xFF003865),
  };

  String _filtro = '';

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

  @override
  Widget build(BuildContext context) {
    final resultados =
        _servicios.where((s) {
          return s['service'].toLowerCase().contains(_filtro.toLowerCase());
        }).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Inicio'),
        backgroundColor: _colorPrincipal,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: TextField(
              controller: _busquedaCtrl,
              decoration: InputDecoration(
                hintText: 'Buscar servicio...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              onChanged: (value) {
                setState(() {
                  _filtro = value;
                });
              },
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: resultados.length,
              itemBuilder: (context, index) {
                final servicio = resultados[index];
                return ServiceCard(
                  name: servicio['name'],
                  service: servicio['service'],
                  color: servicio['color'],
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => PublicarServicioPage()),
          );
        },
        child: const Icon(Icons.add),
        backgroundColor: _colorPrincipal,
      ),
    );
  }
}

class ServiceCard extends StatelessWidget {
  final String name;
  final String service;
  final Color color;

  const ServiceCard({
    super.key,
    required this.name,
    required this.service,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 20),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 3,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Encabezado: Nombre y menú
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

          // Descripción del servicio con fondo de color
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              gradient: LinearGradient(colors: [color.withOpacity(0.7), color]),
              borderRadius: const BorderRadius.vertical(
                top: Radius.zero,
                bottom: Radius.zero,
              ),
            ),
            child: Text(
              service,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 15,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),

          // Botones de acción (alineados horizontalmente)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _botonAccion(
                  icono: Icons.remove_red_eye,
                  texto: 'Perfil',
                  color: Colors.blueAccent,
                  onPressed: () {},
                ),
                _botonAccion(
                  icono: Icons.chat_bubble_outline,
                  texto: 'Chat',
                  color: Colors.green,
                  onPressed: () {},
                ),
                _botonAccion(
                  icono: Icons.share,
                  texto: 'Compartir',
                  color: Colors.deepPurple,
                  onPressed: () {},
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _botonAccion({
    required IconData icono,
    required String texto,
    required Color color,
    required VoidCallback onPressed,
  }) {
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
