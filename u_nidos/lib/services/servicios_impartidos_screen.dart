import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:u_nidos/publication/bloc/mis_cursos_bloc.dart';

class ServiciosImpartidosScreen extends StatelessWidget {
  const ServiciosImpartidosScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => MisCursosBloc()..add(CargarMisCursos()),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Servicios Impartidos'),
        ),
        body: BlocBuilder<MisCursosBloc, MisCursosState>(
          builder: (context, state) {
            if (state is MisCursosCargando) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state is MisCursosError) {
              return Center(child: Text(state.mensaje));
            }

            if (state is MisCursosCargado) {
              final cursos = state.cursos;

              if (cursos.isEmpty) {
                return const Center(child: Text('Aún no has impartido cursos.'));
              }

              return ListView.builder(
                itemCount: cursos.length,
                itemBuilder: (context, index) {
                  final curso = cursos[index];
                  final descripcion = curso['descripcion'] ?? 'Sin descripción';

                  // Validación segura para el promedio
                  final promedio = curso['promedio'];
                  final promedioTexto = (promedio is num)
                      ? promedio.toStringAsFixed(1)
                      : 'N/A';

                  return Card(
                    margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                    elevation: 3,
                    child: ListTile(
                      title: Text(
                        descripcion,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Row(
                        children: [
                          const Icon(Icons.star, color: Colors.amber, size: 20),
                          const SizedBox(width: 6),
                          Text(
                            promedioTexto,
                            style: const TextStyle(fontSize: 16),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            }

            return const SizedBox(); // Estado inicial
          },
        ),
      ),
    );
  }
}
