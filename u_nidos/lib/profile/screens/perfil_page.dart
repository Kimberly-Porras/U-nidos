import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
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
  final TextEditingController anioIngresoCtrl = TextEditingController();
  final TextEditingController fechaNacimientoCtrl = TextEditingController();
  final TextEditingController emailCtrl = TextEditingController();

  DateTime? fechaNacimiento;

  final List<String> campusList = [
    'Campus Coto (Corredores)',
    'Campus Pérez Zeledón',
    'Campus Omar Dengo (Heredia)',
    'Campus Sarapiquí',
    'Campus Liberia',
    'Campus Nicoya',
    'Campus Puntarenas'
  ];

  Future<void> _cerrarSesionYSalir() async {
    await FirebaseAuth.instance.signOut();
    SystemNavigator.pop();
  }

  @override
  Widget build(BuildContext context) {
    final uid = FirebaseAuth.instance.currentUser?.uid ?? '';
    final colorUniversidad = Theme.of(context).primaryColor;

    return BlocProvider(
      create: (_) => ProfileBloc()..add(LoadUserProfile(uid)),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Mi Perfil'),
          backgroundColor: colorUniversidad,
          actions: [
            IconButton(
              icon: const Icon(Icons.logout),
              onPressed: _cerrarSesionYSalir,
            ),
          ],
        ),
        body: BlocBuilder<ProfileBloc, ProfileState>(
          builder: (context, state) {
            if (state.cargando) {
              return const Center(child: CircularProgressIndicator());
            }

            // ✅ Solo se llena si están vacíos (para no sobrescribir cambios manuales)
            if (nombreCtrl.text.isEmpty) nombreCtrl.text = state.nombre;
            if (carreraCtrl.text.isEmpty) carreraCtrl.text = state.carrera;
            if (campusCtrl.text.isEmpty) campusCtrl.text = state.campus;
            if (habilidadesCtrl.text.isEmpty) habilidadesCtrl.text = state.habilidades;
            if (anioIngresoCtrl.text.isEmpty) anioIngresoCtrl.text = state.anioIngreso.toString();
            if (emailCtrl.text.isEmpty) emailCtrl.text = state.email;
            if (fechaNacimiento == null) {
              fechaNacimiento = state.fechaNacimiento;
              fechaNacimientoCtrl.text = fechaNacimiento != null
                  ? DateFormat('dd/MM/yyyy').format(fechaNacimiento!)
                  : '';
            }

            return SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
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
                  DropdownButtonFormField<String>(
                    value: campusList.contains(campusCtrl.text) ? campusCtrl.text : null,
                    items: campusList.map((campus) {
                      return DropdownMenuItem(
                        value: campus,
                        child: Text(campus),
                      );
                    }).toList(),
                    onChanged: (nuevoCampus) {
                      if (nuevoCampus != null) {
                        setState(() {
                          campusCtrl.text = nuevoCampus;
                        });
                      }
                    },
                    decoration: const InputDecoration(labelText: 'Campus'),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: anioIngresoCtrl,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(labelText: 'Año de ingreso'),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: habilidadesCtrl,
                    decoration: const InputDecoration(labelText: 'Habilidades'),
                  ),
                  const SizedBox(height: 16),
                  GestureDetector(
                    onTap: () async {
                      final DateTime? selected = await showDatePicker(
                        context: context,
                        initialDate: fechaNacimiento ?? DateTime(2000),
                        firstDate: DateTime(1900),
                        lastDate: DateTime.now(),
                      );
                      if (selected != null) {
                        setState(() {
                          fechaNacimiento = selected;
                          fechaNacimientoCtrl.text =
                              DateFormat('dd/MM/yyyy').format(selected);
                        });
                      }
                    },
                    child: AbsorbPointer(
                      child: TextField(
                        controller: fechaNacimientoCtrl,
                        decoration: const InputDecoration(labelText: 'Fecha de nacimiento'),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: emailCtrl,
                    readOnly: true,
                    decoration: const InputDecoration(labelText: 'Correo'),
                  ),
                  const SizedBox(height: 32),
                  ElevatedButton(
                    onPressed: () {
                      print('📤 Campus seleccionado: ${campusCtrl.text}');

                      final nuevoUsuario = UsuarioModel(
                        uid: uid,
                        nombre: nombreCtrl.text.trim(),
                        carrera: carreraCtrl.text.trim(),
                        campus: campusCtrl.text.trim(),
                        email: state.email,
                        habilidades: habilidadesCtrl.text.trim(),
                        fechaNacimiento: fechaNacimiento,
                        anioIngreso:
                            int.tryParse(anioIngresoCtrl.text.trim()) ?? 0,
                        intereses: state.intereses,
                      );

                      context.read<ProfileBloc>().add(
                        GuardarCambiosPerfil(nuevoUsuario),
                      );

                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Cambios guardados')),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: colorUniversidad,
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