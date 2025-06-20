import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:u_nidos/list_publication/screen/publications_page.dart';
import 'package:u_nidos/chat/screens/chat_page.dart';
import 'package:u_nidos/services/historial_page.dart';
import 'package:u_nidos/profile/screens/perfil_page.dart';
import 'package:u_nidos/publication/screens/publicar_servicio_page.dart';
import 'package:u_nidos/shared_preferences.dart';
import 'package:u_nidos/chat/bloc conversation list/conversation_list_bloc.dart';
import 'package:u_nidos/chat/bloc message/message_bloc.dart';
import 'package:u_nidos/chat/repository/chat_repository.dart';

class HomeScreen extends StatefulWidget {
  final String uid;
  const HomeScreen({super.key, required this.uid});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  Color get _colorPrincipal => Theme.of(context).primaryColor;

  @override
  Widget build(BuildContext context) {
    final List<Widget> _screens = [
      const PublicationsPage(),
      MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (_) => ConversationListBloc(repository: ChatRepository()),
          ),
          BlocProvider(
            create: (_) => MessageBloc(repository: ChatRepository()),
          ),
        ],
        child: ChatPage(usuarioActualId: widget.uid),
      ),
      const HistorialPage(),
      const PerfilPage(),
    ];

    return Scaffold(
      body: _screens[_currentIndex],
      floatingActionButton:
          _currentIndex == 0
              ? FloatingActionButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const PublicarServicioPage(),
                    ),
                  );
                },
                backgroundColor: _colorPrincipal,
                child: const Icon(Icons.add, color: Colors.white),
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
