import 'package:flutter/material.dart';
import 'publicar_servicio_page.dart';

class InicioPage extends StatefulWidget {
  const InicioPage({super.key});

  @override
  State<InicioPage> createState() => _InicioPageState();
}

class _InicioPageState extends State<InicioPage> {
  final TextEditingController _busquedaCtrl = TextEditingController();

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

  String _filtro = '';

  @override
  Widget build(BuildContext context) {
    final resultados = _servicios.where((s) {
      return s['service'].toLowerCase().contains(_filtro.toLowerCase());
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Inicio'),
        backgroundColor: Colors.blueAccent,
      ),
      body: Column(
        children: [
          // 🔍 Barra de búsqueda
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

          // 📋 Lista de servicios
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

      // ➕ Botón flotante solo con ícono
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => const PublicarServicioPage(),
            ),
          );
        },
        child: const Icon(Icons.add),
        backgroundColor: Colors.blueAccent,
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
      child: Column(
        children: [
          ListTile(
            leading: const CircleAvatar(child: Icon(Icons.person)),
            title: Text(name),
            trailing: PopupMenuButton<String>(
              icon: const Icon(Icons.more_horiz),
              onSelected: (value) {
                switch (value) {
                  case 'Editar':
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Editar servicio de $name')),
                    );
                    break;
                  case 'Eliminar':
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Eliminar servicio de $name')),
                    );
                    break;
                  case 'Reportar':
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Has reportado a $name')),
                    );
                    break;
                }
              },
              itemBuilder: (context) => const [
                PopupMenuItem(value: 'Editar', child: Text('Editar')),
                PopupMenuItem(value: 'Eliminar', child: Text('Eliminar')),
                PopupMenuItem(value: 'Reportar', child: Text('Reportar')),
              ],
            ),
          ),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [color.withOpacity(0.7), color],
              ),
            ),
            child: Text(
              service,
              style: const TextStyle(color: Colors.white, fontSize: 16),
            ),
          ),
          ButtonBar(
            alignment: MainAxisAlignment.spaceAround,
            children: [
              TextButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.remove_red_eye),
                label: const Text('Ver perfil'),
              ),
              TextButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.chat),
                label: const Text('Chat'),
              ),
              TextButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.share),
                label: const Text('Compartir'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
