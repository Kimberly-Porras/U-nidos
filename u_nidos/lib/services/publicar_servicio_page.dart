import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:flutter/material.dart';

class PublicarServicioPage extends StatefulWidget {
  const PublicarServicioPage({super.key});

  @override
  State<PublicarServicioPage> createState() => _PublicarServicioPageState();
}

class _PublicarServicioPageState extends State<PublicarServicioPage> {
  final TextEditingController _servicioCtrl = TextEditingController();
  Color fondo = Colors.blue.shade100;

  void _seleccionarColor() async {
    final colorElegido = await showDialog<Color>(
      context: context,
      builder: (_) => AlertDialog(
        content: SingleChildScrollView(
          child: BlockPicker(
            pickerColor: fondo,
            onColorChanged: (color) => Navigator.pop(context, color),
          ),
        ),
      ),
    );

    if (colorElegido != null) {
      setState(() => fondo = colorElegido);
    }
  }

  void _publicar() {
    if (_servicioCtrl.text.isEmpty) return;
    // Lógica para publicar servicio
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Servicio publicado')),
    );
    _servicioCtrl.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Nuevo Servicio'),
        backgroundColor: Colors.blueAccent,
      ),
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFE0F7FA), Color(0xFFB3E5FC), Color(0xFF0288D1)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text(
              '¿Qué servicio desea brindar?',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),

            // 📝 Cuadro de texto con botón 🎨 en la esquina superior derecha
            Stack(
              alignment: Alignment.topRight,
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: fondo,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: TextField(
                    controller: _servicioCtrl,
                    maxLines: 6,
                    decoration: const InputDecoration.collapsed(
                      hintText: 'Escribe aquí .....',
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.color_lens, color: Colors.black),
                  onPressed: _seleccionarColor,
                ),
              ],
            ),

            const SizedBox(height: 30),

            ElevatedButton(
              onPressed: _publicar,
              child: const Text('Publicar'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black87,
                padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 12),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
