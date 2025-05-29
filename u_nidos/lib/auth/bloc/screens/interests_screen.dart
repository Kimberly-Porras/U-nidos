import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:u_nidos/services/home_screen.dart';
import '../register/register_bloc.dart';
import '../register/register_event.dart';
import '../register/register_state.dart';
import 'package:firebase_auth/firebase_auth.dart';

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
      body: BlocListener<RegisterBloc, RegisterState>(
        listener: (context, state) {
          if (state is RegisterLoading) {
            showDialog(
              context: context,
              barrierDismissible: false,
              builder: (_) => const Center(child: CircularProgressIndicator()),
            );
          } else if (state is RegisterError) {
            Navigator.pop(context);
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(state.message)));
          } else if (state is RegisterInterestsCompleted) {
            Navigator.pop(context);
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                builder:
                    (_) =>
                        HomeScreen(uid: FirebaseAuth.instance.currentUser!.uid),
              ),
              (route) => false,
            );
          }
        },
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Selecciona tus intereses:',
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 12),
              Expanded(
                child: SingleChildScrollView(
                  child: Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children:
                        categories.map((cat) {
                          final isSelected = selected.contains(cat['label']);

                          return ChoiceChip(
                            label: Text(
                              cat['label'],
                              style: TextStyle(
                                color:
                                    isSelected
                                        ? Theme.of(context).primaryColor
                                        : Colors.black,
                                fontWeight:
                                    isSelected
                                        ? FontWeight.bold
                                        : FontWeight.normal,
                              ),
                            ),
                            avatar: Icon(
                              cat['icon'],
                              size: 20,
                              color: colorForIcon(cat['label']),
                            ),
                            selected: isSelected,
                            onSelected: (bool value) {
                              setState(() {
                                value
                                    ? selected.add(cat['label'])
                                    : selected.remove(cat['label']);
                              });
                            },
                            backgroundColor: Colors.white,
                            selectedColor: Colors.white,
                            shape: StadiumBorder(
                              side: BorderSide(
                                color:
                                    isSelected
                                        ? Theme.of(context).primaryColor
                                        : Colors.grey.shade400,
                                width: 2,
                              ),
                            ),
                          );
                        }).toList(),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Center(
                child: ElevatedButton(
                  onPressed:
                      selected.isEmpty
                          ? null
                          : () {
                            context.read<RegisterBloc>().add(
                              InterestsSelected(selected),
                            );
                          },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 40,
                      vertical: 14,
                    ),
                  ),
                  child: const Text('Finalizar Registro'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Color colorForIcon(String label) {
    final Map<String, Color> colores = {
      'Arte': Colors.pink,
      'Música': Colors.deepPurple,
      'Deportes': Colors.orange,
      'Gaming': Colors.green,
      'Moda': Colors.brown,
      'Cocina': Colors.red,
      'Lectura': Colors.indigo,
      'Ciencia': Colors.blue,
      'Programación': Colors.cyan,
      'Cine': Colors.teal,
      'Viajes': Colors.deepOrange,
      'Naturaleza': Colors.green.shade800,
      'Fotografía': Colors.purple,
      'Animales': Colors.amber,
      'Salud y bienestar': Colors.lightBlue,
      'Manualidades': Colors.grey,
      'Emprendimiento': Colors.blueGrey,
    };

    return colores[label] ?? Colors.black;
  }
}
