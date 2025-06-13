import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:u_nidos/list_publication/bloc/publications_event.dart';
import 'package:u_nidos/list_publication/bloc/publications_state.dart';
import 'package:u_nidos/list_publication/repository/publications_repository.dart';

class PublicacionBloc extends Bloc<PublicacionEvent, PublicacionState> {
  final PublicacionRepository repository;

  PublicacionBloc(this.repository) : super(PublicacionInicial()) {
    on<CargarPublicaciones>(_onCargar);
  }

  Future<void> _onCargar(
    CargarPublicaciones event,
    Emitter<PublicacionState> emit,
  ) async {
    emit(PublicacionCargando());

    try {
      // 🔍 Pasamos el UID actual para excluir publicaciones propias
      final publicaciones = await repository.obtenerPublicacionesPorCampus(
        event.campus,
        event.currentUserId, // 👈 nuevo parámetro
      );

      emit(PublicacionCargada(publicaciones));
    } catch (e) {
      print('🔥 Error cargando publicaciones: $e');
      emit(PublicacionError('Error al cargar publicaciones'));
    }
  }
}
