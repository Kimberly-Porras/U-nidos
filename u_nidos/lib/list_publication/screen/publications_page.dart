import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:share_plus/share_plus.dart';
import 'package:u_nidos/list_publication/bloc/publications_bloc.dart';
import 'package:u_nidos/list_publication/bloc/publications_state.dart';
import 'package:u_nidos/list_publication/bloc/publications_event.dart';
import 'package:u_nidos/list_publication/repository/publications_repository.dart';
import 'package:u_nidos/list_publication/widget/publication_card.dart';
import 'package:u_nidos/shared_preferences.dart';
import 'package:u_nidos/chat/screens/chat_conversation_page.dart';
import 'package:u_nidos/auth/bloc/screens/public_profile_page.dart';

class PublicationsPage extends StatefulWidget {
  const PublicationsPage({super.key});

  @override
  State<PublicationsPage> createState() => _PublicationsPageState();
}

class _PublicationsPageState extends State<PublicationsPage> {
  final TextEditingController _busquedaCtrl = TextEditingController();
  late Color _colorPrincipal = Colors.blueAccent;
  String _filtro = '';

  final Map<String, Color> coloresUniversidades = {
    'UNA': const Color(0xFFAD002E),
    'UCR': const Color(0xFF007DC5),
    'TEC': const Color(0xFF0C2340),
    'UNED': const Color(0xFF003366),
    'UTN': const Color(0xFF003865),
  };

  @override
  void initState() {
    super.initState();
    _cargarYFiltrarPublicaciones();
  }

  Future<void> _cargarYFiltrarPublicaciones() async {
    final campus = await SharedPrefsService.obtenerCampus();
    print("🧪 Campus obtenido de SharedPrefs: $campus");

    if (campus != null && campus.isNotEmpty) {
      context.read<PublicacionBloc>().add(CargarPublicaciones(campus));
    } else {
      print("⚠️ No se encontró campus en SharedPreferences");
    }
  }

  @override
  Widget build(BuildContext context) {
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
                setState(() => _filtro = value);
              },
            ),
          ),
          Expanded(
            child: BlocBuilder<PublicacionBloc, PublicacionState>(
              builder: (context, state) {
                if (state is PublicacionCargando) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state is PublicacionCargada) {
                  final publicaciones = state.publicaciones.where((pub) {
                    return pub.descripcion.toLowerCase().contains(
                          _filtro.toLowerCase(),
                        );
                  }).toList();

                  if (publicaciones.isEmpty) {
                    return const Center(
                      child: Text('No se encontraron resultados.'),
                    );
                  }

                  return ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: publicaciones.length,
                    itemBuilder: (context, index) {
                      final p = publicaciones[index];

                      final fondoSeguro =
                          (p.fondo is int) ? p.fondo : 0xFFE0E0E0;

                      return ServiceCard(
                        name: p.nombre,
                        description: p.descripcion,
                        fondo: fondoSeguro,
                        onPerfil: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => PublicProfilePage(uid: p.uid),
                            ),
                          );
                        },
                        onChat: () {
                          final uidActual =
                              FirebaseAuth.instance.currentUser!.uid;
                          final uidDestino = p.uid;

                          if (uidActual == uidDestino) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content:
                                    Text('No puedes chatear contigo mismo'),
                              ),
                            );
                            return;
                          }

                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => ChatConversationPage(
                                nombreContacto: p.nombre,
                                fotoUrl: '',
                                contactoId: uidDestino,
                                usuarioActualId: uidActual,
                              ),
                            ),
                          );
                        },
                        onCompartir: () {
                          Share.share(
                            'Servicio en U-NIDOS:\n\n'
                            '${p.nombre} ofrece: ${p.descripcion}',
                          );
                        },
                      );
                    },
                  );
                } else if (state is PublicacionError) {
                  return Center(child: Text('Error: ${state.mensaje}'));
                } else {
                  return const SizedBox.shrink();
                }
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // TODO: Navegar a la pantalla para publicar servicio
        },
        backgroundColor: _colorPrincipal,
        child: const Icon(Icons.add),
      ),
    );
  }
}
