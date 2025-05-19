import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import '../bloc/publication_bloc.dart';
import '../bloc/publication_event.dart';
import '../bloc/publication_state.dart';

class PublicarServicioPage extends StatelessWidget {
  final List<Map<String, dynamic>> categorias = [
    {'label': 'Arte', 'icon': Icons.brush, 'color': Colors.pink},
    {'label': 'Música', 'icon': Icons.music_note, 'color': Colors.deepPurple},
    {'label': 'Deportes', 'icon': Icons.sports_soccer, 'color': Colors.orange},
    {'label': 'Gaming', 'icon': Icons.videogame_asset, 'color': Colors.green},
    {'label': 'Moda', 'icon': Icons.shopping_bag, 'color': Colors.brown},
    {'label': 'Cocina', 'icon': Icons.restaurant_menu, 'color': Colors.red},
    {'label': 'Lectura', 'icon': Icons.book, 'color': Colors.indigo},
    {'label': 'Ciencia', 'icon': Icons.science, 'color': Colors.blue},
    {'label': 'Programación', 'icon': Icons.code, 'color': Colors.cyan},
    {'label': 'Cine', 'icon': Icons.movie, 'color': Colors.teal},
    {'label': 'Viajes', 'icon': Icons.flight, 'color': Colors.deepOrange},
    {'label': 'Naturaleza', 'icon': Icons.park, 'color': Colors.green.shade800},
    {'label': 'Fotografía', 'icon': Icons.camera_alt, 'color': Colors.purple},
    {'label': 'Animales', 'icon': Icons.pets, 'color': Colors.amber},
    {
      'label': 'Salud y bienestar',
      'icon': Icons.health_and_safety,
      'color': Colors.lightBlue,
    },
    {'label': 'Manualidades', 'icon': Icons.handyman, 'color': Colors.grey},
    {
      'label': 'Emprendimiento',
      'icon': Icons.business_center,
      'color': Colors.blueGrey,
    },
  ];

  PublicarServicioPage({super.key});

  void _mostrarColorPicker(BuildContext context, Color actual) async {
    final color = await showDialog<Color>(
      context: context,
      builder:
          (_) => AlertDialog(
            title: const Text('Seleccionar color de fondo'),
            content: BlockPicker(
              pickerColor: actual,
              onColorChanged: (c) => Navigator.pop(context, c),
            ),
          ),
    );

    if (color != null) {
      context.read<PublicationBloc>().add(BackgroundColorChanged(color));
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => PublicationBloc(),
      child: Scaffold(
        appBar: AppBar(title: const Text('Nuevo servicio')),
        body: BlocBuilder<PublicationBloc, PublicationState>(
          builder: (context, state) {
            return Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Selecciona una categoría:',
                    style: TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 8),

                  /// Dropdown personalizado con iconos y colores
                  DropdownButtonFormField<String>(
                    value: state.categoria.isEmpty ? null : state.categoria,
                    hint: const Text('Seleccionar categoría'),
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 10,
                      ),
                    ),
                    items:
                        categorias.map<DropdownMenuItem<String>>((cat) {
                          return DropdownMenuItem<String>(
                            value: cat['label'] as String,
                            child: Row(
                              children: [
                                Icon(
                                  cat['icon'],
                                  color: cat['color'],
                                  size: 20,
                                ),
                                const SizedBox(width: 8),
                                Text(cat['label']),
                              ],
                            ),
                          );
                        }).toList(),
                    onChanged: (valor) {
                      if (valor != null) {
                        context.read<PublicationBloc>().add(
                          CategoryChanged(valor),
                        );
                      }
                    },
                  ),

                  const SizedBox(height: 16),
                  Stack(
                    alignment: Alignment.topRight,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: state.fondo,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: TextField(
                          maxLines: 6,
                          onChanged:
                              (value) => context.read<PublicationBloc>().add(
                                DescriptionChanged(value),
                              ),
                          decoration: const InputDecoration.collapsed(
                            hintText: 'Describe el servicio...',
                          ),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.color_lens),
                        onPressed:
                            () => _mostrarColorPicker(context, state.fondo),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  Center(
                    child: ElevatedButton(
                      onPressed:
                          state.enviando
                              ? null
                              : () {
                                if (state.categoria.isEmpty) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text(
                                        'Por favor selecciona una categoría',
                                      ),
                                    ),
                                  );
                                  return;
                                }
                                context.read<PublicationBloc>().add(
                                  SubmitPublication(),
                                );
                              },
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            Theme.of(
                              context,
                            ).primaryColor, // ✅ color por universidad
                        foregroundColor: Colors.white, // ✅ texto en blanco
                        padding: const EdgeInsets.symmetric(
                          horizontal: 30,
                          vertical: 12,
                        ),
                      ),
                      child:
                          state.enviando
                              ? const SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Colors.white, // ✅ loader en blanco
                                ),
                              )
                              : const Text('Publicar'),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
