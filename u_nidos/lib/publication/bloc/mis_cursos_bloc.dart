import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// ===== ESTADOS =====

abstract class MisCursosState {}

class MisCursosInicial extends MisCursosState {}

class MisCursosCargando extends MisCursosState {}

class MisCursosCargado extends MisCursosState {
  final List<Map<String, dynamic>> cursos;
  MisCursosCargado(this.cursos);
}

class MisCursosError extends MisCursosState {
  final String mensaje;
  MisCursosError(this.mensaje);
}

/// ===== EVENTOS =====

abstract class MisCursosEvent {}

class CargarMisCursos extends MisCursosEvent {}

/// ===== BLOC =====

class MisCursosBloc extends Bloc<MisCursosEvent, MisCursosState> {
  MisCursosBloc() : super(MisCursosInicial()) {
    on<CargarMisCursos>(_onCargar);
  }

  Future<void> _onCargar(CargarMisCursos event, Emitter<MisCursosState> emit) async {
    emit(MisCursosCargando());

    try {
      final uid = FirebaseAuth.instance.currentUser?.uid;
      if (uid == null) throw Exception('Usuario no autenticado');

      final querySnapshot = await FirebaseFirestore.instance
          .collection('publicaciones')
          .where('uid', isEqualTo: uid)
          .get();

      final List<Map<String, dynamic>> cursos = [];

      for (var doc in querySnapshot.docs) {
        final data = doc.data();
        final idPublicacion = doc.id;

        final calificacionesSnapshot = await FirebaseFirestore.instance
            .collection('calificaciones')
            .where('idPublicacion', isEqualTo: idPublicacion)
            .get();

        final calificaciones = calificacionesSnapshot.docs
            .map((d) => (d['calificacion'] as num).toDouble())
            .toList();

        final promedio = calificaciones.isEmpty
            ? 0.0
            : calificaciones.reduce((a, b) => a + b) / calificaciones.length;

        cursos.add({
          ...data,
          'id': idPublicacion,
          'promedio': promedio,
        });
      }

      emit(MisCursosCargado(cursos));
    } catch (e) {
      print('❌ Error cargando cursos: $e');
      emit(MisCursosError('No se pudieron cargar tus cursos.'));
    }
  }
}
