import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:u_nidos/list_publication/bloc/publications_event.dart';
import 'package:u_nidos/list_publication/bloc/publications_state.dart';
import 'package:u_nidos/list_publication/repository/publications_repository.dart';

class PublicacionBloc extends Bloc<PublicacionEvent, PublicacionState> {
  final PublicacionRepository repository;

  PublicacionBloc(this.repository) : super(PublicacionInicial()) {
    // 🔄 Cuando se dispare el evento CargarPublicaciones...
    on<CargarPublicaciones>(_onCargar);
  }

  Future<void> _onCargar(
    CargarPublicaciones event,
    Emitter<PublicacionState> emit,
  ) async {
    emit(PublicacionCargando()); // Estado de carga

    try {
      // 🔎 Cargar publicaciones filtrando por campus
      final publicaciones = await repository.obtenerPublicacionesPorCampus(
        event.campus,
      );

      emit(PublicacionCargada(publicaciones)); // Publicaciones listas
    } catch (e) {
      print('🔥 Error cargando publicaciones: $e');
      emit(PublicacionError('Error al cargar publicaciones'));
    }
  }
}
