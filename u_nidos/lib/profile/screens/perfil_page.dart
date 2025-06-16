import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:u_nidos/profile/bloc/profile_bloc.dart';
import 'package:u_nidos/profile/bloc/profile_event.dart';
import 'package:u_nidos/profile/bloc/profile_state.dart';
import 'package:u_nidos/profile/model/profile_model.dart';
import 'package:u_nidos/publication/repository/rating_repository.dart';

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
  bool editando = false;
  DateTime? fechaNacimiento;

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

            if (nombreCtrl.text.isEmpty) nombreCtrl.text = state.nombre;
            if (carreraCtrl.text.isEmpty) carreraCtrl.text = state.carrera;
            if (campusCtrl.text.isEmpty) campusCtrl.text = state.campus;
            if (habilidadesCtrl.text.isEmpty)
              habilidadesCtrl.text = state.habilidades;
            if (anioIngresoCtrl.text.isEmpty)
              anioIngresoCtrl.text = state.anioIngreso.toString();
            if (emailCtrl.text.isEmpty) emailCtrl.text = state.email;
            if (fechaNacimiento == null) {
              fechaNacimiento = state.fechaNacimiento;
              fechaNacimientoCtrl.text =
                  fechaNacimiento != null
                      ? DateFormat('dd/MM/yyyy').format(fechaNacimiento!)
                      : '';
            }

            return SingleChildScrollView(
              padding: const EdgeInsets.only(
                top: 0,
                left: 20,
                right: 20,
                bottom: 20,
              ),
              child: Column(
                children: [
                  Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    color: const Color(0xFFFFF1F2),
                    elevation: 4,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 12,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text(
                                'Nombre',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.grey,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child:
                                    editando
                                        ? TextField(
                                          controller: nombreCtrl,
                                          textAlign: TextAlign.center,
                                          decoration: const InputDecoration(
                                            isDense: true,
                                            border: InputBorder.none,
                                          ),
                                        )
                                        : Text(
                                          nombreCtrl.text,
                                          textAlign: TextAlign.center,
                                          style: const TextStyle(fontSize: 16),
                                        ),
                              ),
                              IconButton(
                                icon: Icon(
                                  editando ? Icons.save : Icons.edit,
                                  color: Colors.grey[700],
                                ),
                                onPressed: () {
                                  if (editando) {
                                    final nuevoUsuario = UsuarioModel(
                                      uid: uid,
                                      nombre: nombreCtrl.text.trim(),
                                      carrera: carreraCtrl.text.trim(),
                                      campus: campusCtrl.text.trim(),
                                      email: state.email,
                                      habilidades: habilidadesCtrl.text.trim(),
                                      fechaNacimiento: fechaNacimiento,
                                      anioIngreso:
                                          int.tryParse(
                                            anioIngresoCtrl.text.trim(),
                                          ) ??
                                          0,
                                      intereses: state.intereses,
                                    );
                                    context.read<ProfileBloc>().add(
                                      GuardarCambiosPerfil(nuevoUsuario),
                                    );
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text('Cambios guardados'),
                                      ),
                                    );
                                  }
                                  setState(() => editando = !editando);
                                },
                              ),
                            ],
                          ),
                          _campoEditableCentrado(
                            'Carrera',
                            carreraCtrl,
                            editando,
                          ),
                          _campoEditableCentrado(
                            'Campus',
                            campusCtrl,
                            editando,
                          ),
                          _campoEditableCentrado(
                            'Año de ingreso',
                            anioIngresoCtrl,
                            editando,
                          ),
                          _campoEditableCentrado(
                            'Fecha de nacimiento',
                            fechaNacimientoCtrl,
                            false,
                          ),
                          _campoEditableCentrado('Correo', emailCtrl, false),
                          _campoEditableCentrado(
                            'Habilidades',
                            habilidadesCtrl,
                            editando,
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),
                  const Text(
                    'Historial de calificaciones de servicios ofrecidos',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 10),
                  FutureBuilder<QuerySnapshot>(
                    future:
                        FirebaseFirestore.instance
                            .collection('publicaciones')
                            .where('uid', isEqualTo: uid)
                            .orderBy('timestamp', descending: true)
                            .get(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      }

                      final publicaciones = snapshot.data?.docs ?? [];

                      if (publicaciones.isEmpty) {
                        return const Text('No has publicado servicios aún.');
                      }

                      return ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: publicaciones.length,
                        itemBuilder: (context, index) {
                          final pub =
                              publicaciones[index].data()
                                  as Map<String, dynamic>;
                          final fecha =
                              pub['timestamp'] != null
                                  ? DateFormat(
                                    'dd/MM/yyyy',
                                  ).format(pub['timestamp'].toDate())
                                  : 'Fecha desconocida';

                          return FutureBuilder<double>(
                            future: RatingRepository()
                                .obtenerPromedioCalificacionServicio(
                                  publicaciones[index].id,
                                ),
                            builder: (context, snapshot) {
                              final promedio = snapshot.data ?? 0.0;

                              return Card(
                                color: const Color(0xFFFFF1F2),
                                margin: const EdgeInsets.symmetric(vertical: 8),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(12),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        pub['categoria'] ?? 'Sin categoría',
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      Text(
                                        pub['descripcion'] ?? 'Sin descripción',
                                      ),
                                      const SizedBox(height: 4),
                                      Text('Publicado: $fecha'),
                                      const SizedBox(height: 4),
                                      Row(
                                        children: [
                                          ...List.generate(5, (i) {
                                            return Icon(
                                              i < promedio.round()
                                                  ? Icons.star
                                                  : Icons.star_border,
                                              color: Colors.amber,
                                              size: 20,
                                            );
                                          }),
                                          const SizedBox(width: 6),
                                          Text(
                                            '(${promedio.toStringAsFixed(1)})',
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          );
                        },
                      );
                    },
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _campoEditableCentrado(
    String label,
    TextEditingController controller,
    bool editable,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.grey,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 2),
          editable
              ? TextField(
                controller: controller,
                textAlign: TextAlign.center,
                decoration: const InputDecoration(
                  isDense: true,
                  border: InputBorder.none,
                ),
              )
              : Text(
                controller.text,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 16),
              ),
        ],
      ),
    );
  }
}
