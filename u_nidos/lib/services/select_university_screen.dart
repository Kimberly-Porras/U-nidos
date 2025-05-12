import 'package:flutter/material.dart';
import '../shared_preferences.dart';

class SelectUniversityScreen extends StatelessWidget {
  final VoidCallback onSeleccion;

  const SelectUniversityScreen({required this.onSeleccion, super.key});

  @override
  Widget build(BuildContext context) {
    final universidades = [
      {
        'nombre': 'UNIVERSIDAD NACIONAL DE COSTA RICA',
        'valor': 'UNA',
        'logo': 'assets/logos/UNA.png',
      },
      {
        'nombre': 'UNIVERSIDAD DE COSTA RICA',
        'valor': 'UCR',
        'logo': 'assets/logos/UCR.png',
      },
      {
        'nombre': 'TECNOLOGICO DE COSTA RICA',
        'valor': 'TEC',
        'logo': 'assets/logos/TEC.png',
      },
      {
        'nombre': 'UNIVERSIDAD NACIONAL DE EDUCACION A DISTANCIA',
        'valor': 'UNED',
        'logo': 'assets/logos/UNED.png',
      },
      {
        'nombre': 'UNIVERSIDAD TECNICA NACIONAL',
        'valor': 'UTN',
        'logo': 'assets/logos/UTN.png',
      },
    ];

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              const Text(
                '¿De qué universidad eres?',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 40),
              Expanded(
                child: ListView.builder(
                  itemCount: universidades.length,
                  itemBuilder: (context, index) {
                    final uni = universidades[index];
                    return Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 4,
                      margin: const EdgeInsets.symmetric(vertical: 10),
                      child: ListTile(
                        contentPadding: const EdgeInsets.symmetric(
                          vertical: 12,
                          horizontal: 16,
                        ),
                        leading: Image.asset(
                          uni['logo']!,
                          width: 40,
                          height: 40,
                          fit: BoxFit.contain,
                        ),
                        title: Text(
                          uni['nombre']!,
                          style: const TextStyle(fontSize: 16),
                        ),
                        onTap: () async {
                          await SharedPrefsService.guardarUniversidad(
                            uni['valor']!,
                          );
                          onSeleccion();
                        },
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
