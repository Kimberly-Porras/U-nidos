import 'package:flutter/material.dart';
import 'package:u_nidos/services/home_screen.dart';

class Interests extends StatefulWidget {
  final String email;
  final String username;
  final String password;
  final String name;
  final String campus;

  const Interests({
    super.key,
    required this.email,
    required this.username,
    required this.password,
    required this.name,
    required this.campus,
  });

  @override
  _InterestsState createState() => _InterestsState();
}

class _InterestsState extends State<Interests> {
  final List<Map<String, dynamic>> categories = [
    {'label': 'Arte', 'icon': Icons.brush},
    {'label': 'Música', 'icon': Icons.music_note},
    {'label': 'Deportes', 'icon': Icons.sports_soccer},
    {'label': 'Gaming', 'icon': Icons.videogame_asset},
    {'label': 'Moda', 'icon': Icons.shopping_bag},
    {'label': 'Cocina', 'icon': Icons.restaurant_menu},
    {'label': 'Lectura', 'icon': Icons.book},
    {'label': 'Ciencia', 'icon': Icons.science},
    {'label': 'Programación', 'icon': Icons.code},
    {'label': 'Cine', 'icon': Icons.movie},
    {'label': 'Viajes', 'icon': Icons.flight},
    {'label': 'Naturaleza', 'icon': Icons.park},
    {'label': 'Fotografía', 'icon': Icons.camera_alt},
    {'label': 'Animales', 'icon': Icons.pets},
    {'label': 'Salud y bienestar', 'icon': Icons.health_and_safety},
    {'label': 'Manualidades', 'icon': Icons.handyman},
    {'label': 'Emprendimiento', 'icon': Icons.business_center},
  ];

  List<String> selected = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Registro - Paso 3')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Selecciona tus intereses:', style: TextStyle(fontSize: 16)),
            const SizedBox(height: 12),
            Expanded(
              child: SingleChildScrollView(
                child: Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: categories.map((cat) {
                    return FilterChip(
                      avatar: Icon(
                        cat['icon'],
                        size: 20,
                        color: selected.contains(cat['label']) ? Colors.white : Colors.black54,
                      ),
                      label: Text(cat['label']),
                      selected: selected.contains(cat['label']),
                      onSelected: (bool value) {
                        setState(() {
                          value
                              ? selected.add(cat['label'])
                              : selected.remove(cat['label']);
                        });
                      },
                      selectedColor: Theme.of(context).primaryColor,
                      checkmarkColor: Colors.white,
                    );
                  }).toList(),
                ),
              ),
            ),
            const SizedBox(height: 24),
            Center(
              child: ElevatedButton(
                onPressed: selected.isEmpty
                    ? null
                    : () {
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const HomeScreen(),
                          ),
                          (route) => false,
                        );
                      },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 14),
                ),
                child: const Text('Finalizar Registro'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
