import 'package:equatable/equatable.dart';
import 'package:u_nidos/list_publication/model/publications_model.dart';

abstract class PublicacionState extends Equatable {
  const PublicacionState();

  @override
  List<Object> get props => [];
}

class PublicacionInicial extends PublicacionState {}

class PublicacionCargando extends PublicacionState {}

class PublicacionCargada extends PublicacionState {
  final List<Publicacion> publicaciones;

  const PublicacionCargada(this.publicaciones);

  @override
  List<Object> get props => [publicaciones];
}

class PublicacionError extends PublicacionState {
  final String mensaje;

  const PublicacionError(this.mensaje);

  @override
  List<Object> get props => [mensaje];
}
