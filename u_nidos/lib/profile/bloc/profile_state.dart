import 'package:equatable/equatable.dart';

class ProfileState extends Equatable {
  final String nombre;
  final String carrera;
  final String campus;
  final String email;
  final String habilidades;
  final DateTime? fechaNacimiento;
  final bool cargando;

  const ProfileState({
    this.nombre = '',
    this.carrera = '',
    this.campus = '',
    this.email = '',
    this.habilidades = '',
    this.fechaNacimiento,
    this.cargando = false,
  });

  ProfileState copyWith({
    String? nombre,
    String? carrera,
    String? campus,
    String? email,
    String? habilidades,
    DateTime? fechaNacimiento,
    bool? cargando,
  }) {
    return ProfileState(
      nombre: nombre ?? this.nombre,
      carrera: carrera ?? this.carrera,
      campus: campus ?? this.campus,
      email: email ?? this.email,
      habilidades: habilidades ?? this.habilidades,
      fechaNacimiento: fechaNacimiento ?? this.fechaNacimiento,
      cargando: cargando ?? this.cargando,
    );
  }

  @override
  List<Object?> get props => [
    nombre,
    carrera,
    campus,
    email,
    habilidades,
    fechaNacimiento,
    cargando,
  ];
}
