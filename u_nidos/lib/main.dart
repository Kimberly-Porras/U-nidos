import 'package:flutter/material.dart';
import 'shared_preferences.dart';
import 'login_screen.dart';
import 'services/home_screen.dart'; // <<--- AQUI IMPORTAS HomeScreen

void main() {
  runApp(const UNidosApp());
}

class UNidosApp extends StatefulWidget {
  const UNidosApp({super.key});

  @override
  State<UNidosApp> createState() => _UNidosAppState();
}

class _UNidosAppState extends State<UNidosApp> {
  String? universidadSeleccionada;

  final Map<String, Color> coloresUniversidades = {
    'UNA': Color(0xFFAD002E),
    'UCR': Color(0xFF007DC5),
    'TEC': Color(0xFF0C2340),
    'UNED': Color(0xFF003366),
    'UTN': Color(0xFF003865),
  };

  @override
  void initState() {
    super.initState();
    cargarUniversidad();
  }

  Future<void> cargarUniversidad() async {
    final uni = await SharedPrefsService.obtenerUniversidad();
    setState(() {
      universidadSeleccionada = uni;
    });
  }

  @override
  Widget build(BuildContext context) {
    Color colorPrimario =
        coloresUniversidades[universidadSeleccionada] ?? Colors.grey;

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'U-NIDOS',
      theme: ThemeData(
        primaryColor: colorPrimario,
        appBarTheme: AppBarTheme(
          backgroundColor: colorPrimario,
          foregroundColor: Colors.white,
        ),
        colorScheme: ColorScheme.fromSeed(
          seedColor: colorPrimario,
          primary: colorPrimario,
        ),
      ),
      home: universidadSeleccionada == null
          ? SeleccionarUniversidad(onSeleccion: cargarUniversidad)
          : LoginScreen(), // ← Aquí sigue mostrando Login primero
      // : HomeScreen(), // ← si quieres que abra directo HomeScreen en pruebas
    );
  }
}

class SeleccionarUniversidad extends StatelessWidget {
  final VoidCallback onSeleccion;

  const SeleccionarUniversidad({required this.onSeleccion, super.key});

  @override
  Widget build(BuildContext context) {
    List<String> universidades = ['UNA', 'UCR', 'TEC', 'UNED', 'UTN'];

    return Scaffold(
      appBar: AppBar(title: const Text('Selecciona tu universidad')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                '¿De qué universidad eres?',
                style: TextStyle(fontSize: 18),
              ),
              const SizedBox(height: 20),
              DropdownButtonFormField<String>(
                items: universidades.map((uni) {
                  return DropdownMenuItem<String>(
                    value: uni,
                    child: Text(uni),
                  );
                }).toList(),
                onChanged: (valor) async {
                  if (valor != null) {
                    await SharedPrefsService.guardarUniversidad(valor);
                    onSeleccion();
                  }
                },
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Universidad',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
