import 'package:flutter/material.dart';
import 'package:u_nidos/services/inicio_page.dart';
import 'package:u_nidos/services/chat_page.dart';
import 'package:u_nidos/services/historial_page.dart';
import 'package:u_nidos/profile/screens/perfil_page.dart';
import 'package:u_nidos/publication/screens/publicar_servicio_page.dart';
import 'package:u_nidos/shared_preferences.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;
  Color _colorPrincipal = Colors.blueAccent;

  final List<Widget> _screens = [
    const InicioPage(),
    const ChatPage(),
    const HistorialPage(),
    const PerfilPage(),
  ];

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
    return Scaffold(
      body: _screens[_currentIndex],

      floatingActionButton:
          _currentIndex == 0
              ? FloatingActionButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => PublicarServicioPage()),
                  );
                },
                backgroundColor: _colorPrincipal,
                child: const Icon(
                  Icons.add,
                  color: Colors.white, // ✅ Ícono blanco
                ),
              )
              : null,

      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _currentIndex,
        selectedItemColor: _colorPrincipal,
        unselectedItemColor: Colors.grey,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Inicio'),
          BottomNavigationBarItem(icon: Icon(Icons.chat), label: 'Chat'),
          BottomNavigationBarItem(
            icon: Icon(Icons.history),
            label: 'Historial',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Perfil'),
        ],
      ),
    );
  }
}
