import 'package:equatable/equatable.dart';

abstract class PublicacionEvent extends Equatable {
  const PublicacionEvent();

  @override
  List<Object> get props => [];
}

class CargarPublicaciones extends PublicacionEvent {
  final String campus;

  const CargarPublicaciones(this.campus);

  @override
  List<Object> get props => [campus];
}
