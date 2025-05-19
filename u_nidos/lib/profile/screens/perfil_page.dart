// perfil_page.dart editable y funcional
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:u_nidos/profile/bloc/profile_bloc.dart';
import 'package:u_nidos/profile/bloc/profile_event.dart';
import 'package:u_nidos/profile/bloc/profile_state.dart';
import 'package:u_nidos/profile/model/profile_model.dart';

class PerfilPage extends StatefulWidget {
  const PerfilPage({super.key});

  @override
  State<PerfilPage> createState() => _PerfilPageState();
}

class _PerfilPageState extends State<PerfilPage> {
  final TextEditingController nombreCtrl = TextEditingController();
  final TextEditingController carreraCtrl = TextEditingController();
  final TextEditingController campusCtrl = TextEditingController();
  final TextEditingController habilidadesCtrl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final uid = FirebaseAuth.instance.currentUser?.uid ?? '';

    return BlocProvider(
      create: (_) => ProfileBloc()..add(LoadUserProfile(uid)),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Mi Perfil'),
          actions: [
            IconButton(
              icon: const Icon(Icons.logout),
              onPressed: () => exit(0), // Cierra la app
            ),
          ],
        ),
        body: BlocBuilder<ProfileBloc, ProfileState>(
          builder: (context, state) {
            if (state.cargando) {
              return const Center(child: CircularProgressIndicator());
            }

            nombreCtrl.text = state.nombre;
            carreraCtrl.text = state.carrera;
            campusCtrl.text = state.campus;
            habilidadesCtrl.text = state.habilidades;

            return SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
              child: Column(
                children: [
                  const CircleAvatar(
                    radius: 60,
                    backgroundColor: Color(0xFFE0F7FA),
                    child: Icon(Icons.camera_alt, size: 30),
                  ),
                  const SizedBox(height: 20),
                  TextField(
                    controller: nombreCtrl,
                    decoration: const InputDecoration(labelText: 'Nombre'),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: carreraCtrl,
                    decoration: const InputDecoration(labelText: 'Carrera'),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: campusCtrl,
                    decoration: const InputDecoration(labelText: 'Campus'),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: habilidadesCtrl,
                    decoration: const InputDecoration(labelText: 'Habilidades'),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    enabled: false,
                    decoration: InputDecoration(
                      labelText: 'Correo',
                      hintText: state.email,
                    ),
                  ),
                  const SizedBox(height: 30),
                  ElevatedButton(
                    onPressed: () {
                      final nuevoUsuario = UsuarioModel(
                        uid: uid,
                        nombre: nombreCtrl.text.trim(),
                        carrera: carreraCtrl.text.trim(),
                        campus: campusCtrl.text.trim(),
                        email: state.email,
                        habilidades: habilidadesCtrl.text.trim(),
                        fechaNacimiento: state.fechaNacimiento,
                      );

                      context.read<ProfileBloc>().add(
                        GuardarCambiosPerfil(nuevoUsuario),
                      );

                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Cambios guardados')),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).primaryColor,
                      foregroundColor: Colors.white,
                      minimumSize: const Size(double.infinity, 50),
                    ),
                    child: const Text('Guardar cambios'),
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
