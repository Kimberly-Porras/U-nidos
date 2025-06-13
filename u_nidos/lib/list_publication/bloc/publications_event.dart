import 'package:equatable/equatable.dart';

abstract class PublicacionEvent extends Equatable {
  const PublicacionEvent();

  @override
  List<Object> get props => [];
}

class CargarPublicaciones extends PublicacionEvent {
  final String campus;
  final String currentUserId;

  const CargarPublicaciones(this.campus, this.currentUserId);

  @override
  List<Object> get props => [campus, currentUserId];
}
